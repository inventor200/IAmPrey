#define roomsFamiliarByDefault true

defaultLabFloor: Floor { 'the floor;terrazzo floor;tiles flecks'
    "Plain, white, terrazzo tiles with black flecks. "
    ambiguouslyPlural = true
}

cementFloor: Floor { 'the floor;concrete cement'
    "The dark-gray floors are made of smooth concrete here. "
}

carpetedFloor: Floor { 'the floor;;carpet rug'
    "The floor here has a dark gray-blue carpet. "
}

#define airlockDisclaimer '\n<b>It probably does not close itself automatically.</b>'

#define standardDoorDescription \
    "A heavy, metal door. A spring-resistent handle keeps rooms closed, but accessible. \
    Hidden pneumatics make the doors close automatically. \
    There seems to be a sort of rough, rectangular cat door \
    cut into the bottom of the door. "

#define lockedDoorDescription \
    "There seems to be a proximity lock on this door, and a \
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

// Allowing doors to use prefab grouping
class PrefabDoor: PrefabObject, Door {
    isFreezerDoor = nil

    hasPrefabMatchWith(obj) {
        if (!obj.ofKind(Door)) return nil;
        if (isFreezerDoor != obj.isFreezerDoor) return nil;
        if (airlockDoor != obj.airlockDoor) return nil;
        if (lockability != obj.lockability) return nil;
        if (isVentGrateDoor != obj.isVentGrateDoor) return nil;
        return true;
    }

    isOutOfContext(np, cmd, mode) {
        local isNormallyOutOfContext = inherited(np, cmd, mode);
        if (isNormallyOutOfContext) return true;

        local isAnyAltInContext = nil;
        local isThisInContext = nil;

        for (local i = 1; i <= np.matches.length; i++) {
            local matchObj = np.matches[i].obj;
            if (!hasPrefabMatchWith(matchObj)) continue;
            if (gActor.canReach(matchObj)) {
                isAnyAltInContext = true;
                if (matchObj == self) {
                    isThisInContext = true;
                    break;
                }
            }
        }

        if (!isAnyAltInContext) {
            // If nothing is in context, then being out-of-context
            // means nothing. Default to being in-context.
            return nil;
        }

        // If something IS in context, then is it us?

        return !isThisInContext;
    }
}

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

roomDaemonTurnTracker: object {
    lastRoomDaemonTurn = 0
}

#define checkRoomDaemonTurns if (roomDaemonTurnTracker.lastRoomDaemonTurn == gTurns) return

modify Room {
    floorObj = defaultLabFloor
    ceilingObj = defaultLabCeiling
    atmosphereObj = defaultLabAtmosphere

    //isFamiliar = true

    isFreezing = nil
    moistureFactor = (isFreezing ? 0 : -1)

    // If true, then we are entering a new SenseRegion, so showing a better
    // description is necessary
    lookAroundArmed = (lookAroundRegion == nil ? true :
        lookAroundRegion.lookAroundArmed)
    lookAroundRegion = nil

    observedRemotely = nil

    lastPeekTurn = -1

    roomDaemon() {
        checkRoomDaemonTurns;
        if (isFreezing) {
            "<.p>\^<<freezer.expressAmbience>>.";
        }
        inherited();
        if (!gActionIs(TravelAction)) {
            roomDaemonTurnTracker.lastRoomDaemonTurn = gTurns;
        }
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

            // If we have looked in before, and it was last turn,
            // then don't bother.
            if (self.(obProp) && (
                (gTurns == lastPeekTurn) || ((gTurns - 1) == lastPeekTurn)
                )) {
                botherToGiveDescription = nil;
            }
        }
        else {
            // In brief mode, only give the description if we both
            // have not peeked inside already, and have not visited.
            botherToGiveDescription = !self.(obProp) && !visited;
        }

        "<.p><i>(looking into <<roomTitle>>...)</i><.p>";
        if(botherToGiveDescription) {
            "<.roomdesc>";
            descFrom(pov);
            "<./roomdesc><.p>";
            self.(obProp) = true;
            lookedThru = true;
        }

        lastPeekTurn = gTurns;

        if (lst.length == 0) {
            if (!skashek.showsDuringPeek()) {
                "{I} {see} nothing<<if lookedThru>> else<<end>> <<locPhrase>>. ";
            }
        }
        else {
            "{I}<<if lookedThru>> also<<end>>{aac} {see}
            <<makeListStr(lst, &aName, 'and')>> <<locPhrase>>. ";
        }
        peekInto();
        "<.p><i>(returning {my} attention to
        <<pov.getOutermostRoom().roomTitle>>...)</i><.p>";
    }
}

defaultLabCeiling: Ceiling { 'ceiling;ceiling eps polystyrene foam;panels tiles frame[weak] lights'
    "Industrial panels of expanded polystyrene foam create the ceiling here. "
    ambiguouslyPlural = true
    notImportantMsg = '{That dobj} {is} too far{dummy} above {me}. '
}

industrialCeiling: Ceiling { 'pipes[n] on[prep] the ceiling;upper[weak] lower[weak];sections[weak] pipe'
    "The upper section of the walls are exposed here, as there are no ceiling panels
    to cover them. The ceiling is much higher, too, and the various pipes of the
    facility are visible. "
    matchPhrases = [
        'ceiling', 'pipes', 'upper section of wall',
        'upper section of walls', 'upper wall section'
    ]
    plural = true

    // Other pipes are surely more important
    filterResolveList(np, cmd, mode) {
        if (np.matches.length > 1) {
            np.matches = np.matches.subset({m: m.obj != self});
        }
    }
}

defaultLabAtmosphere: Atmosphere {
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
    "{I} begin to wake up... "
    isFamiliar = nil
    ambienceObject = nil
}

dreamWorldCat: Room { 'The Dream of Memories'
    "{I} begin to wake up... "
    isFamiliar = nil
    ambienceObject = nil
}

dreamWorldSkashek: Room { 'The Dream of Starvation'
    "{I} begin to wake up... "
    isFamiliar = nil
    ambienceObject = nil
}

#define DefineDoorAwayTo(outDir, inDir, outerRoom, localRoom, theLocalDoorName) \
    localRoom##ExitDoor: PrefabDoor { \
        vocab = 'the exit door' \
        location = localRoom \
        desc = standardDoorDescription \
        otherSide = localRoom##EntryDoor \
        soundSourceRepresentative = localRoom##EntryDoor \
        pullHandleSide = nil \
    } \
    localRoom##EntryDoor: PrefabDoor { \
        vocab = theLocalDoorName \
        location = outerRoom \
        desc = standardDoorDescription \
        otherSide = localRoom##ExitDoor \
        soundSourceRepresentative = localRoom##EntryDoor \
        pullHandleSide = true \
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

#define defaultVentVocab 'vent[n] grate;ventilation air'
#define defaultVentVocabSuffix ';door'

#define windowLookBlock(mcwRoom, mcwRemoteHeader) \
    canLookThroughMe = true \
    skipInRemoteList = true \
    allowLookThroughSearch \
    remappingLookIn = true \
    remappingSearch = true \
    dobjFor(LookIn) asDobjFor(LookThrough) \
    dobjFor(PeekInto) asDobjFor(LookThrough) \
    dobjFor(PeekThrough) asDobjFor(LookThrough) \
    dobjFor(LookThrough) { \
        action() { } \
        report() { \
            handleCustomPeekThrough(mcwRoom, mcwRemoteHeader); \
        } \
    }

#define windowTravelBlock \
    configureDoorOrPassageAsLocalPlatform(TravelVia) \
    dobjFor(SneakThrough) { \
        verify() { } \
        action() { \
            sneakyCore.trySneaking(); \
            sneakyCore.doSneakStart(self, self); \
            doNested(TravelVia, self); \
            sneakyCore.doSneakEnd(self); \
        } \
    } \
    dobjFor(TravelVia) { \
        preCond = [travelPermitted, actorInStagingLocation] \
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
        windowLookBlock(localRoom, otherSide.remoteHeader) \
        dobjFor(Break) { \
            verify() { \
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
        windowLookBlock(outerRoom, remoteHeader) \
        dobjFor(Break) { \
            verify() { \
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
        windowLookBlock(localRoom, otherSide.remoteHeader) \
        dobjFor(Break) { \
            verify() { \
                illogical(otherSide.breakMsg); \
            } \
        } \
        windowResolveBlock \
    } \
    windowIn##localRoom: Fixture \
        location = localRoom \
        otherSide = windowIn##outerRoom \
        windowLookBlock(outerRoom, remoteHeader) \
        dobjFor(Break) { \
            verify() { \
                illogical(breakMsg); \
            } \
        } \
        windowResolveBlock
