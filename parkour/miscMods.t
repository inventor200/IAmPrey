modify Room {
    parkourModule = perInstance(new ParkourModule(self))

    hasParkourRecon = true

    isLikelyContainer() {
        return true;
    }

    getParkourModule() {
        return parkourModule;
    }

    isStandardPlatform(moduleChecked?, confirmedParkourModule?) {
        return nil;
    }

    jumpOffFloor() {
        doInstead(Jump);
    }

    canGetOffFloor = nil

    getOffFloor() {
        jumpOffFloor();
    }

    omitFromStagingError() {
        return nil;
    }

    getStandardOn() {
        return self;
    }
}

// floorActions allow for extended decoration actions.
modify Floor {
    parkourModule = (gPlayerChar.outermostVisibleParent().parkourModule)
    decorationActions = (
        floorActions
        .append(ParkourClimbGeneric)
        .append(ParkourClimbUpTo)
        .append(ParkourClimbOverTo)
        .append(ParkourClimbDownTo)
        .append(ParkourJumpGeneric)
        .append(ParkourJumpUpTo)
        .append(ParkourJumpOverTo)
        .append(ParkourJumpDownTo)
        .append(ParkourClimbOffOf)
        .append(ParkourJumpOffOf)
        .append(Board)
        .append(GetOff)
        .append(JumpOff)
        .append(Climb)
        .append(ClimbUp)
        .append(ClimbDown)
    )

    floorActions = [Examine, TakeFrom]

    hasParkourRecon = true

    redirectJumpOffFloor(JumpOff)
    redirectJumpOffFloor(ParkourJumpOffOf)
    redirectGetOffFloor(GetOff)
    redirectGetOffFloor(ParkourClimbOffOf)

    omitFromStagingError() {
        return nil;
    }

    getStandardOn() {
        return gPlayerChar.outermostVisibleParent();
    }
}

modify SubComponent {
    parkourModule = (lexicalParent == nil ? nil : lexicalParent.parkourModule)

    hasParkourRecon = (lexicalParent == nil ? true : lexicalParent.hasParkourRecon)

    // In case the "IN" part is on the top of the container
    partOfParkourSurface = nil
    // For drawers on a short desk, for example
    isInReachOfParkourSurface = (partOfParkourSurface)

    isLikelyContainer() {
        if (forcedLocalPlatform) return nil;
        if (parkourModule != nil) return true;
        if (lexicalParent != nil) {
            return lexicalParent.isLikelyContainer();
        }
        return inherited();
    }

    getParkourModule() {
        if (forcedLocalPlatform) return nil;
        if (lexicalParent != nil) {
            if (lexicalParent.remapOn == self || partOfParkourSurface) {
                return lexicalParent.getParkourModule();
            }
            return nil;
        }
        return inherited();
    }

    loadGetOffSuggestion(strBfr, requiresJump, isHarmful) {
        if (lexicalParent == nil) return;
        lexicalParent.loadGetOffSuggestion(strBfr, requiresJump, isHarmful);
    }

    standardDoNotSuggestGetOff() {
        if (lexicalParent == nil) return nil;
        return lexicalParent.standardDoNotSuggestGetOff();
    }

    getStandardOn() {
        local res = lexicalParent;
        if (res.remapOn != nil) {
            res = res.remapOn;
        }
        return res;
    }

    omitFromLogicalLocalsList() {
        local ret = inherited();
        if (ret) return ret;
        if (lexicalParent != nil) {
            return lexicalParent.omitFromLogicalLocalsList();
        }
        return nil;
    }

    omitFromPrintedLocalsList() {
        local ret = inherited();
        if (ret) return ret;
        if (lexicalParent != nil) {
            return lexicalParent.omitFromPrintedLocalsList();
        }
        return nil;
    }

    omitFromStagingError() {
        local ret = inherited();
        if (ret == nil) return ret;
        if (lexicalParent != nil) {
            return lexicalParent.omitFromStagingError();
        }
        return nil;
    }

    markAsClimbed() {
        if (lexicalParent != nil) lexicalParent.markAsClimbed();
        playerClimbed = true;
    }

    hasBeenClimbed() {
        if (lexicalParent != nil) return lexicalParent.hasBeenClimbed();
        return playerClimbed;
    }

    getBonusLocalPlatforms() {
        if (lexicalParent != nil) return lexicalParent.getBonusLocalPlatforms();
        return nil;
    }

    #ifdef __DEBUG
    dobjFor(DebugCheckForContainer) {
        preCond = nil
        verify() { }
        check() { }
        action() {
            local status = isLikelyContainer();
            local parkourStatusStr = (parkourModule == nil ?
                ', and is not prepared for parkour' :
                ', and is prepared for parkour'
            );
            if (status) {
                extraReport(
                    '\^' + contType.prep +
                    ' {the subj dobj} is likely a container<<parkourStatusStr>>.\n'
                );
            }
            else {
                extraReport(
                    '\^' + contType.prep +
                    ' {the subj dobj} is likely an item<<parkourStatusStr>>.\n'
                );
            }
        }
        report() { }
    }
    #endif
}

modify Actor {
    fitForParkour = true

    isLikelyContainer() {
        return nil;
    }

    isStandardPlatform(moduleChecked?, confirmedParkourModule?) {
        return nil;
    }
}