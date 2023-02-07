enum basicTutorial, preyTutorial, easyMode, mediumMode, hardMode, nightmareMode;
#define gCatMode huntCore.inCatMode

huntCore: InitObject {
    revokedFreeTurn = nil
    inMapMode = nil
    inCatMode = (difficulty == basicTutorial)
    wasBathTimeAnnounced = nil
    #if __IS_CAT_GAME
    difficulty = basicTutorial
    #else
    difficulty = mediumMode
    #endif

    execBeforeMe = [prologueCore]
    bathTimeFuse = nil
    apologyGivenToPG = nil
    apologyFuse = nil
    allNormalDoors = static new Vector(10)

    execute() {
        if (inCatMode) {
            bathTimeFuse = new Fuse(self, &startBathTime, 9);
            // Cats cannot open doors, so we'll have them open
            // by default.
            for (local i = 1; i <= allNormalDoors.length; i++) {
                allNormalDoors[i].isOpen = true;
            }
        }
    }

    startBathTime() {
        wasBathTimeAnnounced = true;
        "<.p>The voice of your Royal Subject is heard over the facility's
        intercom:\n
        <q><<gCatName>>...! It's bath time! I can smell you from the other
        side of the hunting zone!</q>\b
        Oh no. You fucking <i>hate</i> bath time...!! Time to make
        the Royal Subject <i>work for it!!</i>";
        bathTimeFuse = nil;
    }

    printApologyNoteForPG() {
        if (!apologyGivenToPG) {
            apologyFuse = new Fuse(self, &apologyMethod, 0);
            apologyGivenToPG = true;
        }
        return cat.actualName;
    }

    apologyMethod() {
        "<.p><i>(<b>Note for the real Piergiorgio:</b>
        Don't worry; I will change the cat's name to something else before I
        upload this anywhere! This silly joke was for testers only!)</i><.p>";
        apologyFuse = nil;
    }

    // Generically handle free action
    handleFreeTurn() {
        if (gAction.freeTurnAlertsRemaining > 0) {
            if (gAction.freeTurnAlertsRemaining > 1) {
                "<.p><i>(You used this turn for FREE!)</i><.p>";
            }
            else {
                "<.p><i>(From now-on, you will only be alerted if
                this action </i>wasn't<i> a FREE turn!)</i><.p>";
            }
            gAction.freeTurnAlertsRemaining--;
        }
    }

    // Generically handle turn-based action
    advanceTurns() {
        if (revokedFreeTurn) {
            "<.p><i>(These particular consequences have cost you a turn!
                Normally, you would have gotten this for FREE!)</i>";
        }
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

modify Door {
    preinitThing() {
        inherited();
        if (!isLocked) {
            huntCore.allNormalDoors.append(self);
        }
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

#define gHadRevokedFreeAction (turnsTaken == 0 && huntCore.revokedFreeTurn)
#define gActionWasCostly (turnsTaken > 0 || gHadRevokedFreeAction)

modify Action {
    freeTurnAlertsRemaining = 2

    turnSequence() {
        // Map mode is done with everything frozen in time
        if (huntCore.inMapMode) {
            revokedFreeTurn = nil;
            return;
        }

        inherited();
        
        if (gActionWasCostly) {
            huntCore.advanceTurns();
            huntCore.offerTrickAction();
            huntCore.handleSkashekAction();
        }
        else {
            huntCore.handleFreeTurn();
            huntCore.offerTrickAction();
        }

        if (gHadRevokedFreeAction) libGlobal.totalTurns++;

        huntCore.revokedFreeTurn = nil;
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

    dobjFor(Open) {
        verify() {
            if (gCatMode) {
                illogical('You are a simple cat, and cannot open that. ');
                return;
            }
            inherited();
        }
    }

    dobjFor(Close) {
        verify() {
            if (gCatMode) {
                illogical('As a cat, you don\'t want to make things inaccessible later! ');
                return;
            }
            inherited();
        }
    }

    catInventoryMsg = 'Carrying that in your mouth would only slow you down. ';

    dobjFor(Take) {
        verify() {
            if (gCatMode) {
                illogical(catInventoryMsg);
                return;
            }
            inherited();
        }
    }

    dobjFor(TakeFrom) {
        verify() {
            if (gCatMode) {
                illogical(catInventoryMsg);
                return;
            }
            inherited();
        }
    }

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