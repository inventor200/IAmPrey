enum notApproaching, approachingRoom, approachingDoor, approachingOther;

modify skashek {
    lastTrappedConnector = nil

    informLikelyDestination(room) {
        skashekAIControls.currentState.informLikelyDestination(room);
    }

    nextStopInRoute() {
        return skashekAIControls.currentState.nextStopInRoute();
    }

    // WARNING: MIGHT NOT BE ADJACENT ROOM!
    getNextStopOnMap() {
        local nextStop = nextStopInRoute();
        if (!nextStop.isMapModeRoom) return nextStop.mapModeVersion;
        return nextStop;
    }

    // WARNING: MIGHT NOT BE ADJACENT ROOM!
    getNextStopOffMap() {
        local nextStop = nextStopInRoute();
        if (nextStop.isMapModeRoom) return nextStop.actualRoom;
        return nextStop;
    }

    // [next room, direction, approach]
    getApproach() {
        local nextStop = getNextStopOffMap();

        if (nextStop == nil || nextStop == getOutermostRoom()) {
            return [nil, nil, notApproaching];
        }

        local approachDirection = getBestWayTowardGoalRoom(
            nextStop
        );

        local actualNextStop = nil;

        if (approachDirection == nil) {
            return [nil, nil, notApproaching];
        }
        else {
            actualNextStop = approachDirection.destination.actualRoom;
        }

        local dangerDirection = getBestWayTowardGoalObject(
            getPracticalPlayer()
        );

        if (dangerDirection == nil) {
            return [actualNextStop, approachDirection, approachingOther];
        }

        if (dangerDirection == approachDirection) {
            if (approachDirection.connector.ofKind(Door)) {
                return [actualNextStop, approachDirection, approachingDoor];
            }
            return [actualNextStop, approachDirection, approachingRoom];
        }

        return [actualNextStop, approachDirection, approachingOther];
    }
    
    travelThroughComplex() {
        local approachArray = getApproach();

        local approachDirection = approachArray[2];

        if (approachDirection == nil) return nil;
        local door = nil;
        if (approachDirection.connector.ofKind(Door)) {
            #if __DEBUG_SKASHEK_ACTIONS
            "<.p>
            NAV: Door found.
            <.p>";
            #endif
            door = getOpenableSideOfDoor(approachDirection.connector);
        }
        if (door == nil) {
            #if __DEBUG_SKASHEK_ACTIONS
            "<.p>
            NAV: Clear way found; passing...
            <.p>";
            #endif
            travelThroughSimple(approachArray);
            return true;
        }
        else if (door.isOpen) {
            #if __DEBUG_SKASHEK_ACTIONS
            "<.p>
            NAV: Door is open; passing...
            <.p>";
            #endif
            travelThroughSimple(approachArray);
            if (door.lockability == lockableWithKey || door.airlockDoor) {
                #if __DEBUG_SKASHEK_ACTIONS
                "<.p>
                NAV: Closing door behind self...";
                #endif
                closeDoor(door.otherSide);
                #if __DEBUG_SKASHEK_ACTIONS
                if (!door.isOpen) "\tSUCCESSFUL! ";
                "<.p>";
                #endif
                if (door.lockability == lockableWithKey && door.isLocked) {
                    #if __DEBUG_SKASHEK_ACTIONS
                    "<.p>
                    NAV: Re-locking door behind self...
                    <.p>";
                    #endif
                    door.makeLocked(true);
                }
            }
            return true;
        }
        else if (door.isLocked) {
            #if __DEBUG_SKASHEK_ACTIONS
            "<.p>
            NAV: Unlocking door...
            <.p>";
            #endif
            unlockDoor(door);
            return true;
        }
        else if (!door.isOpen) {
            #if __DEBUG_SKASHEK_ACTIONS
            "<.p>
            NAV: Opening door...
            <.p>";
            #endif
            openDoor(door);
            return true;
        }
        return nil;
    }

    travelThroughSimple(approachArray) {
        if (skashekAIControls.isImmobile) return;
        local lastRoom = getOutermostRoom();
        local nextRoom = approachArray[2].destination.actualRoom;
        local hasDescribedTravel = nil;
        local player = getPracticalPlayer();
        if (player.canSee(self)) {
            "<.p>";
            describeTravel(approachArray);
            hasDescribedTravel = true;
        }
        /*else if (player.canHear(self)) {
            "<.p>";
            describeRustlingAction();
            hasDescribedTravel = true;
        }*/
        moveInto(nextRoom);
        popDoorMovingOnItsOwn();

        local possibleDoor = approachArray[2].connector;
        local playerInNextRoom = (player.getOutermostRoom() == nextRoom);
        if (possibleDoor.ofKind(Door) && playerInNextRoom) {
            // If a door was trapped, then set the next one as trapped.
            trapConnector(possibleDoor);
        }
        // If the next room is really big, then a trap is not possible.
        else if (nextRoom.roomNavigationType != bigRoom) {
            abandonTraps();
            if (playerInNextRoom) {
                // If the player is in the next room, trap the one
                // Skashek came from.
                trapConnector(lastRoom);
            }
            else {
                // Otherwise, Skashek now controls the room he's in.
                trapConnector(nextRoom);
            }
        }
        else {
            // This case gets called when the room Skashek walks into
            // is MASSIVE, so he cannot control any exits.
            abandonTraps();
        }
        
        if (!hasDescribedTravel) {
            if (player.canSee(self)) {
                "<.p>";
                describeTravel(approachArray);
            }
            /*else if (player.canHear(self)) {
                "<.p>";
                describeRustlingAction();
                hasDescribedTravel = true;
            }*/
        }
    }

    abandonTraps() {
        if (lastTrappedConnector != nil) {
            lastTrappedConnector.setTrap(nil);
            lastTrappedConnector = nil;
        }
    }

    trapConnector(connector) {
        abandonTraps();
        lastTrappedConnector = connector;
        connector.setTrap(true);
    }

    receiveDoorSlam() {
        hasSeenPreyOutsideOfDeliveryRoom = true;
        skashekAIControls.currentState.receiveDoorSlam();
        abandonTraps();
    }

    doesDoorGoToValidDest(door) {
        if (!door.location.ofKind(Room)) return nil;

        local otherSideRoom = door.otherSide.location;
        if (!otherSideRoom.ofKind(Room)) return nil;

        if (otherSideRoom.mapModeVersion == nil) return nil;

        local dirToThere = getBestWayBetweenMapModeRooms(
            door.location.mapModeVersion,
            otherSideRoom.mapModeVersion
        );
        return dirToThere != nil;
    }

    getOpenableSideOfDoor(door) {
        if (door == nil) return nil;
        if (!door.ofKind(Door)) return nil;
        local mySide = door;
        if (mySide.getOutermostRoom() != getOutermostRoom()) {
            // Simply process of elimination
            mySide = mySide.otherSide;
        }
        if (mySide == nil) return nil;
        if (canReach(mySide)) {
            return mySide;
        }
        return nil;
    }

    openDoor(openableSide) {
        // If Skashek can open the door, then he controls it.
        trapConnector(openableSide);
        if (openableSide.isOpen) return;
        huntCore.doSkashekAction(Open, openableSide);
    }

    unlockDoor(openableSide) {
        if (!openableSide.isLocked) return;
        huntCore.doSkashekAction(Unlock, openableSide);
    }

    closeDoor(openableSide) {
        if (!openableSide.isOpen) return;
        huntCore.doSkashekAction(Close, openableSide);
    }

    // If going somewhere, return next room, unless blocked,
    // in which case return nil. If going nowhere, return nil.
    getWalkInRoom(approachArray?) {
        if (approachArray == nil) approachArray = getApproach();
        local nextRoom = approachArray[1];
        if (nextRoom == nil || nextRoom == getOutermostRoom()) return nil;

        local connector = approachArray[2];
        if (!connector.ofKind(Door)) return nextRoom;

        if (connector.isOpen) return nextRoom;

        return nil;
    }

    getRoomFromGoalObject(goalObj) {
        if (goalObj.location == nil) return nil;
        if (goalObj.ofKind(MultiLoc)) return nil;
        local actualRoom = goalObj.getOutermostRoom();
        if (actualRoom.isMapModeRoom) {
            // Should never happen, but just in case
            actualRoom = actualRoom.actualRoom;
        }
        return actualRoom;
    }

    getBestWayTowardGoalObject(goalObj) {
        local goalRoom = getRoomFromGoalObject(goalObj);
        if (goalRoom == nil) return nil; // Can't find our way off-grid

        return getBestWayTowardGoalRoom(goalRoom);
    }

    getBestWayTowardGoalRoom(goalRoom) {
        local goalMapModeRoom = goalRoom.mapModeVersion;
        if (goalMapModeRoom == nil) return nil; // Can't find our way off-grid

        return getBestWayTowardGoalMapModeRoom(goalMapModeRoom);
    }

    getCurrentMapModeRoom() {
        if (location == nil) return nil; // Can't find our way in the void
        return getOutermostRoom().mapModeVersion;
    }

    getBestWayTowardGoalMapModeRoom(goalMapModeRoom) {
        return getBestWayBetweenMapModeRooms(
            getCurrentMapModeRoom(),
            goalMapModeRoom
        );
    }

    getBestWayBetweenMapModeRooms(mapModeRoomA, mapModeRoomB) {
        if (mapModeRoomB == nil) return nil; // Can't find our way off-grid
        if (mapModeRoomA == nil) return nil; // Can't find our way off-grid

        return mapModeRoomA.skashekRouteTable
            .findBestDirectionTo(mapModeRoomB);
    }

    getFullPathToMapModeRoom(goalMapModeRoom) {
        return getFullPathBetweenRooms(
            getCurrentMapModeRoom(),
            goalMapModeRoom
        );
    }

    getFullPathBetweenRooms(mapModeRoomA, mapModeRoomB) {
        if (mapModeRoomB == nil) return nil; // Can't find our way off-grid
        if (mapModeRoomA == nil) return nil; // Can't find our way off-grid

        local currentRoom = mapModeRoomA;
        local path = [mapModeRoomA];

        while (currentRoom != mapModeRoomB) {
            local nextDir = getBestWayBetweenMapModeRooms(
                currentRoom,
                mapModeRoomB
            );

            if (nextDir == nil) return nil;
            if (nextDir == compassAlreadyHereSignal) return path;

            currentRoom = nextDir.destination;
            path += nextDir;
        }

        if (path.length == 1) return nil;

        return path;
    }
}