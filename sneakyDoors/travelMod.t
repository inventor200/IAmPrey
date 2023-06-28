actorHasPeekAngle: PreCondition {
    checkPreCondition(obj, allowImplicit) {
        if (!obj.requiresPeekAngle) return true;
        local stagingLoc = obj.stagingLocation;
        return actorInStagingLocation.doPathCheck(stagingLoc, allowImplicit);
    }
}

modify TravelAction {
    handleExtraRoomCheck(room) {
        sneakyCore.performStagingCheck(room);
    }

    handleExtraPlayerTravelStart(conn, direction) {
        sneakyCore.doSneakStart(conn, direction);
    }

    handleExtraPlayerTravelEnd(conn, direction) {
        sneakyCore.doSneakEnd(conn);
    }

    handleExtraPlayerTravelCancel(direction) {
        sneakyCore.disarmSneaking();
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