freeTurnCore: object {
    lastTurncount = -1

    handleFreeTurn() {
        "<.p><i>(That action used a FREE TURN!)</i>";
    }

    advanceTurns() {
        "<.p>total turns: <<libGlobal.totalTurns>>";
        if (libGlobal.totalTurns == 2)
            soundBleedCore.createSound(hardImpactNoiseProfile, sideRoom, nil);

        soundBleedCore.doPropagation();
    }
}

//TODO: Open and close actions actions will be free, so long as the previous
// action was not an open or close action. This means that implicit open can happen
// before travel, with the same turn count as explicit open and travel.
// Additionally, closing the door behind you is a free action.

modify Action {
    turnSequence() {
        freeTurnCore.lastTurncount = libGlobal.totalTurns;
        inherited();
        if (freeTurnCore.lastTurncount == libGlobal.totalTurns) {
            freeTurnCore.handleFreeTurn();
        }
        else {
            freeTurnCore.advanceTurns();
        }
    }
}