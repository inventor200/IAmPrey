actorHasPeekAngle: PreCondition {
    checkPreCondition(obj, allowImplicit) {
        if (!obj.requiresPeekAngle) return true;
        local stagingLoc = obj.stagingLocation;
        return actorInStagingLocation.doPathCheck(stagingLoc, allowImplicit);
    }
}

modify TravelAction {
    execCycle(cmd) {
        actionFailed = nil;
        parkourCore.cacheParkourRunner(gActor);
        local traveler = parkourCore.currentParkourRunner;
        local oldLoc = traveler.location;
        try {
            inherited(cmd);
        } catch(ExitSignal ex) {
            actionFailed = true;
        }
        if (oldLoc == traveler.location) {
            // We didn't move. We failed.
            actionFailed = true;
        }
    }

    execAction(cmd) {
        easeIntoTravel();
        doTravel();
    }

    easeIntoTravel() {
        parkourCore.cacheParkourRunner(gActor);

        // Re-interpreting getting out?
        //TODO: Pop these changes to TravelAction out, so
        // more modules can use them later.
        if (!gActor.location.ofKind(Room)) {
            local getOutAction = nil;
            if (direction == outDir) {
                getOutAction = GetOutOf;
            }
            else if (direction == downDir) {
                getOutAction = GetOff;
            }
            if (getOutAction != nil) {
                replaceAction(getOutAction, gActor.location);
                return;
            }
        }

        sneakyCore.performStagingCheck(gActor.getOutermostRoom());
    }

    doTravel() {
        local loc = gActor.getOutermostRoom();
        local conn;
        local illum = loc.allowDarkTravel || loc.isIlluminated;
        parkourCore.cacheParkourRunner(gActor);
        local traveler = parkourCore.currentParkourRunner;
        if (loc.propType(direction.dirProp) == TypeObject) {
            conn = loc.(direction.dirProp);
            if (conn.isConnectorVisible) {
                if (gActorIsPlayer) {
                    sneakyCore.doSneakStart(conn, direction);
                    conn.travelVia(traveler);
                    sneakyCore.doSneakEnd(conn);
                }
                else {
                    sneakyCore.disarmSneaking();
                    gActor.travelVia(conn);
                }
            }
            else if (illum && gActorIsPlayer) {
                sneakyCore.disarmSneaking();
                loc.cannotGoThatWay(direction);
            }
            else if (gActorIsPlayer) {
                sneakyCore.disarmSneaking();
                loc.cannotGoThatWayInDark(direction);
            }
        }
        else {
            sneakyCore.disarmSneaking();
            nonTravel(loc, direction);
        }
    }
}

modify Door {
    getCatAccessibility() {
        if (!hasDistCompCatFlap) {
            return [travelPermitted, actorInStagingLocation, objOpen];
        }
        if (gActorIsCat) {
            return [travelPermitted, actorInStagingLocation];
        }
        return [travelPermitted, actorInStagingLocation, objOpen];
    }

    isActuallyPassable(traveler) {
        if (traveler == cat) {
            return hasDistCompCatFlap || isVentGrateDoor;
        }
        return isOpen;
    }

    replace checkTravelBarriers(traveler) {
        if(inherited(traveler) == nil) {
            return nil;
        }
        
        if (!isActuallyPassable(traveler)) {
            if (gPlayerChar.isOrIsIn(traveler)) {
                if (tryImplicitAction(Open, self)) {
                    "<<gAction.buildImplicitActionAnnouncement(true)>>";
                }
            }
            else if (tryImplicitActorAction(traveler, Open, self)) { }
            else if (gPlayerChar.canSee(traveler)) {
                local obj = self;
                gMessageParams(obj);

                say(cannotGoThroughClosedDoorMsg);
            }
        }
        
        return isActuallyPassable(traveler);
    }

    replace noteTraversal(actor) {
        if (gPlayerChar.isOrIsIn(actor) && !(gAction.isPushTravelAction && suppressTravelDescForPushTravel)) {
            if (!gOutStream.watchForOutput({:travelDesc}) &&
                actor == cat && hasDistCompCatFlap &&
                catFlapNotificationCounter.count > 0) {
                local obj = gActor;
                gMessageParams(obj);
                if (catFlapNotificationCounter.count > 2) {
                    "{The subj obj} carefully climb{s/ed} through the cat flap of <<theName>>.";
                }
                else {
                    "(using the cat flap of <<theName>>...)";
                }
                catFlapNotificationCounter.count--;
            }
            "<.p>";
        }

        local travelers = (actor.location && actor.location.isVehicle)
            ? [actor, actor.location] : [actor];

        traversedBy = traversedBy.appendUnique(travelers);
    }
}