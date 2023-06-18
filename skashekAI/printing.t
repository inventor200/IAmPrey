modify skashek {
    peekedNameAlready = nil
    _suppressIdleDescription = 0

    getPeekHe(caps?) {
        if (peekedNameAlready) {
            return caps == nil ? 'he' : 'He';
        }
        peekedNameAlready = true;
        return gSkashekName;
    }

    getPeekHim(caps?) {
        if (peekedNameAlready) {
            return caps == nil ? 'him' : 'Him';
        }
        peekedNameAlready = true;
        return gSkashekName;
    }

    getPeekHis(caps?) {
        if (peekedNameAlready) {
            return caps == nil ? 'his' : 'His';
        }
        peekedNameAlready = true;
        return gSkashekName + '\'s';
    }

    getPeekHeIs(caps?) {
        if (peekedNameAlready) {
            return caps == nil ? 'he\'s' : 'He\'s';
        }
        peekedNameAlready = true;
        return gSkashekName + '\'s';
    }

    handleDescOnTurn(playerVisibleNow) {
        if (skashekAIControls.currentState.showPeekAfterTurn(playerVisibleNow)) {
            local player = getPracticalPlayer();
            
            if (_suppressIdleDescription > 0) {
                _suppressIdleDescription--;
            }
            else if (player.canSee(self)) {
                "<.p>";
                forcePeekDesc();
            }
            else if (player.canHear(self)) {
                "<.p>";
                describeRustlingAction();
            }
        }
    }

    suppressIdleDescription(turns?) {
        if (turns == nil) turns = 1;
        _suppressIdleDescription = turns;
    }

    forcePeekDesc(approachArray?) {
        if (approachArray == nil) approachArray = getApproach();
        // Force peeking mode
        local setPeekMode = nil;
        if (peekPOV == nil) {
            setPeekMode = true;
            peekPOV = getPracticalPlayer();
        }
        // Look
        describeTravel(approachArray);
        // Unset peeking mode
        if (setPeekMode) peekPOV = nil;
    }

    describeRustlingAction() {
        skashekAIControls.currentState.describeRustlingAction();
    }

    describeTravel(approachArray) {
        // Get pov
        local fromPeeking = true;
        local pov = peekPOV;
        local player = getPracticalPlayer();
        if (pov == nil) {
            pov = player;
            fromPeeking = nil;
        }

        // Unpack array input
        //local nextStop = approachArray[1];
        local approachDirection = approachArray[2];
        local approachType = approachArray[3];

        if (approachType == notApproaching) {
            if (fromPeeking) {
                skashekAIControls.currentState.describeNonTravelAction();
            }
            return;
        }

        local door = approachDirection.connector;
        if (!door.ofKind(Door)) door = nil;
        local lastRoom = getOutermostRoom();
        local canSeeLastRoom = pov.canSee(lastRoom);
        local canPlayerSeeLastRoom = player.canSee(lastRoom);
        local nextRoom = approachDirection.destination.actualRoom;
        local canSeeNextRoom = pov.canSee(nextRoom);
        local canPlayerSeeNextRoom = player.canSee(nextRoom);
        local announceTravel =
            canSeeLastRoom || canSeeNextRoom || canPlayerSeeLastRoom || canPlayerSeeNextRoom;
        if (!announceTravel) return;
        local isLeaving = canSeeLastRoom && !canSeeNextRoom;
        if (canPlayerSeeNextRoom) {
            // The player might be peeking outside, but Skashek could still
            // be coming into the player's current room.
            isLeaving = nil;
        }

        local enterVerbForm = fromPeeking ? 'is about to enter' : 'enters';
        local exitVerbForm = fromPeeking ? 'is about to exit' : 'exits';
        local unlockVerbForm = fromPeeking ? 'is about to unlock' : 'unlocks';
        local openVerbForm = fromPeeking ? 'is about to open' : 'opens';
        local goVerbForm = fromPeeking ? 'is heading' : 'goes';
        local perceivedVerb = isLeaving ? exitVerbForm : enterVerbForm;
        local subjRoom = isLeaving ? lastRoom : nextRoom;
        local punct = fromPeeking ? '. ' : '! ';
        
        if (door != nil) {
            local visibleSide = door;
            if (!pov.canSee(visibleSide)) {
                visibleSide = door.otherSide;
            }
            local entryPlan = nil;
            if (door.isLocked) {
                "<<getPeekHe(true)>> <<unlockVerbForm>> <<visibleSide.theName>><<punct>> ";
                entryPlan = true;
            }
            else if (!door.isOpen) {
                "<<getPeekHe(true)>> <<openVerbForm>> <<visibleSide.theName>><<punct>> ";
                entryPlan = true;
            }
            else {
                "<<getPeekHe(true)>> <<perceivedVerb>> <<subjRoom.roomTitle>>
                through <<visibleSide.theName>><<punct>>";
            }
            if (entryPlan) {
                "\n(<<getPeekHe(true)>> must be planning to enter <<nextRoom.roomTitle>>...) ";
            }
        }
        else if (approachType == approachingRoom && fromPeeking) {
            "<<getPeekHeIs(true)>> approaching from <<lastRoom.roomTitle>>! ";
        }
        else {
            "<<getPeekHe(true)>> <<goVerbForm>> <<approachDirection.getDirNameFromProp()>>,
            and <<perceivedVerb>> <<subjRoom.roomTitle>><<punct>>";
        }
    }

    showSlamPainDesc() {
        "<<getPeekHeIs()>> rubbing his forehead in pain.
        {I} seem to have gotten him good with that door slam!
        <i>{I} should really take this opportunity to escape, though!</i> ";
    }

    describePeekedAction(distantRoom) {
        "<.p>";
        if (distantRoom != nil) {
            "<i>{I} can see <<getPeekHim()>> in <<distantRoom.roomTitle>>...</i>\n";
        }
        local getsCaught = playerWillGetCaughtPeeking();
        //performNextAnnouncement(getsCaught, getsCaught);
        skashekAIControls.currentState.describePeekedAction();
        // Probably better to announce afterward
        performNextAnnouncement(getsCaught, getsCaught);
    }
}