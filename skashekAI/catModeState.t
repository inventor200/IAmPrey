// Skashek just chilling during cat mode
skashekCatModeState: SkashekAIState {
    stateName = 'Cat Mode State'

    #ifdef __DEBUG
    setupForTesting() {
        inherited();
        // Set starting variables for testing
    }
    #endif

    canMockPlayer() {
        return nil;
    }
}