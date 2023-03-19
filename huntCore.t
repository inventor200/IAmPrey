enum basicTutorial, preyTutorial, easyMode, mediumMode, hardMode, nightmareMode;

#define gPlayerAction huntCore.playerAction
#define gPlayerActionActor huntCore.playerActionActor
#define gPlayerDobj huntCore.playerAction.curDobj
#define gPlayerIobj huntCore.playerAction.curIobj
#define nestedSkashekAction(action, dobj, iobj) huntCore.doSkashekAction(action, dobj, iobj)

#ifdef __DEBUG
#define __DEBUG_SKASHEK_ACTIONS true
#else
#define __DEBUG_SKASHEK_ACTIONS nil
#endif

class DifficultySetting: object {
    title = '(unnamed difficulty)'
    generalBlurb = ''
    hasSneak = nil
    isCatMode = nil
    trickCount = 3
    tricksFromPool = nil
    turnsBeforeSkashekChecks = 3
    skipPrologue = nil
    startingFreeTurnAlerts = 2
    turnsSkipsForFalling = 1

    getBlurb() {
        local strBfr = new StringBuffer(12);
        strBfr.append(generalBlurb);
        if (hasSneak) {
            strBfr.append('\n\t<b>(AUTO-SNEAKING IS AVAILABLE)</b>');
        }
        strBfr.append('\b<i>(');

        if (isCatMode) {
            strBfr.append('You play as the Predator\'s pet cat, and cannot read notes.
            However, the Predator will not chase you,
            so you can freely explore the majority of the map at your own pace');
        }
        else if (trickCount == 0) {
            strBfr.append('The Predator will never fall for <b>any tricks</b>');
        }
        else if (tricksFromPool) {
            strBfr.append('The Predator will only fall for
            <b>a total of ');
            strBfr.append(spellNumber(trickCount));
            strBfr.append(' tricks</b>, regardless of type');
        }
        else {
            strBfr.append('The Predator will only fall for <b>each type</b> of trick <b>');
            strBfr.append(spellNumber(trickCount));
            strBfr.append('</b> time');
            if (trickCount != 1) {
                strBfr.append('s');
            }
        }

        if (skipPrologue) {
            strBfr.append(', and the prologue will be skipped.');
        }
        else {
            strBfr.append('.');
        }

        strBfr.append(')</i>');
        return toString(strBfr);
    }
}

basicTutorialSetting: DifficultySetting {
    title = 'Cat Mode'
    generalBlurb =
        'You are new to interactive fiction (<q><tt>IF</tt></q>), and are not
        versed in the usual controls or mechanics of parser-based text games.\n
        <b>This tutorial will also introduce you to the game\'s parkour
        movement mechanics!</b>'
    isCatMode = true
    turnsSkipsForFalling = 0
}

preyTutorialSetting: DifficultySetting {
    title = 'Prey Tutorial'
    generalBlurb =
        'You are new to <i>I Am Prey</i>, and have not used the
        stealth or chase mechanics before.'
    hasSneak = true
}

easyModeSetting: DifficultySetting {
    title = 'Easy Mode'
    generalBlurb =
        'The Predator has had a string of victories, and will go
        easy on you, mostly for his own entertainment.'
    trickCount = 2
    turnsBeforeSkashekChecks = 3
    startingFreeTurnAlerts = 1
}

mediumModeSetting: DifficultySetting {
    title = 'Medium Mode'
    generalBlurb =
        'The Predator revels in his apparent sense of superiority over you.
        This hunt will have the typical amount of sadism.'
    trickCount = 1
    turnsBeforeSkashekChecks = 3
    startingFreeTurnAlerts = 0
}

hardModeSetting: DifficultySetting {
    title = 'Hard Mode'
    generalBlurb =
        'The Predator must be furious, and is taking all of his
        rage out on you, during this hunt.'
    trickCount = 3
    tricksFromPool = true
    turnsBeforeSkashekChecks = 2
    skipPrologue = true
    startingFreeTurnAlerts = 0
}

nightmareModeSetting: DifficultySetting {
    title = 'Nightmare Mode'
    generalBlurb =
        'What the <i>fuck?!</i> Something has really gotten into the Predator
        today! His cruelty is <i>insatiable!</i>'
    trickCount = 0
    turnsBeforeSkashekChecks = 1
    skipPrologue = true
    startingFreeTurnAlerts = 0
    turnsSkipsForFalling = 2
}

huntCore: InitObject {
    revokedFreeTurn = nil
    inCatMode = (difficulty == basicTutorial)
    wasBathTimeAnnounced = nil

    difficultySettings = static [
        basicTutorialSetting,
        preyTutorialSetting,
        easyModeSetting,
        mediumModeSetting,
        hardModeSetting,
        nightmareModeSetting
    ]

    difficulty = mediumMode
    difficultySettingObj = mediumModeSetting

    execBeforeMe = [prologueCore]
    bathTimeFuse = nil
    #if __IS_MAP_TEST
    apologyGivenToPG = nil
    apologyFuse = nil
    #endif

    playerAction = nil
    playerActionActor = nil

    setDifficult(index, midGame?) {
        sneakyCore.armSneaking = nil;
        sneakyCore.armEndSneaking = nil;
        sneakyCore.sneakDirection = nil;
        switch (index) {
            case 1:
                difficulty = basicTutorial;
                break;
            case 2:
                difficulty = preyTutorial;
                break;
            case 3:
                difficulty = easyMode;
                break;
            case 4:
                difficulty = mediumMode;
                break;
            case 5:
                difficulty = hardMode;
                break;
            case 6:
                difficulty = nightmareMode;
                break;
        }
        difficultySettingObj = difficultySettings[index];
        if (!midGame) {
            if (index == 1) {
                moveCat();
            }
            else {
                movePrey();
            }
        }
        sneakyCore.allowSneak = difficultySettingObj.hasSneak;
        sneakyCore.sneakSafetyOn = difficultySettingObj.hasSneak;
    }

    moveCat() {
        // Hacky method to set the cat character, because no command is performed
        // when the switch happens here, and it throws a nil error.
        // Also, both player chars will never see each other, so the many vocab
        // checks were unnecessary.
        gPlayerChar = cat;
        gPlayerChar.name = nil;
        gPlayerChar.initVocab();
        libGlobal.playerCharName = cat.theName;
        // End hacky method

        bathTimeFuse = new Fuse(self, &startBathTime, 9);
        #ifdef __DEBUG
        cat.moveInto(__TEST_ROOM);
        #else
        cat.moveInto(directorsOffice);
        #endif
    }

    movePrey() {
        #ifdef __DEBUG
        prey.moveInto(__TEST_ROOM);
        #else
        prey.moveInto(genericCatchNet);
        #endif
        //TODO: Later on, we can have him start in the map during cat mode,
        //      and slowly make his way down to the reservoir after checking
        //      the director's office for the cat.
        #ifdef __DEBUG
        skashek.moveInto(breakroom);
        #else
        skashek.moveInto(breakroom);
        #endif
    }

    startBathTime() {
        wasBathTimeAnnounced = true;
        "<.p>The voice of your Royal Subject is heard over the facility's
        intercom:\n
        <q><<gCatNickname>>...!
        It's Bath Time! I can smell you from the other side of the facility!</q>\b
        Oh no. You fucking <i>hate</i> Bath Time...!! Time to make
        the Royal Subject <i>regret</i> that!<<
        skashekFishing.suggestAttackInSuspicion()>> ";
        bathTimeFuse = nil;
    }

    printApologyNoteForPG(nickname?) {
        #if __IS_MAP_TEST
        if (!apologyGivenToPG) {
            apologyFuse = new Fuse(self, &apologyMethod, 0);
            apologyGivenToPG = true;
        }
        #endif
        return nickname ? cat.nickname : cat.actualName;
    }

    #if __IS_MAP_TEST
    apologyMethod() {
        "<.p><i>(<b>Note for the real Piergiorgio:</b>
        Don't worry; I will change the cat's name to something else before I
        upload this anywhere! This silly joke was for testers only!)</i><.p>";
        apologyFuse = nil;
    }
    #endif

    startingFreeTurnAlerts = 2

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
            gAction.freeTurnAlertsRemaining = gAction.freeTurnAlertsRemaining - 1;
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

    addBonusSkashekTurn(count?) {
        if (count == 0) return;
        if (count == nil) count = 1;
        skashekAIControls.bonusTurns += count;
    }

    // Shashek's actions go here
    handleSkashekAction() {
        if (skashekAIControls.isFrozen) {
            "<.p>(Skashek's AI is frozen, so he skips this turn)<.p>";
            return;
        }
        skashekAIControls.startTurn();
        for (local i = 1; i <= skashekAIControls.availableTurns; i++) {
            if (i > 1) {
                "<.p><i>(<<gSkashekName>> takes a bonus turn!)</i><.p>";
            }
            doSkashekTurn();
        }
        skashekAIControls.endTurn();

        // If Skashek did anything, then handle the sounds here
        handleSoundPropagation();
    }

    doSkashekTurn() {
        /*if (gTurns == 6) {
            doSkashekAction(Open, hallwayDoor);
        }*/
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
    freeTurnAlertsRemaining = (huntCore.difficultySettingObj.startingFreeTurnAlerts)

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
        if (mapModeDatabase.inMapMode || gAction.actionFailed) {
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

#define reinventForSkashek(targetAction) \
    modify targetAction { \
        skashekActionDProp = &dobjForDoSkashek##targetAction \
        skashekVisibilityDProp = &dobjForVisibilitySkashek##targetAction \
        skashekReportDProp = &dobjForReportSkashek##targetAction \
        skashekActionIProp = &iobjForDoSkashek##targetAction \
        skashekVisibilityIProp = &iobjForVisibilitySkashek##targetAction \
        skashekReportIProp = &iobjForReportSkashek##targetAction \
    } \
    modify Thing { \
        dobjForDoSkashek##targetAction() { } \
        dobjForVisibilitySkashek##targetAction() { \
            return dobjForVisibilitySkashekDefault(); \
        } \
        dobjForReportSkashek##targetAction() { } \
        iobjForDoSkashek##targetAction() { } \
        iobjForVisibilitySkashek##targetAction() { \
            return iobjForVisibilitySkashekDefault(); \
        } \
        iobjForReportSkashek##targetAction() { } \
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
        "\^<<gSkashekName>> opens <<theName>>. ";
    }

    dobjForDoSkashekClose() {
        makeOpen(nil);
    }

    dobjForReportSkashekClose() {
        "\^<<gSkashekName>> closes <<theName>>. ";
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
        "\^<<gSkashekName>> opens <<theName>>! ";
    }
}