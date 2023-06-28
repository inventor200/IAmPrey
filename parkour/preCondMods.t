// Modifying the behavior for moving actors into position
modify actorInStagingLocation {
    checkPreCondition(obj, allowImplicit) {
        //if (parkourPathFinder.mapBetween(gActor, obj, true, nil)) return true;
        local stagingLoc = obj.stagingLocation;
        return doPathCheck(stagingLoc, allowImplicit);
    }

    doPathCheck(stagingLoc, allowImplicit) {
        local loc = gMoverLocationFor(gActor);

        local actorParkourMod = gParkourRunnerModule;
        local objectParkourMod = stagingLoc.getParkourModule();

        if (objectParkourMod != nil) {
            stagingLoc = objectParkourMod.getStandardOn();
        }

        if (loc == stagingLoc) return true; // FREE!!

        if (allowImplicit) {
            local impAction = nil;
            local impDest = nil;

            // Attempting to do parkour in invalid vehicle
            if (!gMover.fitForParkour) {
                parkourCore.sayParkourRunnerError(actor);
            }
            else if (actorParkourMod != nil && objectParkourMod != nil) {
                local connPath = objectParkourMod.getPathFrom(
                    actorParkourMod, parkourCore.autoPathCanDiscover
                );

                if (connPath != nil) {
                    if (connPath.isSafeForAutoParkour()) {
                        switch (connPath.direction) {
                            case parkourUpDir:
                                impAction = ParkourClimbUpTo;
                                break;
                            case parkourOverDir:
                                impAction = ParkourClimbOverTo;
                                break;
                            case parkourDownDir:
                                impAction = ParkourClimbDownTo;
                                break;
                        }
                        impDest = objectParkourMod;
                    }
                }
            }
            else if (gMover.canReach(stagingLoc)) {
                if (actorParkourMod == nil && loc.exitLocation == stagingLoc) {
                    if (loc.contType == On) {
                        impAction = GetOff;
                    }
                    else {
                        impAction = GetOutOf;
                    }
                    impDest = loc;
                }
                else if (objectParkourMod == nil && stagingLoc.stagingLocation == loc) {
                    if (stagingLoc.contType == On) {
                        impAction = Board;
                    }
                    else {
                        impAction = Enter;
                    }
                    impDest = stagingLoc;
                }
            }

            if (impAction != nil && impDest != nil) {
                parkourCore.implicitPlatform = impDest;
                local tried = tryImplicitAction(impAction, impDest);
                if (tried) {
                    spendImplicitTurn();
                }
                if (gMoverLocation == stagingLoc) return true;
            }
        }

        local realStagingLocation = stagingLoc;
        local stagingMod = realStagingLocation.getParkourModule();
        if (stagingMod != nil) {
            realStagingLocation = stagingMod;
        }

        if (realStagingLocation.omitFromStagingError()) {
            say('{I} need{s/ed} to be in a better spot to do that. ');
        }
        else {
            local locRoom = realStagingLocation.getOutermostRoom();
            if (locRoom != gActor.getOutermostRoom()) {
                realStagingLocation = locRoom;
            }
            say('{I} need{s/ed} to be
                <<realStagingLocation.objInPrep>> <<realStagingLocation.theName>>
                to do that. ');
        }
        
        return nil;
    }

    spendImplicitTurn() {
        //
    }
}

#define parkourPreCond touchObj