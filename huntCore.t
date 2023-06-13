enum basicTutorial, preyTutorial, easyMode, mediumMode, hardMode, nightmareMode;

#define gPlayerAction huntCore.playerAction
#define gPlayerActionActor huntCore.playerActionActor
#define gPlayerDobj huntCore.playerAction.curDobj
#define gPlayerIobj huntCore.playerAction.curIobj
#define nestedSkashekAction(action, dobj, iobj) huntCore.doSkashekAction(action, dobj, iobj)

#ifdef __DEBUG
#define __DEBUG_SKASHEK_ACTIONS nil
#define __DEBUG_SUIT nil
#define __DEBUG_SUIT_PLACEMENT nil
#else
#define __DEBUG_SKASHEK_ACTIONS nil
#define __DEBUG_SUIT nil
#define __DEBUG_SUIT_PLACEMENT nil
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
    startingSkashekState = skashekIntroState
    turnsBeforeSkashekDeploys = 10
    lockoutUndo = nil
    offerUndoOption = nil
    showOtherQualities = true

    getBlurb() {
        local strBfr = new StringBuffer(12);
        strBfr.append(generalBlurb);

        if (showOtherQualities) {
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

            if (lockoutUndo) {
                strBfr.append(', ');
                if (!skipPrologue) strBfr.append('and ');
                strBfr.append('<<formatTheCommand('undo')>> <b>will be locked</b> from use');
            }
            if (skipPrologue) {
                strBfr.append(', and the prologue will be skipped');
            }
            strBfr.append('.');
            strBfr.append(')</i>');
        }

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
    startingSkashekState = skashekCatModeState
}

preyTutorialSetting: DifficultySetting {
    title = 'Prey Tutorial'
    generalBlurb =
        'You are new to <i>I Am Prey</i>, and have not used the
        stealth or chase mechanics before.'
    hasSneak = true
    turnsBeforeSkashekDeploys = 16
    offerUndoOption = true
}

easyModeSetting: DifficultySetting {
    title = 'Easy Mode'
    generalBlurb =
        'The Predator has had a string of victories, and will go
        easy on you, mostly for his own entertainment.'
    trickCount = 2
    turnsBeforeSkashekChecks = 3
    startingFreeTurnAlerts = 1
    turnsBeforeSkashekDeploys = 12
    offerUndoOption = true
}

mediumModeSetting: DifficultySetting {
    title = 'Medium Mode'
    generalBlurb =
        'The Predator revels in his apparent sense of superiority over you.
        This hunt will have the typical amount of sadism.'
    trickCount = 1
    turnsBeforeSkashekChecks = 3
    startingFreeTurnAlerts = 0
    turnsBeforeSkashekDeploys = 8
    offerUndoOption = true
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
    turnsBeforeSkashekDeploys = 4
    offerUndoOption = true
}

nightmareModeSetting: DifficultySetting {
    title = 'Nightmare Mode'
    generalBlurb =
        'What the <i>heck?!</i> Something has really gotten into the Predator
        today! His cruelty is <i>insatiable!</i>'
    trickCount = 0
    turnsBeforeSkashekChecks = 1
    skipPrologue = true
    startingFreeTurnAlerts = 0
    turnsSkipsForFalling = 2
    turnsBeforeSkashekDeploys = 0
    lockoutUndo = true
    offerUndoOption = nil
}

restoreModeSetting: DifficultySetting {
    title = 'Restore Game'
    generalBlurb =
        'Skips everything, so you can quickly load a saved game file,
        or read the in-game survival guide.'
    startingSkashekState = skashekCatModeState
    skipPrologue = true
    offerUndoOption = nil
    showOtherQualities = nil
}

enum plentyOfTricksRemaining, oneTrickRemaining, noTricksRemaining;
enum undoFree, undoAsTrick, undoLocked, isUndoProp;

transient undoCounter: object {
    count = nil

    useCounter() {
        return huntCore.undoStyle == undoAsTrick;
    }

    updateTrickCount(nextAmount) {
        if (!useCounter()) return;
        local currentAmount = count;
        if (currentAmount == nil) {
            count = nextAmount;
        }
        else if (currentAmount < nextAmount) {
            count = currentAmount;
        }
        else {
            count = nextAmount;
        }
    }

    getActualTrickCount() {
        if (!useCounter()) return 10;
        if (huntCore.difficultySettingObj.tricksFromPool) {
            return huntCore.tricksInPool;
        }
        return count;
    }

    pollTrickNumber() {
        if (!useCounter()) return 10;
        local _count = getActualTrickCount();
        if (_count <= 0) return 0;
        return _count;
    }

    pollTrick() {
        if (!useCounter()) return plentyOfTricksRemaining;
        local _count = getActualTrickCount();
        if (_count <= 0) return noTricksRemaining;
        else if (_count == 1) return oneTrickRemaining;
        return plentyOfTricksRemaining;
    }

    spendTrick() {
        if (!useCounter()) return plentyOfTricksRemaining;
        if (huntCore.difficultySettingObj.tricksFromPool) {
            huntCore.difficultySettingObj.tricksFromPool--;
            count = huntCore.difficultySettingObj.tricksFromPool;
        }
        else {
            count--;
        }
        if (count <= 0) {
            if (huntCore.difficultySettingObj.tricksFromPool) {
                huntCore.difficultySettingObj.tricksFromPool = 0;
            }
            count = 0;
            return noTricksRemaining;
        }
        if (count == 1) return oneTrickRemaining;
        return plentyOfTricksRemaining;
    }
}

modify Undo {
    execAction(cmd) {
        if (huntCore.difficultySettingObj == nightmareModeSetting) {
            "You cannot undo your last action in Nightmare Mode.\b\b
            <b>Best of luck to you.</b>\b\b";
            return nil;
        }

        local suggestion =
            'The most you can do from here is improvise or use
            <<formatTheCommand('restart', shortCmd)>>.';
        if (huntCore.undoStyle == undoLocked) {
            "You have voluntarily locked UNDO from use.
            <<suggestion>> ";
            return nil;
        }
        else if (huntCore.undoStyle == undoAsTrick) {
            local count = undoCounter.pollTrickNumber();

            if (count == 0) {
                "You have no remaining opportunities to undo your last action.
                <<suggestion>> ";
                return nil;
            }

            if (huntCore.difficultySettingObj.tricksFromPool) {
                "A total of <b><<count>> tricks</b> remain in the pool,
                and this will use <b>1</b> of them. ";
            }
            else {
                local times = count == 1 ? 'time' : 'times';
                "\^<<formatTheCommand('undo')>> 
                can be used <b><<count>> more <<times>></b>,
                <b><i>not</i></b> including <b><i>this</i></b> time. ";
            }
            if (count == 1) {
                "If <<formatTheCommand('UNDO')>> is used now,
                <b>it will be locked for the rest of the run.</b> ";
            }
            if (ChoiceGiver.staticAsk(
                'Are you sure you want to spend a trick to UNDO?'
            )) {
                local res = inherited(cmd);
                count--;
                undoCounter.spendTrick();
                local uses = count == 1 ? 'use' : 'uses';
                local remain = count == 1 ? 'remains' : 'remain';
                "<.p><b><<count>> <<uses>> now <<remain>>.</b> ";
                return res;
            }

            "Undo canceled. <<count>> still remain.";
        }
        return inherited(cmd);
    }   
}

huntCore: InitObject {
    revokedFreeTurn = nil
    hadNegativeOutcome = nil
    playerWasSeenEntering = nil
    playerWasSeenHiding = nil
    doorThatMovedOnItsOwn = nil
    inCatMode = (difficulty == basicTutorial)
    wasBathTimeAnnounced = nil
    undoStyle = undoFree

    helmetLocations = [
        evaluationRoom,
        breakroomTable,
        labBTable
    ]

    gearLocations = [
        northeastCubicleFilingCabinet.topDrawer,
        northeastCubicleFilingCabinet.middleDrawer,
        northeastCubicleFilingCabinet.bottomDrawer,
        northwestCubicleFilingCabinet.topDrawer,
        northwestCubicleFilingCabinet.middleDrawer,
        northwestCubicleFilingCabinet.bottomDrawer,
        southeastCubicleFilingCabinet.topDrawer,
        southeastCubicleFilingCabinet.middleDrawer,
        southeastCubicleFilingCabinet.bottomDrawer,
        southwestCubicleFilingCabinet.topDrawer,
        southwestCubicleFilingCabinet.middleDrawer,
        southwestCubicleFilingCabinet.bottomDrawer,
        armoryShelves,
        armoryCabinet.topDrawer,
        armoryCabinet.middleDrawer,
        armoryCabinet.bottomDrawer,
        //breakRoomFridge.remapIn,
        snackFridge.remapIn,
        classroomShelves,
        directorCabinet.topDrawer,
        directorCabinet.middleDrawer,
        directorCabinet.bottomDrawer,
        cloneStorageChest.remapIn,
        //evaluationShelves,
        walkInFridge,
        labAShelves,
        libraryCabinet.topDrawer,
        libraryCabinet.middleDrawer,
        libraryCabinet.bottomDrawer,
        securityCabinet.topDrawer,
        securityCabinet.middleDrawer,
        securityCabinet.bottomDrawer,
        securityCloset.remapIn
    ]

    //Tricks
    tricksInPool = nil
    closeDoorCount = nil
    diveOffReservoirCount = nil
    distractingSinkCount = nil
    limitedUndoCount = isUndoProp

    difficultySettings = static new Vector([
        basicTutorialSetting,
        preyTutorialSetting,
        easyModeSetting,
        mediumModeSetting,
        hardModeSetting,
        nightmareModeSetting,
        restoreModeSetting
    ])

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

    setDifficulty(index, midGame?) {
        sneakyCore.armSneaking = nil;
        sneakyCore.armEndSneaking = nil;
        sneakyCore.sneakDirection = nil;
        switch (index) {
            case 7:
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
            if (difficulty == basicTutorial) {
                moveCat();
            }
            else {
                movePrey();
            }
        }
        sneakyCore.allowSneak = difficultySettingObj.hasSneak;
        sneakyCore.sneakSafetyOn = difficultySettingObj.hasSneak;
        if (!midGame) {
            skashek.initSeed();
            #if __DEBUG_SUIT
            enviroSuitBag.moveInto(hangar);
            #else
            if (!gCatMode) scatterPieces();
            #endif
            freeTurnAlertsRemaining =
                difficultySettingObj.startingFreeTurnAlerts;
            skashekAIControls.currentState = getStartingAIState();
            skashekAIControls.currentState.needsGameStartSetup = true;
            skashekAIControls.currentState.activate();
        }

        if (difficultySettingObj.lockoutUndo) undoStyle = undoLocked;

        updateTrickCount(&tricksInPool, difficultySettingObj.trickCount);

        if (!difficultySettingObj.tricksFromPool) {
            updateTrickCount(&closeDoorCount, tricksInPool);
            updateTrickCount(&diveOffReservoirCount, tricksInPool);
            updateTrickCount(&distractingSinkCount, tricksInPool);
            if (undoStyle == undoAsTrick) {
                updateTrickCount(&limitedUndoCount, tricksInPool);
            }
            else {
                limitedUndoCount = nil;
            }
        }
    }
    
    canUndo() {
        switch (undoStyle) {
            case undoLocked:
                return nil;
            case undoAsTrick:
                return pollTrick(&limitedUndoCount) != noTricksRemaining;
            default:
                return true;
        }
    }

    getUndoStyleName() {
        switch (undoStyle) {
            case undoLocked:
                return 'Locked';
            case undoAsTrick:
                return 'Trick';
            default:
                return 'Free';
        }
    }

    isPropForUndo(trickCountProp) {
        return self.(trickCountProp) == isUndoProp;
    }

    updateTrickCount(currentAmountProp, nextAmount) {
        if (isPropForUndo(currentAmountProp)) {
            undoCounter.updateTrickCount(nextAmount);
            return;
        }

        local currentAmount = self.(currentAmountProp);
        if (currentAmount == nil) {
            self.(currentAmountProp) = nextAmount;
        }
        else if (currentAmount < nextAmount) {
            self.(currentAmountProp) = currentAmount;
        }
        else {
            self.(currentAmountProp) = nextAmount;
        }
    }

    getActualTrickProp(trickCountProp) {
        if (difficultySettingObj.tricksFromPool) {
            return &tricksInPool;
        }
        return trickCountProp;
    }

    pollTrickNumber(trickCountProp) {
        if (isPropForUndo(trickCountProp)) {
            return undoCounter.pollTrickNumber();
        }

        local actualTrickProp = getActualTrickProp(trickCountProp);
        local count = self.(actualTrickProp);
        if (count <= 0) return 0;
        return count;
    }

    pollTrick(trickCountProp) {
        if (isPropForUndo(trickCountProp)) {
            return undoCounter.pollTrick();
        }

        local actualTrickProp = getActualTrickProp(trickCountProp);
        if (self.(actualTrickProp) <= 0) return noTricksRemaining;
        else if (self.(actualTrickProp) == 1) return oneTrickRemaining;
        return plentyOfTricksRemaining;
    }

    spendTrick(trickCountProp) {
        local actualTrickProp = getActualTrickProp(trickCountProp);

        if (isPropForUndo(trickCountProp)) {
            return undoCounter.spendTrick();
        }

        self.(actualTrickProp)--;
        if (self.(actualTrickProp) <= 0) {
            self.(actualTrickProp) = 0;
            return noTricksRemaining;
        }
        if (self.(actualTrickProp) == 1) return oneTrickRemaining;
        return plentyOfTricksRemaining;
    }

    scatterPieces() {
        // Move bag
        enviroSuitBag.moveInto(deliveryRoomStool);

        // Scatter others
        local smallPlaces = new Vector(gearLocations.length);
        local largePlaces = new Vector(gearLocations.length);
        for (local i = 1; i <= gearLocations.length; i++) {
            local container = gearLocations[i];
            if (container.maxSingleBulk <= 1) {
                smallPlaces.append(container);
            }
            else if (container.maxSingleBulk > 1) {
                largePlaces.append(container);
            }
        }

        #if __DEBUG_SUIT_PLACEMENT
        "<.p>DISTRIBUTION:";
        #endif

        // Move helmet
        local realInEvalRoom = skashek.getRandomResult(8) == 1;
        local decider = skashek.getRandomResult(16) <= 8;
        local mainRoom = nil;
        local otherRooms = nil;
        if (realInEvalRoom) {
            mainRoom = helmetLocations[1];
            otherRooms = [
                helmetLocations[2],
                helmetLocations[3]
            ];
        }
        else if (decider) {
            mainRoom = helmetLocations[2];
            otherRooms = [
                helmetLocations[1],
                helmetLocations[3]
            ];
        }
        else {
            mainRoom = helmetLocations[3];
            otherRooms = [
                helmetLocations[1],
                helmetLocations[2]
            ];
        }

        local index = skashek.getRandomResult(helmetLocations.length);
        enviroHelmet.moveInto(mainRoom);
        decider = skashek.getRandomResult(16) <= 8;
        local deciderIndex = decider ? 1 : 2;
        local fakeRoom = otherRooms[deciderIndex];
        fakeHelmet.moveInto(fakeRoom);
        #if __DEBUG_SUIT_PLACEMENT
        "\nreal helmet goes into\n
        \t<<mainRoom.theName>>!\n
        \t(in <<mainRoom.getOutermostRoom().roomTitle>>)
        \nfake helmet goes into\n
        \t<<fakeRoom.theName>>!\n
        \t(in <<fakeRoom.getOutermostRoom().roomTitle>>)";
        #endif

        for (local i = 2; i <= suitTracker.missingPieces.length; i++) {
            local piece = suitTracker.missingPieces[i];
            local scatterVec = smallPlaces;
            if (piece.bulk > 1) scatterVec = largePlaces;
            index = skashek.getRandomResult(scatterVec.length);
            piece.moveInto(scatterVec[index]);
            #if __DEBUG_SUIT_PLACEMENT
            "\n<<piece.theName>> goes into\n
            \t<<scatterVec[index].theName>>!\n
            \t(in <<scatterVec[index].getOutermostRoom().theName>>)";
            #endif
            scatterVec.removeElementAt(index);
        }
    }

    freeTurnAlertsRemaining = 2

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

        if (huntCore.difficultySettingObj != restoreModeSetting) {
            bathTimeFuse = new Fuse(self, &startBathTime, 9);
            #ifdef __DEBUG
            local playerStartRoom = __TEST_ROOM;
            if (playerStartRoom == nil) {
                playerStartRoom = catBed;
            }
            cat.moveInto(playerStartRoom);
            #else
            cat.moveInto(catBed);
            #endif
        }
        recoverAmbience();
    }

    movePrey() {
        #ifdef __DEBUG
        local playerStartRoom = __TEST_ROOM;
        if (playerStartRoom == nil) {
            playerStartRoom = genericCatchNet;
        }
        prey.moveInto(playerStartRoom);
        #else
        prey.moveInto(genericCatchNet);
        #endif

        #if __BANISH_SKASHEK
        //
        #else
        #ifdef __DEBUG
        local startRoom = __SKASHEK_START;
        if (startRoom == nil) startRoom = breakroom;
        skashek.moveInto(startRoom);
        #else
        skashek.moveInto(breakroom);
        #endif
        #endif
        recoverAmbience();
    }

    getStartingAIState() {
        #if __BANISH_SKASHEK
        return skashekCatModeState;
        #else
        #ifdef __DEBUG
        local testState = __SKASHEK_STATE;
        if (testState != nil) {
            return testState;
        }
        return difficultySettingObj.startingSkashekState;
        #else
        return difficultySettingObj.startingSkashekState;
        #endif
        #endif
    }

    startBathTime() {
        wasBathTimeAnnounced = true;
        "<.p>The voice of {my} Royal Subject is heard over the facility's
        intercom:\n
        <q><<gCatNickname>>...!
        It's Bath Time! I can smell you from the other side of the facility!</q>\b
        Oh no. {I} absolutely <i>despise</i> Bath Time...!! Time to make
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

    // Generically handle free action
    handleFreeTurn() {
        if (freeTurnAlertsRemaining > 0) {
            if (freeTurnAlertsRemaining > 1) {
                "<.p><i>(You used this turn for FREE!)</i><.p>";
            }
            else {
                "<.p><i>(From now-on, you will only be alerted if
                this action </i>wasn't<i> a FREE turn!)</i><.p>";
            }
            freeTurnAlertsRemaining--;
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
        skashek.doTurn();
        playerWasSeenEntering = nil;
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

#define gHadRevokedFreeAction (turnsTaken == 0 && huntCore.revokedFreeTurn)
#define gActionWasCostly ((turnsTaken > 0 || gHadRevokedFreeAction) \
    && !actionFailed)

modify Action {
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
            sfxPlayer.runSequence(actionFailed || huntCore.hadNegativeOutcome);
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

        sfxPlayer.runSequence(actionFailed || huntCore.hadNegativeOutcome);

        if (gHadRevokedFreeAction) libGlobal.totalTurns++;

        huntCore.revokedFreeTurn = nil;
        huntCore.hadNegativeOutcome = nil;
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
reinventForSkashek(Close)
reinventForSkashek(Unlock)
reinventForSkashek(Lock)

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
        "<<skashek.getPeekHe(true)>> opens <<theName>>. ";
    }

    dobjForDoSkashekClose() {
        makeOpen(nil);
    }

    dobjForReportSkashekClose() {
        "<<skashek.getPeekHe(true)>> closes <<theName>>. ";
    }

    dobjForDoSkashekUnlock() {
        makeLocked(nil);
    }

    dobjForReportSkashekUnlock() {
        "<<skashek.getPeekHe(true)>> unlocks <<theName>>. ";
    }

    dobjForDoSkashekLock() {
        makeLocked(true);
    }

    dobjForReportSkashekLock() {
        "<<skashek.getPeekHe(true)>> locks <<theName>>. ";
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

    getTheVisibleName() {
        if (otherSide != nil) {
            if (gPlayerChar.canSee(otherSide)) return otherSide.theName;
        }
        if (gPlayerChar.canSee(self)) return theName;

        if (otherSide != nil) {
            if (otherSide.getOutermostRoom() == gPlayerChar.getOutermostRoom()) {
                return otherSide.theName;
            }
        }

        return theName;
    }

    dobjForReportSkashekOpen() {
        "<.p><<skashek.getPeekHe(true)>> opens <<getTheVisibleName()>>! ";
    }

    dobjForDoSkashekClose() {
        inherited();
        if (canPlayerSense()) {
            local obj = getSoundSource();
            gMessageParams(obj);
            reportSenseAction(
                doorShutSnd,
                doorShutCloseSnd,
                '<.p><<normalClosingMsg>>',
                doorShutMuffledSnd
            );
        }
        else {
            emitSoundFromBothSides(doorSlamCloseNoiseProfile, nil);
        }
    }

    dobjForReportSkashekClose() {
        addSFX(doorShutSnd);
        "<.p><<skashek.getPeekHe(true)>> closes <<getTheVisibleName()>> behind himself. ";
    }

    dobjForReportSkashekUnlock() {
        addSFX(RFIDUnlockSnd);
        "<.p>There is an electronic buzzing sound,
        as <<skashek.getPeekHe()>> unlocks <<getTheVisibleName()>>! ";
    }

    dobjForDoSkashekUnlock() {
        if (canPlayerSense()) {
            reportSenseAction(
                RFIDUnlockSnd,
                RFIDUnlockCloseSnd,
                '<.p>I can hear <<getTheVisibleName()>> being unlocked... ',
                RFIDUnlockMuffledSnd
            );
        }
        else {
            soundBleedCore.createSound(
                doorUnlockBuzzProfile,
                getSoundSource(),
                getOutermostRoom(),
                nil
            );
            soundBleedCore.createSound(
                doorUnlockBuzzProfile,
                getSoundSource(),
                otherSide.getOutermostRoom(),
                nil
            );
        }
        makeLocked(nil);
    }
}

modify Room {
    travelerEntering(traveler, origin) {
        inherited(traveler, origin);
        if (gPlayerChar.isOrIsIn(traveler)) {
            new Fuse(self, &checkAfterAttemptedTravel, 0);
        }
    }

    checkAfterAttemptedTravel() {
        if (gPlayerChar.getOutermostRoom() == self) {
            if (skashek.canSee(gPlayerChar)) {
                huntCore.playerWasSeenEntering = true;
            }
        }
    }
}

#include "skashekAI/skashekAI.t"