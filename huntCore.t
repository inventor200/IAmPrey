enum basicTutorial, preyTutorial, easyMode, mediumMode, hardMode, nightmareMode;
#define gCatMode huntCore.inCatMode

huntCore: object {
    lastTurnCount = -1
    revokedFreeTurn = nil
    inMapMode = nil
    inCatMode = (difficulty == basicTutorial)
    difficulty = basicTutorial //TODO: Make a cat game preprocessor switch

    // Generically handle free action
    handleFreeTurn() {
        if (gAction.freeTurnAlertsRemaining > 0) {
            if (gAction.freeTurnAlertsRemaining > 1) {
                "<.p><i>(That action used a FREE TURN!)</i><.p>";
            }
            else {
                "<.p><i>(That action used a FREE TURN,
                <b>but this notification will now be muted
                for actions of that kind!)</b></i><.p>";
            }
            gAction.freeTurnAlertsRemaining--;
        }
    }

    // Generically handle turn-based action
    advanceTurns() {
        if (revokedFreeTurn) { //TODO: Print this before the results of the action
            "<.p><i>(That would normally be a FREE action,
            but the consequences cost a turn!)</i>";
        }
        revokedFreeTurn = nil;
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

    // If an action that normally is free suddenly has a cost,
    // then this will be called, to treat a normally-free action
    // as costly.
    revokeFreeTurn() {
        revokedFreeTurn = true;
    }
}

//TODO: When Skashek follows you into a room, you get one turn to act, and he will be
//      reaching out for you by the next turn, and you will die if you are still in the
//      same room by the third turn. (the "short-streak")
//      If you spend that first turn going into a different room, he will immediately
//      follow you. If he can either follow you for 5(?) turns in a row
//      (the "long-streak"), he catches you.
//      Every time he moves into another room, the short-streak resets.
//      Each turn spent climbing on a non-floor object contributes to the long-streak
//      AND short-streak, BUT it will not FINISH the short-steak, as long as you do not
//      touch the floor! (He is waiting to snatch you!)
//      If he fails to follow you into a room, he tries to re-acquire, but every turn
//      without you decrements the long-streak.
//TODO: Passing through a door while being chased asks the player for an evasion action.

modify Action {
    freeTurnAlertsRemaining = 3

    turnSequence() {
        // Map mode is done with everything frozen in time
        if (huntCore.inMapMode) return;
        huntCore.lastTurnCount = libGlobal.totalTurns;

        inherited();

        local wasCostlyTurn =
            (huntCore.lastTurnCount != libGlobal.totalTurns) ||
            huntCore.revokedFreeTurn;
        
        if (wasCostlyTurn) {
            huntCore.advanceTurns();
            huntCore.offerTrickAction();
            huntCore.handleSkashekAction();
        }
        else {
            if (!gAction.ofKind(SystemAction)) {
                huntCore.handleFreeTurn();
                huntCore.offerTrickAction();
            }
        }
    }
}

modify Inventory {
    turnsTaken = 0
}

modify Examine {
    turnsTaken = 0
}

modify LookThrough {
    turnsTaken = 0
}

modify Look {
    turnsTaken = 0
}

modify Read {
    turnsTaken = 0
}

modify Thing {
    wasRead = nil

    dobjFor(Read) {
        action() {
            if (self != catNameTag && gCatMode) {
                "The strange hairless citizens make odd chants while
                staring at these odd shapes, sometimes for hours
                at a time. You're not sure what <i>this</i> particular
                example would do to them, but you resent it anyway.";
            }
            else {
                if (propType(&readDesc) == TypeNil) {
                    say(cannotReadMsg);
                }
                else {
                    display(&readDesc);
                    if (!wasRead) {
                        huntCore.revokeFreeTurn();
                    }
                    wasRead = true;
                }
            }
        }
    }
}