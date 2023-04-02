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
            if (announceDaemon != nil) announceDaemon.removeEvent();
            announceDaemon = nil;
            return;
        }
        local strList = makeListStr(valToList(discoveredPieces), &theName, 'and');
        local numLeft = getNumberLeft();
        local toGoPhrase = 'That\'s all of them! {I} must enter the Emergency Airlock!!
            {I} cannot allow <<gSkashekName>> to stop me now! {My} victory is so close!\b
            <i>(Set your compass by typing in <<gDirectCmdStr('go to emergency airlock')>>,
            and find the next step in the route with the <<gDirectCmdStr('compass')>> command!)</i>';
        if (numLeft > 0) {
            toGoPhrase = 'Only ' + spellNumber(7 - getCount()) + ' more envirosuit pieces to go!';
        }
        say('<.p><b>{I} found ' + strList + '!</b>\b' + toGoPhrase + '<.p>');
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
            if (gCatMode) {
                illogical('What an ugly peasant piece! Absolutely <i>not!</i> ');
                return;
            }
            if (!gActor.isIn(emergencyAirlock)) {
                illogical(
                    '{I} do not need to wear the suit, as it would only slow me down.
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
}

enviroHelmet: EnviroSuitPart { 'envirosuit helmet;enviro environment suit;visor piece part'
    "A sealed helmet with a transparent visor. <<piecesLabel>> "
    bulk = 2
    shortName = 'helmet'
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
    ambiguouslyPlural = true
    qualified = true
    shortName = 'pants'
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