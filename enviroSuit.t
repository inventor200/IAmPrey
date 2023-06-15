suitTracker: object {
    missingPieces = static new Vector([
        enviroHelmet,
        enviroTorso,
        enviroPants,
        enviroLeftGlove,
        enviroRightGlove,
        enviroLeftBoot,
        enviroRightBoot
    ])
    gatheredPieces = static new Vector(8)
    discoveredPieces = static new Vector(8)
    foundFakeHelmet = nil
    firstHelmetFound = nil

    findHelmet(helmet) {
        if (firstHelmetFound) return;
        firstHelmetFound = helmet;
    }

    isFirstHelmet(helmet) {
        if (firstHelmetFound == nil) return true;
        if (!allowFakeHilarity()) {
            return helmet == enviroHelmet;
        }
        return firstHelmetFound == helmet;
    }

    getHelmetSortingOrder(helmet) {
        return isFirstHelmet(helmet) ? 1 : 10;
    }

    getHelmetIndex(helmet) {
        if (firstHelmetFound == nil) return 1;
        if (!allowFakeHilarity()) {
            return (helmet == enviroHelmet) ? 1 : 3;
        }
        return (firstHelmetFound == helmet) ? 1 : 2;
    }

    getHelmetShortName(helmet) {
        switch (getHelmetIndex(helmet)) {
            default:
                return 'helmet';
            case 2:
                return 'other helmet';
            case 3:
                return 'fake helmet';
        }
    }

    getTheHelmetName(helmet) {
        switch (getHelmetIndex(helmet)) {
            default:
                return 'the envirosuit helmet';
            case 2:
                return 'the other helmet';
            case 3:
                return 'the fake helmet';
        }
    }

    getAHelmetName(helmet) {
        switch (getHelmetIndex(helmet)) {
            default:
                return 'an envirosuit helmet';
            case 2:
                return 'another helmet';
            case 3:
                return 'a fake helmet';
        }
    }

    foundRealHelmet() {
        return enviroHelmet.moved;
    }

    allowFakeHilarity() {
        return !(fakeHelmet.isRevealedFake || foundRealHelmet());
    }

    getCount() {
        local startingCount = gatheredPieces.length;
        if (allowFakeHilarity() && foundFakeHelmet && !enviroHelmet.seen) {
            // Only let the fake helmet increase the count if it's the only
            // helmet we've seen so far. If we find 2 helmets, then just
            // count 1.
            startingCount++;
        }
        return startingCount;
    }

    getFullCount() {
        return gatheredPieces.length +
            (foundFakeHelmet ? 1 : 0);
    }

    markPiece(piece) {
        if (piece == enviroHelmet || piece == fakeHelmet) findHelmet(piece);
        local oldCount = getFullCount();
        if (piece != fakeHelmet) {
            gatheredPieces.appendUnique(piece);
        }
        else if (allowFakeHilarity()) {
            foundFakeHelmet = true;
        }
        local newCount = getFullCount();
        if (oldCount != newCount) {
            discoveredPieces.append(piece);
            if (announceDaemon != nil) return;
            announceDaemon = new OneTimePromptDaemon(self, &announcePieces);
        }
    }

    announceDaemon = nil

    announcePieces() {
        if (discoveredPieces.length == 0) {
            clearAnnounceEvent();
            return;
        }
        local strList = 'the ' + makeListStr(valToList(discoveredPieces), &shortName, 'and');
        local numLeft = 7 - getCount();
        if (numLeft < 0) numLeft = 0;
        local toGoPhrase = 'That\'s all of them! {I} must enter the Emergency Airlock!!
            {I} cannot allow <<gSkashekName>> to stop me now! {My} victory is so close!\b
            <i>(Set your compass by typing in
            <<formatCommand('go to emergency airlock', longCmd)>>,
            and find the next step in the route with
            <<formatTheCommand('compass', shortCmd)>>!)</i>';
        if (numLeft > 0) {
            local pieceNoun = 'piece';
            if (numLeft != 1) pieceNoun += 's';
            toGoPhrase = 'Only ' + spellNumber(numLeft) +
                ' more envirosuit ' + pieceNoun + ' to go!';
        }
        say('<.p><b>{I} found ' + strList + '!</b>\b' + toGoPhrase + '<.p>');
        clearAnnounceEvent();
    }

    clearAnnounceEvent() {
        if (announceDaemon != nil) announceDaemon.removeEvent();
        announceDaemon = nil;
    }

    getProgressLists() {
        local strBfr = new StringBuffer(18);

        local carriedParts = [];
        local partsFound = [];
        local partsRemaining = [];

        for (local i = 1; i <= suitTracker.missingPieces.length; i++) {
            local piece = suitTracker.missingPieces[i];
            if (piece.isIn(gPlayerChar) || piece.isWornBy(gPlayerChar)) {
                carriedParts += piece;
            }
            else if (gatheredPieces.indexOf(piece) != nil) {
                partsFound += piece;
            }
            else {
                partsRemaining += piece;
            }
        }

        if (allowFakeHilarity() && foundFakeHelmet) {
            partsFound += fakeHelmet;
        }

        if (carriedParts.length > 0) {
            strBfr.append('{I} {am} currently carrying the ');
            strBfr.append(makeListStr(carriedParts, &shortName, 'and'));
            strBfr.append('. ');
        }
        if (partsFound.length > 0) {
            strBfr.append('\b{I} have found (but {am} not carrying) the ');
            strBfr.append(makeListStr(partsFound, &getLocationString, 'and'));
            strBfr.append('. ');
        }
        if (partsRemaining.length > 0) {
            strBfr.append('\b{I} still have to find the ');
            strBfr.append(makeListStr(partsRemaining, &shortName, 'and'));
            strBfr.append('. ');
        }

        strBfr.append('<.p>');
        return toString(strBfr);
    }
}

VerbRule(SlingOverShoulder)
    (
        'sling' singleDobj 'over' |
        ('put'|'carry'|'drape') singleDobj ('on'|'over'|'across') |
        'hang' singleDobj ('on'|'over'|'across'|'from')
    )
    ('my'|'the'|'prey\'s'|'preys'|'your'|) 'shoulder'
    : VerbProduction
    action = SlingOverShoulder
    verbPhrase = 'sling/slinging (what) over the shoulder'
    missingQ = 'what do you want to carry over the shoulder'
;

DefineTAction(SlingOverShoulder)
;

VerbRule(StrapOn)
    'strap' 'on' singleDobj |
    'strap' singleDobj 'on'
    : VerbProduction
    action = StrapOn
    verbPhrase = 'strap/strapping on (what)'
    missingQ = 'what do you want to strap on'
;

DefineTAction(StrapOn)
;

VerbRule(Unstrap)
    'unstrap' singleDobj
    : VerbProduction
    action = Unstrap
    verbPhrase = 'unstrap/unstrapping (what)'
    missingQ = 'what do you want to unstrap'
;

DefineTAction(Unstrap)
;

VerbRule(Zip)
    'zip' singleDobj |
    'zip' ('up'|'closed'|'shut') singleDobj |
    'zip' singleDobj ('up'|'closed'|'shut')
    : VerbProduction
    action = Zip
    verbPhrase = 'zip/zipping up (what)'
    missingQ = 'what do you want to zip up'
;

DefineTAction(Zip)
;

VerbRule(Unzip)
    'unzip' singleDobj |
    'zip' ('open') singleDobj |
    'zip' singleDobj ('open') |
    'unzip' ('open') singleDobj |
    'unzip' singleDobj ('open')
    : VerbProduction
    action = Unzip
    verbPhrase = 'unzip/unzipping up (what)'
    missingQ = 'what do you want to unzip'
;

DefineTAction(Unzip)
;

modify Thing {
    canSlingOverShoulder = nil
    canStrapOn = nil
    canZipMe = nil
    shouldZipMe = (isOpenable && canZipMe)

    cannotZipMsg =
        '{I} {cannot} zip {that dobj}. '

    shouldNotZipMsg =
        '{I} {have} no reason to zip {that dobj}. '

    cannotUnzipMsg =
        '{I} {cannot} unzip {that dobj}. '

    shouldNotUnzipMsg =
        '{I} {have} no reason to unzip {that dobj}. '

    dobjFor(SlingOverShoulder) {
        preCond = [touchObj]
        verify() {
            if (!canSlingOverShoulder) {
                illogical('{That subj dobj} {is} not carried over a shoulder. ');
            }
        }
        action() {
            doInstead(Take, self);
        }
    }

    dobjFor(StrapOn) {
        preCond = [touchObj]
        verify() {
            if (!canStrapOn) {
                illogical('{I} {cannot} strap {that dobj} on. ');
            }
        }
        action() {
            doInstead(Wear, self);
        }
    }

    dobjFor(Unstrap) {
        preCond = [touchObj]
        verify() {
            if (!canStrapOn) {
                illogical('{I} {cannot} unstrap {that dobj}. ');
            }
        }
        action() {
            doInstead(Doff, self);
        }
    }

    dobjFor(Zip) {
        preCond = [touchObj]
        remap() {
            if (!canZipMe && remapIn != nil && remapIn.canZipMe) {
                return remapIn;
            }
            return self;
        }
        verify() {
            if (!canZipMe) {
                inaccessible(cannotZipMsg);
            }
            if (!isOpenable) {
                illogical(
                    '{That subj dobj} {is} already zipped up. '
                );
            }
            else if (!shouldZipMe) {
                illogical(shouldNotZipMsg);
            }
        }
        action() {
            doInstead(Close, self);
        }
    }

    dobjFor(Unzip) {
        preCond = [touchObj]
        remap() {
            if (!canZipMe && remapIn != nil && remapIn.canZipMe) {
                return remapIn;
            }
            return self;
        }
        verify() {
            if (!canZipMe) {
                inaccessible(cannotUnzipMsg);
            }
            if (isOpenable && isOpen) {
                illogical(
                    '{That subj dobj} {is} already unzipped. '
                );
            }
            else if (!shouldZipMe) {
                illogical(shouldNotUnzipMsg);
            }
        }
        action() {
            doInstead(Open, self);
        }
    }

    okayOpenMsg = (canZipMe ?
        'Unzipped. |{I} unzip{s/?ed} <<gActionListStr>>. ' :
        'Opened. |{I} open{s/ed} <<gActionListStr>>. '
    )
    okayClosedMsg = (canZipMe ?
        'Zipped. |{I} zip{s/?ed} up <<gActionListStr>>. ' :
        'Done. |{I} close{s/d} <<gActionListStr>>. '
    )

    dobjFor(Close) {
        report() {
            say(okayClosedMsg);
        }
    }
}

class Zippable: Thing {
    startUnzipped = nil

    IncludeDistComponent(Zipper)
}

DefineDistSubComponentFor(ZippableInternals, Zippable, remapIn)
    isOpen = nil
    isOpenable = true
    canZipMe = true
    distOrder = 1

    postCreate(_lexParent) {
        bulkCapacity = _lexParent.bulkCapacity;
        maxSingleBulk = _lexParent.maxSingleBulk;
        isOpen = _lexParent.startUnzipped;
    }
;

DefineDistComponent(Zipper)
    vocab = 'zipper;;fly tab'
    desc = "A small, metal zipper tab. "
    basicHandleTabProperties
    decorationActions = [Examine, Pull, Open, Close, Zip, Unzip]
    matchPhrases = ['zipper', 'fly', 'tab']

    hatchHandlerProperties

    getLikelyHatch(obj) {
        return obj.remapIn;
    }

    hasPrefabMatchWith(obj) {
        if (!obj.ofKind(AbstractDistributedComponent)) return nil;
        if (obj.originalPrototype == prototypeFakeZipper) return true;
        return obj.originalPrototype == originalPrototype;
    }

    dobjFor(Open) { remap = (hatch) }
    dobjFor(Close) { remap = (hatch) }
    dobjFor(Zip) { remap = (hatch) }
    dobjFor(Unzip) { remap = (hatch) }
    dobjFor(Pull) {
        remap = nil
        preCond = [touchObj]
        verify() { }
        check() { }
        action() {
            if (hatch.isOpen) {
                doInstead(Zip, hatch);
            }
            else {
                doInstead(Unzip, hatch);
            }
        }
    }
;

class FakeZippable: Thing {
    startUnzipped = nil
    canZipMe = true
    shouldZipMe = nil

    IncludeDistComponent(FakeZipper)
}

DefineDistComponent(FakeZipper)
    vocab = 'zipper;;fly tab'
    desc() { prototypeZipper.desc(); }
    basicHandleTabProperties
    decorationActions = [Examine, Pull, Open, Close, Zip, Unzip]
    matchPhrases = ['zipper', 'fly', 'tab']

    postCreate(_lexParent) {
        addParentVocab(_lexParent);
    }

    remapReach(action) {
        return lexicalParent;
    }

    getLikelyHatch(obj) {
        return obj.remapIn;
    }

    hasPrefabMatchWith(obj) {
        if (!obj.ofKind(AbstractDistributedComponent)) return nil;
        if (obj.originalPrototype == prototypeZipper) return true;
        return obj.originalPrototype == originalPrototype;
    }

    dobjFor(Open) { remap = (lexicalParent) }
    dobjFor(Close) { remap = (lexicalParent) }
    dobjFor(Zip) { remap = (lexicalParent) }
    dobjFor(Unzip) { remap = (lexicalParent) }
    dobjFor(Pull) {
        remap = nil
        preCond = [touchObj]
        verify() { }
        check() { }
        action() {
            if (hatch.isOpen) {
                doInstead(Zip, lexicalParent);
            }
            else {
                doInstead(Unzip, lexicalParent);
            }
        }
    }
;

enviroSuitBag: BagOfHolding, Wearable, Zippable {
    'envirosuit bag;enviro environment suit carryall[weak] duffel;kit carryall'
    "A large duffel bag, which is designed to carry all the pieces of the envirosuit.
    The full suit normally arrives packaged in this, if {i} had to take a guess. "

    bulk = 2
    bulkCapacity = actorCapacity
    maxSingleBulk = 2
    canSlingOverShoulder = true
    canStrapOn = true
    startUnzipped = true

    // After the player picks up the bag, any time
    // inventory is checked and the bag is not in inventory BUT
    // IS IN REACH, then it will also be automatically checked.
    // However, we are only going to support this AFTER the player
    // picks up the bag for the first time, so we do not accidentally
    // create the suspicion that the bag never needs to be carried,
    // if the player starts the game by checking inventory.
    isUnited = nil
    markUnited() {
        isUnited = true;
    }

    hideFromAll(action) {
        //if (gActionIs(Wear)) return true;
        //return wornBy != nil;
        return true;
    }

    dobjFor(Take) {
        action() {
            inherited();
            if (gAction.parentAction == nil) {
                nestedAction(Wear, self);
            }
        }
        report() { }
    }

    dobjFor(Wear) {
        report() {
            """
            <<first time>><.p><<markUnited()>><i>Excellent,</i>
            {i} think to {myself}, as {i} examine
            the bag.
            <<if remapIn.contents.length == 0
            >>Of course it's <i>empty</i>, but {i} won't
            need to carry everything in my hands anymore.\b<<end>>
            There is a small victory in this.\b
            <<only>>
            {I} sling the envirosuit bag over my shoulder.
            """;
        }
    }

    dobjFor(Doff) {
        report() {
            "{I} slip off the envirosuit bag's strap. ";
        }
    }

    affinityFor(obj) {
        if (obj == fakeHelmet) return 0;
        if (obj.ofKind(Outfit)) return 0;
        if (obj.ofKind(EnviroSuitPart)) return 100;
        return 50;
    }
}
+enviroSuitBagStrap: Fixture { 'strap'
    "A long loop of synthetic fiber, to be put over the wearer's shoulder. "
    owner = [enviroSuitBag]
    ownerNamed = true
    canSlingOverShoulder = true
    canStrapOn = true

    hideFromAll(action) {
        return enviroSuitBag.hideFromAll(action);
    }

    dobjFor(Take) { remap = enviroSuitBag }
    dobjFor(TakeFrom) { remap = enviroSuitBag }
    dobjFor(Wear) { remap = enviroSuitBag }
    dobjFor(Doff) { remap = enviroSuitBag }
    dobjFor(SlingOverShoulder) { remap = enviroSuitBag }
    dobjFor(StrapOn) { remap = enviroSuitBag }
    dobjFor(Unstrap) { remap = enviroSuitBag }
}

suitWearingRuleHandler: object {
    isSuitingUp = nil
    hasPreparedExplanation = nil
    hasExplained = nil
    hasDoneTakes = nil
    suitPartsInAll = static new Vector(8)
    suitPartsInBag = static new Vector(8)
    suitPartsInInventory = static new Vector(8)
    suitPartsNearby = static new Vector(8)

    reset() {
        isSuitingUp = nil;
        hasPreparedExplanation = nil;
        hasExplained = nil;
        hasDoneTakes = nil;

        if (suitPartsInAll.length > 0) {
            suitPartsInAll.removeRange(1, -1);
        }
        if (suitPartsInBag.length > 0) {
            suitPartsInBag.removeRange(1, -1);
        }
        if (suitPartsInInventory.length > 0) {
            suitPartsInInventory.removeRange(1, -1);
        }
        if (suitPartsNearby.length > 0) {
            suitPartsNearby.removeRange(1, -1);
        }
    }

    prepareExplanation(suitingUp?, doffing?) {
        if (hasPreparedExplanation) return;
        hasPreparedExplanation = true;
        isSuitingUp = suitingUp;

        local matches = gCommand.dobjs;

        for (local i = 1; i <= matches.length; i++) {
            local obj = matches[i].obj;
            if (!obj.ofKind(EnviroSuitPart)) continue;
            if (obj.wornBy != nil && !doffing) continue;
            if (obj.isIn(enviroSuitBag)) {
                suitPartsInBag += obj;
                suitPartsInAll += obj;
            }
            else if (obj.isIn(gPlayerChar)) {
                suitPartsInInventory += obj;
                suitPartsInAll += obj;
            }
            else if (gPlayerChar.canReach(obj)) {
                suitPartsNearby += obj;
            }
        }
    }

    prepareAutoDoff() {
        if (hasPreparedExplanation) return;
        hasPreparedExplanation = true;

        for (local i = 1; i <= suitTracker.missingPieces.length; i++) {
            local obj = suitTracker.missingPieces[i];
            if (obj.wornBy == gPlayerChar) {
                suitPartsInInventory += obj;
                suitPartsInAll += obj;
            }
        }
    }

    showExplanation(isTaking?, doffing?) {
        if (!hasPreparedExplanation) return;
        if (hasExplained) return;
        hasExplained = true;

        if (isSuitingUp) {
            say('\n');
        }
        else {
            if (isTaking) {
                say('\n');
            }
            else {
                say('\n' + EnviroSuitPart.doNotWearOutsideAirlockMsg + '\b');
            }

            if (suitPartsInBag.length > 0) {
                say(
                    'The <<makeListStr(valToList(suitPartsInBag), &shortName, 'and')>>
                    <<suitPartsInBag.length > 1 ? 'are' : 'is'>>
                    already in the bag, so
                    <<suitPartsInBag.length > 1 ? 'they' : 'it'>>
                    remain in there.
                    \b'
                );
            }

            if (suitPartsInInventory.length > 0 && !doffing) {
                say(
                    'The <<makeListStr(valToList(suitPartsInInventory), &shortName, 'and')>>
                    <<suitPartsInInventory.length > 1 ? 'are' : 'is'>>
                    already in my inventory.
                    \b'
                );
            }
        }
    }

    doTakes(doffing?) {
        if (!hasPreparedExplanation) return;
        if (hasDoneTakes) return;
        hasDoneTakes = true;

        local piecesToMove = new Vector(8);

        local bagAvailable = gPlayerChar.canReach(enviroSuitBag);

        for (local i = 1; i <= suitPartsInInventory.length; i++) {
            local item = suitPartsInInventory[i];
            local moving = true;
            if (doffing) {
                moving = (item.wornBy == gPlayerChar);
            }
            if (moving) piecesToMove.append(item);
        }

        if (!doffing) {
            for (local i = 1; i <= suitPartsNearby.length; i++) {
                piecesToMove.append(suitPartsNearby[i]);
            }

            if (isSuitingUp && bagAvailable) {
                for (local i = 1; i <= suitPartsInBag.length; i++) {
                    piecesToMove.append(suitPartsInBag[i]);
                }
            }
        }

        if (piecesToMove.length == 0) return;

        if (!bagAvailable && !isSuitingUp && !doffing) {
            say(
                '{My} envirosuit bag cannot be reached, so the
                <<makeListStr(valToList(piecesToMove), &shortName, 'and')>>
                <<piecesToMove.length > 1 ? 'are' : 'is'>>
                going to remain here for the moment.
                \b'
            );
            return;
        }

        local smallestBulkToCarry = 1;
        local bulkToClear = 0;
        local bulkToDoff = 0;

        for (local i = 1; i <= piecesToMove.length; i++) {
            local item = piecesToMove[i];
            if (item.bulk > smallestBulkToCarry) {
                smallestBulkToCarry = item.bulk;
            }
            if (!isSuitingUp) {
                bulkToClear += item.bulk;
            }
            if (doffing) {
                bulkToDoff += item.bulk;
            }
        }

        local bulkDroppedFromHands = 0;
        local bulkDroppedFromBag = 0;

        local bulkAvailableInLocation =
            gPlayerChar.location.bulkCapacity
            - gPlayerChar.location.getCarriedBulk();
        local bulkAvailableInHands =
            gPlayerChar.bulkCapacity
            - gPlayerChar.getCarriedBulk();
        local bulkAvailableInBag = bagAvailable ?
            (enviroSuitBag.remapIn.bulkCapacity
            - enviroSuitBag.remapIn.getCarriedBulk()) : 0;
        
        local droppedItems = new Vector(16);

        if (isSuitingUp) {
            smallestBulkToCarry = 2;
        }
        // Make sure bag is free
        else if (bulkAvailableInBag < bulkToClear && bagAvailable) {
            local goalBulk = doffing ? bulkToDoff : bulkToClear;
            for (local i = 1; i <= enviroSuitBag.remapIn.contents.length; i++) {
                local item = enviroSuitBag.remapIn.contents[i];
                if (item.bulk <= 0) continue;
                if (item.isFixed) continue;
                if (enviroSuitBag.affinityFor(item) > 90) continue;
                if (item.bulk > smallestBulkToCarry) {
                    smallestBulkToCarry = item.bulk;
                }
                droppedItems.append(item);
                bulkDroppedFromBag += item.bulk;
                if (bulkAvailableInBag + bulkDroppedFromBag >= goalBulk) {
                    break;
                }
            }
        }

        local bulkToDiscard = 0;

        if (!bagAvailable && doffing) {
            // We don't have our bag, and we gotta put this somewhere
            // so to the floor it goes.
            for (local i = 1; i <= piecesToMove.length; i++) {
                bulkToDiscard += piecesToMove[i].bulk;
            }
        }

        // Make sure hands are free
        if (bulkAvailableInHands < smallestBulkToCarry) {
            for (local i = 1; i <= gPlayerChar.contents.length; i++) {
                local item = gPlayerChar.contents[i];
                if (item.wornBy == gPlayerChar) continue;
                if (item.bulk <= 0) continue;
                if (item == enviroSuitBag) continue;
                if (item.isFixed) continue;
                if (droppedItems.length > 0) {
                    droppedItems.insertAt(1, item);
                }
                else {
                    droppedItems.append(item);
                }
                bulkDroppedFromHands += item.bulk;
                if (bulkAvailableInHands + bulkDroppedFromHands >= smallestBulkToCarry) {
                    break;
                }
            }
        }

        local totalBulkToDrop = bulkDroppedFromBag + bulkDroppedFromHands + bulkToDiscard;

        if (totalBulkToDrop > 0) {
            // Make sure there's organizing room first
            if (bulkAvailableInLocation < totalBulkToDrop) {
                say(
                    '{I} don\'t have enough room where {i} stand to drop some things,
                    and clear some space in {my} inventory.\b'
                );
                return;
            }

            // Inventory cannot be dropped in the cooling duct
            if (gPlayerChar.getOutermostRoom().ofKind(CoolingDuctSegment)) {
                say(
                    '{I}{\'m} too busy holding {myself} to the walls of the duct
                    to move inventory items around.\b'
                );
                return;
            }
        }

        local oldOpenStatus = enviroSuitBag.remapIn.isOpen;
        if (!oldOpenStatus && bagAvailable) {
            enviroSuitBag.remapIn.makeOpen(true);
            say('(first opening <<enviroSuitBag.theName>>)\b');
        }

        if (droppedItems.length > 0) {
            for (local i = 1; i <= droppedItems.length; i++) {
                local item = droppedItems[i];
                if (item.wornBy == gPlayerChar && doffing) {
                    item.makeWorn(nil);
                }
                item.actionMoveInto(gPlayerChar.location);
            }

            say(
                '{I} make some room by dropping
                <<makeListStr(valToList(droppedItems), &theName, 'and')>>.
                \b'
            );
        }

        if (isSuitingUp) {
            for (local i = 1; i <= piecesToMove.length; i++) {
                local item = piecesToMove[i];
                item.actionMoveInto(gPlayerChar);
                suitTracker.markPiece(item);
                item.makeWorn(gPlayerChar);
            }

            if (piecesToMove.length > 0) {
                say(
                    '{I} put on
                    <<makeListStr(valToList(piecesToMove), &shortName, 'and')>>.
                    \b'
                );
            }

            if (emergencyAirlock.allPartsInInventory()) {
                say('<i>Okay, ready to leave!</i>\b');
            }
            else {
                say('<i>{I} think {i}{\'m} missing some pieces...</i>\b');
            }
        }
        else if (bagAvailable) {
            for (local i = 1; i <= piecesToMove.length; i++) {
                local item = piecesToMove[i];
                if (item.wornBy == gPlayerChar && doffing) {
                    item.makeWorn(nil);
                }
                item.actionMoveInto(enviroSuitBag.remapIn);
                suitTracker.markPiece(item);
            }

            say(
                '{I} put the
                <<makeListStr(valToList(piecesToMove), &shortName, 'and')>>
                in the bag'
            );

            if (!oldOpenStatus) {
                enviroSuitBag.remapIn.makeOpen(nil);
                say(', and close it');
            }

            say('.\b');
        }
        else if (doffing) {
            say(
                '{My} bag isn\'t nearby, so {i} will need to leave the
                <<piecesToMove.length > 1 ? 'pieces' : piecesToMove[1].name>>
                here.\b'
            );

            // Discarding suit to the floor
            for (local i = 1; i <= piecesToMove.length; i++) {
                local item = piecesToMove[i];
                if (item.wornBy == gPlayerChar && doffing) {
                    item.makeWorn(nil);
                }
                item.actionMoveInto(gPlayerChar.location);
            }

            say(
                '{I} take off
                <<makeListStr(valToList(piecesToMove), &shortName, 'and')>>.
                From there, {i} put <<piecesToMove.length > 1 ? 'them' : 'it'>>
                on the floor.\b'
            );
        }

        if (enviroSuitBag.wornBy == nil && bagAvailable) {
            if (!enviroSuitBag.isIn(gPlayerChar)) {
                enviroSuitBag.actionMoveInto(gPlayerChar);
            }
            nestedAction(Wear, enviroSuitBag);
        }

        // Pick up dropped items
        local recoveredItems = new Vector(4);

        for (local i = 1; i <= droppedItems.length; i++) {
            local item = droppedItems[i];
            if (item.isIn(gPlayerChar)) continue;
            bulkAvailableInHands =
                gPlayerChar.bulkCapacity
                - gPlayerChar.getCarriedBulk();
            if (item.bulk > bulkAvailableInHands) continue;
            item.actionMoveInto(gPlayerChar);
            recoveredItems.append(item);
        }

        if (recoveredItems.length > 0) {
            say(
                '<.p>{I} pick
                <<makeListStr(valToList(recoveredItems), &theName, 'and')>>
                back up.\b'
            );
        }
    }
}

class PossibleSuitComponent: Wearable {
    shortName = 'piece'

    getLocationString() {
        local str = shortName + ' <b>(';
        if (location.ofKind(Room)) {
            str += location.objInPrep + ' ' + location.roomTitle;
        }
        else {
            str += location.objInPrep + ' ' + location.theName +
                ', in ' + getOutermostRoom().roomTitle;
        }
        return str + ')</b>';
    }
}

class EnviroSuitPart: PossibleSuitComponent {
    shortName = 'piece'
    piecesLabel = '<b>This is one of the pieces for the environment suit!</b>'
    wearingAll = (gCommand.matchedAll || gCommand.matchedMulti)

    doNotWearOutsideAirlockMsg =
        '{I} do not need to wear the suit right now,
        as it would only slow me down.
        {I} just need to have all the pieces{dummy} in {my} inventory,
        before heading into the Emergency Airlock. {I} can put the suit
        pieces on <i>after</i> the inner Airlock door is shut! '
    
    noteSeen() {
        inherited();
        suitTracker.markPiece(self);
    }

    dobjFor(Wear) {
        preCond = (wearingAll ? [touchObj] : [objHeld])
        verify() {
            if (wearingAll) {
                logical;
            }
            else if (!gActor.isIn(emergencyAirlock)) {
                illogical(doNotWearOutsideAirlockMsg);
            }
            else {
                inherited();
            }
        }
        check() {
            if (wearingAll) {
                return;
            }
            inherited();
        }
        action() {
            if (wearingAll) {
                suitWearingRuleHandler.prepareExplanation(gActor.isIn(emergencyAirlock));
                suitWearingRuleHandler.showExplanation();
                suitWearingRuleHandler.doTakes();
                return;
            }
            inherited();
        }
        report() {
            if (wearingAll) {
                return;
            }
            inherited();
        }
    }

    dobjFor(Doff) {
        verify() {
            if (wearingAll) {
                logical;
            }
            else {
                inherited();
            }
        }
        check() {
            if (wearingAll) {
                return;
            }
            inherited();
        }
        action() {
            if (wearingAll) {
                suitWearingRuleHandler.prepareExplanation(nil, true);
                suitWearingRuleHandler.showExplanation(true, true);
                suitWearingRuleHandler.doTakes(true);
                return;
            }
            inherited();
        }
        report() {
            if (wearingAll) {
                return;
            }
            inherited();
        }
    }

    dobjFor(Drop) {
        preCond = (wearingAll ? nil : [objNotWorn])
        verify() {
            if (wearingAll) {
                logical;
            }
            else {
                inherited();
            }
        }
        check() {
            if (wearingAll) {
                return;
            }
            inherited();
        }
        action() {
            if (wearingAll) {
                //local firstOne = !suitWearingRuleHandler.hasPreparedExplanation;
                suitWearingRuleHandler.prepareExplanation(nil, true);
                suitWearingRuleHandler.showExplanation(true, true);
                suitWearingRuleHandler.doTakes(true);
                /*if (gActor.canReach(enviroSuitBag) && firstOne) {
                    nestedAction(Drop, enviroSuitBag);
                }*/
                return;
            }
            inherited();
        }
        report() {
            if (wearingAll) {
                return;
            }
            inherited();
        }
    }

    dobjFor(Take) {
        verify() {
            if (wearingAll) {
                logical;
            }
            else {
                inherited();
            }
        }
        check() {
            if (wearingAll) {
                return;
            }
            inherited();
        }
        action() {
            if (wearingAll) {
                // Taking for wearing is handled in the Wear logic
                if (gActor.isIn(emergencyAirlock) && gAction.parentAction != nil) return;
                // Otherwise
                suitWearingRuleHandler.prepareExplanation();
                suitWearingRuleHandler.showExplanation(true);
                suitWearingRuleHandler.doTakes();
                return;
            }
            inherited();
            suitTracker.markPiece(self);
            if (gActor.isIn(emergencyAirlock)) return;
            if (!isIn(enviroSuitBag) && (
                enviroSuitBag.isIn(gActor) || gActor.canReach(enviroSuitBag)
            )) {
                nestedAction(PutIn, self, enviroSuitBag.remapIn);
            }
        }
        report() {
            if (wearingAll) {
                return;
            }
            inherited();
        }
    }

    dobjFor(TakeFrom) {
        verify() {
            if (wearingAll) {
                logical;
            }
            else {
                inherited();
            }
        }
        check() { checkDobjTake(); }
        action() { actionDobjTake(); }
        report() { reportDobjTake(); }
    }

    #if __DEBUG_SUIT
    location = hangar
    #endif
}

Test 'partialdoff' [
    'take bag', 'w', 'drop bag', 'e',
    'take helmet', 'e', 'drop helmet', 'w',
    'take torso', 'e', 'drop torso',
    'purloin stool',
    'wear all', 'doff pieces', 'drop pieces', 'i'
];

enviroHelmet: EnviroSuitPart { 'envirosuit helmet;enviro environment suit;visor piece part'
    "A sealed helmet with a transparent visor. <<piecesLabel>> "
    bulk = 2
    theName = (suitTracker.getTheHelmetName(self))
    aName = (suitTracker.getAHelmetName(self))
    shortName = (suitTracker.getHelmetShortName(self))
    listOrder = (suitTracker.getHelmetSortingOrder(self))
}

fakeHelmet: PossibleSuitComponent {
    vocab = enviroHelmet.vocab
    desc() {
        if (isRevealedFake) {
            "A <<paperMache>> version of the real envirosuit helmet.
            This will <i>not</i> keep{dummy} {me} safe! ";
        }
        else {
            enviroHelmet.desc();
        }
    }
    bulk = enviroHelmet.bulk
    trueVocab = 'fake helmet;envirosuit enviro environment suit;visor piece part'
    isRevealedFake = nil
    theName = (suitTracker.getTheHelmetName(self))
    aName = (suitTracker.getAHelmetName(self))
    shortName = (suitTracker.getHelmetShortName(self))
    listOrder = (suitTracker.getHelmetSortingOrder(self))

    noteSeen() {
        inherited();
        if (!isRevealedFake) {
            suitTracker.markPiece(self);
        }
    }

    paperMache = 'paper-m\u00E2ch\u00E9'

    itsAFakeMsg =
        '{I} realized the helmet is made of <<paperMache>>. It\'s a fake.
        Truly, <<gSkashekName>>\'s tricks are more plentiful than {my} own. '

    dobjFor(Wear) {
        verify() {
            if (isRevealedFake) {
                illogical('{I} cannot wear this without damaging it.
                    It\'s only made of <<paperMache>>. ');
            }
        }
        check() { }
        action() {
            revealFake();
        }
        report() { }
    }

    dobjFor(Take) {
        action() {
            revealFake();
            inherited();
        }
    }

    dobjFor(TakeFrom) {
        action() {
            revealFake();
            inherited();
        }
    }

    revealFake() {
        isRevealedFake = true;
        replaceVocab(trueVocab);
        say(itsAFakeMsg);
    }
}

enviroTorso: EnviroSuitPart, FakeZippable { 'envirosuit torso;enviro environment suit chest;chestpiece chestplate piece part top shirt'
    "An extra-long-sleeved, insulated, and sealed torso protector.
    A compact life support module is on the back. <<piecesLabel>> "
    bulk = 2
    shortName = 'torso'
    listOrder = 2
}
+Decoration { 'life support;compact;back module'
    "A small box, containing compact filters, pumps, and an air supply. "
}

enviroPants: EnviroSuitPart, FakeZippable { 'envirosuit bottoms;enviro environment suit pair[n] of[prep];bottom trousers pants leggings piece part'
    "Thick, insulated pants, sealed for protection of the wearer. <<piecesLabel>> "
    bulk = 2
    plural = true
    ambiguouslyPlural = true
    qualified = true
    shortName = 'bottoms'
    listOrder = 3
}

enviroLeftGlove: EnviroSuitPart { 'envirosuit left glove;enviro environment suit;mitten mit mitt piece part'
    "A protective glove for the left hand, modified to fit longer fingers. <<piecesLabel>> "
    bulk = 1
    shortName = 'left glove'
    listOrder = 4
}

enviroRightGlove: EnviroSuitPart { 'envirosuit right glove;enviro environment suit;mitten mit mitt piece part'
    "A protective glove for the right hand, modified to fit longer fingers. <<piecesLabel>> "
    bulk = 1
    shortName = 'right glove'
    listOrder = 5
}

enviroLeftBoot: EnviroSuitPart { 'envirosuit left boot;enviro environment suit;shoe piece part'
    "A protective glove for the left hand, modified to fit longer fingers. <<piecesLabel>> "
    bulk = 1
    shortName = 'left boot'
    listOrder = 6
}

enviroRightBoot: EnviroSuitPart { 'envirosuit right boot;enviro environment suit;shoe piece part'
    "A protective glove for the right hand, modified to fit longer fingers. <<piecesLabel>> "
    bulk = 1
    shortName = 'right boot'
    listOrder = 7
}