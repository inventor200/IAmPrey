freeTurnCore: object {
    lastTurnCount = -1

    // Generically handle free action
    handleFreeTurn() {
        "<.p><i>(That action used a FREE TURN!)</i>";
    }

    // Generically handle turn-based action
    advanceTurns() {
        "<.p>total turns: <<libGlobal.totalTurns>>";
        if (libGlobal.totalTurns == 2)
            soundBleedCore.createSound(hardImpactNoiseProfile, sideRoom, nil);

        handleSoundPropagation();
    }

    // If a trick action is available, offer a choice here
    offerTrickAction() {
        //
    }

    // Shashek's actions go here
    handleSkashekAction() {
        //
        handleSoundPropagation();
    }

    // Perform any considerations for sound propagation
    handleSoundPropagation() {
        soundBleedCore.doPropagation();
    }
}

//TODO: When Skashek follows you into a room, you get one turn to act, and he will be reaching out for you
//      by the next turn, and you will die if you are still in the same room by the third turn. (the "short-streak")
//      If you spend that first turn going into a different room, he will immediately follow you.
//      If he can either follow you for 5(?) turns in a row (the "long-streak"), he catches you.
//      Every time he moves into another room, the short-streak resets.
//      Each turn spent climbing on a non-floor object contributes to the long-streak AND short-streak,
//      BUT it will not FINISH the short-steak, as long as you do not touch the floor! (He is waiting to snatch you!)
//      If he fails to follow you into a room, he tries to re-acquire, but every turn without you decrements the long-streak.
//TODO: Passing through a door while being chased asks the player for an evasion action.

modify Action {
    turnSequence() {
        freeTurnCore.lastTurnCount = libGlobal.totalTurns;
        inherited();
        if (freeTurnCore.lastTurnCount == libGlobal.totalTurns) {
            freeTurnCore.handleFreeTurn();
            freeTurnCore.offerTrickAction();
        }
        else {
            freeTurnCore.advanceTurns();
            freeTurnCore.offerTrickAction();
            freeTurnCore.handleSkashekAction();
        }
    }
}