enum basicTutorial, preyTutorial, easyMode, mediumMode, hardMode, nightmareMode;
#define gCatMode huntCore.inCatMode
#define gPlayerAction huntCore.playerAction
#define gPlayerActionActor huntCore.playerActionActor
#define gPlayerDobj huntCore.playerAction.curDobj
#define gPlayerIobj huntCore.playerAction.curIobj
#define nestedSkashekAction(action, dobj, iobj) huntCore.doSkashekAction(action, dobj, iobj)

#define __DEBUG_SKASHEK_ACTIONS true

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
    #if __DEBUG
    apologyGivenToPG = nil
    apologyFuse = nil
    #endif

    playerAction = nil
    playerActionActor = nil

    execute() {
        if (inCatMode) {
            bathTimeFuse = new Fuse(self, &startBathTime, 9);
        }
    }

    startBathTime() {
        wasBathTimeAnnounced = true;
        "<.p>The voice of your Royal Subject is heard over the facility's
        intercom:\n
        <q><<gCatNickname>>...!
        It's bath time! I can smell you from the other side of the facility!</q>\b
        Oh no. You fucking <i>hate</i> bath time...!! Time to make
        the Royal Subject <i>work for it!!</i>";
        bathTimeFuse = nil;
    }

    printApologyNoteForPG(nickname?) {
        #if __DEBUG
        if (!apologyGivenToPG) {
            apologyFuse = new Fuse(self, &apologyMethod, 0);
            apologyGivenToPG = true;
        }
        #endif
        return nickname ? cat.nickname : cat.actualName;
    }

    #if __DEBUG
    apologyMethod() {
        "<.p><i>(<b>Note for the real Piergiorgio:</b>
        Don't worry; I will change the cat's name to something else before I
        upload this anywhere! This silly joke was for testers only!)</i><.p>";
        apologyFuse = nil;
    }
    #endif

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
        /*if (gTurns == 6) {
            doSkashekAction(Open, hallwayDoor);
        }*/
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

    // Build and execute an action for Skashek
    doSkashekAction(action, dobj?, iobj?) {
        // Save what the player's command execution was for later
        playerActionActor = gActor;
        playerAction = gAction;

        // Do Skashek's action
        gActor = skashek;
        gCommand.actor = skashek;
        gAction = action.createInstance();
        gDobj = dobj;
        gIobj = iobj;

        // Verify (privately)
        local clear = true;
        if (dobj != nil) {
            gAction.verifyTab = new LookupTable;
            #if __DEBUG_SKASHEK_ACTIONS
            if (!gAction.verifyObjRole(dobj, DirectObject)) clear = nil;
            #else
            local verResult = gAction.verify(dobj, DirectObject);
            if (!verResult.allowAction) clear = nil;
            #endif
        }
        if (iobj != nil) {
            gAction.verifyTab = new LookupTable;
            #if __DEBUG_SKASHEK_ACTIONS
            if (!gAction.verifyObjRole(iobj, IndirectObject)) clear = nil;
            #else
            local verResult = gAction.verify(iobj, IndirectObject);
            if (!verResult.allowAction) clear = nil;
            #endif
        }
        
        // All clear? Proceed!
        if (clear) {
            #if __DEBUG_SKASHEK_ACTIONS
            local actionName = actionTab.symbolToVal(action);
            "<.p>SKASHEK: Performing [<<actionName>>]!<.p>";
            #endif
            if (dobj == nil) {
                gAction.doIntransitiveSkashek();
                #if __DEBUG_SKASHEK_ACTIONS
                local intVis = nil;
                #else
                local intVis = gAction.isVisibleAsSkashek();
                #endif
                if (intVis) {
                    gAction.reportIntransitiveSkashek();
                }
            }
            else {
                // Do actions
                dobj.(gAction.skashekActionDProp);
                if (iobj != nil) {
                    iobj.(gAction.skashekActionIProp);
                }
                
                // Check visibility and report
                #if __DEBUG_SKASHEK_ACTIONS
                local dVis = true;
                #else
                local dVis = gAction.isVisibleAsSkashek() ||
                    dobj.(gAction.skashekVisibilityDProp);
                #endif
                
                if (dVis) {
                    dobj.(gAction.skashekReportDProp);
                }

                if (iobj != nil) {
                    #if __DEBUG_SKASHEK_ACTIONS
                    local iVis = true;
                    #else
                    local iVis = gAction.isVisibleAsSkashek() ||
                        iobj.(gAction.skashekVisibilityIProp);
                    #endif

                    if (iVis) {
                        iobj.(gAction.skashekReportDProp);
                    }
                }
            }
        }

        // Restore the player's command execution
        gAction = playerAction;
        gCommand.actor = playerActionActor;
        gActor = playerActionActor;
        playerAction = nil;
        playerActionActor = nil;
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
#define gActionWasCostly ((turnsTaken > 0 || gHadRevokedFreeAction) \
    && !actionFailed)

modify Action {
    freeTurnAlertsRemaining = 2

    skashekActionDProp = nil
    skashekVisibilityDProp = nil
    skashekReportDProp = nil
    skashekActionIProp = nil
    skashekVisibilityIProp = nil
    skashekReportIProp = nil

    doIntransitiveSkashek() { }
    reportIntransitiveSkashek() { }

    isVisibleAsSkashek() {
        return gPlayerChar.canSee(skashek);
    }

    turnSequence() {
        // Map mode is done with everything frozen in time
        if (huntCore.inMapMode || gAction.actionFailed) {
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

#define gSkashekGPName skashek.globalParamName

#define reinventForSkashek(action) \
    modify action { \
        skashekActionDProp = &dobjForDoSkashek##action \
        skashekVisibilityDProp = &dobjForVisibilitySkashek##action \
        skashekReportDProp = &dobjForReportSkashek##action \
        skashekActionIProp = &iobjForDoSkashek##action \
        skashekVisibilityIProp = &iobjForVisibilitySkashek##action \
        skashekReportIProp = &iobjForReportSkashek##action \
    } \
    modify Thing { \
        dobjForDoSkashek##action##() { \
            local actionName = actionTab.symbolToVal(action); \
            "<.p>ERROR: MISSING DOBJ SKASHEK ACTION <<actionName>>!<.p>"; \
        } \
        dobjForVisibilitySkashek##action##() { \
            return dobjForVisibilitySkashekDefault(); \
        } \
        dobjForReportSkashek##action##() { } \
        iobjForDoSkashek##action##() { \
            local actionName = actionTab.symbolToVal(action); \
            "<.p>ERROR: MISSING IOBJ SKASHEK ACTION <<actionName>>!<.p>"; \
        } \
        iobjForVisibilitySkashek##action##() { \
            return iobjForVisibilitySkashekDefault(); \
        } \
        iobjForReportSkashek##action##() { } \
    }

reinventForSkashek(Open)

modify Thing {
    dobjForVisibilitySkashekDefault() {
        return gPlayerChar.canSee(self);
    }

    iobjForVisibilitySkashekDefault() {
        return gPlayerChar.canSee(self);
    }

    dobjForDoSkashekOpen() {
        makeOpen(true);
    }

    dobjForReportSkashekOpen() {
        "\^<<gSkashekGPName>> opens <<theName>>. ";
    }

    dobjForDoSkashekClose() {
        makeOpen(nil);
    }

    dobjForReportSkashekClose() {
        "\^<<gSkashekGPName>> closes <<theName>>. ";
    }
}

modify Door {
    dobjForVisibilitySkashekDefault() {
        local otherVis = nil;
        if (otherSide != nil) otherVis = gPlayerChar.canSee(otherSide);
        return gPlayerChar.canSee(self) || otherVis;
    }

    iobjForVisibilitySkashekDefault() {
        local otherVis = nil;
        if (otherSide != nil) otherVis = gPlayerChar.canSee(otherSide);
        return gPlayerChar.canSee(self) || otherVis;
    }

    dobjForReportSkashekOpen() {
        "\^<<gSkashekGPName>> opens <<theName>>! ";
    }
}