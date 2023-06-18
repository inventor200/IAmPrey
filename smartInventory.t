#define SMART_BAG enviroSuitBag
#define IN_SMART_BAG enviroSuitBag.remapIn

#ifdef __DEBUG
#define __DEBUG_SMART_INVENTORY nil
#else
#define __DEBUG_SMART_INVENTORY nil
#endif

enum
    operationTakeItems, operationDropItems,
    operationWearItems, operationDoffItems,
    operationFreeHands;

smartInventoryCore: object {
    activeBatch = nil
    hasBatch = (activeBatch != nil)
    batchFailed = nil
    silent = nil

    // Primary method 1
    // Uses the dobjs from gCommand
    performOperation(opType, additionalItems?) {
        if (activeBatch != nil) return;
        activeBatch = new SmartInventoryBatch(opType, additionalItems);
        doBatch();
    }

    // Primary method 2
    // Uses a custom items list
    performOperationOn(opType, customItems) {
        if (activeBatch != nil) return;
        activeBatch = new SmartInventoryBatch(opType, nil, customItems);
        doBatch();
    }

    doBatch() {
        if (activeBatch == nil) return;
        if (!activeBatch.isValid) {
            batchFailed = true;
            #if __DEBUG_SMART_INVENTORY
            "\b
            ERROR: Invalid before batch start.
            \b";
            #endif
            return;
        }
        activeBatch.plan();
        batchFailed = !activeBatch.isValid;
    }

    reset() {
        activeBatch = nil;
        batchFailed = nil;
        silent = nil;
    }

    getFilteredVector(originalVector, filterObject) {
        if (originalVector == nil) return nil;
        originalVector = convertToVector(originalVector);
        if (filterObject == nil) return originalVector;
        local filtered = new Vector(originalVector.length);

        for (local i = 1; i <= originalVector.length; i++) {
            local item = originalVector[i];
            if (!filterObject.passesFilter(item)) continue;
            filtered.appendUnique(item);
        }

        return filtered;
    }

    isPriorityItem(item) {
        if (item == nil) return nil;
        return SMART_BAG.affinityFor(item) > 90;
    }

    vectorToBulk(vec) {
        local aVec = convertToVector(vec);
        local totalBulk = 0;
        for (local i = 1; i <= aVec.length; i++) {
            local item = aVec[i];
            if (item.wornBy != nil) continue;
            totalBulk += item.bulk;
        }
        return totalBulk;
    }

    getList(vector) {
        if (!vector.ofKind(Collection)) {
            vector = valToList(vector);
        }
        return 'the ' + makeListStr(vector, &smartInventoryName, 'and the');
    }
}

class SmartInventoryFilter: object {
    includeWornObjects = nil
    includeWearableObjects = nil
    includeHeldObjects = true
    includeBaggedObjects = true
    includeSmartBagAsItem = nil
    includeZeroBulkItems = nil
    includeInReach = true
    includePriorityItems = true
    includeJunkItems = true

    passesFilter(item) {
        if (item.bulk == nil) return nil;
        if (item.isFixed) return nil;
        if (item.bulk > 2) return nil;
        if (!includeWornObjects) {
            if (item.wornBy == gPlayerChar) return nil;
        }
        if (!includeWearableObjects) {
            if (item.isWearable) return nil;
        }

        local isInBag = nil;
        if (gPlayerChar.canReach(SMART_BAG)) {
            isInBag = item.isIn(IN_SMART_BAG);
        }

        if (!includeHeldObjects && item.wornBy == nil) {
            if (
                item.isIn(gPlayerChar) &&
                !isInBag
            ) return nil;
        }
        if (!includeBaggedObjects) {
            if (isInBag) return nil;
        }
        if (!includeSmartBagAsItem) {
            if (item == SMART_BAG) return nil;
        }
        if (!includeZeroBulkItems) {
            if (item.bulk <= 0) return nil;
        }
        if (!includeInReach) {
            if (!item.isIn(gPlayerChar) && !isInBag) return nil;
        }
        else {
            if (!gPlayerChar.canReach(item) && !isInBag) return nil;
        }
        if (!includePriorityItems) {
            if (smartInventoryCore.isPriorityItem(item)) return nil;
        }
        if (!includeJunkItems) {
            if (!smartInventoryCore.isPriorityItem(item)) return nil;
        }

        return true;
    }
}

class SmartInventoryCluster: object {
    construct(_parent, _isPriority) {
        parent = _parent;
        isPriority = _isPriority;
        itemsFoundHere = new Vector(16);
        itemsAssignedHere = new Vector(16);
        itemsMovedHere = new Vector(16);
        itemsOverflowedHere = new Vector(16);
        clothesFoundHere = new Vector(8);
        clothesAssignedHere = new Vector(8);
        clothesToWear = new Vector(8);
        clothesToDoff = new Vector(8);
    }

    parent = nil
    isPriority = nil

    // Stuff that is meant to be stored, and not in a worn state
    itemsFoundHere = nil
    itemsAssignedHere = nil
    itemsMovedHere = nil
    itemsOverflowedHere = nil

    // Stuff that is meant to be worn, or is currently worn
    clothesFoundHere = nil
    clothesAssignedHere = nil
    clothesToWear = nil
    clothesToDoff = nil

    initializeItemHere(item) {
        if (item.wornBy != nil) {
            sendToState(item, clothesFoundHere, itemsFoundHere);
            sendToState(item, clothesAssignedHere, itemsAssignedHere);
        }
        else {
            sendToState(item, itemsFoundHere, clothesFoundHere);
            sendToState(item, itemsAssignedHere, clothesAssignedHere);
        }
    }

    assignMovedItem(item) {
        sendToState(item, itemsAssignedHere, clothesAssignedHere);
    }

    assignWornItem(item) {
        sendToState(item, clothesAssignedHere, itemsAssignedHere);
    }

    sendToState(item, vector, otherVector) {
        // Change of assignment
        local otherVersion = otherVector.indexOf(item);
        if (otherVersion != nil) {
            otherVector.removeElementAt(otherVersion);
        }

        // Set assignment
        vector.appendUnique(item);
    }

    takeItemFromVector(item, vec) {
        local index = vec.indexOf(item);
        if (index != nil) {
            vec.removeElementAt(index);
            return true;
        }
        return nil;
    }

    takeItem(item) {
        local tookClothes = takeItemFromVector(item, clothesAssignedHere);
        local tookItems = nil;
        if (!tookClothes) {
            tookItems = takeItemFromVector(item, itemsAssignedHere);
        }
        return tookClothes || tookItems;
    }

    planFit(capacity) {
        clearVector(itemsMovedHere);
        clearVector(itemsOverflowedHere);
        clearVector(clothesToWear);
        clearVector(clothesToDoff);

        local addedBulk = 0;

        for (local i = 1; i <= itemsAssignedHere.length; i++) {
            local item = itemsAssignedHere[i];
            if (item.bulk + addedBulk <= capacity) {
                itemsMovedHere.appendUnique(item);
                addedBulk += item.bulk;
            }
            else {
                itemsOverflowedHere.appendUnique(item);
            }
        }

        return itemsOverflowedHere.length == 0;
    }

    bakePlan() {
        // If there are items moved here, which have ALWAYS been here,
        // then we don't need to move them.
        for (local i = 1; i <= itemsFoundHere.length; i++) {
            local item = itemsFoundHere[i];
            local index = itemsMovedHere.indexOf(item);
            if (index == nil) continue;
            itemsMovedHere.removeElementAt(index);
        }

        // Find clothes to put on
        for (local i = 1; i <= clothesAssignedHere.length; i++) {
            local item = clothesAssignedHere[i];
            local index = clothesFoundHere.indexOf(item);
            if (index != nil) continue;
            clothesToWear.appendUnique(item);
        }

        // Find clothes to take off
        for (local i = 1; i <= clothesFoundHere.length; i++) {
            local item = clothesFoundHere[i];
            local index = clothesAssignedHere.indexOf(item);
            if (index != nil) continue;
            clothesToDoff.appendUnique(item);
        }
    }
}

class SmartInventoryPathway: object {
    construct(_dest) {
        destination = _dest;
        priorityCluster = new SmartInventoryCluster(self, true);
        junkCluster = new SmartInventoryCluster(self, nil);
        overflow = new Vector(16);
    }

    isAvailable = nil
    fallbackPathways = []
    destination = nil
    priorityCluster = nil
    junkCluster = nil

    minimumBulk = 0
    capacity = (destination.bulkCapacity)
    plannedCapacity = 0
    overflow = nil
    hadOverflow = nil
    acceptsSuperOverflow = nil

    initializeItemsHere(matches, filterObject) {
        local filtered = smartInventoryCore.getFilteredVector(matches, filterObject);
        
        for (local i = 1; i <= filtered.length; i++) {
            local item = filtered[i];
            if (smartInventoryCore.isPriorityItem(item)) {
                priorityCluster.initializeItemHere(item);
            }
            else {
                junkCluster.initializeItemHere(item);
            }
        }
    }

    getBulkFromProp(vecProp) {
        #if __DEBUG_SMART_INVENTORY
        "\b
        getBulkFromProp: Calculating bulk...
        \b";
        #endif
        local priorityBulk = smartInventoryCore.vectorToBulk(
            priorityCluster.(vecProp)
        );
        local junkBulk = smartInventoryCore.vectorToBulk(
            junkCluster.(vecProp)
        );
        #if __DEBUG_SMART_INVENTORY
        "\b
        getBulkFromProp: Found <<priorityBulk + junkBulk>>
        \b";
        #endif
        return priorityBulk + junkBulk;
    }

    getVectorFromProp(vecProp) {
        return fuseVectors(
            priorityCluster.(vecProp),
            junkCluster.(vecProp),
            true
        );
    }

    getFoundItems() {
        return getVectorFromProp(&itemsFoundHere);
    }

    getMovedItems() {
        return getVectorFromProp(&itemsMovedHere);
    }

    getWornClothes() {
        return getVectorFromProp(&clothesToWear);
    }

    getDoffedClothes() {
        return getVectorFromProp(&clothesToDoff);
    }

    getAssignedBulk() {
        return getBulkFromProp(&itemsAssignedHere) + minimumBulk;
    }

    getMovedBulk() {
        return getBulkFromProp(&itemsMovedHere) + minimumBulk;
    }

    getOverflowedBulk() {
        return getBulkFromProp(&itemsOverflowedHere) + minimumBulk;
    }

    bakeMinimumBulk() {
        #if __DEBUG_SMART_INVENTORY
        "\b
        bakeMinimumBulk: Baking...
        \b";
        #endif
        // Sometimes not all items in a container are accounted for,
        // so we find out the bulk of the unaccounted items, which we
        // can add back to future accounted bulks later.
        local filBulk = getBulkFromProp(&itemsFoundHere);
        local calBulk = destination.getCarriedBulk();
        #if __DEBUG_SMART_INVENTORY
        "\b
        bakeMinimumBulk: From <<destination.theName>>\n\t
        filBulk: <<filBulk>>\n\t
        calBulk: <<calBulk>>
        \b";
        #endif
        minimumBulk = calBulk - filBulk;
        #if __DEBUG_SMART_INVENTORY
        "\b
        bakeMinimumBulk: minimumBulk is <<minimumBulk>>
        \b";
        #endif
        resetPlan();
    }

    assignMovedItem(item) {
        if (smartInventoryCore.isPriorityItem(item)) {
            priorityCluster.assignMovedItem(item);
        }
        else {
            junkCluster.assignMovedItem(item);
        }
    }

    assignWornItem(item) {
        if (smartInventoryCore.isPriorityItem(item)) {
            priorityCluster.assignWornItem(item);
        }
        else {
            junkCluster.assignWornItem(item);
        }
    }

    resetPlan() {
        plannedCapacity = capacity - minimumBulk;
        clearVector(overflow);
        hadOverflow = nil;
    }

    planFit() {
        if (!priorityCluster.planFit(plannedCapacity)) {
            dumpVectorAIntoB(
                priorityCluster.itemsOverflowedHere,
                overflow,
                true
            );
        }

        plannedCapacity -= smartInventoryCore.vectorToBulk(
            priorityCluster.itemsMovedHere
        );

        if (!junkCluster.planFit(plannedCapacity)) {
            dumpVectorAIntoB(
                junkCluster.itemsOverflowedHere,
                overflow,
                true
            );
        }

        priorityCluster.bakePlan();
        junkCluster.bakePlan();

        hadOverflow = overflow.length > 0;
    }

    takeItem(item) {
        local tookPriority = priorityCluster.takeItem(item);
        local tookJunk = nil;
        if (!tookPriority) {
            tookJunk = junkCluster.takeItem(item);
        }
        return tookPriority || tookJunk;
    }

    acceptOverflowFrom(source) {
        for (local i = 1; i <= source.overflow.length; i++) {
            local item = source.overflow[i];
            if (source.takeItem(item)) {
                assignMovedItem(item);
            }
        }
        resetPlan();
        planFit();
    }
}

class SmartInventoryBatch: object {
    construct(_opType, additionalItems, customItems?) {
        opType = _opType;
        matches = customItems;

        if (matches == nil) {
            local matchObjects = new Vector(gCommand.dobjs.length);
            for (local i = 1; i <= gCommand.dobjs.length; i++) {
                matchObjects.append(gCommand.dobjs[i].obj);
            }
            matches = smartInventoryCore.getFilteredVector(
                matchObjects, allSuitPieces
            );
        }
        else {
            matches = convertToVector(matches);
        }

        if (additionalItems != nil) {
            matches = fuseVectors(
                matches, additionalItems,
                true
            );
        }

        if (matches.length == 0) {
            isValid = nil;
            return;
        }

        // Declare inventory paths
        floorPath = new SmartInventoryPathway(gPlayerChar.location);
        floorPath.acceptsSuperOverflow = true;
        bagPath = new SmartInventoryPathway(IN_SMART_BAG);
        bagPath.isAvailable = gPlayerChar.canReach(SMART_BAG);
        handsPath = new SmartInventoryPathway(gPlayerChar);

        switch (opType) {
            // Concentrate inventory into player and bag
            default:
                bagPath.fallbackPathways = [handsPath, floorPath];
                handsPath.fallbackPathways = (bagPath.isAvailable ?
                    [bagPath, floorPath] : [floorPath]
                );
                break;
            // Completely avoid anything being in the hands
            case operationFreeHands:
                bagPath.fallbackPathways = [floorPath];
                handsPath.fallbackPathways = (bagPath.isAvailable ?
                    [bagPath, floorPath] : [floorPath]
                );
                break;
        }        

        // Assemble all relevant items
        local actionScope = new Vector();
        dumpVectorAIntoB(gPlayerChar.contents, actionScope, true);
        if (bagPath.isAvailable) {
            dumpVectorAIntoB(IN_SMART_BAG.contents, actionScope, true);
        }
        dumpVectorAIntoB(matches, actionScope, true);

        // Funnel into categories
        floorPath.initializeItemsHere(actionScope, foundOnFloorFilter);
        if (bagPath.isAvailable) {
            bagPath.initializeItemsHere(actionScope, foundInBagFilter);
        }
        handsPath.initializeItemsHere(actionScope, foundOnPersonFilter);

        // Bake capacity metrics
        floorPath.bakeMinimumBulk();
        if (bagPath.isAvailable) {
            bagPath.bakeMinimumBulk();
        }
        handsPath.bakeMinimumBulk();
    }

    plan() {
        // Pick up bag
        local wasBagOpen = IN_SMART_BAG.isOpen;
        if (bagPath.isAvailable && !wasBagOpen) {
            if (smartInventoryCore.silent) {
                IN_SMART_BAG.makeOpen(true);
            }
            else {
                nestedAction(Open, IN_SMART_BAG);
            }
        }

        sortMatches();

        switch (opType) {
            default:
            case operationTakeItems:
                planTakeItems();
                break;
            case operationDropItems:
                planDropItems();
                break;
            case operationWearItems:
                planWearItems();
                break;
            case operationDoffItems:
                planDoffItems();
                break;
            case operationFreeHands:
                planFreeHands();
                break;
        }

        floorPath.resetPlan();
        if (bagPath.isAvailable) {
            bagPath.resetPlan();
        }
        handsPath.resetPlan();

        floorPath.planFit();
        if (bagPath.isAvailable) {
            bagPath.planFit();
        }
        handsPath.planFit();

        // Rearrange through fallbacks
        manageOverflow(handsPath);
        if (bagPath.isAvailable) {
            manageOverflow(bagPath);
        }

        // The floor cannot overflow
        if (floorPath.hadOverflow) {
            "<.p>{I} don't have enough room to move stuff around.
            {I} should try this again somewhere with more floor space.<.p>";
            isValid = nil;
            if (!wasBagOpen) {
                nestedAction(Close, IN_SMART_BAG);
            }
            return;
        }

        // Move unsorted pieces
        moveUnsortedPieces();

        local movedToFloor = floorPath.getMovedItems();
        local movedToBag = nil;
        if (bagPath.isAvailable) {
            movedToBag = bagPath.getMovedItems();
        }
        else {
            movedToBag = new Vector();
        }
        local movedToHands = handsPath.getMovedItems();
        local worn = handsPath.getWornClothes();
        local doffed = handsPath.getDoffedClothes();

        local totalMovedItems =
            movedToFloor.length +
            movedToBag.length +
            movedToHands.length;

        // Nothing moved
        if (totalMovedItems.length) {
            if (!smartInventoryCore.silent) {
                "<.p>{I} don't suppose there is a rearrangement
                that would achieve that.<.p>";
            }
            isValid = nil;
            if (!wasBagOpen) {
                if (smartInventoryCore.silent) {
                    IN_SMART_BAG.makeOpen(nil);
                }
                else {
                    nestedAction(Close, IN_SMART_BAG);
                }
            }
            return;
        }

        // Figure out what will be dropped, and then picked back up later.
        local startedInHands = handsPath.getFoundItems();
        // We don't drop things we have not yet grabbed
        subtractVecs(startedInHands, movedToHands);
        // We don't pick items back up if they're meant for the floor
        subtractVecs(startedInHands, movedToFloor);
        // We don't drop items meant for the bag
        subtractVecs(startedInHands, movedToBag);
        // We don't drop items we mean to wear later
        subtractVecs(startedInHands, worn);

        // Drop extra items
        performMoves(startedInHands, floorPath.destination);
        // Take off clothes
        performWearing(doffed, nil);
        // Drop the rest
        performMoves(movedToFloor, floorPath.destination);
        // Move items to bag
        performMoves(movedToBag, bagPath.destination);
        // Take hand items and clothes to wear
        performMoves(
            fuseVectors(movedToHands, worn),
            handsPath.destination,
            true
        );
        // Wear clothes
        performWearing(worn, true);
        // Pick up bag
        if (bagPath.isAvailable && !SMART_BAG.isIn(gPlayerChar)) {
            SMART_BAG.actionMoveInto(gPlayerChar);
            nestedAction(Wear, SMART_BAG);
            if (!wasBagOpen) {
                if (smartInventoryCore.silent) {
                    IN_SMART_BAG.makeOpen(nil);
                }
                else {
                    nestedAction(Close, IN_SMART_BAG);
                }
            }
        }
        // Pick up items from floor
        performMoves(startedInHands, handsPath.destination);
    }

    isCarriedByOtherActor(item) {
        if (item.isOrIsIn(gPlayerChar)) return nil;
        local itemParent = getParentOfItem(item);
        while (!isNonPlayerActor(itemParent)) {
            if (itemParent == nil) return nil;
            itemParent = getParentOfItem(itemParent);
        }
        return true;
    }

    getParentOfItem(item) {
        if (item == nil) return nil;
        if (item.ofKind(SubComponent)) return lexicalParent;
        return location;
    }

    isNonPlayerActor(actor) {
        if (actor == nil) return nil;
        if (!actor.ofKind(Actor)) return nil;
        return actor != gPlayerChar;
    }

    subtractVecs(sourceVec, subtractionVec) {
        for (local i = 1; i <= subtractionVec.length; i++) {
            local item = subtractionVec[i];
            local index = sourceVec.indexOf(item);
            if (index == nil) continue;
            sourceVec.removeElementAt(index);
        }
    }

    performMoves(movVec, destination) {
        if (movVec.length == 0) return;
        if (destination == gPlayerChar) {
            if (!smartInventoryCore.silent) {
                "<.p>{I} take
                <<smartInventoryCore.getList(movVec)>>.<.p>";
            }
        }
        else {
            local inStr = destination.objInPrep + ' ' + destination.theName;
            if (destination.ofKind(Room)) {
                inStr = destination.floorObj.objInPrep + ' ' +
                    destination.floorObj.theName;
            }
            if (!smartInventoryCore.silent) {
                "<.p>{I} put
                <<smartInventoryCore.getList(movVec)>> <<inStr>>.<.p>";
            }
        }
        for (local i = 1; i <= movVec.length; i++) {
            local item = movVec[i];
            item.actionMoveInto(destination);
        }
    }

    performWearing(clothesVec, state) {
        if (clothesVec.length == 0) return;
        if (!smartInventoryCore.silent) {
            if (state) {
                "<.p>{I} wear
                <<smartInventoryCore.getList(clothesVec)>>.<.p>";
            }
            else {
                "<.p>{I} take off
                <<smartInventoryCore.getList(clothesVec)>>.<.p>";
            }
        }
        for (local i = 1; i <= clothesVec.length; i++) {
            local item = clothesVec[i];
            item.makeWorn(state ? gPlayerChar : nil);
        }
    }

    pullItem(item) {
        if (floorPath.takeItem(item)) return true;
        if (bagPath.isAvailable) {
            if (bagPath.takeItem(item)) return true;
        }
        if (handsPath.takeItem(item)) return true;
        return nil;
    }

    storeItemAt(item, path) {
        if (pullItem(item)) {
            path.assignMovedItem(item);
            return true;
        }
        return nil;
    }

    wearItem(item) {
        if (pullItem(item)) {
            handsPath.assignWornItem(item);
            return true;
        }
        return nil;
    }

    manageOverflow(pathway) {
        if (pathway.overflow.length == 0) return;
        for (local i = 1; i <= pathway.fallbackPathways.length; i++) {
            local fallback = pathway.fallbackPathways[i];
            if (fallback.hadOverflow && !fallback.acceptsSuperOverflow) continue;
            fallback.acceptOverflowFrom(pathway);
            return;
        }
    }

    isValid = true

    opType = nil
    matches = nil

    floorPath = nil
    bagPath = nil
    handsPath = nil

    matchedSuitPiecesOnFloor = nil
    matchedJunkOnFloor = nil
    matchedSuitPiecesInBag = nil
    matchedJunkInBag = nil
    matchedSuitPiecesInHands = nil
    matchedJunkInHands = nil
    matchedUnbaggedSuitPieces = nil
    unsortedSuitPieces = nil

    isWearingAnOption = nil
    isPlanningToWear = nil

    sortMatches() {
        isWearingAnOption = (gPlayerChar.getOutermostRoom() == emergencyAirlock);

        matchedSuitPiecesOnFloor = smartInventoryCore.getFilteredVector(
            matches, suitPiecesOnFloorFilter
        );

        matchedJunkOnFloor = smartInventoryCore.getFilteredVector(
            matches, junkOnFloorFilter
        );

        if (bagPath.isAvailable) {
            matchedSuitPiecesInBag = smartInventoryCore.getFilteredVector(
                matches, suitPiecesInBagFilter
            );
        }
        else {
            matchedSuitPiecesInBag = new Vector();
        }

        if (bagPath.isAvailable) {
            matchedJunkInBag = smartInventoryCore.getFilteredVector(
                matches, junkInBagFilter
            );
        }
        else {
            matchedJunkInBag = new Vector();
        }

        matchedSuitPiecesInHands = smartInventoryCore.getFilteredVector(
            matches, suitPiecesInHandsFilter
        );

        matchedJunkInHands = smartInventoryCore.getFilteredVector(
            matches, junkInHandsFilter
        );

        matchedUnbaggedSuitPieces = smartInventoryCore.getFilteredVector(
            matches, unbaggedSuitPiecesFilter
        );

        if (!bagPath.isAvailable) return;
        
        // Suit pieces that are held in the hands,
        // but are not the focus of the current command.
        // Out of convenience, we can try to keep these in the bag
        unsortedSuitPieces = new Vector(
            handsPath.priorityCluster.itemsFoundHere.length
        );
        dumpVectorAIntoB(
            handsPath.priorityCluster.itemsFoundHere,
            unsortedSuitPieces,
            true
        );
        subtractVecs(
            unsortedSuitPieces,
            matches
        );
    }

    moveUnsortedPieces() {
        if (!bagPath.isAvailable) return;
        if (unsortedSuitPieces.length == 0) return;
        for (local i = 1; i <= unsortedSuitPieces.length; i++) {
            local piece = unsortedSuitPieces[i];
            if (bagPath.plannedCapacity < piece.bulk) return;
            if (storeItemAt(piece, bagPath)) {
                bagPath.plannedCapacity -= piece.bulk;
            }
        }
    }

    subPlanTakeItem(item) {
        local _isPriorityItem = smartInventoryCore.isPriorityItem(item);
        local foundInBag = bagPath.isAvailable ? 
            matchedSuitPiecesInBag.indexOf(item) != nil : nil;
        local baggingItems =
            bagPath.isAvailable &&
            (matchedUnbaggedSuitPieces.length > 0);
        
        // We are trying to take a suit piece out of the bag in
        // an attempt to wear it, but it was forbidden elsewhere.
        if (
            foundInBag && _isPriorityItem &&
            opType == operationWearItems &&
            !isPlanningToWear
        ) {
            // We are overriding an attempt to take something
            // out of a bag to wear.
            return nil;
        }

        // We are grabbing a suit piece that was not found
        // in the bag, and we are not intending to wear it,
        // and the bag is available.
        if (
            _isPriorityItem && ((!isPlanningToWear &&
            !foundInBag) || baggingItems) && bagPath.isAvailable
        ) {
            return storeItemAt(item, bagPath);
        }

        // We are intending to grab whatever this is.
        return storeItemAt(item, handsPath);
    }

    planTakeItems() {
        for (local i = 1; i <= matches.length; i++) {
            local item = matches[i];
            subPlanTakeItem(item);
        }
    }
    
    planDropItems() {
        for (local i = 1; i <= matches.length; i++) {
            local item = matches[i];
            storeItemAt(item, floorPath);
        }
    }

    planWearItems() {
        isPlanningToWear = true;
        if (!isWearingAnOption) {
            if (!smartInventoryCore.silent) {
                "<.p><<EnviroSuitPart.doNotWearOutsideAirlockMsg>><.p>";
            }
            isPlanningToWear = nil;
        }

        for (local i = 1; i <= matches.length; i++) {
            local item = matches[i];
            if (item.wornBy != nil) continue;
            if (!item.isWearable) continue;
            if (subPlanTakeItem(item) && isPlanningToWear) {
                wearItem(item);
            }
        }
    }

    planDoffItems() {
        for (local i = 1; i <= matches.length; i++) {
            local item = matches[i];
            if (item.wornBy == nil) continue;
            subPlanTakeItem(item);
        }
    }

    planFreeHands() {
        for (local i = 1; i <= matches.length; i++) {
            local item = matches[i];
            if (bagPath.isAvailable) {
                storeItemAt(item, bagPath);
            }
            else {
                storeItemAt(item, floorPath);
            }
        }
    }
}

allSuitPieces: SmartInventoryFilter {
    includeWornObjects = true
    includeWearableObjects = true
    includeHeldObjects = true
    includeBaggedObjects = true
    includeSmartBagAsItem = nil
    includeZeroBulkItems = true
    includeInReach = true
    includePriorityItems = true
    includeJunkItems = nil
}

foundOnFloorFilter: SmartInventoryFilter {
    includeWornObjects = nil
    includeWearableObjects = true
    includeHeldObjects = nil
    includeBaggedObjects = nil
    includeSmartBagAsItem = nil
    includeZeroBulkItems = nil
    includeInReach = true
    includePriorityItems = true
    includeJunkItems = true
}

foundInBagFilter: SmartInventoryFilter {
    includeWornObjects = nil
    includeWearableObjects = true
    includeHeldObjects = nil
    includeBaggedObjects = true
    includeSmartBagAsItem = nil
    includeZeroBulkItems = nil
    includeInReach = nil
    includePriorityItems = true
    includeJunkItems = true
}

foundOnPersonFilter: SmartInventoryFilter {
    includeWornObjects = true
    includeWearableObjects = true
    includeHeldObjects = true
    includeBaggedObjects = nil
    includeSmartBagAsItem = nil
    includeZeroBulkItems = true
    includeInReach = nil
    includePriorityItems = true
    includeJunkItems = true
}

heldSuitPiecesFilter: foundOnPersonFilter {
    includeWornObjects = nil
    includePriorityItems = true
    includeJunkItems = nil
}

unbaggedSuitPiecesFilter: SmartInventoryFilter {
    includeWornObjects = true
    includeWearableObjects = true
    includeHeldObjects = true
    includeBaggedObjects = nil
    includeSmartBagAsItem = nil
    includeZeroBulkItems = true
    includeInReach = true
    includePriorityItems = true
    includeJunkItems = nil
}

suitPiecesOnFloorFilter: foundOnFloorFilter {
    includePriorityItems = true
    includeJunkItems = nil
}

junkOnFloorFilter: foundOnFloorFilter {
    includePriorityItems = nil
    includeJunkItems = true
}

suitPiecesInBagFilter: foundInBagFilter {
    includePriorityItems = true
    includeJunkItems = nil
}

junkInBagFilter: foundInBagFilter {
    includePriorityItems = nil
    includeJunkItems = true
}

suitPiecesInHandsFilter: foundOnPersonFilter {
    includePriorityItems = true
    includeJunkItems = nil
}

junkInHandsFilter: foundOnPersonFilter {
    includePriorityItems = nil
    includeJunkItems = true
}