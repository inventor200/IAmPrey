//TODO: Throw an error if link or path goes to a class, instead of object
// (Hello from the future. What did you mean by this?)
// OH!! If parkour links are set incorrectly, then they will point to a class,
// and not an instance of an object

modify ParkourModule {
    addPath(parkourPath) {
        for (local i = 1; i <= pathVector.length; i++) {
            if (pathVector[i].destination == parkourPath.destination) {
                if (pathVector[i].provider == parkourPath.provider) {
                    throw new Exception(
                        'Attempted duplicate path from ' +
                        theName + ' to ' +
                        parkourPath.destination.theName + '!'
                    );
                }
            }
        }
        checkForValidFloor();
        parkourPath.destination.checkForValidFloor();
        pathVector.append(parkourPath);
    }

    provideMoveFor(actor) { // actor is usually gParkourRunner
        local plat = parent;
        if (plat.remapOn != nil) {
            plat = plat.remapOn;
        }

        local oldPlat = actor.location;

        actor.actionMoveInto(plat);
        markAsClimbed();

        // Make sure the way back is known, too
        oldPlat.doRecon();
    }

    getPathFrom(source, canBeUnknown?, allowProviders?) {
        local closestParkourMod = source.getParkourModule();
        if (closestParkourMod == nil) return nil;
        if (closestParkourMod == self) return nil;

        // This used to do sorting, but we also can't have two paths
        // with the same location and destination, so I don't think
        // there is a point to sorting this, really.
        for (local i = 1; i <= closestParkourMod.pathVector.length; i++) {
            local path = closestParkourMod.pathVector[i];
            if (path.destination != self.lexicalParent) continue;
            // Past this point, we KNOW we have the right path.
            // It's just a question of feasibility.
            if (!allowProviders) {
                if (path.provider != nil) return nil;
            }
            if (path.isKnown || canBeUnknown) {
                return path;
            }
            return nil;
        }

        return nil;
    }

    getPathThrough(provider) {
        for (local i = 1; i <= pathVector.length; i++) {
            local path = pathVector[i];
            if (path.provider != provider) continue;
            return path;
        }

        return nil;
    }

    hasPathFrom(source, canBeUnknown?) {
        local closestParkourMod = source.getParkourModule();
        if (closestParkourMod == nil) return nil;
        if (closestParkourMod == self) return nil;
        for (local i = 1; i <= closestParkourMod.pathVector.length; i++) {
            local path = closestParkourMod.pathVector[i];
            if (path.destination != self.lexicalParent) continue;
            if (path.isKnown || canBeUnknown) {
                return true;
            }
        }
        return nil;
    }

    dobjParkourIntoRemap(enterAlternative, Climb, Up, lexicalParent.remapIn)
    dobjParkourIntoRemap(enterAlternative, Jump, Up, lexicalParent.remapIn)
    dobjParkourIntoRemap(enterAlternative, Climb, Over, lexicalParent.remapIn)
    dobjParkourIntoRemap(enterAlternative, Jump, Over, lexicalParent.remapIn)
    dobjParkourIntoRemap(enterAlternative, Climb, Down, lexicalParent.remapIn)
    dobjParkourIntoRemap(enterAlternative, Jump, Down, lexicalParent.remapIn)

    // Generic conversions
    dobjFor(Board) asDobjFor(ParkourClimbUpTo)
    dobjFor(Climb) asDobjFor(ParkourClimbGeneric)
    dobjFor(ClimbUp) asDobjFor(ParkourClimbUpTo)
    dobjFor(ClimbDown) asDobjFor(ParkourClimbOffOf)
    dobjFor(GetOff) asDobjFor(ParkourClimbOffOf)
    dobjFor(JumpOff) asDobjFor(ParkourJumpOffOf)

    checkParkour(actor) {
        lexicalParent.checkInsert(actor);
        doParkourCheck(actor, gParkourLastPath);
    }

    dobjFor(ParkourClimbGeneric) {
        parkourActionIntro
        verify() {
            verifyClimbPathFromActor(gActor, parkourCore.autoPathCanDiscover);
        }
        check() { checkParkour(gActor); }
        action() {
            if (gParkourLastPath == nil) {
                // Likely from standard container to parkour one
                doGetOffParkourAlt(gParkourRunner);
                return;
            }
            switch (gParkourLastPath.direction) {
                case parkourUpDir:
                    doNested(ParkourClimbUpTo, self);
                    return;
                case parkourOverDir:
                    doNested(ParkourClimbOverTo, self);
                    return;
                case parkourDownDir:
                    doNested(ParkourClimbDownTo, self);
                    return;
            }
        }
        report() { }
    }

    parkourSimplyClimb(Up)
    parkourSimplyClimb(Over)
    parkourSimplyClimb(Down)

    dobjFor(ParkourJumpGeneric) {
        parkourActionIntro
        verify() {
            verifyJumpPathFromActor(gActor, parkourCore.autoPathCanDiscover);
        }
        check() { checkParkour(gActor); }
        action() {
            tryClimbInstead(ParkourClimbGeneric);
            switch (gParkourLastPath.direction) {
                case parkourUpDir:
                    doNested(ParkourJumpUpTo, self);
                    return;
                case parkourOverDir:
                    doNested(ParkourJumpOverTo, self);
                    return;
                case parkourDownDir:
                    doNested(ParkourJumpDownTo, self);
                    return;
            }
        }
        report() { }
    }

    parkourSimplyJump(Up)
    parkourSimplyJump(Over)
    parkourSimplyJump(Down)

    parkourReshapeGetOff(ParkourClimbOffOf, ParkourClimbDownTo)
    parkourReshapeGetOff(ParkourJumpOffOf, ParkourJumpDownTo)
}