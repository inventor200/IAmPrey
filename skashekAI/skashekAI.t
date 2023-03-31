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

VerbRule(ToggleSkashekAINoTarget)
    'notarget'
    : VerbProduction
    action = ToggleSkashekAINoTarget
    verbPhrase = 'toggle/toggling Skashek\'s notarget mode'
;

DefineSystemAction(ToggleSkashekAINoTarget)
    execAction(cmd) {
        skashekAIControls.isNoTargetMode = !skashekAIControls.isNoTargetMode;
        if (skashekAIControls.isNoTargetMode) {
            "notarget ON. ";
        }
        else {
            "notarget OFF. ";
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
    maxShortStreak = 2

    // Number of rooms spent on the same floor as the player
    longStreak = 0
    maxLongStreak = 5

    // Other stuff
    doorSlamStunTurns = 2

    isFrozen = __SKASHEK_FROZEN
    isToothless = __SKASHEK_TOOTHLESS
    isImmobile = __SKASHEK_IMMOBILE
    isNoTargetMode = __SKASHEK_NO_TARGET

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
    // After turn actions
    doAfterTurn() { }
    // Notice ominous clicking during creeping actions
    noticeOminousClicking() { }
    // Do door slam
    receiveDoorSlam() { }
    // Get info of where player could go next
    informLikelyDestination(room) { }

    isChasing() {
        return nil;
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

    getRandomResult(min, max?) {
        return skashek.getRandomResult(min, max);
    }
}

#include "skashekAnnouncements.t"

skashekTalkingProfile: SoundProfile {
    'the muffled sound of <<getPeekHis()>> voice'
    'the nearby sound of <<getPeekHis()>> voice'
    'the distant sound of <<getPeekHis()>> voice'
    strength = 3
}

ominousClickingProfile: SoundProfile {
    'the muffled sound of <b>ominous clicking</b>'
    'the nearby sound of <b>ominous clicking</b>'
    'the distant sound of <b>ominous clicking</b>'
    strength = 3
}
+SubtleSound 'ominous clicking'
    doAfterPerception() {
        #if __DEBUG_SKASHEK_ACTIONS
        "<.p>
        Player noticed clicking!
        <.p>";
        #endif
        skashekAIControls.currentState.noticeOminousClicking();
    }
;

iKnowYoureInThereProfile: SoundProfile {
    '<<gSkashekName>>\'s muffled voice:\n<<messageStr>>'
    '<<gSkashekName>>\'s nearby voice:\n<<messageStr>>'
    '<<gSkashekName>>\'s distant voice:\n<<messageStr>>'
    strength = 3
    isSuspicious = true

    messageStr = '<q>I know you\'re in there, Prey...</q>'
}

_peekSkashekPOV: Thing {
    isListed = nil
    skipInRemoteList = true
}

_skashekProbe: Thing {
    isListed = nil
    skipInRemoteList = true

    canSee(target) {
        local normalResult = inherited(target);
        local player = skashek.getPracticalPlayer();
        if (target == player) {
            if (skashekAIControls.isNoTargetMode) return nil;
            local playerLoc = player.location;
            return (normalResult && !playerLoc.isHidingSpot) ||
                huntCore.playerWasSeenHiding;
        }
        return normalResult;
    }
}

enum notApproaching, approachingRoom, approachingDoor, approachingOther;

modify skashek {
    hasSeenPreyOutsideOfDeliveryRoom = nil
    playerLeewayTurns = 0
    preparedAnnouncements = static new Vector(4);
    didAnnouncementDuringTurn = nil
    peekPOV = nil
    peekedNameAlready = nil
    _suppressIdleDescription = 0
    turnsBeforeNextMocking = 0
    getMockingInterval() { return getRandomResult(2, 18); }

    lastTrappedConnector = nil

    lastSeed = 1
    seedMax = 128
    randPool = static new Vector(128)

    // We are relying on a pool so that undo states have consistent behavior
    // Replugging seeds has weird results and lag with the algorithms available
    initSeed() {
        randomize();
        if (randPool.length > 0) randPool.removeRange(1, -1);
        for (local i = 1; i <= seedMax; i++) {
            local frontOrBack = (rand(4096) >= 2048);
            if (frontOrBack && randPool.length > 0) {
                randPool.insertAt(1, i);
            }
            else {
                randPool.append(i);
            }
        }
        lastSeed = 1;
    }

    getRandomResult(min, max?) {
        local root = randPool[lastSeed];
        lastSeed++;
        if (lastSeed >= seedMax) lastSeed -= seedMax;

        if (max == nil) {
            return (root % min) + 1;
        }

        local span = max - min;
        return (root % span) + min;
    }

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

    checkDeliveryRoom() {
        if (hasSeenPreyOutsideOfDeliveryRoom) return;
        hasSeenPreyOutsideOfDeliveryRoom = true;
        suppressIdleDescription();
        if (!canSee(getPracticalPlayer())) {
            #if __DEBUG_SKASHEK_ACTIONS
            "\nLoaded message.";
            #endif
            reciteAnnouncement(inspectingDeliveryRoomMessage);
            return;
        }
        if (huntCore.difficulty == nightmareMode) return;
        playerLeewayTurns = huntCore.difficultySettingObj.turnsBeforeSkashekDeploys;
        prepareSpeech();
        "<.p><q>Um, Prey,</q> <<getPeekHe()>> stammers, <q>I'm not sure if you
        dropped out of the womb correctly, but... Well, you <i>do</i> understand
        that you must run, yeah? I'm <i>planning to eat you</i>, if you do not
        escape the facility first!</q>\b
        He puts his hands on his hips, exasperated.\b
        <q>Okay, let me strike you a deal: I will give you a bit more time
        to get the fuck away from me, and <i>then</i> I will hunt you!
        <b>Remember:</b> You need to collect all seven pieces of the environment suit
        to escape! I've hidden them around the place! The timer starts <i>now</i>,
        Prey!</q> ";
    }

    suppressIdleDescription(turns?) {
        if (turns == nil) turns = 1;
        _suppressIdleDescription = turns;
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
            nextAnnouncement.interruptedMsg();
        }
        else if (canSee(getPracticalPlayer())) {
            nextAnnouncement.inPersonFullMsg();
        }
        else if (getPracticalPlayer().canSee(self)) {
            nextAnnouncement.inPersonStealthyMsg();
            // Actions are usually described in these
            suppressIdleDescription();
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
            if (skashekAIControls.isNoTargetMode) return nil;
            local playerLoc = player.location;
            return (normalResult && !playerLoc.isHidingSpot) ||
                huntCore.playerWasSeenHiding;
        }
        return normalResult;
    }

    peekInto(room) {
        _skashekProbe.moveInto(room);
        local spotted = _skashekProbe.canSee(getPracticalPlayer());
        _skashekProbe.moveInto(nil);
        #if __DEBUG_SKASHEK_ACTIONS
        "<.p>
        (Skashek spies into <<room.roomTitle>>...)\n
        <<if spotted>>He sees you!!<<else>>You are hidden!<<end>>
        <.p>";
        #endif
        if (spotted && room != deliveryRoom) {
            hasSeenPreyOutsideOfDeliveryRoom = true;
        }
        return spotted;
    }

    nextStopInRoute() {
        return skashekAIControls.currentState.nextStopInRoute();
    }

    // WARNING: MIGHT NOT BE ADJACENT ROOM!
    getNextStopOnMap() {
        local nextStop = nextStopInRoute();
        if (!nextStop.isMapModeRoom) return nextStop.mapModeVersion;
        return nextStop;
    }

    // WARNING: MIGHT NOT BE ADJACENT ROOM!
    getNextStopOffMap() {
        local nextStop = nextStopInRoute();
        if (nextStop.isMapModeRoom) return nextStop.actualRoom;
        return nextStop;
    }

    // [next room, direction, approach]
    getApproach() {
        local nextStop = getNextStopOffMap();

        if (nextStop == nil || nextStop == getOutermostRoom()) {
            return [nil, nil, notApproaching];
        }

        local approachDirection = getBestWayTowardGoalRoom(
            nextStop
        );

        local actualNextStop = nil;

        if (approachDirection == nil) {
            return [nil, nil, notApproaching];
        }
        else {
            actualNextStop = approachDirection.destination.actualRoom;
        }

        local dangerDirection = getBestWayTowardGoalObject(
            getPracticalPlayer()
        );

        if (dangerDirection == nil) {
            return [actualNextStop, approachDirection, approachingOther];
        }

        if (dangerDirection == approachDirection) {
            if (approachDirection.connector.ofKind(Door)) {
                return [actualNextStop, approachDirection, approachingDoor];
            }
            return [actualNextStop, approachDirection, approachingRoom];
        }

        return [actualNextStop, approachDirection, approachingOther];
    }

    isPlayerVulnerableToShortStreak() {
        local player = getPracticalPlayer();
        local playerLoc = player.location;
        local om = player.getOutermostRoom();

        // Player is in another room
        if (om != getOutermostRoom()) return nil;

        // Player is hidden
        if (!canSee(player)) return nil;

        // Player is on the floor
        if (isPlayerOnFloor()) return true;

        // In chase rooms, you are only safe on specific platforms
        if (om.roomNavigationType == chaseRoom) {
            return !playerLoc.isSafeParkourPlatform;
        }

        // In other rooms, Skashek waits for you to surrender or leave
        return nil;
    }

    isPlayerOnFloor() {
        local player = getPracticalPlayer();
        local playerLoc = player.location;
        local om = player.getOutermostRoom();

        // Player is on the floor
        if (playerLoc == om) return true;

        local onParkourPlat = nil;
        if (playerLoc.parkourModule != nil) {
            onParkourPlat = true;
        }
        else if (playerLoc.contType == On) {
            onParkourPlat = true;
        }

        // No safety hiding in or under things
        if (!onParkourPlat) return true;

        return nil;
    }

    travelThroughComplex() {
        local approachArray = getApproach();

        local approachDirection = approachArray[2];

        if (approachDirection == nil) return nil;
        local door = nil;
        if (approachDirection.connector.ofKind(Door)) {
            #if __DEBUG_SKASHEK_ACTIONS
            "<.p>
            NAV: Door found.
            <.p>";
            #endif
            door = getOpenableSideOfDoor(approachDirection.connector);
        }
        if (door == nil) {
            #if __DEBUG_SKASHEK_ACTIONS
            "<.p>
            NAV: Clear way found; passing...
            <.p>";
            #endif
            travelThroughSimple(approachArray);
            return true;
        }
        else if (door.isOpen) {
            #if __DEBUG_SKASHEK_ACTIONS
            "<.p>
            NAV: Door is open; passing...
            <.p>";
            #endif
            travelThroughSimple(approachArray);
            if (door.lockability == lockableWithKey || door.airlockDoor) {
                #if __DEBUG_SKASHEK_ACTIONS
                "<.p>
                NAV: Closing door behind self...";
                #endif
                closeDoor(door.otherSide);
                #if __DEBUG_SKASHEK_ACTIONS
                if (!door.isOpen) "\tSUCCESSFUL! ";
                "<.p>";
                #endif
                if (door.lockability == lockableWithKey && door.isLocked) {
                    #if __DEBUG_SKASHEK_ACTIONS
                    "<.p>
                    NAV: Re-locking door behind self...
                    <.p>";
                    #endif
                    door.makeLocked(true);
                }
            }
            return true;
        }
        else if (door.isLocked) {
            #if __DEBUG_SKASHEK_ACTIONS
            "<.p>
            NAV: Unlocking door...
            <.p>";
            #endif
            unlockDoor(door);
            return true;
        }
        else if (!door.isOpen) {
            #if __DEBUG_SKASHEK_ACTIONS
            "<.p>
            NAV: Opening door...
            <.p>";
            #endif
            openDoor(door);
            return true;
        }
        return nil;
    }

    travelThroughSimple(approachArray) {
        if (skashekAIControls.isImmobile) return;
        local lastRoom = getOutermostRoom();
        local nextRoom = approachArray[2].destination.actualRoom;
        local hasDescribedTravel = nil;
        if (getPracticalPlayer().canSee(self)) {
            "<.p>";
            describeTravel(approachArray);
            hasDescribedTravel = true;
        }
        moveInto(nextRoom);
        popDoorMovingOnItsOwn();

        local possibleDoor = approachArray[2].connector;
        local playerInNextRoom =
            (getPracticalPlayer().getOutermostRoom() == nextRoom);
        if (possibleDoor.ofKind(Door) && playerInNextRoom) {
            // If a door was trapped, then set the next one as trapped.
            trapConnector(possibleDoor);
        }
        // If the next room is really big, then a trap is not possible.
        else if (nextRoom.roomNavigationType != bigRoom) {
            abandonTraps();
            if (playerInNextRoom) {
                // If the player is in the next room, trap the one
                // Skashek came from.
                trapConnector(lastRoom);
            }
            else {
                // Otherwise, Skashek now controls the room he's in.
                trapConnector(nextRoom);
            }
        }
        else {
            // This case gets called when the room Skashek walks into
            // is MASSIVE, so he cannot control any exits.
            abandonTraps();
        }
        
        if (!hasDescribedTravel && getPracticalPlayer().canSee(self)) {
            "<.p>";
            describeTravel(approachArray);
        }
    }

    abandonTraps() {
        if (lastTrappedConnector != nil) {
            lastTrappedConnector.setTrap(nil);
            lastTrappedConnector = nil;
        }
    }

    trapConnector(connector) {
        abandonTraps();
        lastTrappedConnector = connector;
        connector.setTrap(true);
    }

    receiveDoorSlam() {
        hasSeenPreyOutsideOfDeliveryRoom = true;
        skashekAIControls.currentState.receiveDoorSlam();
        abandonTraps();
    }

    showSlamPainDesc() {
        "<<getPeekHeIs()>> rubbing his forehead in pain.
        {I} seem to have gotten him good with that door slam!
        <i>{I} should really take this opportunity to escape, though!</i> ";
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
        // If Skashek can open the door, then he controls it.
        trapConnector(openableSide);
        if (openableSide.isOpen) return;
        huntCore.doSkashekAction(Open, openableSide);
    }

    unlockDoor(openableSide) {
        if (!openableSide.isLocked) return;
        huntCore.doSkashekAction(Unlock, openableSide);
    }

    closeDoor(openableSide) {
        if (!openableSide.isOpen) return;
        huntCore.doSkashekAction(Close, openableSide);
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
            local entryPlan = nil;
            if (door.isLocked) {
                "<<getPeekHe(true)>> <<unlockVerbForm>> <<visibleSide.theName>><<punct>> ";
                entryPlan = true;
            }
            else if (!door.isOpen) {
                "<<getPeekHe(true)>> <<openVerbForm>> <<visibleSide.theName>><<punct>> ";
                entryPlan = true;
            }
            else {
                "<<getPeekHe(true)>> <<perceivedVerb>> <<subjRoom.roomTitle>>
                through <<visibleSide.theName>><<punct>>";
            }
            if (entryPlan) {
                "\n(<<getPeekHe(true)>> must be planning to enter <<nextRoom.roomTitle>>...) ";
            }
        }
        else if (approachType == approachingRoom && fromPeeking) {
            "<<getPeekHeIs(true)>> approaching from <<lastRoom.roomTitle>>! ";
        }
        else {
            "<<getPeekHe(true)>> <<goVerbForm>> <<approachDirection.getDirNameFromProp()>>,
            and <<perceivedVerb>> <<subjRoom.roomTitle>><<punct>>";
        }
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

        playerVisibleNow = canSee(getPracticalPlayer());
        hasSightChange =
            (skashekAIControls.playerWasVisibleLastTurn != playerVisibleNow);
        
        if (playerVisibleNow) {
            skashekAIControls.currentState.onSightAfter(hasSightChange);
        }
        else {
            skashekAIControls.currentState.offSightAfter(hasSightChange);
        }
        
        if (skashekAIControls.currentState.showPeekAfterTurn(playerVisibleNow)) {
            if (_suppressIdleDescription > 0) {
                _suppressIdleDescription--;
            }
            else if (getPracticalPlayer().canSee(self)) {
                "<.p>";
                forcePeekDesc();
            }
        }

        skashekAIControls.playerWasVisibleLastTurn = playerVisibleNow;

        if (!skashekAIControls.currentState.allowStreaks()) {
            doAfterTurn();
            return;
        }

        skashekAIControls.currentState.doStreaksAfterTurn();
        if (skashekAIControls.shortStreak < 0) skashekAIControls.shortStreak = 0;
        if (skashekAIControls.longStreak < 0) skashekAIControls.longStreak = 0;
        doAfterTurn();
        if (skashekAIControls.isToothless) return;
        if (skashekAIControls.shortStreak >= skashekAIControls.maxShortStreak && 
            isPlayerVulnerableToShortStreak()) {
            //TODO: Skashek snatches player
            "<.p>(You would be dead from short streak right now.)<.p>";
        }
        else if (skashekAIControls.longStreak >= (skashekAIControls.maxLongStreak + 1)) {
            //TODO: Skashek catches up to player
            "<.p>(You would be dead from long streak right now.)<.p>";
        }
    }

    doAfterTurn() {
        skashekAIControls.currentState.doAfterTurn();
        didAnnouncementDuringTurn = nil;
        peekedNameAlready = nil;
        if (turnsBeforeNextMocking > 0) turnsBeforeNextMocking--;
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
        if (skashekAIControls.isNoTargetMode) return nil;
        return skashekAIControls.currentState.playerWillGetCaughtPeeking();
    }

    // Player was seen entering room
    playerWasSeenEntering() {
        if (skashekAIControls.isNoTargetMode) return nil;
        return huntCore.playerWasSeenEntering;
    }

    // Check to see if Skashek notices a door being mysteriously opened
    highlightDoorChange(door) {
        if (skashekAIControls.isNoTargetMode) return;
        if (canSee(door)) {
            setDoorMovingOnItsOwn(door);
        }
        if (door.otherSide != nil) {
            if (canSee(door.otherSide)) {
                setDoorMovingOnItsOwn(door.otherSide);
            }
        }
    }

    setDoorMovingOnItsOwn(door) {
        hasSeenPreyOutsideOfDeliveryRoom = true;
        if (!doesDoorGoToValidDest(door)) return;
        huntCore.doorThatMovedOnItsOwn = door;
    }

    doesDoorGoToValidDest(door) {
        if (!door.location.ofKind(Room)) return nil;

        local otherSideRoom = door.otherSide.location;
        if (!otherSideRoom.ofKind(Room)) return nil;

        if (otherSideRoom.mapModeVersion == nil) return nil;

        local dirToThere = getBestWayBetweenMapModeRooms(
            door.location.mapModeVersion,
            otherSideRoom.mapModeVersion
        );
        return dirToThere != nil;
    }

    popDoorMovingOnItsOwn() {
        local door = huntCore.doorThatMovedOnItsOwn;
        huntCore.doorThatMovedOnItsOwn = nil;
        return door;
    }

    // Player let a door fall closed
    mockPreyForDoorClosing(door, room) {
        if (!checkMockingOpportunity()) return;

        mockForDoorCloseMessage.cachedLastDoor = door;
        mockForDoorCloseMessage.cachedLastRoom = room;
        reciteAnnouncement(mockForDoorCloseMessage);

        concludeMockingOpportunity();
    }

    // Player closed one of Skashek's doors
    mockPreyForDoorAlteration(door) {
        if (!checkMockingOpportunity()) return;

        mockForDoorAlterationMessage.cachedLastDoor = door;
        reciteAnnouncement(mockForDoorAlterationMessage);

        concludeMockingOpportunity();
    }

    // Player left a door looking suspicious
    mockPreyForDoorSuspicion(door) {
        if (!checkMockingOpportunity()) return;

        mockForDoorSuspicionMessage.cachedLastDoor = door;
        reciteAnnouncement(mockForDoorSuspicionMessage);

        concludeMockingOpportunity();
    }

    // Player moving a door in view of Skashek
    mockPreyForDoorMovement(door) {
        if (!checkMockingOpportunity()) return;

        mockForDoorMovementMessage.cachedLastDoor = door;
        reciteAnnouncement(mockForDoorMovementMessage);

        concludeMockingOpportunity();
    }

    checkMockingOpportunity() {
        // Don't mock too often
        if (turnsBeforeNextMocking > 0) return nil;
        if (!skashekAIControls.currentState.canMockPlayer()) return nil;
        // Don't be obnoxious lmao
        if (canSee(getPracticalPlayer())) return nil;
        return true;
    }

    concludeMockingOpportunity() {
        turnsBeforeNextMocking = getMockingInterval();
    }

    informLikelyDestination(room) {
        skashekAIControls.currentState.informLikelyDestination(room);
    }

    isChasing() {
        return skashekAIControls.currentState.isChasing();
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
//#include "ambushState.t"
#include "chaseState.t"
