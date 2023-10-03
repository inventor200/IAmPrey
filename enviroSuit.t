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
    hardlyClothing = true

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
        if (action.ofKind(Examine)) return nil;
        if (getOutermostRoom() == deliveryRoom) {
            // Make sure TAKE ALL works when the player first
            // starts the game.
            // The player is unlikely to drop the bag later,
            // but if they do, then they might want more control.
            return moved;
        }
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
    isWearable = true
    wornBy = (enviroSuitBag.wornBy)
    hardlyClothing = true

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

class PossibleSuitComponent: Wearable {
    shortName = 'piece'
    smartInventoryName = (shortName)

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
        preCond = (wearingAll ? nil : [objHeld])
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
                smartInventoryCore.performOperation(operationWearItems);
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
                smartInventoryCore.performOperation(operationDoffItems);
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
                smartInventoryCore.performOperation(operationDropItems);
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
        preCond = (wearingAll ? nil : [touchObj])
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
                smartInventoryCore.performOperation(operationTakeItems);
                return;
            }
            local wasAlreadyInBag = isIn(enviroSuitBag);
            inherited();
            suitTracker.markPiece(self);
            if (gActor.isIn(emergencyAirlock)) return;
            if (!wasAlreadyInBag && (
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
        preCond = (wearingAll ? nil : [touchObj])
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
    location = __DEBUG_SUIT_LOCATION
    #endif
}

/*Test 'partialdoff' [
    'take bag', 'w', 'drop bag', 'e',
    'take helmet', 'e', 'drop helmet', 'w',
    'take torso', 'e', 'drop torso',
    'purloin stool',
    'wear all', 'doff pieces', 'drop pieces', 'i'
];*/

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
