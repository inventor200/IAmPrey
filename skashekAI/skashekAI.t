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
    describePeekedAction() {
        describeNonTravelAction();
    }
    // What to print when not traveling
    describeNonTravelAction() {
        "<<getPeekHe(true)>> seems to be just...<i>standing</i> there... ";
    }
    // Print peek after turn?
    showPeekAfterTurn(canSeePlayer) {
        return showsDuringPeek() && canSeePlayer;
    }
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
        <<getPeekHe()>> shouts{dummy} at {me},<<one of>>
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

    describeApproach(approachArray) {
        skashek.describeTravel(approachArray);
    }

    getPeekHe(caps?) {
        return skashek.getPeekHe(caps);
    }

    getPeekHim(caps?) {
        return skashek.getPeekHim(caps);
    }

    getPeekHis(caps?) {
        return skashek.getPeekHis(caps);
    }

    getPeekHeIs(caps?) {
        return skashek.getPeekHeIs(caps);
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
    'the muffled sound of <<getPeekHis()>> voice'
    'the nearby sound of <<getPeekHis()>> voice'
    'the distant sound of <<getPeekHis()>> voice'
    strength = 3
}

_peekSkashekPOV: Thing {
    isListed = nil
    skipInRemoteList = true
}

enum notApproaching, approachingRoom, approachingDoor, approachingOther;

modify skashek {
    hasSeenPreyOutsideOfDeliveryRoom = nil
    preparedAnnouncements = static new Vector(4);
    didAnnouncementDuringTurn = nil
    peekPOV = nil
    peekedNameAlready = nil

    getPeekHe(caps?) {
        if (peekedNameAlready) {
            return caps == nil ? 'he' : 'He';
        }
        peekedNameAlready = true;
        return gSkashekName;
    }

    getPeekHim(caps?) {
        if (peekedNameAlready) {
            return caps == nil ? 'him' : 'Him';
        }
        peekedNameAlready = true;
        return gSkashekName;
    }

    getPeekHis(caps?) {
        if (peekedNameAlready) {
            return caps == nil ? 'his' : 'His';
        }
        peekedNameAlready = true;
        return gSkashekName + '\'s';
    }

    getPeekHeIs(caps?) {
        if (peekedNameAlready) {
            return caps == nil ? 'he\'s' : 'He\'s';
        }
        peekedNameAlready = true;
        return gSkashekName + '\'s';
    }

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

    // [next room, direction, approach]
    getApproach() {
        local nextStop = getNextStopOffMap();

        if (nextStop == nil || nextStop == getOutermostRoom()) {
            return [nextStop, nil, notApproaching];
        }

        local approachDirection = getBestWayTowardGoalRoom(
            nextStop
        );

        if (approachDirection == nil) {
            return [nextStop, nil, notApproaching];
        }

        local dangerDirection = getBestWayTowardGoalObject(
            getPracticalPlayer()
        );

        if (dangerDirection == nil) {
            return [nextStop, nil, approachingOther];
        }

        if (dangerDirection == approachDirection) {
            if (approachDirection.connector.ofKind(Door)) {
                return [nextStop, approachDirection, approachingDoor];
            }
            return [nextStop, approachDirection, approachingRoom];
        }

        return [nextStop, approachDirection, approachingOther];
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

    travelThroughComplex() {
        local approachArray = getApproach();

        local approachDirection = approachArray[2];

        if (approachDirection == nil) return nil;
        local door = nil;
        if (approachDirection.connector.ofKind(Door)) {
            door = getOpenableSideOfDoor(approachDirection.connector);
        }
        if (door == nil) {
            travelThroughSimple(approachArray);
            return true;
        }
        else if (door.isOpen) {
            travelThroughSimple(approachArray);
            return true;
        }
        else if (door.isLocked) {
            unlockDoor(door);
            return true;
        }
        else if (!door.isOpen) {
            openDoor(door);
            return true;
        }
        return nil;
    }

    // If going somewhere, return next room, unless blocked,
    // in which case return nil. If going nowhere, return nil.
    getWalkInRoom(approachArray?) {
        if (approachArray == nil) approachArray = getApproach();
        local nextRoom = approachArray[1];
        if (nextRoom == nil || nextRoom == getOutermostRoom()) return nil;

        local connector = approachArray[2];
        if (!connector.ofKind(Door)) return nextRoom;

        if (connector.isOpen) return nextRoom;

        return nil;
    }

    forcePeekDesc(approachArray?) {
        if (approachArray == nil) approachArray = getApproach();
        // Force peeking mode
        local setPeekMode = nil;
        if (peekPOV == nil) {
            setPeekMode = true;
            peekPOV = getPracticalPlayer();
        }
        // Look
        describeTravel(approachArray);
        // Unset peeking mode
        if (setPeekMode) peekPOV = nil;
    }

    describeTravel(approachArray) {
        // Get pov
        local fromPeeking = true;
        local pov = peekPOV;
        local player = getPracticalPlayer();
        if (pov == nil) {
            pov = player;
            fromPeeking = nil;
        }

        // Unpack array input
        //local nextStop = approachArray[1];
        local approachDirection = approachArray[2];
        local approachType = approachArray[3];

        if (approachType == notApproaching) {
            if (fromPeeking) {
                skashekAIControls.currentState.describeNonTravelAction();
            }
            return;
        }

        local door = approachDirection.connector;
        if (!door.ofKind(Door)) door = nil;
        local lastRoom = getOutermostRoom();
        local canSeeLastRoom = pov.canSee(lastRoom);
        local canPlayerSeeLastRoom = player.canSee(lastRoom);
        local nextRoom = approachDirection.destination.actualRoom;
        local canSeeNextRoom = pov.canSee(nextRoom);
        local canPlayerSeeNextRoom = player.canSee(nextRoom);
        local announceTravel =
            canSeeLastRoom || canSeeNextRoom || canPlayerSeeLastRoom || canPlayerSeeNextRoom;
        if (!announceTravel) return;
        local isLeaving = canSeeLastRoom && !canSeeNextRoom;
        if (canPlayerSeeNextRoom) {
            // The player might be peeking outside, but Skashek could still
            // be coming into the player's current room.
            isLeaving = nil;
        }

        local enterVerbForm = fromPeeking ? 'is about to enter' : 'enters';
        local exitVerbForm = fromPeeking ? 'is about to exit' : 'exits';
        local unlockVerbForm = fromPeeking ? 'is about to unlock' : 'unlocks';
        local openVerbForm = fromPeeking ? 'is about to open' : 'opens';
        local goVerbForm = fromPeeking ? 'is heading' : 'goes';
        local perceivedVerb = isLeaving ? exitVerbForm : enterVerbForm;
        local subjRoom = isLeaving ? lastRoom : nextRoom;
        local punct = fromPeeking ? '. ' : '! ';
        
        if (door != nil) {
            local visibleSide = door;
            if (!pov.canSee(visibleSide)) {
                visibleSide = door.otherSide;
            }
            local entryPlan =
                '(getPeekHe(true) must be planning to enter <<nextRoom.roomTitle>>...) ';
            if (door.isLocked) {
                "<<getPeekHe(true)>> <<unlockVerbForm>> <<visibleSide.theName>><<punct>>\n
                <<entryPlan>> ";
            }
            else if (!door.isOpen) {
                "<<getPeekHe(true)>> <<openVerbForm>> <<visibleSide.theName>><<punct>>\n
                <<entryPlan>> ";
            }
            else {
                "<<getPeekHe(true)>> <<perceivedVerb>> <<subjRoom.roomTitle>>
                through <<visibleSide.theName>><<punct>>";
            }
        }
        else if (approachType == approachingRoom && fromPeeking) {
            "<<getPeekHe(true)>> seems to be approaching! ";
        }
        else {
            "<<getPeekHe(true)>> <<goVerbForm>> <<approachDirection.getDirNameFromProp()>>,
            and <<perceivedVerb>> <<subjRoom.roomTitle>><<punct>>";
        }
    }

    travelThroughSimple(approachArray) {
        local nextRoom = approachArray[2].destination.actualRoom;
        moveInto(nextRoom);
        "<.p>";
        describeTravel(approachArray);
    }

    getOpenableSideOfDoor(door) {
        if (door == nil) return nil;
        if (!door.ofKind(Door)) return nil;
        local mySide = door;
        if (mySide.getOutermostRoom() != getOutermostRoom()) {
            // Simply process of elimination
            mySide = mySide.otherSide;
        }
        if (mySide == nil) return nil;
        if (canReach(mySide)) {
            return mySide;
        }
        return nil;
    }

    openDoor(openableSide) {
        huntCore.doSkashekAction(Open, openableSide);
    }

    unlockDoor(openableSide) {
        huntCore.doSkashekAction(Unlock, openableSide);
    }

    closeDoor(openableSide) {
        huntCore.doSkashekAction(Close, openableSide);
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
        
        if (skashekAIControls.currentState.showPeekAfterTurn(
            skashekAIControls.playerWasVisibleLastTurn
        )) {
            forcePeekDesc();
        }

        didAnnouncementDuringTurn = nil;
        peekedNameAlready = nil;

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
            "<i>{I} can see <<getPeekHim()>> in <<distantRoom.roomTitle>>...</i>\n";
        }
        local getsCaught = playerWillGetCaughtPeeking();
        //performNextAnnouncement(getsCaught, getsCaught);
        skashekAIControls.currentState.describePeekedAction();
        // Probably better to announce afterward
        performNextAnnouncement(getsCaught, getsCaught);
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
