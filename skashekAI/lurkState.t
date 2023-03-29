// Skashek moving and hunting for the player
skashekLurkState: SkashekAIState {
    stateName = 'Lurk State'

    checkableRooms = [
        northwestCubicle,
        northeastCubicle,
        southwestCubicle,
        southeastCubicle,
        armory,
        assemblyShop,
        breakroom,
        cloneQuarters,
        commonRoom,
        deliveryRoom,
        directorsOffice,
        enrichmentRoom,
        evaluationRoom,
        freezer,
        humanQuarters,
        storageBay,
        kitchen,
        labA,
        labB,
        library,
        lifeSupportTop,
        reservoir,
        securityOffice,
        serverRoomTop
    ]

    roomsLeftToCheck = static new Vector(checkableRooms.length)

    goalRoom = deliveryRoom
    startRandom = nil
    currentStep = 1
    stepsInStride = 2
    inspectionTurns = 0
    creepTurns = 0
    creepingWithClicking = nil
    suspendCreeping = nil

    resetRoomList() {
        #if __DEBUG_SKASHEK_ACTIONS
        "<.p>
        LURK: Resetting room list...
        <.p>";
        #endif
        if (roomsLeftToCheck.length > 0) {
            roomsLeftToCheck.removeRange(1, -1);
        }
        for (local i = 1; i <= checkableRooms.length; i++) {
            roomsLeftToCheck.append(checkableRooms[i]);
        }
    }

    disqualifyCurrentRoom() {
        if (roomsLeftToCheck.length > 0) {
            local index = roomsLeftToCheck.indexOf(skashek.getOutermostRoom());
            if (index != nil) {
                // Do not try to check the room we are currently in.
                roomsLeftToCheck.removeElementAt(index);
            }
        }
    }

    checkForRoomRefresh() {
        if (roomsLeftToCheck.length == 0) {
            resetRoomList();
            disqualifyCurrentRoom();
        }
    }

    chooseNewRoom() {
        disqualifyCurrentRoom();
        checkForRoomRefresh();
        local nextIndex = getRandomResult(roomsLeftToCheck.length);
        goalRoom = roomsLeftToCheck[nextIndex];
        roomsLeftToCheck.removeElementAt(nextIndex);
        checkForRoomRefresh();
        #if __DEBUG_SKASHEK_ACTIONS
        "<.p>
        LURK: Chose new room: <<goalRoom.roomTitle>>
        <.p>";
        #endif
    }

    start(nextState) {
        #ifdef __DEBUG
        setupForTesting();
        #endif
        inspectionTurns = 0;
        currentStep = 1;
        if (startRandom) {
            resetRoomList();
            chooseNewRoom();
        }
        else {
            #if __DEBUG_SKASHEK_ACTIONS
            "<.p>
            LURK: Chose new room: <<goalRoom.roomTitle>>
            <.p>";
            #endif
        }
    }

    end(nextState) {
        startRandom = true;
    }

    #ifdef __DEBUG
    setupForTesting() {
        inherited();
        startRandom = nil;
    }
    #endif

    nextStopInRoute() {
        return goalRoom;
    }
    
    doPerception(impact) {
        //TODO: Handle Skashek sound perception
    }

    playerWillGetCaughtPeeking() {
        return creepTurns > 0;
    }

    doPlayerPeek() {
        //TODO: Player peeks in while he is in the room
    }

    doPlayerCaughtLooking() {
        if (creepTurns <= 0) return;
        "<q>Why, hello there, Prey...!</q> he cackles.
        <q>If you ever needed a reason to run, then I'm
        <i>coming in!</i></q> ";
    }

    describePeekedAction() {
        if (creepTurns > 0) {
            "<<getPeekHeIs(true)>> right there,
            and he knows {i}{'m} in here...! ";
        }
        if (inspectionTurns > 0) {
            describeNonTravelAction();
        }
        else {
            local approachArray = skashek.getApproach();
            describeApproach(approachArray);
        }
    }

    showPeekAfterTurn(canSeePlayer) {
        return showsDuringPeek() || inspectionTurns > 0;
    }

    addSpeedBoost(turns) {
        currentStep = stepsInStride + (turns - 1);
    }

    startCreeping() {
        if (suspendCreeping) return nil;
        local approachArray = skashek.getApproach();
        local nextRoom = approachArray[1];
        local connector = approachArray[2].connector;
        if (!skashek.peekInto(nextRoom)) return nil;
        if (!connector.ofKind(Door)) return nil;
        if (connector.lockability == lockableWithKey) return nil;
        #if __DEBUG_SKASHEK_ACTIONS
        "<.p>
        LURK: Starting creep...
        <.p>";
        #endif

        local decisionSelector = getRandomResult(6);
        if (decisionSelector <= 3) {
            suspendCreeping = true;
            return nil;
        }

        skashek.trapConnector(connector);

        creepingWithClicking = decisionSelector == 6;
        if (creepingWithClicking) {
            creepTurns = getRandomResult(6, 10);
        }
        else {
            creepTurns = 3;
            skashek.prepareSpeech();
            soundBleedCore.createSound(
                iKnowYoureInThereProfile,
                skashek,
                skashek.getOutermostRoom(),
                nil
            );
        }
        return true;
    }

    doSingleStep() {
        local oldRoom = skashek.getOutermostRoom();
        skashek.travelThroughComplex();
        local newRoom = skashek.getOutermostRoom();
        if (oldRoom != newRoom) {
            #if __DEBUG_SKASHEK_ACTIONS
            "<.p>
            LURK: Move into: <<newRoom.roomTitle>>";
            #endif
            if (currentStep == stepsInStride) {
                // Reset after move
                currentStep = 1;
            }
            else {
                // Drain boost
                currentStep--;
            }
            if (newRoom == goalRoom) {
                suspendCreeping = nil;
                if (goalRoom == deliveryRoom &&
                    !skashek.hasSeenPreyOutsideOfDeliveryRoom
                ) {
                    #if __DEBUG_SKASHEK_ACTIONS
                    "\nDelivery Room reached!
                    \nDoing first-time inspection.";
                    #endif
                    skashek.checkDeliveryRoom();
                    inspectionTurns = 1;
                    #if __DEBUG_SKASHEK_ACTIONS
                    "<.p>";
                    #endif
                }
                else {
                    inspectionTurns = getRandomResult(3, 5);
                    #if __DEBUG_SKASHEK_ACTIONS
                    "\nGoal reached!
                    \nHanging out for <<inspectionTurns>> turns.
                    <.p>";
                    #endif
                }
            }
            #if __DEBUG_SKASHEK_ACTIONS
            "<.p>";
            #endif
        }
    }

    doSteps() {
        if (startCreeping()) return;
        if (huntCore.difficulty == nightmareMode) {
            // In nightmare mode, Skashek sprints all the time!
            doSingleStep();
            return;
        }
        // Steps oscillate between 1 and 2, where 2
        // is where movement actually takes place.
        // More bonus steps can be added for a speed boost.
        if (currentStep >= stepsInStride) {
            doSingleStep();
        }
        else {
            currentStep++;
        }
    }

    // If the player notices clicking, then creeping
    // becomes silent, and the player gets 3 turns to GTFO
    noticeOminousClicking() {
        if (suspendCreeping) return;
        creepingWithClicking = nil;
        creepTurns = 3;
    }

    doTurn() {
        if (creepTurns > 0) {
            if (creepingWithClicking) {
                soundBleedCore.createSound(
                    ominousClickingProfile,
                    skashek,
                    skashek.getOutermostRoom(),
                    nil
                );
            }
            creepTurns--;
            if (creepTurns <= 0) {
                suspendCreeping = true;
            }
            #if __DEBUG_SKASHEK_ACTIONS
            else {
                "<.p>
                LURK: Skashek is creeping!
                GTFO in <b><<creepTurns>> turns</b>, or less!
                <.p>";
            }
            #endif
        }
        else if (inspectionTurns > 0) {
            inspectionTurns--;
            if (inspectionTurns <= 0) {
                chooseNewRoom();
                currentStep = stepsInStride;
            }
        }
        else {
            doSteps();
        }
    }

    leewayExpired = nil

    onSightAfter(begins) {
        if (skashek.playerLeewayTurns > 0) {
            if (begins && skashek.playerLeewayTurns <
                huntCore.difficultySettingObj.turnsBeforeSkashekDeploys
            ) {
                "<.p><q>Prey, I'm giving you quite the
                opportunity here! I suggest you run <i>far
                away</i> from me!</q> <<getPeekHe()>> says, smiling. ";
            }
            skashek.playerLeewayTurns--;
            if (skashek.playerLeewayTurns == 0) {
                leewayExpired = true;
            }
            return;
        }
        if (leewayExpired) {
            leewayExpired = nil;
            "<.p><q>My mercy has expired, Prey!</q> <<getPeekHe()>> shouts.
            <q>Run for your fucking <i>life!!</i></q><.p>";
        }
        else {
            if (!begins) return;
            if (!skashek.didAnnouncementDuringTurn) {
                "<.p><q>Aha!</q> <<getPeekHe()>> shouts.
                <q><i>There</i> you are!</q><.p>";
            }
        }
        skashekChaseState.activate();
    }

    describeNonTravelAction() {
        "<<getPeekHeIs(true)>> looking around
        <<skashek.getOutermostRoom.roomTitle>>{dummy} for {me}! ";
    }
}