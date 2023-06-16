#define SMART_BAG enviroSuitBag
#define IN_SMART_BAG enviroSuitBag.remapIn

enum operationTakeItems, operationDropItems, operationWearItems, operationDoffItems;

smartInventoryCore: object {
    activeBatch = nil
    hasBatch = (activeBatch != nil)
    batchFailed = nil

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
        activeBatch.plan();
        batchFailed = !activeBatch.isValid;
    }

    reset() {
        activeBatch = nil;
        batchFailed = nil;
    }

    getFilteredVector(originalVector, filterObject) {
        if (originalVector == nil) return nil;
        if (dataIsNotCollection(originalVector)) {
            originalVector = new Vector([originalVector]);
        }
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

    dataIsNotCollection(obj) {
        if (obj == nil) return true;
        return !obj.ofKind(Collection);
    }

    convertToVector(obj) {
        if (obj == nil) return new Vector();
        if (obj.ofKind(Vector)) return obj;
        if (obj.ofKind(List)) return new Vector(obj);
        local ret = new Vector(1);
        ret.append(obj);
        return ret;
    }

    dumpVectorAIntoB(a, b) {
        if (a == nil) return;
        if (!b.ofKind(Vector)) {
            throw new Exception('b is not a true Vector! ');
        }
        if (dataIsNotCollection(a)) {
            b.appendUnique(a);
            return;
        }
        for (local i = 1; i <= a.length; i++) {
            b.appendUnique(a[i]);
        }
    }

    fuseVectors(a, b) {
        local aNCol = dataIsNotCollection(a);
        local bNCol = dataIsNotCollection(b);
        local aLen = aNCol ? 1 : a.length;
        local bLen = bNCol ? 1 : b.length;

        local repo = new Vector(aLen + bLen);

        if (a != nil) {
            if (aNCol) {
                repo.appendUnique(a);
            }
            else {
                dumpVectorAIntoB(a, repo);
            }
        }

        if (b != nil) {
            if (bNCol) {
                repo.appendUnique(b);
            }
            else {
                dumpVectorAIntoB(b, repo);
            }
        }

        return repo;
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
        if (item.isFixed) return nil;
        if (item.bulk > 2) return nil;
        if (!includeWornObjects) {
            if (item.wornBy == gPlayerChar) return nil;
        }
        if (!includeWearableObjects) {
            if (item.isWearable) return nil;
        }
        if (!includeHeldObjects && item.wornBy == nil) {
            if (
                item.isIn(gPlayerChar) &&
                !item.isIn(IN_SMART_BAG)
            ) return nil;
        }
        if (!includeBaggedObjects) {
            if (item.isIn(IN_SMART_BAG)) return nil;
        }
        if (!includeSmartBagAsItem) {
            if (item == SMART_BAG) return nil;
        }
        if (!includeZeroBulkItems) {
            if (item.bulk <= 0) return nil;
        }
        if (!includeInReach) {
            if (!item.isIn(gPlayerChar)) return nil;
        }
        else {
            if (!gPlayerChar.canReach(item)) return nil;
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
        if (itemsMovedHere.length > 0) itemsMovedHere.removeRange(1, -1);
        if (itemsOverflowedHere.length > 0) itemsOverflowedHere.removeRange(1, -1);
        if (clothesToWear.length > 0) clothesToWear.removeRange(1, -1);
        if (clothesToDoff.length > 0) clothesToDoff.removeRange(1, -1);

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
    construct(_fallbacks, _dest) {
        fallbackPathways = valToList(_fallbacks);
        destination = _dest;
        priorityCluster = new SmartInventoryCluster(self);
        junkCluster = new SmartInventoryCluster(self);
        overflow = new Vector(16);
    }

    isAvailable = nil
    fallbackPathways = nil
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
        local priorityBulk = smartInventoryCore.vectorToBulk(
            priorityCluster.(vecProp)
        );
        local junkBulk = smartInventoryCore.vectorToBulk(
            junkCluster.(vecProp)
        );
        return priorityBulk + junkBulk;
    }

    getVectorFromProp(vecProp) {
        return smartInventoryCore.fuseVectors(
            priorityCluster.(vecProp),
            junkCluster.(vecProp)
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
        // Sometimes not all items in a container are accounted for,
        // so we find out the bulk of the unaccounted items, which we
        // can add back to future accounted bulks later.
        local filBulk = getBulkFromProp(&itemsFoundHere);
        local calBulk = destination.getCarriedBulk();
        minimumBulk = calBulk - filBulk;
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
        if (overflow.length > 0) overflow.removeRange(1, -1);
        hadOverflow = nil;
    }

    planFit() {
        if (!priorityCluster.planFit(plannedCapacity)) {
            smartInventoryCore.dumpVectorAIntoB(
                priorityCluster.itemsOverflowedHere,
                overflow
            );
        }

        plannedCapacity -= smartInventoryCore.vectorToBulk(
            priorityCluster.itemsMovedHere
        );

        if (!junkCluster.planFit(plannedCapacity)) {
            smartInventoryCore.dumpVectorAIntoB(
                junkCluster.itemsOverflowedHere,
                overflow
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
            matches = smartInventoryCore.convertToVector(gCommand.dobjs);
        }
        else {
            matches = smartInventoryCore.convertToVector(matches);
        }

        if (additionalItems != nil) {
            matches = smartInventoryCore.fuseVectors(
                matches, additionalItems
            );
        }

        if (matches.length == 0) {
            isValid = nil;
            return;
        }

        floorPath = new SmartInventoryPathway(nil, gPlayerChar.location);
        floorPath.acceptsSuperOverflow = true;
        bagPath = new SmartInventoryPathway([handsPath, floorPath], IN_SMART_BAG);
        bagPath.isAvailable = gPlayerChar.canReach(SMART_BAG);
        handsPath = new SmartInventoryPathway(
            bagPath.isAvailable ? [bagPath, floorPath] : floorPath,
            gPlayerChar.contents
        );

        // Assemble all relevant items
        local actionScope = new Vector();
        smartInventoryCore.dumpVectorAIntoB(gPlayerChar.contents, actionScope);
        if (bagPath.isAvailable) {
            smartInventoryCore.dumpVectorAIntoB(IN_SMART_BAG.contents, actionScope);
        }
        smartInventoryCore.dumpVectorAIntoB(matches, actionScope);

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
        //TODO: Make assignments
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
            return;
        }

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
            smartInventoryCore.fuseVectors(movedToHands, worn),
            handsPath.destination
        );
        // Wear clothes
        performWearing(worn, true);
        // Pick up items from floor
        performMoves(startedInHands, handsPath.destination);
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
            "<.p>{I} take 
            <<makeListStr(valToList(movVec), &theName, 'and')>>.<.p>";
        }
        else {
            "<.p>{I} put
            <<makeListStr(valToList(movVec), &theName, 'and')>>
            <<destination.objInPrep>> <<destination.theName>>.<.p>";
        }
        for (local i = 1; i <= movVec.length; i++) {
            local item = movVec[i];
            item.actionMoveInto(destination);
        }
    }

    performWearing(clothesVec, state) {
        if (clothesVec.length == 0) return;
        if (state) {
            "<.p>{I} put on 
            <<makeListStr(valToList(clothesVec), &theName, 'and')>>.<.p>";
        }
        else {
            "<.p>{I} take off
            <<makeListStr(valToList(clothesVec), &theName, 'and')>>.<.p>";
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

    planTakeItems() {
        //TODO: Plan
    }
    
    planDropItems() {
        //TODO: Plan
    }

    planWearItems() {
        //TODO: Plan
    }

    planDoffItems() {
        //TODO: Plan
    }
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
    includeInReach = true
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

foundInHandsFilter: SmartInventoryFilter {
    includeWornObjects = nil
    includeWearableObjects = true
    includeHeldObjects = true
    includeBaggedObjects = nil
    includeSmartBagAsItem = nil
    includeZeroBulkItems = nil
    includeInReach = nil
    includePriorityItems = true
    includeJunkItems = true
}

wearingAsSuitFilter: SmartInventoryFilter {
    includeWornObjects = true
    includeWearableObjects = true
    includeHeldObjects = nil
    includeBaggedObjects = nil
    includeSmartBagAsItem = nil
    includeZeroBulkItems = true
    includeInReach = nil
    includePriorityItems = true
    includeJunkItems = nil
}