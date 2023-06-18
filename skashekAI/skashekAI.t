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

    previousState = skashekIntroState
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
        skashekAIControls.previousState = prevState;
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
    // When the player cannot see him
    describeRustlingAction() {
        "{I} can hear <<getPeekHim()>> moving around in the room... ";
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

