// Prefer parkourModule over getParkourModule(), because
// climbing on something that isn't a parkour platform should
// not default to the parkour platform it rests on.
#define dobjParkourRemap(parkourAction, remapAction) \
    dobjFor(parkourAction) { \
        preCond = [parkourPreCond] \
        remap = (/*getParkourModule()*/parkourModule) \
        verify() { } \
        check() { } \
        action() { \
            doInstead(remapAction, self); \
        } \
        report() { } \
    }

#define dobjParkourJumpOverRemapFix(parkourAction, remapAction) \
    dobjFor(parkourAction) { \
        preCond = [parkourPreCond] \
        remap = (canJumpOverMe ? nil : getParkourModule()) \
        verify() { } \
        check() { } \
        action() { \
            if (canJumpOverMe) { \
                doInstead(JumpOver, self); \
            } \
            else { \
                doInstead(remapAction, self); \
            } \
        } \
        report() { } \
    }

#define dobjParkourIntoRemap(remapAction, climbOrJump, parkourDir, remapDest) \
    dobjFor(Parkour##climbOrJump##parkourDir##Into) { \
        preCond = [parkourPreCond] \
        remap = (remapDest) \
        verify() { } \
        check() { \
            parkourCore.cacheParkourRunner(gActor); \
            if (!gParkourRunner.fitForParkour) { \
                parkourCore.sayParkourRunnerError(gActor); \
            } \
        } \
        action() { \
            if (simplyRerouteClimbInto) { \
                doInstead(Parkour##climbOrJump##parkourDir##To, self); \
            } \
            else { \
                if (gParkourRunner.location != stagingLocation) { \
                    local stagingParkourModule = stagingLocation.getParkourModule(); \
                    if (stagingParkourModule == nil) { \
                        parkourCore.implicitPlatform = stagingLocation; \
                        tryImplicitAction(stagingLocation.climbOnAlternative, stagingLocation); \
                    } \
                    else { \
                        parkourCore.implicitPlatform = stagingParkourModule; \
                        tryImplicitAction(Parkour##climbOrJump##parkourDir##To, stagingParkourModule); \
                    } \
                } \
                doInstead(remapAction, self); \
            } \
        } \
        report() { } \
    }

#define announcePathDiscovery(str, reportMethod) \
    reportMethod('\n' + str + '\n')

#define learnOnlyLocalPlatform(plat, reportMethod) \
    searchCore.startSearch(true, true); \
    if (plat.secretLocalPlatform) { \
        local discoveryStr = \
            '({I} learned a new route: ' + \
            formatCommand(plat.getLocalPlatformBoardingCommand(), longCmd) + \
            '!) '; \
        announcePathDiscovery(discoveryStr, reportMethod); \
        plat.secretLocalPlatform = nil; \
        searchCore.reportedSuccess = true; \
    } \
    searchCore.concludeSearch(plat, nil, nil, true);

#define learnPath(path, reportMethod) \
    searchCore.startSearch(true, true); \
    if (!path.isAcknowledged) { \
        if (path.isKnown) { \
            path.acknowledge(); \
            if (parkourCore.showNewRoute) { \
                announcePathDiscovery(path.getDiscoverMsg(), reportMethod); \
                searchCore.reportedSuccess = true; \
            } \
        } \
    } \
    searchCore.concludeSearch(path.destination, nil, nil, true);

// Actual parkour reporting
#define reportParkour \
    if (!parkourCore.hadAccident) { \
        "<<gParkourLastPath.getPerformMsg()>><.p>"; \
    }

// Fake parkour reporting
#define reportStandardWithRoutes(destination) \
    inherited()

#define verifyAlreadyAtDestination(actor) \
    if (actor.getParkourModule() == self) { \
        illogical(alreadyOnParkourModuleMsg); \
        return; \
    }

#define verifyParkourProviderFromActor(actor, ProviderAction) \
    local realProvider = getParkourProvider(nil, nil); \
    if (realProvider == nil) { \
        illogical(cannot##ProviderAction##Msg); \
        return; \
    } \
    if (!realProvider.can##ProviderAction##Me) { \
        illogical(cannot##ProviderAction##Msg); \
        return; \
    } \
    parkourCore.cacheParkourRunner(actor); \
    local pm = gParkourRunnerModule; \
    if (pm == nil) { \
        illogical(useless##ProviderAction##Msg); \
        return; \
    } \
    verifyAlreadyAtDestination(gParkourRunner); \
    gParkourLastPath = pm.getPathThrough(realProvider); \
    if (gParkourLastPath == nil) { \
        illogical(useless##ProviderAction##Msg); \
        return; \
    }

#define beginParkourReset(announceNewRoute) \
    parkourCore.hadAccident = nil; \
    parkourCore.showNewRoute = announceNewRoute

#define beginParkour(announceNewRoute) \
    beginParkourReset(announceNewRoute); \
    local parkourDestination = \
        gParkourLastPath.destination.getParkourModule(); \
    parkourDestination.lexicalParent.applyRecon(); \
    if (gParkourLastPath.provider != nil) { \
        gParkourLastPath.provider.applyRecon(); \
    } \
    learnPath(gParkourLastPath, extraReport)

#define doParkourThroughProvider(actor) \
    beginParkour(parkourCore.announceRouteAfterTrying); \
    parkourDestination.provideMoveFor(actor)

#define parkourProviderAction(ProviderAction, remapPrep) \
    dobjFor(ProviderAction) { \
        preCond = [parkourPreCond] \
        remap = remapPrep \
        verify() { \
            verifyParkourProviderFromActor(gActor, ProviderAction); \
        } \
        check() { \
            local parkourDestination = \
                gParkourLastPath.destination.getParkourModule(); \
            if (checkParkourProviderBarriers(gActor, gParkourLastPath)) { \
                applyRecon(); \
                gParkourLastPath.destination.applyRecon(); \
                parkourDestination.lexicalParent.checkInsert(gActor); \
                parkourDestination.doParkourCheck(gActor, gParkourLastPath); \
            } \
        } \
        action() { \
            if (checkProviderAccident(gActor, gParkourRunner, gParkourLastPath)) { \
                doParkourThroughProvider(gActor); \
                parkourDestination.doAllPunishmentsAndAccidents( \
                    gActor, gParkourRunner, gParkourLastPath \
                ); \
            } \
        } \
        report() { \
            reportParkour; \
        } \
    }

#define handleFloorCheck(roomRef) \
    else if (roomRef.ofKind(Room) && !roomRef.canGetOffFloor) { \
        illogical(alreadyOnFloorMsg); \
    }
    
#define verifyGetOffFloorRedirect \
    parkourCore.cacheParkourRunner(gActor); \
    local om = gPlayerChar.outermostVisibleParent(); \
    if (gParkourRunner.location != om) { \
        illogical(actorNotOnMsg); \
        return; \
    } \
    handleFloorCheck(om)

#define redirectJumpOffFloor(originalAction) \
    dobjFor(originalAction) { \
        preCond = nil \
        remap = nil \
        verify() { \
            verifyGetOffFloorRedirect \
        } \
        check() { } \
        action() { \
            gPlayerChar.outermostVisibleParent().jumpOffFloor(); \
        } \
        report() { } \
    }

#define redirectGetOffFloor(originalAction) \
    dobjFor(originalAction) { \
        preCond = nil \
        remap = nil \
        verify() { \
            verifyGetOffFloorRedirect \
        } \
        check() { } \
        action() { \
            gPlayerChar.outermostVisibleParent().getOffFloor(); \
        } \
        report() { } \
    }

#define parkourActionIntro \
    preCond = [parkourPreCond] \
    remap = nil

#define verifyJumpPathFromActor(actor, canBeUnknown) \
    parkourCore.cacheParkourRunner(actor); \
    gParkourLastPath = nil; \
    verifyAlreadyAtDestination(gParkourRunner); \
    local closestParkourMod = gParkourRunnerModule; \
    if (closestParkourMod == nil) { \
        local closestSurface = gParkourRunner.location; \
        if (!checkStagingExitLocationConnection(closestSurface.exitLocation)) { \
            illogical(noParkourPathFromHereMsg); \
            return; \
        } \
        /* At this point, we know there is a staging connection */ \
        /* tryStagingSolution will take over from here. */ \
        return; \
    } \
    else { \
        gParkourLastPath = getPathFrom(gParkourRunner, canBeUnknown); \
        if (gParkourLastPath == nil) { \
            illogical(noParkourPathFromHereMsg); \
            return; \
        } \
    }

#define verifyClimbPathFromActor(actor, canBeUnknown) \
    verifyJumpPathFromActor(actor, canBeUnknown) \
    if (gParkourLastPath != nil) { \
        if (gParkourLastPath.requiresJump) { \
            illogical(parkourNeedsJumpMsg); \
        } \
    }

#define verifyDirection(parkourDir, climbOrJump) \
    if (gParkourLastPath != nil) { \
        if (gParkourLastPath.direction != parkour##parkourDir##Dir) { \
            if (parkourCore.enforceDirectionality) { \
                illogical(parkourCannot##climbOrJump##parkourDir##Msg); \
                return; \
            } \
        } \
    }

#define verifyClimbDirPathFromActor(actor, parkourDir) \
    verifyJumpPathFromActor(actor, true) \
    verifyDirection(parkourDir, Climb) \
    if (gParkourLastPath.requiresJump) { \
        if (gParkourLastPath.isHarmful) { \
            illogical(parkourNeedsFallMsg); \
        } \
        else { \
            illogical(parkourNeedsJumpMsg); \
        } \
    }

#define verifyJumpDirPathFromActor(actor, parkourDir) \
    verifyJumpPathFromActor(actor, true) \
    verifyDirection(parkourDir, Jump)

// TODO: The first case of this seems to be redundant with tryStagingSolution
#define tryClimbInstead(climbAction) \
    if (gParkourLastPath == nil) { \
        /* Likely from standard container to parkour one */ \
        extraReport(parkourUnnecessaryJumpMsg + '\n'); \
        doGetOffParkourAlt(gParkourRunner); \
        return; \
    } \
    else if (!gParkourLastPath.requiresJump) { \
        extraReport(parkourUnnecessaryJumpMsg + '\n'); \
        doNested(climbAction, self); \
        return; \
    }

#define doGetOffParkourAlt(actor) \
    local closestSurface = gParkourRunner.location; \
    beginParkourReset(parkourCore.announceRouteAfterTrying); \
    doNested(GetOff, closestSurface)

#define tryStagingSolution(actor) \
    if (gParkourRunnerModule == nil) { \
        local closestSurface = gParkourRunner.location; \
        if (checkStagingExitLocationConnection(closestSurface.exitLocation)) { \
            beginParkourReset(parkourCore.announceRouteAfterTrying); \
            if (closestSurface.contType == On) { \
                doInstead(GetOff, closestSurface); \
            } \
            else { \
                doInstead(GetOut, closestSurface); \
            } \
            return; \
        } \
    }

#define doClimbFor(actor) \
    local closestParkourMod = gParkourRunnerModule; \
    if (closestParkourMod == nil) { \
        doGetOffParkourAlt(actor); \
    } \
    else { \
        beginParkour(parkourCore.announceRouteAfterTrying); \
        provideMoveFor(actor); \
    }

#define parkourSimplyClimb(parkourDir) \
    dobjFor(ParkourClimb##parkourDir##To) { \
        parkourActionIntro \
        verify() { \
            verifyClimbDirPathFromActor(gActor, parkourDir); \
        } \
        check() { checkParkour(gActor); } \
        action() { \
            tryStagingSolution(gParkourRunner); \
            doClimbFor(gParkourRunner); \
            doAllPunishmentsAndAccidents(gActor, gParkourRunner, gParkourLastPath); \
        } \
        report() { \
            reportParkour; \
        } \
    }

#define parkourSimplyJump(parkourDir) \
    dobjFor(ParkourJump##parkourDir##To) { \
        parkourActionIntro \
        verify() { \
            verifyJumpDirPathFromActor(gActor, parkourDir); \
        } \
        check() { checkParkour(gActor); } \
        action() { \
            tryStagingSolution(gParkourRunner); \
            tryClimbInstead(ParkourClimb##parkourDir##To); \
            doClimbFor(gParkourRunner); \
            doAllPunishmentsAndAccidents(gActor, gParkourRunner, gParkourLastPath); \
        } \
        report() { \
            reportParkour; \
        } \
    }

#define parkourReshapeGetOff(originalAction, redirectAction) \
    dobjFor(originalAction) { \
        verify() { \
            parkourCore.cacheParkourRunner(gActor); \
            local myOn = getStandardOn(); \
            if(!gParkourRunner.isIn(myOn) || \
                (myOn.contType != On && !myOn.ofKind(Room))) { \
                illogicalNow(actorNotOnMsg); \
            } \
            handleFloorCheck(myOn) \
        } \
        action() { \
            doInstead(redirectAction, exitLocation); \
        } \
        report() { } \
    }