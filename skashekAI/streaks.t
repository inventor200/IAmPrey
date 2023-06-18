modify skashek {
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
        // No mercy in kill rooms!!
        if (hasPlayerInKillRoom()) return true;

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

    handleStreakConsequences() {
        skashekAIControls.currentState.doStreaksAfterTurn();
        if (skashekAIControls.shortStreak < 0) skashekAIControls.shortStreak = 0;
        if (skashekAIControls.longStreak < 0) skashekAIControls.longStreak = 0;
        doAfterTurn();
        if (skashekAIControls.isToothless) return;
        // Don't kill if player isn't visible
        if (!canSee(getPracticalPlayer())) return;
        if (skashekAIControls.shortStreak >= getContextualMaxShortStreak() && 
            isPlayerVulnerableToShortStreak()) {
            getPracticalPlayer().dieToShortStreak();
        }
        else if (skashekAIControls.longStreak >= (skashekAIControls.maxLongStreak)) {
            getPracticalPlayer().dieToLongStreak();
        }
    }

    hasPlayerInKillRoom() {
        local om = getOutermostRoom();
        if (om.roomNavigationType != killRoom) return nil;
        if (om != getPracticalPlayer().getOutermostRoom()) return nil;
        // Make sure if he's eating kelp chips, then it's not insta-death.
        if (
            skashekAIControls.previousState == skashekIntroState &&
            om == breakroom
        ) {
            return nil;
        }
        return true;
    }

    // Kill rooms have a one-turn death, to save the player time
    getContextualMaxShortStreak() {
        if (hasPlayerInKillRoom()) return 0;
        return skashekAIControls.maxShortStreak;
    }
}