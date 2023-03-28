#ifdef __DEBUG
VerbRule(ReportSkashekRouteToPlayer)
    ('check'|'report'|'print'|'get'|'show'|'what' 'is'|'what\'s')
    ('skashek'|'skashek\'s'|) (
        ('route'|'path') ('to'|'toward'|'towards') ('me'|'player') |
        ('hunt'|'hunting') ('route'|'path')
    )
    : VerbProduction
    action = ReportSkashekRouteToPlayer
    verbPhrase = 'report/reporting Skashek\'s route to the player'
;

DefineSystemAction(ReportSkashekRouteToPlayer)
    execAction(cmd) {
        skashek.reportPathToPlayer();
    }
;

VerbRule(FreezeSkashekAI)
    ('freeze'|'pause') ('skashek'|'ai'|)
    : VerbProduction
    action = FreezeSkashekAI
    verbPhrase = 'freeze/freezing Skashek\'s AI'
;

DefineSystemAction(FreezeSkashekAI)
    execAction(cmd) {
        skashekAIControls.isFrozen = !skashekAIControls.isFrozen;
        if (skashekAIControls.isFrozen) {
            "Skashek's AI is now frozen. ";
        }
        else {
            "Skashek's AI is now unfrozen. ";
        }
    }
;

VerbRule(CheckVisibilityToSkashekAI)
    'can' 'you' 'see' 'me'
    : VerbProduction
    action = CheckVisibilityToSkashekAI
    verbPhrase = 'check/checking if Skashek can see you'
;

DefineSystemAction(CheckVisibilityToSkashekAI)
    execAction(cmd) {
        if (skashek.canSee(skashek.getPracticalPlayer())) {
            "Skashek can see you. ";
        }
        else {
            "Skashek cannot see you. ";
        }
    }
;
#endif

skashekAIControls: object {
    lastTurn = -1
    currentTurn = -1
    bonusTurns = 0
    availableTurns = 0

    playerWasVisibleLastTurn = nil

    // Number of turns spend in a specific room with the player
    shortStreak = 0
    maxShortStreak = 3

    // Number of rooms spent on the same floor as the player
    longStreak = 0
    maxLongStreak = 5

    isFrozen = __SKASHEK_FROZEN
    isToothless = __SKASHEK_TOOTHLESS
    isImmobile = __SKASHEK_IMMOBILE

    currentState = skashekIntroState

    #ifdef __DEBUG
    setupForTesting() {
        // Setup variables for testing
    }
    #endif

    startTurn() {
        currentTurn += 1 + bonusTurns;
        bonusTurns = 0;
        availableTurns = currentTurn - lastTurn;
    }

    endTurn() {
        lastTurn = currentTurn;
    }
}

class SkashekAIState: object {
    stateName = 'Unnamed State'
    needsGameStartSetup = nil

    activate() {
        local prevState = skashekAIControls.currentState;
        if (prevState != nil) prevState.end(self);
        #if __DEBUG_SKASHEK_ACTIONS
        "<.p>Skashek is entering a new state: <<stateName>> ";
        #endif
        skashekAIControls.currentState = self;
        if (needsGameStartSetup) {
            needsGameStartSetup = nil;
            startGameFrom();
        }
        start(prevState);
    }

    #ifdef __DEBUG
    setupForTesting() { }
    #endif

    startGameFrom() { }
    start(prevState) { }
    end(nextState) { }

    // Run per-turn logic
    doTurn() { }
    // Process sounds
    doPerception(impact) { }
    // Process player peeking at him
    doPlayerPeek() { }
    // Process player getting caught peeking
    doPlayerCaughtLooking() { }
    // Print desc from peek
    describePeekedAction(approachType) { }
    // Shows up during peek?
    showsDuringPeek() {
        return true;
    }
    // Will the player get caught peeking?
    playerWillGetCaughtPeeking() {
        return nil;
    }
    // Check ability to mock
    canMockPlayer() {
        return true;
    }
    // Announce a player's failure to hide
    announceBadHidingSpot() {
        if (!canMockPlayer()) return;
        prepareSpeech();
        "<.p>
        <q>I can <i>see</i> you <<one of
        >>hiding<<or
        >>trying to hide<<at random
        >>, Prey!</q>
        <<gSkashekName>> shouts{dummy} at {me},<<one of>>
        cackling<<or>>
        laughing<<or>>
        chuckling<<at random>>.
        <.p>";
    }
    // Progress streaks
    allowStreaks() {
        return true;
    }
    // Do streaks before and after turn
    doStreaksBeforeTurn() { }
    doStreaksAfterTurn() { }
    // Do sight status actions
    onSightBefore(begins) { }
    offSightBefore(ends) { }
    onSightAfter(begins) { }
    offSightAfter(ends) { }
    // Speech management
    prepareSpeech() {
        skashek.prepareSpeech();
    }
    didAnnouncementDuringTurn() {
        return skashek.didAnnouncementDuringTurn;
    }
    // Next room in planned route
    nextStopInRoute() {
        return skashek.getOutermostRoom();
    }

    describeApproach(approachType) {
        switch (approachType) {
            default: 
                "<<gSkashekName>> is seen just...<i>standing there!</i> ";
                return;
            case approachingRoom:
                "<<gSkashekName>> seems to be <i>coming this way!</i> ";
                return;
            case approachingDoor:
                "<<gSkashekName>> is <i>about to open this door!</i> ";
                return;
            case approachingOther:
                "<<gSkashekName>> seems to be on the move... ";
                return;
        }
    }
}

class IntercomMessage: object {
    // The version when visible, but player is hiding
    inPersonStealthyMsg() { overCommsMsg(); }
    // The version when not visible
    overCommsMsg = "Message over intercom. "
    // The version when visible, and player is visible
    inPersonFullMsg() { overCommsMsg(); }
    // The version when the player is seen upon triggering
    interruptedMsg() { overCommsMsg(); }
}

#include "skashekAnnouncements.t"

skashekTalkingProfile: SoundProfile {
    'the muffled sound of <<gSkashekName>>\'s voice'
    'the nearby sound of <<gSkashekName>>\'s voice'
    'the distant sound of <<gSkashekName>>\'s voice'
    strength = 3
}

enum notApproaching, approachingRoom, approachingDoor, approachingOther;

modify skashek {
    hasSeenPreyOutsideOfDeliveryRoom = nil
    preparedAnnouncements = static new Vector(4);
    didAnnouncementDuringTurn = nil

    prepareSpeech() {
        // Don't go on a monologue if we have something else to say!
        didAnnouncementDuringTurn = true;
    }

    reciteAnnouncement(intercomMsg) {
        preparedAnnouncements.appendUnique(intercomMsg);
    }

    hasAnnouncement() {
        if (didAnnouncementDuringTurn) return nil;
        return preparedAnnouncements.length > 0;
    }

    getAnnouncement() {
        if (!hasAnnouncement()) return nil;
        local announcement = preparedAnnouncements[1];
        preparedAnnouncements.removeElementAt(1);
        didAnnouncementDuringTurn = true;
        return announcement;
    }

    performNextAnnouncement(isVisible?, isInterrupted?) {
        local nextAnnouncement = getAnnouncement();
        if (nextAnnouncement == nil) return;
        "<.p>";
        if (isInterrupted) {
            interruptedMsg.inPersonFullMsg();
        }
        else if (canSee(getPracticalPlayer())) {
            nextAnnouncement.inPersonFullMsg();
        }
        else if (isVisible) {
            nextAnnouncement.inPersonStealthyMsg();
        }
        else {
            nextAnnouncement.overCommsMsg();
            // Give the player a hint of where he is when he talks
            soundBleedCore.createSound(
                skashekTalkingProfile,
                self,
                getOutermostRoom(),
                nil
            );
        }
        "<.p>";
    }

    canSee(target) {
        local normalResult = inherited(target);
        local player = getPracticalPlayer();
        if (target == player) {
            local playerLoc = player.location;
            return (normalResult && !playerLoc.isHidingSpot) ||
                huntCore.playerWasSeenHiding;
        }
        return normalResult;
    }

    nextStopInRoute() {
        return skashekAIControls.currentState.nextStopInRoute();
    }

    getNextStopOnMap() {
        local nextStop = nextStopInRoute();
        if (!nextStop.isMapModeRoom) return nextStop.mapModeVersion;
        return nextStop;
    }

    getNextStopOffMap() {
        local nextStop = nextStopInRoute();
        if (nextStop.isMapModeRoom) return nextStop.actualRoom;
        return nextStop;
    }

    getApproach() {
        local nextStop = getNextStopOffMap();

        if (nextStop == nil || nextStop == getOutermostRoom()) {
            return notApproaching;
        }

        local dangerDirection = getBestWayTowardGoalObject(
            getPracticalPlayer()
        );

        if (dangerDirection == nil) {
            return approachingOther;
        }

        local approachDirection = getBestWayTowardGoalRoom(
            nextStop
        );

        if (dangerDirection == nil) {
            return notApproaching;
        }

        if (dangerDirection == approachDirection) {
            if (approachDirection.connector.ofKind(Door)) {
                return approachingDoor;
            }
            return approachingRoom;
        }

        return approachingOther;
    }

    isPlayerVulnerableToShortStreak() {
        local player = getPracticalPlayer();
        local playerLoc = player.location;
        local om = player.getOutermostRoom();

        // Player is in another room
        if (om != getOutermostRoom()) return nil;

        // Player is on the floor
        if (playerLoc == om) return true;

        // Player is hidden
        if (!canSee(player)) return nil;

        // In chase rooms, you are only safe on specific platforms
        if (om.roomNavigationType == chaseRoom) {
            return !playerLoc.isSafeParkourPlatform;
        }

        // In other rooms, Skashek waits for you to surrender or leave
        return nil;
    }

    doAction(action, dobj?, iobj?) {
        huntCore.doSkashekAction(action, dobj, iobj);
    }

    doTurn() {
        if (!hasSeenPlayerAttemptToHide && huntCore.playerWasSeenHiding) {
            hasSeenPlayerAttemptToHide = true;
            skashekAIControls.currentState.announceBadHidingSpot();
        }

        if (skashekAIControls.currentState.allowStreaks()) {
            skashekAIControls.currentState.doStreaksBeforeTurn();
        }

        local playerVisibleNow = canSee(getPracticalPlayer());
        local hasSightChange =
            (skashekAIControls.playerWasVisibleLastTurn != playerVisibleNow);

        // If player walked in him, interrupt his speech lol
        local playerHasAppeared = playerVisibleNow && hasSightChange;
        performNextAnnouncement(playerVisibleNow, playerHasAppeared);
        
        if (playerVisibleNow) {
            skashekAIControls.currentState.onSightBefore(hasSightChange);
        }
        else {
            skashekAIControls.currentState.offSightBefore(hasSightChange);
        }

        skashekAIControls.currentState.doTurn();
        
        if (playerVisibleNow) {
            skashekAIControls.currentState.onSightAfter(hasSightChange);
        }
        else {
            skashekAIControls.currentState.offSightAfter(hasSightChange);
        }

        skashekAIControls.playerWasVisibleLastTurn = canSee(getPracticalPlayer());

        didAnnouncementDuringTurn = nil;

        if (!skashekAIControls.currentState.allowStreaks()) return;
        skashekAIControls.currentState.doStreaksAfterTurn();
        if (skashekAIControls.shortStreak < 0) skashekAIControls.shortStreak = 0;
        if (skashekAIControls.longStreak < 0) skashekAIControls.longStreak = 0;
        if (skashekAIControls.isToothless) return;
        if (skashekAIControls.shortStreak >= skashekAIControls.maxShortStreak && 
            isPlayerVulnerableToShortStreak()) {
            //TODO: Skashek snatches player
        }
        else if (skashekAIControls.longStreak >= skashekAIControls.maxLongStreak) {
            //TODO: Skashek catches up to player
        }
    }

    doPerception() {
        #if __DEBUG_SOUND_SKASHEK_SIDE
        if (perceivedSoundImpacts.length > 0) {
            "\bSkashek hears:";
        }
        #endif
        for (local i = 1; i <= perceivedSoundImpacts.length; i++) {
            local impact = perceivedSoundImpacts[i];
            #if __DEBUG_SOUND_SKASHEK_SIDE
            say('\n' + impact.soundProfile.closeEchoStr);
            say('\n\tFrom: ' + impact.sourceOrigin.theName);
            #endif
            skashekAIControls.currentState.doPerception(impact);
        }
        #if __DEBUG_SOUND_SKASHEK_SIDE
        if (perceivedSoundImpacts.length > 0) {
            "\b";
        }
        #endif
        if (perceivedSoundImpacts.length > 0) {
            perceivedSoundImpacts.removeRange(1, -1);
        }
    }

    doPlayerPeek() {
        skashekAIControls.currentState.doPlayerPeek();
        if (playerWillGetCaughtPeeking()) {
            huntCore.revokeFreeTurn();
            doPlayerCaughtLooking();
        }
    }

    doPlayerCaughtLooking() {
        skashekAIControls.currentState.doPlayerCaughtLooking();
    }

    describePeekedAction(distantRoom) {
        "<.p>";
        if (distantRoom != nil) {
            "<i>{I} see someone in <<distantRoom.roomTitle>>...</i>\n";
        }
        local getsCaught = playerWillGetCaughtPeeking();
        performNextAnnouncement(getsCaught, getsCaught);
        skashekAIControls.currentState.describePeekedAction(getApproach());
    }

    showsDuringPeek() {
        return skashekAIControls.currentState.showsDuringPeek();
    }

    canMockPlayer() {
        return skashekAIControls.currentState.canMockPlayer();
    }

    playerWillGetCaughtPeeking() {
        return skashekAIControls.currentState.playerWillGetCaughtPeeking();
    }

    playerWasSeenEntering() {
        return huntCore.playerWasSeenEntering;
    }

    getRoomFromGoalObject(goalObj) {
        if (goalObj.location == nil) return nil;
        if (goalObj.ofKind(MultiLoc)) return nil;
        local actualRoom = goalObj.getOutermostRoom();
        if (actualRoom.isMapModeRoom) {
            // Should never happen, but just in case
            actualRoom = actualRoom.actualRoom;
        }
        return actualRoom;
    }

    getBestWayTowardGoalObject(goalObj) {
        local goalRoom = getRoomFromGoalObject(goalObj);
        if (goalRoom == nil) return nil; // Can't find our way off-grid

        return getBestWayTowardGoalRoom(goalRoom);
    }

    getBestWayTowardGoalRoom(goalRoom) {
        local goalMapModeRoom = goalRoom.mapModeVersion;
        if (goalMapModeRoom == nil) return nil; // Can't find our way off-grid

        return getBestWayTowardGoalMapModeRoom(goalMapModeRoom);
    }

    getCurrentMapModeRoom() {
        if (location == nil) return nil; // Can't find our way in the void
        return getOutermostRoom().mapModeVersion;
    }

    getBestWayTowardGoalMapModeRoom(goalMapModeRoom) {
        return getBestWayBetweenMapModeRooms(
            getCurrentMapModeRoom(),
            goalMapModeRoom
        );
    }

    getBestWayBetweenMapModeRooms(mapModeRoomA, mapModeRoomB) {
        if (mapModeRoomB == nil) return nil; // Can't find our way off-grid
        if (mapModeRoomA == nil) return nil; // Can't find our way off-grid

        return mapModeRoomA.skashekRouteTable
            .findBestDirectionTo(mapModeRoomB);
    }

    getFullPathToMapModeRoom(goalMapModeRoom) {
        return getFullPathBetweenRooms(
            getCurrentMapModeRoom(),
            goalMapModeRoom
        );
    }

    getFullPathBetweenRooms(mapModeRoomA, mapModeRoomB) {
        if (mapModeRoomB == nil) return nil; // Can't find our way off-grid
        if (mapModeRoomA == nil) return nil; // Can't find our way off-grid

        local currentRoom = mapModeRoomA;
        local path = [mapModeRoomA];

        while (currentRoom != mapModeRoomB) {
            local nextDir = getBestWayBetweenMapModeRooms(
                currentRoom,
                mapModeRoomB
            );

            if (nextDir == nil) return nil;
            if (nextDir == compassAlreadyHereSignal) return path;

            currentRoom = nextDir.destination;
            path += nextDir;
        }

        if (path.length == 1) return nil;

        return path;
    }

    // If FOR ANY REASON we need to refer to the player while in map
    // mode, then this will fetch the actual player character.
    getPracticalPlayer() {
        if (gCatMode) return cat;
        return prey;
    }

    reportPathToPlayer() {
        local goalRoom = getRoomFromGoalObject(
            getPracticalPlayer()
        );
        local goalMapModeRoom = goalRoom.mapModeVersion;
        local path = getFullPathToMapModeRoom(goalMapModeRoom);

        if (path == nil) {
            "Skashek has no way to <<goalRoom.roomTitle>>. ";
            return;
        }

        "Skashek's path would be the following...";
        for (local i = 1; i <= path.length; i++) {
            if (i == 1) {
                "\n\tStarting in <<path[i].actualRoom.roomTitle>>";
            }
            else {
                "\n\t\^<<path[i].getSkashekDir()>>";
            }
        }
    }
}

#include "introState.t"
#include "catModeState.t"
#include "lurkState.t"
#include "ambushState.t"
#include "chaseState.t"
#include "reacquireState.t"
