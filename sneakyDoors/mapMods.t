modify Door {
    getSuspicionScore() {
        // Airlock doors can be suspicious, but there's no way to tell
        // how long ago it was visited.
        if (airlockDoor) return 1;
        if (closingFuse == nil) return 1;

        // Otherwise, rank by how much time is left to close.
        return (closingFuse.nextRunTime - gTurns) + 2;
    }
}

class MaintenanceDoor: PrefabDoor {
    keyList = [maintenanceKey]
}

DefineDistComponentFor(ProximityScanner, MaintenanceDoor)
    vocab = 'proximity lock;RFID[weak];scanner'

    desc = "A small, metal box. If someone with the right keycard approaches,
    it unlocks, but only for a moment. "

    isDecoration = true
;

modify Passage {
    dobjFor(SneakThrough) {
        verify() {
            logical;
        }
        action() {
            sneakyCore.trySneaking();
            sneakyCore.doSneakStart(self, self);
            doNested(TravelVia, self);
            sneakyCore.doSneakEnd(self);
        }
    }
}

modify Room {
    hasDanger() {
        local res = nil;
        reachGhostTest_.moveInto(self);

        // Are we peeking him where he is now?
        local canSeeCurrentPosition =
            (skashek.getOutermostRoom() == self) ||
                reachGhostTest_.canSee(skashek);
        
        // Are we peeking him entering?
        local canSeeNextPosition = nil;
        local nextStop = skashek.getWalkInRoom();
        if (nextStop != nil) {
            canSeeNextPosition = 
                (nextStop == self) || reachGhostTest_.canSee(nextStop);
        }

        if (canSeeCurrentPosition || canSeeNextPosition) {
            res = skashek.showsDuringPeek();
        }
        reachGhostTest_.moveInto(nil);
        return res;
    }

    peekInto() {
        if (hasDanger()) {
            local distantRoom = nil;
            local skashekRoom = skashek.getOutermostRoom();
            if (skashekRoom != self) {
                distantRoom = skashekRoom;
            }
            else {
                // Player cannot be caught peeking from a distance
                skashek.doPlayerPeek();
            }
            // Move our peek POV into place, and mark it
            _peekSkashekPOV.moveInto(self);
            skashek.peekPOV = _peekSkashekPOV;
            if (distantRoom != nil) {
                // Make sure we can actually see the room...
                if (!_peekSkashekPOV.canSee(distantRoom)) {
                    distantRoom = nil;
                }
            }
            // Do peek
            skashek.describePeekedAction(distantRoom);
            // Pack up our peek POV
            _peekSkashekPOV.moveInto(nil);
            skashek.peekPOV = nil;
        }
        else {
            "<.p><i>Seems safe!</i> ";
        }
    }

    doorScanFuse = nil

    startDoorScan() {
        if (doorScanFuse != nil) return;
        doorScanFuse = new Fuse(self, &doDoorScan, 0);
        doorScanFuse.eventOrder = 80;
    }

    haltScheduledDoorScan() {
        if (doorScanFuse != nil) {
            doorScanFuse.removeEvent();
            doorScanFuse = nil;
        }
    }

    travelerEntering(traveler, origin) {
        inherited(traveler, origin);
        if (gPlayerChar.isOrIsIn(traveler)) {
            startDoorScan();
        }
    }

    lookAroundWithin() {
        inherited();
        if (doorScanFuse == nil) {
            doDoorScan(true);
        }
    }

    getMainDoorsInSight(actor, scopeVector) {
        local om = actor.getOutermostRoom();
        local omRegions = valToList(om.allRegions);
        for (local i = 1; i <= omRegions.length; i++) {
            local reg = omRegions[i];
            if (!reg.canSeeAcross) continue;
            local regRooms = valToList(reg.roomList);
            for (local j = 1; j <= regRooms.length; j++) {
                local room = regRooms[j];
                if (!om.canSeeOutTo(room)) continue;
                getMainDoorsInRoom(actor, room, scopeVector);
            }
        }
        if (omRegions.length == 0) {
            getMainDoorsInRoom(actor, om, scopeVector);
        }
    }

    getMainDoorsInRoom(actor, room, scopeVector) {
        local roomScope = valToList(room.contents);
        for (local i = 1; i <= roomScope.length; i++) {
            local obj = roomScope[i];
            if (!actor.canSee(obj)) continue;
            if (!obj.ofKind(Door)) continue;
            scopeVector.appendUnique(obj);
        }
    }

    getSuspiciousDoorsForSkashek() {
        local scopeList = new Vector(16);
        getMainDoorsInSight(skashek, scopeList);

        local suspiciousDoors = new Vector(8);

        for (local i = 1; i <= scopeList.length; i++) {
            local obj = scopeList[i];
            if (!skashek.doesDoorGoToValidDest(obj)) continue;
            if (obj.isStatusSuspiciousTo(skashek, &skashekCloseExpectationFuse)) {
                suspiciousDoors.appendUnique(obj);
            }
        }

        if (suspiciousDoors.length == 0) return [];

        suspiciousDoors.sort(true,
            { a, b: a.getSuspicionScore() - b.getSuspicionScore() }
        );

        return suspiciousDoors.toList();
    }

    doDoorScan(fromCommand?) {
        if (gPlayerChar.getOutermostRoom() != self) return; // Oops
        local beVerbose = fromCommand || gameMain.verbose;

        local totalRoomList = new Vector(8);
        local totalRegions = valToList(allRegions);
        for (local i = 1; i <= totalRegions.length; i++) {
            local currentRoomList = valToList(totalRegions[i].roomList);
            for (local j = 1; j <= currentRoomList.length; j++) {
                local currentRoom = currentRoomList[j];
                if (currentRoom == self) continue;
                if (!canSeeOutTo(currentRoom)) continue;
                totalRoomList.appendUnique(currentRoom);
            }
        }

        local scopeList = [];
        scopeList += Q.scopeList(gPlayerChar);

        for (local i = 1; i <= totalRoomList.length; i++) {
            local currentRoom = totalRoomList[i];
            scopeList += currentRoom.getWindowList(gPlayerChar);
        }

        local openExpectedDoors = new Vector(4);
        local closedExpectedDoors = new Vector(4);
        local suspiciousOpenDoors = new Vector(4);
        local suspiciousClosedDoors = new Vector(4);

        for (local i = 1; i <= scopeList.length; i++) {
            local obj = scopeList[i];
            if (!gPlayerChar.canSee(obj)) continue;
            if (!obj.ofKind(Door)) continue;
            if (!obj.isConnectorListed) continue;
            if (obj.isVentGrateDoor) continue;
            if (obj.isStatusSuspiciousTo(gPlayerChar, &playerCloseExpectationFuse)) {
                if (obj.isOpen) {
                    suspiciousOpenDoors.appendUnique(obj);
                }
                else {
                    suspiciousClosedDoors.appendUnique(obj);
                }
            }
            else if (beVerbose) {
                if (obj.isOpen) {
                    openExpectedDoors.appendUnique(obj);
                }
                else {
                    closedExpectedDoors.appendUnique(obj);
                }
            }
        }

        local expectedCount = openExpectedDoors.length + closedExpectedDoors.length;
        local suspicionCount = suspiciousOpenDoors.length + suspiciousClosedDoors.length;

        if (expectedCount > 0 || suspicionCount > 0) {
            "<.p>";
        }

        if (expectedCount > 0) {
            local firstListing = nil;

            if (closedExpectedDoors.length > 0) {
                "\^<<makeListStr(closedExpectedDoors, &getScanName, 'and')>>
                <<if closedExpectedDoors.length > 1>>are<<else>>is<<end>>
                closed";
                firstListing = true;
            }

            if (openExpectedDoors.length > 0) {
                "<<if firstListing>>, and <<else>>\^<<end>><<
                makeListStr(openExpectedDoors, &getScanName, 'and')>>
                <<if openExpectedDoors.length > 1>>are<<else>>is<<end>>
                currently open, but {i}
                <<one of>>probably knew<<or>>already knew<<or>>{was} expecting<<at random>>
                that. ";
            }
            else {
                ". ";
            }
        }

        if (suspicionCount > 0) {
            if (expectedCount > 0) {
                "<.p>However...
                <<if suspicionCount > 1>><i>some</i> things are<<else
                >><i>something</i> is<<end>>
                suspicious here...<.p>";
            }

            local firstListing = nil;
            
            if (suspiciousOpenDoors.length > 0) {
                "\^<<makeListStr(suspiciousOpenDoors, &getScanName, 'and')>>
                <<if suspiciousOpenDoors.length > 1>>are<<else>>is<<end>>
                open, ";
                firstListing = true;
            }

            if (suspiciousClosedDoors.length > 0) {
                "<<if firstListing>>while <<else>>\^<<end>><<
                makeListStr(suspiciousClosedDoors, &getScanName, 'and')>>
                <<if suspiciousClosedDoors.length > 1>>are<<else>>is<<end>>
                <<if firstListing>>closed<<else>><i>open</i><<end>>, ";
            }

            "and {i} don't remember leaving
            <<if suspicionCount > 1>>them<<else>>it<<end>>
            <<one of>>like that<<or>>in that state<<or>>that way<<at random>>!";
        }

        if (openExpectedDoors.length > 0 || suspicionCount > 0) {
            "<.p>";
        }

        haltScheduledDoorScan();
    }

    getSpecialPeekDirectionTarget(dirObj) {
        return nil;
    }
}