defaultLabFloor: Floor { 'the floor'
    "TODO: Add description. "
}

#define standardDoorDescription \
    "TODO: Add inside description. \
    There seems to be a sort of rough, rectangular cat door \
    cut into the bottom of the door. "

#define lockedDoorDescription \
    "TODO: Add inside description. \
    There seems to be a proximity lock on this door, and a \
    startling lack of cat accessibility. "

modify SenseRegion {
    lookAroundArmed = true
}

class HallRegion: SenseRegion {
    canSeeAcross = true
    canHearAcross = true
    canSmellAcross = nil
    canTalkAcross = true
    canThrowAcross = true
    autoGoTo = nil
}

modify Thing {
    skipInRemoteList = nil
}

modify Room {
    floorObj = defaultLabFloor

    // If true, then we are entering a new SenseRegion, so showing a better
    // description is necessary
    lookAroundArmed = (lookAroundRegion == nil ? true :
        lookAroundRegion.lookAroundArmed)
    lookAroundRegion = nil

    observedRemotely = nil

    travelerLeaving(traveler, dest) {
        inherited(traveler, dest);
        if (lookAroundRegion != nil) {
            lookAroundRegion.lookAroundArmed = nil;
        }
    }

    getWindowList(pov) {
        local scopeList = Q.scopeList(self);
        local spottedItems = new Vector(8);

        for (local i = 1; i <= scopeList.length; i++) {
            local obj = scopeList[i];
            // Do not include Skashek here, because we will handle
            // sighting him a little differently
            if (obj == skashek) continue;
            if (obj.skipInRemoteList) continue;
            if (obj.sightSize == small) continue;
            if (obj.getOutermostRoom() != self) continue;
            if (!pov.canSee(obj)) continue;
            if (obj.ofKind(Door)) {
                if (!obj.isOpen) continue;
            }
            else {
                if (!obj.isListed) continue;
            }
            spottedItems.appendUnique(obj);
        }

        return valToList(spottedItems);
    }

    descFrom(pov) {
        desc();
    }

    getObservationProp(pov) {
        return &observedRemotely;
    }

    observeFrom(pov, locPhrase) {
        local lst = getWindowList(pov);
        local obProp = getObservationProp(pov);
        local lookedThru = nil;

        local botherToGiveDescription;
        if (gameMain.verbose) {
            // In verbose mode, give the description if we either
            // haven't looked in from outside before or haven't
            // visited before.
            botherToGiveDescription = !self.(obProp) || !visited;
        }
        else {
            // In brief mode, only give the description if we both
            // have not peeked inside already, and have not visited.
            botherToGiveDescription = !self.(obProp) && !visited;
        }

        "<.p><i>(Looking into <<roomTitle>>...)</i><.p>";
        if(botherToGiveDescription) {
            "<.roomdesc>";
            descFrom(pov);
            "<./roomdesc><.p>";
            self.(obProp) = true;
            lookedThru = true;
        }

        if (lst.length == 0) {
            "{I} {see} nothing<<if lookedThru>> else<<end>> <<locPhrase>>. ";
            peekInto();
            return;
        }
        "{I}<<if lookedThru>> also<<end>>{aac} {see} <<makeListStr(lst, &aName, 'and')>> <<locPhrase>>. ";
        peekInto();
    }
}

modify GoTo {
    turnsTaken = 0

    exec(cmd) {
        "Sorry!\b
        Due to the high level of caution required during travel, the <b>GOTO</b>
        command has been disabled for this game! ";
        exit;
    }
}

modify Continue {
    turnsTaken = 0
    
    exec(cmd) {
        GoTo.exec(cmd);
    }
}

#define DefineDoorAwayTo(outDir, inDir, outerRoom, localRoom, theLocalDoorName) \
    localRoom##ExitDoor: Door { \
        vocab = 'the exit door' \
        location = localRoom \
        desc = standardDoorDescription \
        otherSide = localRoom##EntryDoor \
        soundSourceRepresentative = localRoom##EntryDoor \
    } \
    localRoom##EntryDoor: Door { \
        vocab = theLocalDoorName \
        location = outerRoom \
        desc = standardDoorDescription \
        otherSide = localRoom##ExitDoor \
        soundSourceRepresentative = localRoom##EntryDoor \
    } \
    modify localRoom { \
        outDir = localRoom##ExitDoor \
    } \
    modify outerRoom { \
        inDir = localRoom##EntryDoor \
    }

#define DefineDoorNorthTo(outerRoom, localRoom, theLocalDoorName) \
    DefineDoorAwayTo(north, south, outerRoom, localRoom, theLocalDoorName)

#define DefineDoorEastTo(outerRoom, localRoom, theLocalDoorName) \
    DefineDoorAwayTo(east, west, outerRoom, localRoom, theLocalDoorName)

#define DefineDoorSouthTo(outerRoom, localRoom, theLocalDoorName) \
    DefineDoorAwayTo(south, north, outerRoom, localRoom, theLocalDoorName)

#define DefineDoorWestTo(outerRoom, localRoom, theLocalDoorName) \
    DefineDoorAwayTo(west, east, outerRoom, localRoom, theLocalDoorName)

#define windowLookBlock \
    canLookThroughMe = true \
    skipInRemoteList = true \
    dobjFor(LookIn) asDobjFor(LookThrough) \
    dobjFor(Search) asDobjFor(LookThrough) \
    dobjFor(PeekInto) asDobjFor(LookThrough) \
    dobjFor(PeekThrough) asDobjFor(LookThrough)

#define windowTravelBlock \
    dobjFor(SqueezeThrough) asDobjFor(TravelVia) \
    dobjFor(ParkourClimbGeneric) asDobjFor(TravelVia) \
    dobjFor(ParkourClimbOverInto) asDobjFor(TravelVia) \
    dobjFor(ParkourJumpOverInto) asDobjFor(TravelVia)

#define windowResolveBlock \
    filterResolveList(np, cmd, mode) { \
        if (np.matches.length > 1 && getOutermostRoom() != gActor.getOutermostRoom()) { \
            np.matches = np.matches.subset({m: m.obj != self}); \
        } \
    }

#define DefineBrokenWindowPairLookingAway(outDir, inDir, outerRoom, localRoom) \
    windowIn##outerRoom: Passage { \
        vocab = otherSide.vocab \
        desc = otherSide.desc \
        destination = localRoom \
        travelDesc = otherSide.travelDesc \
        location = outerRoom \
        otherSide = windowIn##localRoom \
        windowLookBlock \
        dobjFor(LookThrough) { \
            action() { } \
            report() { \
                localRoom.observeFrom(gActor, otherSide.remoteHeader); \
            } \
        } \
        dobjFor(Break) { \
            validate() { \
                illogical(otherSide.breakMsg); \
            } \
        } \
        windowResolveBlock \
        windowTravelBlock \
    } \
    modify localRoom { \
        outDir = windowIn##localRoom \
    } \
    modify outerRoom { \
        inDir = windowIn##outerRoom \
    } \
    windowIn##localRoom: Passage \
        location = localRoom \
        otherSide = windowIn##outerRoom \
        destination = outerRoom \
        windowLookBlock \
        dobjFor(LookThrough) { \
            action() { } \
            report() { \
                outerRoom.observeFrom(gActor, remoteHeader); \
            } \
        } \
        dobjFor(Break) { \
            validate() { \
                illogical(breakMsg); \
            } \
        } \
        windowResolveBlock \
        windowTravelBlock

#define DefineWindowPair(outerRoom, localRoom) \
    windowIn##outerRoom: Fixture { \
        vocab = otherSide.vocab \
        desc = otherSide.desc \
        location = outerRoom \
        otherSide = windowIn##localRoom \
        windowLookBlock \
        dobjFor(LookThrough) { \
            action() { } \
            report() { \
                localRoom.observeFrom(gActor, otherSide.remoteHeader); \
            } \
        } \
        dobjFor(Break) { \
            validate() { \
                illogical(otherSide.breakMsg); \
            } \
        } \
        windowResolveBlock \
    } \
    windowIn##localRoom: Fixture \
        location = localRoom \
        otherSide = windowIn##outerRoom \
        windowLookBlock \
        dobjFor(LookThrough) { \
            action() { } \
            report() { \
                outerRoom.observeFrom(gActor, remoteHeader); \
            } \
        } \
        dobjFor(Break) { \
            validate() { \
                illogical(breakMsg); \
            } \
        } \
        windowResolveBlock
