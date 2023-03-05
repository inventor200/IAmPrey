defaultLabFloor: Floor { 'the floor'
    "TODO: Add description. "
}

cementFloor: Floor { 'the floor'
    "TODO: Add description. "
}

#define airlockDisclaimer '\n<b>It probably does not close itself automatically.</b>'

#define standardDoorDescription \
    "TODO: Add description. \
    There seems to be a sort of rough, rectangular cat door \
    cut into the bottom of the door. "

#define lockedDoorDescription \
    "TODO: Add description. \
    There seems to be a proximity lock on this door, and a \
    startling lack of cat accessibility. "

#define airlockDoorDesc \
    "It's a glass airlock door, meant to keep toxic fumes out. \
    Black-and-yellow warning tape borders the sides. \
    <<airlockDisclaimer>> "

#define freezerDoorDesc \
    "It's a large, metal door&mdash;reminiscent of a vault&mdash;and \
    made to keep freezing air from leaking into the rest of \
    the facility. \
    <<airlockDisclaimer>> "

modify SenseRegion {
    lookAroundArmed = true
    /*familiar() {
        return true;
    }*/
}

class HallRegion: SenseRegion {
    canSeeAcross = true
    canHearAcross = true
    canSmellAcross = nil
    canTalkAcross = true
    canThrowAcross = true
    autoGoTo = nil
}

class WindowRegion: SenseRegion {
    canSeeAcross = true
    canHearAcross = nil
    canSmellAcross = nil
    canTalkAcross = true
    canThrowAcross = nil
    autoGoTo = nil
}

class GrateRegion: SenseRegion {
    canSeeAcross = true
    canHearAcross = true
    canSmellAcross = true
    canTalkAcross = true
    canThrowAcross = nil
    autoGoTo = nil
}

modify Thing {
    skipInRemoteList = nil
}

modify Room {
    floorObj = defaultLabFloor
    wallsObj = defaultWalls
    ceilingObj = defaultCeiling
    atmosphereObj = defaultAtmosphere

    isFamiliar = true

    isFreezing = nil
    moistureFactor = (isFreezing ? 0 : -1)

    // If true, then we are entering a new SenseRegion, so showing a better
    // description is necessary
    lookAroundArmed = (lookAroundRegion == nil ? true :
        lookAroundRegion.lookAroundArmed)
    lookAroundRegion = nil

    observedRemotely = nil

    dobjFor(LookIn) asDobjFor(Search)
    dobjFor(LookThrough) asDobjFor(Search)
    dobjFor(Search) {
        verify() {
            illogical('{I} will have to be more specific,
                and search specific containers instead. ');
        }
    }

    dobjFor(LookUnder) {
        remap = floorObj
    }

    roomDaemon() {
        if (isFreezing) {
            "<.p>\^<<freezer.expressAmbience>>.";
        }
        inherited();
    }

    roomBeforeAction() {
        if (gActionIs(Smell)) {
            doInstead(SmellSomething, atmosphereObj);
        }

        inherited();
    }

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

class Walls: MultiLoc, Thing {
    isFixed = true
    plural = true
    isDecoration = true
    initialLocationClass = Room
    
    isInitiallyIn(obj) { return obj.wallsObj == self; }
    decorationActions = [Examine]       
}

defaultWalls: Walls { 'walls;north[weak] n[weak] south[weak] s[weak] east[weak] e[weak] west[weak] w[weak];wall'
    "{I} {see} nothing special about the walls. "
}

class Ceiling: MultiLoc, Thing {
    isFixed = true
    isDecoration = true
    initialLocationClass = Room
    
    isInitiallyIn(obj) { return obj.ceilingObj == self; }
    decorationActions = [Examine]       
}

defaultCeiling: Ceiling { 'ceiling'
    "TODO: Add description. "
}

industrialCeiling: Floor { 'pipes[weak] on[prep] the ceiling'
    "TODO: Add description. "
    plural = true
    ambiguouslyPlural = true
}

class Atmosphere: MultiLoc, Thing {
    vocab = 'air;;atmosphere breeze wind'
    isFixed = true
    isDecoration = true
    initialLocationClass = Room
    
    isInitiallyIn(obj) { return obj.atmosphereObj == self; }
    decorationActions = [Examine, SmellSomething, Feel]       
}

defaultAtmosphere: Atmosphere {
    desc = "{I} {see} nothing special about the air. "
    feelDesc = "There is the mildest of breezes, thanks to
    enduring life support systems. "
    smellDesc = "The air smells recycled, but clean. "
}

freezingAtmosphere: Atmosphere { 'air;;atmosphere breeze wind fog mist breath frost condensation'
    "{I} {see} nothing special about the air. "
    feelDesc = "{I} {cannot} feel anything but dry, chilling air. "
    smellDesc = "{My} lungs fill with abrasive, dry, freezing air. "
}

dreamWorldPrey: Room { 'The Artificial Dream'
    "You begin to wake up... "
    isFamiliar = nil
}

dreamWorldCat: Room { 'The Dream of Memories'
    "You begin to wake up... "
    isFamiliar = nil
}

dreamWorldSkashek: Room { 'The Dream of Starvation'
    "You begin to wake up... "
    isFamiliar = nil
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
    allowLookThroughSearch \
    dobjFor(LookIn) asDobjFor(LookThrough) \
    dobjFor(PeekInto) asDobjFor(LookThrough) \
    dobjFor(PeekThrough) asDobjFor(LookThrough)

#define windowTravelBlock \
    configureDoorOrPassageAsLocalPlatform(TravelVia) \
    dobjFor(TravelVia) { \
        preCond = [travelPermitted, actorInStagingLocation] \
        action() { \
            inherited(); \
            learnLocalPlatform(self, reportAfter); \
        } \
    }

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
