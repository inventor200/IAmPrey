// Skashek trying to catch up to the player
skashekChaseState: SkashekAIState {
    stateName = 'Chase State'

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

    describeNonTravelAction() {
        "<<getPeekHe(true)>> chases you!! ";
    }

    doTurn() {
        //
    }
}