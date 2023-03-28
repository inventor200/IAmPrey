// Skashek hiding somewhere, waiting to ambush the player
skashekAmbushState: SkashekAIState {
    stateName = 'Abmush State'

    #ifdef __DEBUG
    setupForTesting() {
        inherited();
        // Set starting variables for testing
    }
    #endif
    
    doPerception(impact) {
        //TODO: Handle Skashek sound perception
    }

    doPlayerPeek() {
        //TODO: Player peeks in while he is in the room
    }

    doPlayerCaughtLooking() {
        //TODO: The player sees Skashek through a grate or cat flap,
        // but Skashek was ready!
        //TODO: Do not accept this if it happened last turn
    }

    describePeekedAction(approachType) {
        //TODO: Allow for him to be described according to his current action
        "<.p><i>\^<<gSkashekName>> is in there!</i> ";
    }

    showsDuringPeek() {
        return nil;
    }

    doTurn() {
        //
    }

    canMockPlayer() {
        return nil;
    }
}