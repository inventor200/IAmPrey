modify Thing {
    parkourModule = nil
    isPushable = nil

    canSlideUnderMe = nil
    canRunAcrossMe = nil
    canSwingOnMe = nil
    canSqueezeThroughMe = nil

    prepForParkour() {
        if (forcedLocalPlatform) {
            // Do NOT let forced local surfaces be parkour surfaces!!
            // These have VERY specific overrides that will absolutely
            // ruin a parkour module!
            #ifdef __DEBUG
            "<.p>ERROR: \^<<theName>> is a forced local surface,
            and is being asked to become a parkour surface!\b
            Luckily, the system have intervened, and maintained
            the local surface status!<.p>";
            #endif
            return;
        }

        // Check if we already handle parkour
        if (parkourModule != nil) return;

        parkourModule = new ParkourModule(self);

        // Make absolutely certain that everything is done
        // through parkour now:
        remapDobjBoard = parkourModule;
        remapDobjGetOff = parkourModule;
        remapDobjJumpOff = parkourModule;
        remapDobjClimb = parkourModule;
        remapDobjClimbUp = parkourModule;
        remapDobjClimbDown = parkourModule;
    }

    getParkourModule() {
        if (forcedLocalPlatform) return nil;
        if (parkourModule != nil) return parkourModule;
        if (!isLikelyContainer()) { // Likely an actor or item
            if (location != nil) {
                local locationMod = location.getParkourModule();
                if (locationMod != nil) {
                    return locationMod;
                }
            }
        }
        return nil;
    }

    isLikelyContainer() {
        // Forced local surfaces are usually things
        // that are not usually containers, and therefore
        // need intentional classification
        if (forcedLocalPlatform) return nil;

        if (parkourModule != nil) return true;
        if (contType == Outside) return nil;
        if (contType == Carrier) return nil;
        if (isVehicle) return nil;
        if (isFixed) {
            //if (gMover == self) return nil;
            if (isBoardable) return true;
            if (isEnterable) return true;
            if (remapOn != nil) {
                if (remapOn.isBoardable) return true;
            }
            if (remapIn != nil) {
                if (remapIn.isEnterable) return true;
            }
            return isDecoration;
        }
        return nil;
    }

    filterParkourList(np, cmd, mode, pm) {
        //
    }

    getStandardOn() {
        if (remapOn != nil) {
            return remapOn;
        }

        return self;
    }

    getGhostReachDestination() {
        return self;
    }

    isStandardPlatform(moduleChecked?, confirmedParkourModule?) {
        if (moduleChecked) {
            if (confirmedParkourModule) return nil;
        }
        else {
            if (parkourModule != nil) return nil;
        }
        if (remapOn != nil) {
            return remapOn.isStandardPlatform(moduleChecked, confirmedParkourModule);
        }
        if (!isBoardable) return nil;
        if (isVehicle) return nil;
        if (contType != On) return nil;
        return true;
    }

    climbOnAlternative = (isClimbable ? Climb : (canClimbUpMe ? ClimbUp : Board))
    climbOffAlternative = (canClimbDownMe ? ClimbDown : GetOff)
    enterAlternative = (canGoThroughMe ? GoThrough : Enter)
    jumpOffAlternative = JumpOff

    dobjParkourRemap(ParkourClimbGeneric, climbOnAlternative)
    dobjParkourJumpOverRemapFix(ParkourJumpGeneric, climbOnAlternative)
    dobjParkourRemap(ParkourClimbUpTo, climbOnAlternative)
    dobjParkourRemap(ParkourJumpUpTo, climbOnAlternative)
    dobjParkourRemap(ParkourClimbOverTo, climbOnAlternative)
    dobjParkourJumpOverRemapFix(ParkourJumpOverTo, climbOnAlternative)
    dobjParkourRemap(ParkourClimbDownTo, climbOnAlternative)
    dobjParkourRemap(ParkourJumpDownTo, climbOnAlternative)

    dobjParkourIntoRemap(enterAlternative, Climb, Up, remapIn)
    dobjParkourIntoRemap(enterAlternative, Jump, Up, remapIn)
    dobjParkourIntoRemap(enterAlternative, Climb, Over, remapIn)
    dobjParkourIntoRemap(enterAlternative, Jump, Over, remapIn)
    dobjParkourIntoRemap(enterAlternative, Climb, Down, remapIn)
    dobjParkourIntoRemap(enterAlternative, Jump, Down, remapIn)

    dobjParkourRemap(ParkourClimbOffOf, climbOffAlternative)
    dobjParkourRemap(ParkourJumpOffOf, jumpOffAlternative)

    parkourProviderAction(JumpOver, remapOn)
    parkourProviderAction(SlideUnder, remapUnder)
    parkourProviderAction(RunAcross, remapOn)
    parkourProviderAction(SwingOn, remapOn)
    parkourProviderAction(SqueezeThrough, remapIn)
}