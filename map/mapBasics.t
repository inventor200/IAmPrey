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
        "TODO: Add remote description. ";
    }

    getObservationProp(pov) {
        return &observedRemotely;
    }

    observeFrom(pov, locPhrase) {
        local lst = getWindowList(pov);
        local obProp = getObservationProp(pov);
        local lookedThru = nil;
        if(gameMain.verbose || !self.(obProp)) {
            "<.roomdesc>";
            descFrom(pov);
            "<./roomdesc><.p>";
            self.(obProp) = true;
            lookedThru = true;
        }
        if (lst.length == 0) {
            "{I} {see} nothing<<if lookedThru>> else<<end>> <<locPhrase>>. ";
            return;
        }
        "{I}<<if lookedThru>> also<<end>>{aac} {see} <<makeListStr(lst, &aName, 'and')>> <<locPhrase>>. ";
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