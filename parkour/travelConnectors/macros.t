#define TravelConnectorUsesParkour \
    doTravelMoveInto(traveler, dest) { \
        if (destinationPlatform != nil) { \
            if (!destinationPlatform.ofKind(Room)) { \
                local pm = destinationPlatform.parkourModule; \
                if (pm == nil) { \
                    traveler.actionMoveInto(destinationPlatform); \
                    return; \
                } \
                else if (gOutStream.watchForOutput({: pm.checkParkour(traveler) }) == nil) { \
                    gParkourLastPath = self; \
                    pm.provideMoveFor(traveler); \
                    return; \
                } \
            } \
        } \
        traveler.actionMoveInto(dest); \
    } \
    doBeforeTravelDiscovery(oldPlat) { \
        learnOnlyLocalPlatform(self, say); \
    } \
    doAfterTravelDiscovery(newPlat) { \
        newPlat.doParkourSearch(); \
    } \
    getLocalPlatform() { \
        return self; \
    } \
    getOppositePlatform() { \
        return oppositeLocalPlatform; \
    }

#define rerouteBasicClimbForPlatform(oldAction, cancelMsg) \
    dobjFor(oldAction) { \
        preCond = [actorInStagingLocation] \
        verify() { \
            illogical(cancelMsg); \
        } \
    }

#define rerouteBasicJumpIntoForPlatform(oldAction, targetAction) \
    dobjFor(oldAction) { \
        preCond { return preCondDobj##targetAction; } \
        verify() { verifyDobj##targetAction; } \
        remap() { return remapDobj##targetAction; } \
        check() { checkDobj##targetAction; } \
        action() { \
            extraReport(parkourUnnecessaryJumpMsg); \
            actionDobj##targetAction; \
        } \
        report() { reportDobj##targetAction; } \
    }

#define setPreferredClimbToDirection(rightWay, wrongWay) \
    dobjFor(Climb) asDobjFor(TravelVia) \
    dobjFor(ParkourClimbGeneric) asDobjFor(TravelVia) \
    \
    dobjFor(Climb##rightWay) asDobjFor(TravelVia) \
    dobjFor(ParkourClimb##rightWay##To) asDobjFor(TravelVia) \
    rerouteBasicJumpIntoForPlatform(ParkourJump##rightWay##To, TravelVia) \
    \
    rerouteBasicClimbForPlatform(Climb##wrongWay, localPlatformGoes##rightWay##Msg) \
    rerouteBasicClimbForPlatform(ParkourClimb##wrongWay##To, localPlatformGoes##rightWay##Msg) \
    rerouteBasicClimbForPlatform(ParkourJump##wrongWay##To, localPlatformGoes##rightWay##Msg) \
    rerouteBasicClimbForPlatform(ParkourClimbOverTo, localPlatformGoes##rightWay##Msg) \
    rerouteBasicClimbForPlatform(ParkourJumpOverTo, localPlatformGoes##rightWay##Msg)

#define acceptClimbIntoDirection(rightWay, wrongWay) \
    dobjFor(ParkourClimb##rightWay##Into) asDobjFor(TravelVia) \
    rerouteBasicJumpIntoForPlatform(ParkourJump##rightWay##Into, TravelVia) \
    \
    rerouteBasicClimbForPlatform(ParkourClimb##wrongWay##Into, localPlatformGoes##rightWay##Msg) \
    rerouteBasicClimbForPlatform(ParkourJump##wrongWay##Into, localPlatformGoes##rightWay##Msg) \
    rerouteBasicClimbForPlatform(ParkourClimbOverInto, localPlatformGoes##rightWay##Msg) \
    rerouteBasicClimbForPlatform(ParkourJumpOverInto, localPlatformGoes##rightWay##Msg)

#define rejectClimbInto \
    rerouteBasicClimbForPlatform(ParkourClimbUpInto, cannotEnterMsg) \
    rerouteBasicClimbForPlatform(ParkourJumpUpInto, cannotEnterMsg) \
    rerouteBasicClimbForPlatform(ParkourClimbDownInto, cannotEnterMsg) \
    rerouteBasicClimbForPlatform(ParkourJumpDownInto, cannotEnterMsg) \
    rerouteBasicClimbForPlatform(ParkourClimbOverInto, cannotEnterMsg) \
    rerouteBasicClimbForPlatform(ParkourJumpOverInto, cannotEnterMsg)

#define asAliasFor(targetPlatform) \
    unlistedLocalPlatform = true \
    localAliasPlatform = targetPlatform \
    oppositeLocalPlatform = (targetPlatform.oppositeLocalPlatform) \
    dobjFor(TravelVia) { \
        remap = targetPlatform \
    } \
    dobjFor(Search) { \
        remap = targetPlatform \
    }

#define configureDoorOrPassageAsLocalPlatform(targetAction) \
    forcedLocalPlatform = true \
    isConnectorListed = !secretLocalPlatform \
    getPreferredBoardingAction() { \
        return GoThrough; \
    } \
    rerouteBasicClimbForPlatform(Board, cannotBoardMsg) \
    rerouteBasicClimbForPlatform(Climb, cannotClimbMsg) \
    rerouteBasicClimbForPlatform(ClimbUp, cannotClimbMsg) \
    rerouteBasicClimbForPlatform(ClimbDown, cannotClimbMsg) \
    rerouteBasicClimbForPlatform(ParkourClimbDownTo, cannotClimbMsg) \
    rerouteBasicClimbForPlatform(ParkourJumpGeneric, parkourCannotJumpUpMsg) \
    rerouteBasicClimbForPlatform(ParkourJumpUpTo, parkourCannotJumpUpMsg) \
    rerouteBasicClimbForPlatform(ParkourJumpOverTo, parkourCannotJumpOverMsg) \
    rerouteBasicClimbForPlatform(ParkourJumpDownTo, parkourCannotJumpDownMsg) \
    dobjFor(SqueezeThrough) asDobjFor(targetAction) \
    dobjFor(ParkourClimbGeneric) asDobjFor(targetAction) \
    dobjFor(ParkourClimbUpTo) asDobjFor(targetAction) \
    dobjFor(ParkourClimbOverTo) asDobjFor(targetAction) \
    dobjFor(ParkourClimbUpInto) asDobjFor(targetAction) \
    dobjFor(ParkourClimbOverInto) asDobjFor(targetAction) \
    dobjFor(ParkourClimbDownInto) asDobjFor(targetAction) \
    rerouteBasicJumpIntoForPlatform(ParkourJumpUpInto, targetAction) \
    rerouteBasicJumpIntoForPlatform(ParkourJumpOverInto, targetAction) \
    rerouteBasicJumpIntoForPlatform(ParkourJumpDownInto, targetAction)

#define RoomHasLadderDown(ladderObj) \
    roomBeforeAction() { \
        inherited(); \
        local actionMatches = nil; \
        if (gActionIs(ClimbDown)) actionMatches = true; \
        else if (gActionIs(ParkourClimbOffIntransitive)) actionMatches = true; \
        else if (gActionIs(ParkourJumpOffIntransitive)) actionMatches = true; \
        if (actionMatches && gMoverLocationFor(gActor) == self) { \
            doInstead(ParkourClimbGeneric, ladderObj); \
            exit; \
        } \
    }