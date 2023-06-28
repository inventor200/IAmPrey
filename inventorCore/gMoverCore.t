#define gMoverFrom(actor) (gMoverCore.cacheMover(actor))
#define gMover (gMoverCore.cachedMover)
#define gMoverLocation (gMoverCore.getMoverLocation())
#define gMoverLocationFor(actor) (gMoverCore.getMoverLocation(actor))

gMoverCore: object {
    cachedMover = nil

    cacheMover(actor) {
        local potentialVehicle = actor.location;
        while (potentialVehicle != nil && !potentialVehicle.ofKind(Room)) {
            if (potentialVehicle.isVehicle) {
                cachedMover = potentialVehicle;
                return cachedMover;
            }
            potentialVehicle = potentialVehicle.location;
        }
        
        cachedMover = actor;
        return cachedMover;
    }

    getMoverLocation(actor?) {
        if (actor != nil) cacheMover(actor);
        return cachedMover.location;
    }
}

modify statusLine {
    showStatusHtml() {
        "<<statusHTML(0)>><<aHref('look around', nil, nil, AHREF_Plain)>>";
        showStatusLeft();
        "<./a></a><<statusHTML(1)>>";
        showStatusRight();
        "<./a></a><<statusHTML(2)>>";
        if (gMoverLocationFor(gPlayerChar) != nil) {
            gMoverLocation.showStatuslineExits();
        }
    }
}

modify TravelAction {
    execCycle(cmd) {
        actionFailed = nil;
        local oldLoc = gMoverLocationFor(gActor);
        try {
            inherited(cmd);
        } catch(ExitSignal ex) {
            actionFailed = true;
        }
        if (oldLoc == gMoverLocation) {
            // We didn't move. We failed.
            actionFailed = true;
        }
    }

    execAction(cmd) {
        easeIntoTravel();
        doTravel();
    }

    easeIntoTravel() {
        gMoverFrom(gActor);

        // Re-interpreting getting out?
        if (!gMoverLocationFor(gActor).ofKind(Room)) {
            local getOutAction = nil;
            if (direction == outDir) {
                getOutAction = GetOutOf;
            }
            else if (direction == downDir) {
                getOutAction = GetOff;
            }
            if (getOutAction != nil) {
                replaceAction(getOutAction, gMoverLocation);
                return;
            }
        }

        handleExtraRoomCheck(gActor.getOutermostRoom());
    }

    doTravel() {
        local loc = gActor.getOutermostRoom();
        local conn;
        local illum = loc.allowDarkTravel || loc.isIlluminated;
        local traveler = gMoverFrom(gActor);
        if (loc.propType(direction.dirProp) == TypeObject) {
            conn = loc.(direction.dirProp);
            if (conn.isConnectorVisible) {
                if (gActorIsPlayer) {
                    handleExtraPlayerTravelStart(conn, direction);
                    conn.travelVia(traveler);
                    handleExtraPlayerTravelEnd(conn, direction);
                }
                else {
                    handleExtraPlayerTravelCancel(direction);
                    gActor.travelVia(conn);
                }
            }
            else if (illum && gActorIsPlayer) {
                handleExtraPlayerTravelCancel(direction);
                loc.cannotGoThatWay(direction);
            }
            else if (gActorIsPlayer) {
                handleExtraPlayerTravelCancel(direction);
                loc.cannotGoThatWayInDark(direction);
            }
        }
        else {
            handleExtraPlayerTravelCancel(direction);
            nonTravel(loc, direction);
        }
    }

    handleExtraRoomCheck(room) {
        //
    }

    handleExtraPlayerTravelStart(conn, direction) {
        //
    }

    handleExtraPlayerTravelEnd(conn, direction) {
        //
    }

    handleExtraPlayerTravelCancel(direction) {
        //
    }
}
