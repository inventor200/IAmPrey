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

    getCount() {
        return gatheredPieces.length;
    }

    markPiece(piece) {
        local oldCount = getCount();
        gatheredPieces.appendUnique(piece);
        local newCount = getCount();
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
        local numLeft = getNumberLeft();
        local toGoPhrase = 'That\'s all of them! {I} must enter the Emergency Airlock!!
            {I} cannot allow <<gSkashekName>> to stop me now! {My} victory is so close!\b
            <i>(Set your compass by typing in <<gDirectCmdStr('go to emergency airlock')>>,
            and find the next step in the route with the <<gDirectCmdStr('compass')>> command!)</i>';
        if (numLeft > 0) {
            local pieceNoun = 'piece';
            if (numLeft != 1) pieceNoun += 's';
            toGoPhrase = 'Only ' + spellNumber(7 - getCount()) +
                ' more envirosuit ' + pieceNoun + ' to go!';
        }
        say('<.p><b>{I} found ' + strList + '!</b>\b' + toGoPhrase + '<.p>');
        clearAnnounceEvent();
    }

    clearAnnounceEvent() {
        if (announceDaemon != nil) announceDaemon.removeEvent();
        announceDaemon = nil;
    }

    getNumberLeft() {
        return 7 - getCount();
    }

    getProgressLists() {
        local strBfr = new StringBuffer(18);
        local inventory = valToList(gPlayerChar.contents);

        local carriedParts = [];
        local partsFound = [];
        local partsRemaining = [];
        local indexRem = 0;
        
        for (local i = 1; i <= inventory.length; i++) {
            local obj = inventory[i];
            if (!obj.ofKind(EnviroSuitPart)) continue;
            carriedParts += obj;
        }
        for (local i = 1; i <= gatheredPieces.length; i++) {
            local obj = gatheredPieces[i];
            indexRem = carriedParts.indexOf(obj);
            if (indexRem != nil) continue;
            partsFound += obj;
        }
        for (local i = 1; i <= missingPieces.length; i++) {
            local obj = missingPieces[i];
            indexRem = carriedParts.indexOf(obj);
            if (indexRem != nil) continue;
            indexRem = partsFound.indexOf(obj);
            if (indexRem != nil) continue;
            partsRemaining += obj;
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

class EnviroSuitPart: Wearable {
    shortName = 'piece'
    piecesLabel = '<b>This is one of the pieces for the environment suit!</b>'
    dobjFor(Wear) {
        verify() {
            if (!gActor.isIn(emergencyAirlock)) {
                illogical(
                    '{I} do not need to wear the suit right now,
                    as it would only slow me down.
                    {I} just need to have all the pieces{dummy} in {my} inventory,
                    before heading into the Emergency Airlock. {I} can put the suit
                    pieces on <i>after</i> the inner Airlock door is shut! '
                );
            }
        }
    }

    dobjFor(Take) {
        action() {
            inherited();
            suitTracker.markPiece(self);
        }
    }

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

    #if __DEBUG_SUIT
    location = hangar
    #endif
}

enviroHelmet: EnviroSuitPart { 'envirosuit helmet;enviro environment suit;visor piece part'
    "A sealed helmet with a transparent visor. <<piecesLabel>> "
    bulk = 2
    shortName = 'helmet'
}

fakeHelmet: Thing {
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
    bulk = 2
    trueVocab = 'fake helmet;envirosuit enviro environment suit;visor piece part'
    isRevealedFake = nil

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

enviroTorso: EnviroSuitPart { 'envirosuit torso;enviro environment suit chest;chestpiece chestplate piece part top shirt'
    "An extra-long-sleeved, insulated, and sealed torso protector.
    A compact life support module is on the back. <<piecesLabel>> "
    bulk = 2
    shortName = 'torso'
}
++Decoration { 'life support;compact;back module'
    "A small box, containing compact filters, pumps, and an air supply. "
}

enviroPants: EnviroSuitPart { 'envirosuit bottoms;enviro environment suit pair[n] of[prep];bottom trousers pants leggings piece part'
    "Thick, insulated pants, sealed for protection of the wearer. <<piecesLabel>> "
    bulk = 2
    plural = true
    ambiguouslyPlural = true
    qualified = true
    shortName = 'bottoms'
}

enviroLeftGlove: EnviroSuitPart { 'envirosuit left glove;enviro environment suit;mitten mit mitt piece part'
    "A protective glove for the left hand, modified to fit longer fingers. <<piecesLabel>> "
    bulk = 1
    shortName = 'left glove'
}

enviroRightGlove: EnviroSuitPart { 'envirosuit right glove;enviro environment suit;mitten mit mitt piece part'
    "A protective glove for the right hand, modified to fit longer fingers. <<piecesLabel>> "
    bulk = 1
    shortName = 'right glove'
}

enviroLeftBoot: EnviroSuitPart { 'envirosuit left boot;enviro environment suit;shoe piece part'
    "A protective glove for the left hand, modified to fit longer fingers. <<piecesLabel>> "
    bulk = 1
    shortName = 'left boot'
}

enviroRightBoot: EnviroSuitPart { 'envirosuit right boot;enviro environment suit;shoe piece part'
    "A protective glove for the right hand, modified to fit longer fingers. <<piecesLabel>> "
    bulk = 1
    shortName = 'right boot'
}