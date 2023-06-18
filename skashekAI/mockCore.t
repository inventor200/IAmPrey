modify skashek {
    preparedAnnouncements = static new Vector(4);
    didAnnouncementDuringTurn = nil
    turnsBeforeNextMocking = 0
    getMockingInterval() { return getRandomResult(2, 18); }

    prepareSpeech() {
        // Don't go on a monologue if we have something else to say!
        didAnnouncementDuringTurn = true;
    }

    reciteAnnouncement(intercomMsg) {
        preparedAnnouncements.appendUnique(intercomMsg);
    }

    hasAnnouncement() {
        if (didAnnouncementDuringTurn) return nil;
        return preparedAnnouncements.length > 0;
    }

    getAnnouncement() {
        if (!hasAnnouncement()) return nil;
        local announcement = preparedAnnouncements[1];
        preparedAnnouncements.removeElementAt(1);
        didAnnouncementDuringTurn = true;
        return announcement;
    }

    performNextAnnouncement(isVisible?, isInterrupted?) {
        local nextAnnouncement = getAnnouncement();
        if (nextAnnouncement == nil) return;
        local player = getPracticalPlayer();
        local om = getOutermostRoom();
        "<.p>";
        if (isInterrupted) {
            nextAnnouncement.interruptedMsg();
        }
        else if (canSee(player)) {
            nextAnnouncement.inPersonFullMsg();
        }
        else if (player.canSee(self)) {
            nextAnnouncement.inPersonStealthyMsg();
            // Actions are usually described in these
            suppressIdleDescription();
        }
        else if (player.getOutermostRoom() == om) {
            nextAnnouncement.inPersonAudioMsg();
            // Actions are usually described in these
            suppressIdleDescription();
        }
        else {
            nextAnnouncement.overCommsMsg();
            // Give the player a hint of where he is when he talks
            soundBleedCore.createSound(
                skashekTalkingProfile,
                self,
                om,
                nil
            );
        }
        "<.p>";
    }

    // Player let a door fall closed
    mockPreyForDoorClosing(door, room) {
        if (!checkMockingOpportunity()) return;

        mockForDoorCloseMessage.cachedLastDoor = door;
        mockForDoorCloseMessage.cachedLastRoom = room;
        reciteAnnouncement(mockForDoorCloseMessage);

        concludeMockingOpportunity();
    }

    // Player closed one of Skashek's doors
    mockPreyForDoorAlteration(door) {
        if (!checkMockingOpportunity()) return;

        mockForDoorAlterationMessage.cachedLastDoor = door;
        reciteAnnouncement(mockForDoorAlterationMessage);

        concludeMockingOpportunity();
    }

    // Player left a door looking suspicious
    mockPreyForDoorSuspicion(door) {
        if (!checkMockingOpportunity()) return;

        mockForDoorSuspicionMessage.cachedLastDoor = door;
        reciteAnnouncement(mockForDoorSuspicionMessage);

        concludeMockingOpportunity();
    }

    // Player moving a door in view of Skashek
    mockPreyForDoorMovement(door) {
        if (!checkMockingOpportunity()) return;

        mockForDoorMovementMessage.cachedLastDoor = door;
        reciteAnnouncement(mockForDoorMovementMessage);

        concludeMockingOpportunity();
    }

    // Player turning on the water
    mockPreyForRunningWaterMovement() {
        if (!checkMockingOpportunity()) return;

        reciteAnnouncement(mockForRunningWaterMessage);

        concludeMockingOpportunity();
    }

    // Player was heard climbing around
    mockPreyForAudibleClimbing() {
        if (!checkMockingOpportunity()) return;

        reciteAnnouncement(mockForAudibleClimbingMessage);

        concludeMockingOpportunity();
    }

    // Player was heard falling hard
    mockPreyForAudibleFalling() {
        if (!checkMockingOpportunity()) return;

        reciteAnnouncement(mockForAudibleFallingMessage);

        concludeMockingOpportunity();
    }

    // Player was heard flushing toilet
    mockPreyForFlushing() {
        if (!checkMockingOpportunity()) return;

        reciteAnnouncement(mockForFlushingMessage);

        concludeMockingOpportunity();
    }

    checkMockingOpportunity() {
        // Don't mock too often
        if (turnsBeforeNextMocking > 0) return nil;
        if (!skashekAIControls.currentState.canMockPlayer()) return nil;
        // Don't be obnoxious lmao
        if (canSee(getPracticalPlayer())) return nil;
        return true;
    }

    concludeMockingOpportunity() {
        turnsBeforeNextMocking = getMockingInterval();
    }

    canMockPlayer() {
        return skashekAIControls.currentState.canMockPlayer();
    }
}