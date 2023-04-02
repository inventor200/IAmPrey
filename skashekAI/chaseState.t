// Skashek trying to catch up to the player
skashekChaseState: SkashekAIState {
    stateName = 'Chase State'

    // Intel
    lastKnownPlayerRoom = nil

    // Steak actions
    resetShortStreak = nil
    incrementShortStreak = nil
    incrementLongStreak = nil
    decrementLongStreak = nil

    // Door slamming stun:
    stunTurns = 0

    fallbackToLurk = nil

    // Special movement rule for intercepting the player
    //interceptLungeAvailable = nil

    start(prevState) {
        #ifdef __DEBUG
        #if __SKASHEK_ALLOW_TESTING_CHASE
        setupForTesting();
        #endif
        #endif
        resetShortStreak = nil;
        incrementShortStreak = nil;
        incrementLongStreak = nil;
        decrementLongStreak = nil;
        fallbackToLurk = nil;
        stunTurns = 0;
        //interceptLungeAvailable = nil;
        // We are CERTAIN now, lol:
        skashek.hasSeenPreyOutsideOfDeliveryRoom = true;
        updatePlayerRoom();
    }

    isChasing() {
        return true;
    }

    receiveDoorSlam() {
        stunTurns = skashekAIControls.doorSlamStunTurns;
    }

    #ifdef __DEBUG
    setupForTesting() {
        inherited();
        // Set starting variables for testing
    }
    #endif

    updatePlayerRoom() {
        local player = skashek.getPracticalPlayer();

        if (!skashek.canSee(player)) return;

        local dirToPlayer = skashek.getBestWayTowardGoalObject(player);

        if (dirToPlayer == nil) {
            return;
        }

        lastKnownPlayerRoom = player.getOutermostRoom();
    }

    nextStopInRoute() {
        return lastKnownPlayerRoom;
    }

    describeNonTravelAction() {
        if (stunTurns > 0) {
            skashek.showSlamPainDesc();
            return;
        }
        local sprintingVerbs =
            '<<one of
            >>running<<or
            >>sprinting<<or
            >>speeding<<at random>>
            <<one of
            >>toward<<or
            >>at<<or
            >>right at<<at random>>';
        local player = skashek.getPracticalPlayer();
        //local shortStreakLimit = skashek.getContextualMaxShortStreak();
        #if __DEBUG_SKASHEK_ACTIONS
        "<.p>
        \tShort: <<skashekAIControls.shortStreak>> / <<skashekAIControls.maxShortStreak>>
        <.p>";
        #endif
        local isShortDangerous =
            skashekAIControls.shortStreak + 1 >= skashekAIControls.maxShortStreak;
        if (skashek.getOutermostRoom().roomNavigationType == killRoom) {
            isShortDangerous = true;
        }
        if (skashek.isPlayerVulnerableToShortStreak()) {
            if (skashek.isPlayerOnFloor()) {
                if (!isShortDangerous) {
                    if (skashekAIControls.longStreak >= skashekAIControls.maxLongStreak - 1) {
                        "<<getPeekHe(true)>> is <<sprintingVerbs>>{dummy}
                        {me}! If {i} do not evade now, he will
                        likely{dummy} kill {me} in the next room. ";
                        return;
                    }
                    "<<getPeekHe(true)>> is <<sprintingVerbs>>{dummy}
                    {me}, but {i} still have time to react! ";
                    return;
                }
                "<<getPeekHe(true)>> is bearing down{dummy}
                on {me}! {I} need to make a decisive move <i>now!</i> ";
                return;
            }
            if (!isShortDangerous) {
                "<<getPeekHe(true)>> watches{dummy} {me} from
                <<player.getOutermostRoom().floorObj.theName>>, with
                a grin that says {i} {am} not safe here! ";
                return;
            }
            "<<getPeekHe(true)>> keeps watching{dummy} {me} from
            <<player.getOutermostRoom().floorObj.theName>>, but
            it looks like his patience will run out soon! ";
            return;
        }
        "<<getPeekHe(true)>> paces around on
        <<player.getOutermostRoom().floorObj.theName>>, as
        he{dummy} watches {me}! ";
    }

    doTurn() {
        resetShortStreak = nil;
        incrementShortStreak = nil;
        incrementLongStreak = nil;
        decrementLongStreak = nil;

        if (stunTurns > 0) {
            stunTurns--;
            resetShortStreak = true;
            decrementLongStreak = true;
            return;
        }
        #if __DEBUG_SKASHEK_ACTIONS
        "<.p>
        CHASE: Heading for: <<lastKnownPlayerRoom.roomTitle>>
        <.p>";
        #endif
        doChaseStep();

        #if __DEBUG_SKASHEK_ACTIONS
        "<.p>
        CHASE: Testing lunge...
        <.p>";
        #endif

        local om = skashek.getOutermostRoom();

        // See if the bonus lunge can be used
        if (om == lastKnownPlayerRoom) return;
        
        // Keep the streak, just in case
        local oldStreakStatus = decrementLongStreak;
        decrementLongStreak = nil;

        // Find route
        local thisMapMode = om.mapModeVersion;
        local thatMapMode = lastKnownPlayerRoom.mapModeVersion;
        local route =
            skashek.getFullPathBetweenRooms(thisMapMode, thatMapMode);

        local routeLen = 0;
        local routeFailed = nil;

        if (route == nil) {
            routeFailed = true;
            fallbackToLurk = true;
            "<.p>
            CHASE: Lunge failed!\n
            \tNil route!
            <.p>";
        }
        else if (route.length == 1) {
            routeFailed = true;
            "<.p>
            CHASE: Lunge failed!\n
            \tNo route!
            <.p>";
        }

        // A length of 2 triggers the lunge
        if (!routeFailed) routeLen = route.length - 1;

        if (routeLen == 1) {
            routeFailed = true;
            "<.p>
            CHASE: Lunge failed!\n
            \tToo short!
            <.p>";
        }

        if (routeLen == 3) {
            "<.p>
            CHASE: Lunge paused!
            <.p>";
        }

        if (routeLen > 3) {
            routeFailed = true;
            fallbackToLurk = true;
            "<.p>
            CHASE: Lunge failed!\n
            \tToo long!\n
            \tFalling back to lurk!
            <.p>";
        }

        local closedDoorCount = 0;

        if (routeLen > 0) {
            for (local i = 2; i <= route.length; i++) {
                local dir = route[i];

                if (dir.connector.ofKind(Door)) {
                    if (!dir.connector.isOpen) {
                        closedDoorCount++;
                        if (dir.connector.lockability != notLockable) {
                            // Locked doors are too much of a hassle.
                            routeFailed = true;
                            fallbackToLurk = true;
                            "<.p>
                            CHASE: Lunge failed!\n
                            \tClosed and locked door in the way!
                            <.p>";
                            break;
                        }
                    }
                }
            }
        }

        // Too many closed doors to pass through.
        if (closedDoorCount > 1) {
            routeFailed = true;
            fallbackToLurk = true;
            "<.p>
            CHASE: Lunge failed!\n
            \tToo many closed doors! (<<closedDoorCount>>)
            <.p>";
        }

        if (routeFailed) {
            decrementLongStreak = oldStreakStatus;
            return;
        }
        
        // IT CAN BE USED!
        #if __DEBUG_SKASHEK_ACTIONS
        "<.p>
        CHASE: Lunge approved!
        <.p>";
        #endif
        if (skashek.getPracticalPlayer().canSee(skashek)) {
            "<.p><b><<getPeekHe(true)>>
            violently scrambles to{dummy} intercept {me}!!</b><.p>";
        }
        else {
            "<.p><b>{I} think {i} hear <<getPeekHim()>>
            violently scrambling to{dummy} intercept {me}!!</b><.p>";
        }

        for (local i = 1; i < routeLen; i++) {
            local finishedStep = nil;
            while (!finishedStep) {
                finishedStep = doLungeStep();
            }
        }

        // Make sure the way is open as the player
        // lands on the ground
        local nextDir = skashek.getApproach()[2];
        if (nextDir == nil) return;
        local nextConnector = nextDir.connector;
        if (nextConnector == nil) return;
        while (!nextConnector.isOpen) {
            skashek.travelThroughComplex();
        }
    }

    doLungeStep() {
        updatePlayerRoom();
        local oldRoom = skashek.getOutermostRoom();
        if (oldRoom == lastKnownPlayerRoom) return true;
        skashek.travelThroughComplex();
        local newRoom = skashek.getOutermostRoom();
        #if __DEBUG_SKASHEK_ACTIONS
        if (oldRoom != newRoom) {
            "<.p>
            CHASE: Lunge into: <<newRoom.roomTitle>>
            <.p>";
        }
        #endif
        updatePlayerRoom();
        return oldRoom != newRoom;
    }

    doChaseStep() {
        local player = skashek.getPracticalPlayer();
        local actualPlayerRoom = player.getOutermostRoom();
        updatePlayerRoom();
        local oldRoom = skashek.getOutermostRoom();
        skashek.travelThroughComplex();
        local newRoom = skashek.getOutermostRoom();
        local hasVisual = skashek.canSee(player);
        if (oldRoom != newRoom) {
            resetShortStreak = true;
            #if __DEBUG_SKASHEK_ACTIONS
            "<.p>
            CHASE: Move into: <<newRoom.roomTitle>>
            <.p>";
            #endif
            updatePlayerRoom();
            if (hasVisual) {
                // Large rooms allow for more flexibility?
                // We can undo this later, if we want.
                if (
                    (newRoom == actualPlayerRoom) &&
                    (newRoom.roomNavigationType != bigRoom)
                ) {
                    incrementLongStreak = true;
                    player.addExhaustion(2);
                }
            }
            else {
                decrementLongStreak = true;
            }
        }
        else if (hasVisual && oldRoom == actualPlayerRoom) {
            incrementShortStreak = true;
        }
    }

    doStreaksAfterTurn() {
        if (resetShortStreak) {
            skashekAIControls.shortStreak = 0;
        }
        else if (incrementShortStreak) {
            skashekAIControls.shortStreak++;
        }

        if (incrementLongStreak) {
            skashekAIControls.longStreak++;
        }
        else if (decrementLongStreak) {
            skashekAIControls.longStreak--;
        }

        #if __DEBUG_SKASHEK_ACTIONS
        "<.p>
        CHASE STREAKS:\n
        \tLong: <<skashekAIControls.longStreak>>\n
        \tShort: <<skashekAIControls.shortStreak>>
        <.p>";
        #endif

        if (fallbackToLurk) {
            fallbackToLurk = nil;
            skashekLurkState.startRandom = nil;
            skashekLurkState.goalRoom = lastKnownPlayerRoom;
            skashekLurkState.activate();
            skashekLurkState.addSpeedBoost(3);
        }
    }

    informLikelyDestination(room) {
        #if __DEBUG_SKASHEK_ACTIONS
        "<.p>
        CHASE: Player will be in <<room.roomTitle>>!
        <.p>";
        #endif
        lastKnownPlayerRoom = room;
    }

    offSightAfter(ends) {
        if (!ends) return;
        if (stunTurns > 0) return;
        if (skashek.didAnnouncementDuringTurn) return;
        skashek.prepareSpeech();
        "<q><<one of
        >>You won't get away <i>that</i> easy!<<or
        >>It's a matter of time, Prey!<<or
        >>You're a <i>difficult</i> one, huh?<<or
        >>Don't think you've <i>escaped</i>, Prey!<<or
        >>You don't make this easy, Prey!<<
        at random>></q>
        <<getPeekHe>> <<one of>>shouts<<or>>barks<<or>>yells<<at random>>. ";
    }
}