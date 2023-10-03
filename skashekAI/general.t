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

modify skashek {
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

        local player = getPracticalPlayer();
        local playerVisibleNow = canSee(player);
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

        playerVisibleNow = canSee(player);
        hasSightChange =
            (skashekAIControls.playerWasVisibleLastTurn != playerVisibleNow);
        
        if (playerVisibleNow) {
            skashekAIControls.currentState.onSightAfter(hasSightChange);
        }
        else {
            skashekAIControls.currentState.offSightAfter(hasSightChange);
        }

        if (skashekAIControls.currentState.allowStreaks()) {
            handleStreakConsequences();
        }
        else {
            doAfterTurn();
        }
        
        handleDescOnTurn(playerVisibleNow);

        skashekAIControls.playerWasVisibleLastTurn = playerVisibleNow;
    }

    doAfterTurn() {
        skashekAIControls.currentState.doAfterTurn();
        didAnnouncementDuringTurn = nil;
        peekedNameAlready = nil;
        if (turnsBeforeNextMocking > 0) turnsBeforeNextMocking--;
    }

    doPlayerPeek() {
        skashekAIControls.currentState.doPlayerPeek();
        if (playerWillGetCaughtPeeking()) {
            gameTurnBroker.revokeFreeTurn();
            doPlayerCaughtLooking();
        }
    }

    doPlayerCaughtLooking() {
        skashekAIControls.currentState.doPlayerCaughtLooking();
    }

    showsDuringPeek() {
        return skashekAIControls.currentState.showsDuringPeek();
    }

    playerWillGetCaughtPeeking() {
        if (skashekAIControls.isNoTargetMode) return nil;
        return skashekAIControls.currentState.playerWillGetCaughtPeeking();
    }

    isChasing() {
        return skashekAIControls.currentState.isChasing();
    }

    // If FOR ANY REASON we need to refer to the player while in map
    // mode, then this will fetch the actual player character.
    getPracticalPlayer() {
        if (gCatMode) return cat;
        return prey;
    }
}