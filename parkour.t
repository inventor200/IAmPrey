#define gParkourLastPath parkourCache.lastPath
#define gParkourRunner parkourCache.currentParkourRunner

#define expandedOnto ('onto'|'on' 'to')
#define expandedInto ('in'|'into'|'in' 'to'|'through')
#define expandedUpSideOf (('the'|) 'side' 'of'|'to'|)
#define genericOnTopOfPrep ('on'|expandedOnto|'on' 'top' 'of'|expandedOnto 'the' 'top' 'of'|'atop')
#define genericAcrossPrep ('over'|'across'|'over' 'to'|'across' 'to'|'to'|'onto'|'on' 'to') (('the'|)'top' 'of'|)

#define climbImplicitReport \
    implicitAnnouncement(success) { \
        if (success) { \
            return 'climbing to {the dobj}'; \
        } \
        return 'failing to climb to {the dobj}'; \
    }

VerbRule(ParkourClimbOverTo)
    ('climb'|'cl'|'get'|'step') genericAcrossPrep singleDobj
    : VerbProduction
    action = ParkourClimbOverTo
    verbPhrase = 'climb over to (what)'
    missingQ = 'what do you want to climb over to'
;

DefineTAction(ParkourClimbOverTo)
    climbImplicitReport
;

VerbRule(ParkourClimbOverInto)
    ('climb'|'cl'|'get'|'step') expandedInto singleDobj
    : VerbProduction
    action = ParkourClimbOverInto
    verbPhrase = 'climb through (what)'
    missingQ = 'what do you want to climb through'
;

DefineTAction(ParkourClimbOverInto)
    allowImplicit = nil
;

VerbRule(ParkourJumpOverTo)
    ('jump'|'hop'|'leap') genericAcrossPrep singleDobj
    : VerbProduction
    action = ParkourJumpOverTo
    verbPhrase = 'jump to (what)'
    missingQ = 'what do you want to jump to'
;

DefineTAction(ParkourJumpOverTo)
    allowImplicit = nil
;

VerbRule(ParkourJumpOverInto)
    ('jump'|'hop'|'leap') expandedInto singleDobj
    : VerbProduction
    action = ParkourJumpOverInto
    verbPhrase = 'jump through (what)'
    missingQ = 'what do you want to jump through'
;

DefineTAction(ParkourJumpOverInto)
    allowImplicit = nil
;

VerbRule(ParkourJumpUpTo)
    ('jump'|'hop'|'leap'|'clamber'|'scramble'|'wall' 'run'|'wallrun') 'up' expandedUpSideOf singleDobj |
    'clamber' singleDobj
    : VerbProduction
    action = ParkourJumpUpTo
    verbPhrase = 'jump up (what)'
    missingQ = 'what do you want to jump up'
;

DefineTAction(ParkourJumpUpTo)
    allowImplicit = nil
;

VerbRule(ParkourJumpUpInto)
    ('jump'|'hop'|'leap'|'clamber'|'scramble'|'wall' 'run'|'wallrun') 'up' expandedInto singleDobj |
    'clamber' singleDobj
    : VerbProduction
    action = ParkourJumpUpInto
    verbPhrase = 'jump up into (what)'
    missingQ = 'what do you want to jump up into'
;

DefineTAction(ParkourJumpUpInto)
    allowImplicit = nil
;

VerbRule(ParkourJumpDownTo)
    ('jump'|'hop'|'leap'|'clamber'|'scramble'|'drop'|'fall') 'down' 'to' singleDobj
    : VerbProduction
    action = ParkourJumpDownTo
    verbPhrase = 'jump down to (what)'
    missingQ = 'what do you want to jump down to'
;

DefineTAction(ParkourJumpDownTo)
    allowImplicit = nil
;

VerbRule(ParkourJumpDownInto)
    ('jump'|'hop'|'leap'|'clamber'|'scramble'|'drop'|'fall') 'down' expandedInto singleDobj
    : VerbProduction
    action = ParkourJumpDownInto
    verbPhrase = 'jump down into (what)'
    missingQ = 'what do you want to jump down into'
;

DefineTAction(ParkourJumpDownInto)
    allowImplicit = nil
;

VerbRule(ParkourClimbDownTo)
    ('climb'|'cl'|'get'|'step') 'down' 'to' singleDobj
    : VerbProduction
    action = ParkourClimbDownTo
    verbPhrase = 'climb down to (what)'
    missingQ = 'what do you want to climb down to'
;

DefineTAction(ParkourClimbDownTo)
    climbImplicitReport
;

VerbRule(ParkourClimbDownInto)
    ('climb'|'cl'|'get'|'step') 'down' expandedInto singleDobj
    : VerbProduction
    action = ParkourClimbDownInto
    verbPhrase = 'climb down into (what)'
    missingQ = 'what do you want to climb down into'
;

DefineTAction(ParkourClimbDownInto)
    allowImplicit = nil
;

VerbRule(ParkourClimbUpInto)
    ('climb'|'cl'|'mantel'|'mantle'|'go'|'walk'|'run'|'sprint') 'up' expandedInto singleDobj
    : VerbProduction
    action = ParkourClimbUpInto
    verbPhrase = 'climb up into (what)'
    missingQ = 'what do you want to climb up into'
;

DefineTAction(ParkourClimbUpInto)
    allowImplicit = nil
;

VerbRule(ParkourClimbUpTo)
    ('climb'|'cl'|'mantel'|'mantle'|'go'|'walk'|'run'|'sprint') 'up' expandedUpSideOf singleDobj
    : VerbProduction
    action = ParkourClimbUpTo
    verbPhrase = 'climb up to (what)'
    missingQ = 'what do you want to climb up to'
;

DefineTAction(ParkourClimbUpTo)
    climbImplicitReport
;

VerbRule(ParkourJumpGeneric)
    ('jump'|'hop'|'leap'|'jm') singleDobj
    : VerbProduction
    action = ParkourJumpGeneric
    verbPhrase = 'jump to (what)'
    missingQ = 'what do you want to jump to'
;

DefineTAction(ParkourJumpGeneric)
    allowImplicit = nil
;

VerbRule(ParkourClimbGeneric)
    ('climb'|'cl'|'mantel'|'mantle'|'mount'|'board') singleDobj |
    ('climb'|'cl'|'mantel'|'mantle'|'get'|'go') genericOnTopOfPrep singleDobj |
    'parkour' ('to'|'on'|) singleDobj
    : VerbProduction
    action = ParkourClimbGeneric
    verbPhrase = 'parkour to (what)'
    missingQ = 'what do you want to parkour to'
;

DefineTAction(ParkourClimbGeneric)
    climbImplicitReport
;

VerbRule(ParkourSlideUnder)
    ('slide'|'dive'|'roll'|'go'|'crawl'|'scramble'|'slither') 'under' singleDobj
    : VerbProduction
    action = ParkourSlideUnder
    verbPhrase = 'slide under (what)'
    missingQ = 'what do you want to slide under'
;

DefineTAction(ParkourSlideUnder)
    implicitAnnouncement(success) {
        if (success) {
            return 'sliding under {the dobj}';
        }
        return 'failing to slide under {the dobj}';
    }
;

VerbRule(ParkourJumpOver)
    ('jump'|'hop'|'leap'|'vault') ('over'|) singleDobj
    : VerbProduction
    action = ParkourJumpOver
    verbPhrase = 'jump over (what)'
    missingQ = 'what do you want to jump over'
;

DefineTAction(ParkourJumpOver)
    implicitAnnouncement(success) {
        if (success) {
            return 'jumping over {the dobj}';
        }
        return 'failing to jump over {the dobj}';
    }
;

VerbRule(ParkourRunAcross)
    ('run'|'sprint'|'hop'|'go'|'walk') 'across' singleDobj
    : VerbProduction
    action = ParkourRunAcross
    verbPhrase = 'run across (what)'
    missingQ = 'what do you want to run across'
;

DefineTAction(ParkourRunAcross)
    implicitAnnouncement(success) {
        if (success) {
            return 'running across {the dobj}';
        }
        return 'failing to run across {the dobj}';
    }
;

VerbRule(ParkourSwingOn)
    'swing' ('on'|'under'|'with'|'using'|'via'|'across') singleDobj
    : VerbProduction
    action = ParkourSwingOn
    verbPhrase = 'swing on (what)'
    missingQ = 'what do you want to swing on'
;

DefineTAction(ParkourSwingOn)
    implicitAnnouncement(success) {
        if (success) {
            return 'swinging on {the dobj}';
        }
        return 'failing to swing on {the dobj}';
    }
;

VerbRule(SlideUnder)
    ('slide'|'dive'|'roll'|'go'|'crawl'|'scramble'|'slither') 'under' singleDobj
    : VerbProduction
    action = SlideUnder
    verbPhrase = 'slide under (what)'
    missingQ = 'what do you want to slide under'
;

DefineTAction(SlideUnder)
    implicitAnnouncement(success) {
        if (success) {
            return 'sliding under {the dobj}';
        }
        return 'failing to slide under {the dobj}';
    }
;

VerbRule(RunAcross)
    ('run'|'sprint'|'hop'|'go'|'walk') 'across' singleDobj
    : VerbProduction
    action = RunAcross
    verbPhrase = 'run across (what)'
    missingQ = 'what do you want to run across'
;

DefineTAction(RunAcross)
    implicitAnnouncement(success) {
        if (success) {
            return 'running across {the dobj}';
        }
        return 'failing to run across {the dobj}';
    }
;

VerbRule(SwingOn)
    'swing' ('on'|'under'|'with'|'using'|'via'|'across') singleDobj
    : VerbProduction
    action = SwingOn
    verbPhrase = 'swing on (what)'
    missingQ = 'what do you want to swing on'
;

DefineTAction(SwingOn)
    implicitAnnouncement(success) {
        if (success) {
            return 'swinging on {the dobj}';
        }
        return 'failing to swing on {the dobj}';
    }
;

VerbRule(ParkourClimbOffOf)
    ('get'|'climb'|'cl'|'parkour') ('off'|'off' 'of'|'down' 'from') singleDobj
    : VerbProduction
    action = ParkourClimbOffOf
    verbPhrase = 'get off of (what)'
    missingQ = 'what do you want to get off of'
;

DefineTAction(ParkourClimbOffOf)
    implicitAnnouncement(success) {
        if (success) {
            return 'climbing off {the dobj}';
        }
        return 'failing to climb off {the dobj}';
    }
;

VerbRule(ParkourClimbOffIntransitive)
    ('get'|'climb'|'cl'|'parkour') ('off'|'down')
    : VerbProduction
    action = ParkourClimbOffIntransitive
    verbPhrase = 'climb/climbing off'        
;

DefineIAction(ParkourClimbOffIntransitive)
    allowAll = nil

    execAction(cmd) {
        parkourCache.cacheParkourRunner(gActor);
        doInstead(ParkourClimbOffOf, gParkourRunner.location);
    }
;

VerbRule(ParkourJumpOffOf)
    ('jump'|'hop'|'leap'|'fall'|'drop') ('off'|'off' 'of'|'down' 'from') singleDobj
    : VerbProduction
    action = ParkourJumpOffOf
    verbPhrase = 'jump off of (what)'
    missingQ = 'what do you want to jump off of'
;

DefineTAction(ParkourJumpOffOf)
    implicitAnnouncement(success) {
        if (success) {
            return 'jumping off of {the dobj}';
        }
        return 'failing to jump off of {the dobj}';
    }
;

VerbRule(ParkourJumpOffIntransitive)
    ('jump'|'hop'|'leap'|'fall'|'drop') ('off'|'down')
    : VerbProduction
    action = ParkourJumpOffIntransitive
    verbPhrase = 'jump/jumping off'        
;

DefineIAction(ParkourJumpOffIntransitive)
    allowAll = nil

    execAction(cmd) {
        parkourCache.cacheParkourRunner(gActor);
        doInstead(ParkourJumpOffOf, gParkourRunner.location);
    }
;

VerbRule(ShowParkourRoutes)
    ((('show'|'list'|'remember'|'review'|'ponder'|'study'|'find'|'search') ('all'|'available'|'known'|'familiar'|'traveled'|'travelled'|)|)
    (
        (('climbing'|'parkour') ('paths'|'pathways'|'options'|'routes')) |
        (('climbable'|'jumpable') ('paths'|'pathways'|'options'|'routes'|'platforms'|'surfaces'|'fixtures'|'things'|'spots'|'stuff'|'objects'|'furniture'|'ledges'|'places'))
    )) |
    ('parkour'|'prkr'|'pkr'|'pk'|'routes'|'paths'|'pathways')
    : VerbProduction
    action = ShowParkourRoutes
    verbPhrase = 'show/showing parkour routes'        
;

DefineIAction(ShowParkourRoutes)
    allowAll = nil

    execAction(cmd) {
        parkourCache.cacheParkourRunner(gActor);
        local closestParkourMod = gParkourRunner.getParkourModule();
        if (closestParkourMod != nil) {
            if (closestParkourMod.pathVector.length > 0) {
                local strBfr = new StringBuffer(6*closestParkourMod.pathVector.length);
                for (local i = 1; i <= closestParkourMod.pathVector.length; i++) {
                    local path = closestParkourMod.pathVector[i];

                    strBfr.append('{I} {can} ');
                    if (path.requiresJump) {
                        strBfr.append('JUMP ');
                    }
                    else {
                        strBfr.append('CLIMB ');
                    }
                    switch (path.direction) {
                        case parkourUpDir:
                            strBfr.append('up ');
                            break;
                        case parkourOverDir:
                            strBfr.append('over ');
                            break;
                        case parkourDownDir:
                            strBfr.append('down ');
                            break;
                    }
                    strBfr.append('to ');
                    strBfr.append(path.destination.parkourModule.theName);
                    strBfr.append('. ');
                }
                "<<toString(strBfr)>>";
                return;
            }
        }
        "<<parkourCache.noKnownRoutesMsg>>";
    }
;

#if __DEBUG
VerbRule(DebugCheckForContainer)
    'is' singleDobj ('a'|'an'|) ('container'|'item') |
    ('container'|'cont'|'c') 'check' ('for'|'on'|) singleDobj |
    ('ccheck'|'cc') singleDobj
    : VerbProduction
    action = DebugCheckForContainer
    verbPhrase = 'check (what) for container likelihood'
    missingQ = 'what do you want to check for container likelihood'
;

DefineTAction(DebugCheckForContainer)
;
#endif

//TODO: Mute parkour reports during implicit actions
parkourCache: object {
    requireRouteRecon = nil //FIXME: Set this to true after development is done
    formatForScreenReader = nil
    autoPathCanDiscover = nil

    cacheParkourRunner(actor) {
        local potentialVehicle = actor.location;
        while (potentialVehicle != nil && !potentialVehicle.ofKind(Room)) {
            if (potentialVehicle.isVehicle) {
                currentParkourRunner = potentialVehicle;
                return;
            }
            potentialVehicle = potentialVehicle.location;
        }
        
        currentParkourRunner = actor;
    }

    sayParkourRunnerError(actor) {
        if (gParkourRunner != actor) {
            say(gParkourRunner.cannotDoParkourInMsg);
            return;
        }

        say(actor.cannotDoParkourMsg);
    }

    lastPath = nil
    currentParkourRunner = nil
    noKnownRoutesMsg =
        '{I} {do} not {know} any routes from here. '
}

reachGhostTest_: Thing {
    isListed = nil
    isFixed = nil
    isLikelyContainer() {
        return nil;
    }
}

#define __PARKOUR_REACH_DEBUG nil

enum parkourReachSuccessful, parkourReachTopTooFar, parkourSubComponentTooFar;

QParkour: Special {
    priority = 16
    active = true

    reachProblemVerify(a, b) {
        local issues = [];

        // Don't worry about room connections
        if (a.ofKind(Room) || b.ofKind(Room)) return issues; //FIXME: Do we need this?

        local aItem = nil;
        local aLoc = nil;
        local doNotFactorJumpForA = nil;
        local bItem = nil;
        local bLoc = nil;
        local doNotFactorJumpForB = nil;

        if (a.isLikelyContainer()) {
            aLoc = a;
            doNotFactorJumpForA = true;
            #if __PARKOUR_REACH_DEBUG
            extraReport('\b(LOC A: <<aLoc.theName>> (<<aLoc.contType.prep>>).)\b');
            #endif
        }
        else {
            aItem = a;
            aLoc = a.location;
            #if __PARKOUR_REACH_DEBUG
            extraReport('\b(ITEM A: <<aItem.theName>> (<<aItem.contType.prep>>).)\b');
            #endif
        }

        if (b.isLikelyContainer()) {
            bLoc = b;
            doNotFactorJumpForB = true;
            #if __PARKOUR_REACH_DEBUG
            extraReport('\b(LOC B: <<bLoc.theName>> (<<bLoc.contType.prep>>).)\b');
            #endif
        }
        else {
            bItem = b;
            bLoc = b.location;
            #if __PARKOUR_REACH_DEBUG
            extraReport('\b(ITEM B: <<bItem.theName>> (<<bItem.contType.prep>>).)\b');
            #endif
        }

        local parkourB = b.getParkourModule();
        if (parkourB == nil) {
            local parkourA = a.getParkourModule();
            if (parkourA != nil) {
                local reachResult = parkourA.isInReachFromVerbose(
                    b, true, doNotFactorJumpForA
                );
                if (reachResult != parkourReachSuccessful) {
                    issues += getMessageFromReachResult(
                        a, b, aItem, bItem, aLoc, bLoc, reachResult
                    );
                    return issues;
                }
            }
        }
        else {
            local reachResult = parkourB.isInReachFromVerbose(
                a, true, doNotFactorJumpForB
            );
            if (reachResult != parkourReachSuccessful) {
                issues += getMessageFromReachResult(
                    a, b, aItem, bItem, aLoc, bLoc, reachResult
                );
                return issues;
            }
        }

        return issues;
    }

    getMessageFromReachResult(a, b, aItem, bItem, aLoc, bLoc, reachResult) {
        switch (reachResult) {
            case parkourReachTopTooFar:
                return new ReachProblemParkour(
                    a, b, aItem, bItem, aLoc, bLoc
                );
            case parkourSubComponentTooFar:
                return new ReachProblemParkourFromTopOfSame(
                    a, b, aItem, bItem, aLoc, bLoc
                );
        }
        return new ReachProblemDistance(a, b);
    }
}

class ReachProblemParkourBase: ReachProblemDistance {
    construct(source, target, srcItem, trgItem, srcLoc, trgLoc) {
        inherited(source, target);
        srcItem_ = srcItem;
        srcLoc_ = srcLoc;
        trgItem_ = trgItem;
        trgLoc_ = trgLoc;
    }

    srcItem_ = nil;
    srcLoc_ = nil;
    trgItem_ = nil;
    trgLoc_ = nil;

    trgItemName = (trgItem_.theName);
    trgItemIs() {
        if (trgItem_.person == 1) {
            return '{am|was}';
        }
        if (trgItem_.plural || trgItem_.person == 2) {
            return '{are|were}';
        }
        return '{is|was}';
    }
    trgItemNameIs = (trgItemName + ' ' + trgItemIs())

    trgLocName = (trgLoc_.theName);
    trgLocIs() {
        if (trgLoc_.person == 1) {
            return '{am|was}';
        }
        if (trgLoc_.plural || trgLoc_.person == 2) {
            return '{are|were}';
        }
        return '{is|was}';
    }
    trgLocNameIs = (trgLocName + ' ' + trgLocIs())
}

// General error for being unable to reach, due to parkour limitations
class ReachProblemParkour: ReachProblemParkourBase {
    tooFarAwayMsg() {
        if (trgItem_ == nil) {
            if (trgLoc_.contType == On || trgLoc_.partOfParkourSurface) {
                return 'The top of <<trgLocNameIs>> out of reach. ';
            }
            return 'That part of <<trgLocNameIs>> out of reach. ';
        }

        if (trgLoc_.contType == On) {
            return '\^<<trgItemNameIs>> on top of <<trgLocName>>,
                which <<trgLocIs>> out of reach. ';
        }
        return '\^<<trgItemNameIs>> <<trgLoc_.contType.prep>> <<trgLocName>>,
            which <<trgLocIs>> out of reach. ';
    }
}

// Error for attempt to reach inside of container while standing on top of it
class ReachProblemParkourFromTopOfSame: ReachProblemParkourBase {
    tooFarAwayMsg() {
        if (trgItem_ == nil) {
            if (trgLoc_.contType == On || trgLoc_.partOfParkourSurface) {
                return 'The top of <<trgLocName>> {cannot} be reached from {here}. ';
            }
            return 'That part of <<trgLocName>> {cannot} be reached from {here}. ';
        }

        if (trgLoc_.contType == On) {
            return '\^<<trgItemNameIs>> on top of <<trgLocName>>,
                and that part {cannot} be reached from {here}. ';
        }
        return '\^<<trgItemNameIs>> <<trgLoc_.contType.prep>> <<trgLocName>>,
            and that part {cannot} be reached from {here}. ';
    }
}

#define __PARKOUR_PATHING_DEBUG true

class parkourPathStep: object {
    construct(nextLoc_, nextParkourMod_, parkourDir_) {
        nextLoc = nextLoc_;
        nextParkourMod = nextParkourMod_;
        parkourDir = parkourDir_;
    }

    nextLoc = nil;
    nextParkourMod = nil;
    parkourDir = nil;
}

// Modifying the behavior for moving actors into position
modify actorInStagingLocation {
    checkPreCondition(obj, allowImplicit) {
        local stagingLoc = obj.stagingLocation;
        parkourCache.cacheParkourRunner(gActor);
        local loc = gParkourRunner.location;

        if (loc == stagingLoc) return true; // FREE!!

        // Attempting to do parkour in invalid vehicle
        if (!gParkourRunner.fitForParkour) {
            parkourCache.sayParkourRunnerError(gActor);
        }

        if (allowImplicit) {
            local tookSteps = nil;

            // Handle parkour pathing
            local getActorToFloorLst = getPathToFloor(loc, nil);
            local getObjectToFloorLst = getPathToFloor(stagingLoc, true);

            local actorGoalIndex = 1;
            local objectStartIndex = 1;

            local connectionFound = nil;

            for (local i = 1; i <= getObjectToFloorLst.length; i++) {
                local objectNode = getObjectToFloorLst[i];
                local objectParkourMod = objectNode.nextParkourMod;
                objectStartIndex = i;
                for (local j = 1; j <= getActorToFloorLst.length; j++) {
                    local actorNode = getActorToFloorLst[j];
                    local actorParkourMod = actorNode.nextParkourMod;
                    actorGoalIndex = j;

                    // Do we happen to connect?
                    if (objectNode.nextLoc == actorNode.nextLoc) {
                        connectionFound = true;
                        break;
                    }

                    local connPath = getValidPathStep(
                        actorNode.nextLoc, objectNode.nextLoc,
                        actorParkourMod, objectParkourMod, nil
                    );

                    if (connPath != nil) {
                        #if __PARKOUR_PATHING_DEBUG
                        extraReport('ConnPath ' +
                            actorNode.nextLoc.theName +
                            'to ' +
                            objectNode.nextLoc.theName + ' found!\n');
                        #endif
                        getActorToFloorLst += connPath;
                        connectionFound = true;
                        break;
                    }
                }
                if (connectionFound) break;
            }

            // Hail-Mary Clause
            if (!connectionFound) {
                local connPath = getValidPathStep(
                    loc, stagingLoc,
                    loc.getParkourModule(), stagingLoc.getParkourModule(), nil
                );

                if (connPath != nil) {
                    #if __PARKOUR_PATHING_DEBUG
                    extraReport('Hail Mary ConnPath from ' +
                        loc.theName +
                        ' to ' +
                        stagingLoc.theName + ' found!\n');
                    #endif
                    getActorToFloorLst += connPath;
                    connectionFound = true;
                }
            }

            // Valid path found!
            if (connectionFound) {
                local stepSuccess = nil;
                #if __PARKOUR_PATHING_DEBUG
                extraReport('CONNECTION FOUND!\n');
                #endif

                // Perform path
                for (local i = 1; i <= actorGoalIndex; i++) {
                    local nextStep = getActorToFloorLst[i];
                    #if __PARKOUR_PATHING_DEBUG
                    extraReport('Next stop: ' + nextStep.nextLoc.theName + '\n');
                    #endif
                    stepSuccess = doPathStep(gParkourRunner, nextStep, nil);
                    if (!stepSuccess) break;
                    else {
                        tookSteps = true;
                    }
                }

                if (gParkourRunner.location == stagingLoc) return true;

                if (getObjectToFloorLst.length > 0) {
                    /*
                     * Honestly, if a connection was found and the object-side
                     * path is empty, then the actor-side path should have brought
                     * victory. There should be absolutely no reason why we are
                     * here, unless something went hilariously-wrong on the actor-
                     * side calculation, which should be airtight.
                     * Either way, I'm include the above length check for cleaner
                     * error report, and perfectionism.
                     */
                    if (stepSuccess) {
                        for (local i = objectStartIndex; i >= 1; i--) {
                            local nextStep = getObjectToFloorLst[i];
                            #if __PARKOUR_PATHING_DEBUG
                            extraReport('Next stop: ' + nextStep.nextLoc.theName + '\n');
                            #endif
                            stepSuccess = doPathStep(gParkourRunner, nextStep, true);
                            if (!stepSuccess) break;
                            else {
                                tookSteps = true;
                            }
                        }
                    }

                    if (gParkourRunner.location == stagingLoc) return true;
                }
            }

            if (tookSteps && gParkourRunner.location != stagingLoc) {
                extraReport('\n({I} {get} as far as
                    <<gParkourRunner.location.theName>>
                    before the path {becomes|became} too uncertain.)\n');
            }
        }

        local realStagingLocation = stagingLoc;
        local stagingMod = realStagingLocation.getParkourModule();
        if (stagingMod != nil) {
            realStagingLocation = stagingMod;
        }

        say('{I} need{s/ed} to be
            <<realStagingLocation.objInPrep>> <<realStagingLocation.theName>>
            to do that. ');
        return nil;
    }

    doPathStep(actor, nextStep, goingUp) {
        local oldLoc = actor.location;
        local nextLoc = nextStep.nextLoc;

        if (oldLoc == nextLoc) return true;

        local action = nil;
        local nextParkourMod = nextStep.nextParkourMod;

        // All parkour steps will have a registered direction
        if (nextStep.parkourDir != nil) {
            switch (nextStep.parkourDir) {
                case parkourUpDir:
                    tryImplicitAction(ParkourClimbUpTo, nextParkourMod);
                    break;
                case parkourOverDir:
                    tryImplicitAction(ParkourClimbOverTo, nextParkourMod);
                    break;
                case parkourDownDir:
                    tryImplicitAction(ParkourClimbDownTo, nextParkourMod);
                    break;
            }
        }
        else if (goingUp) {
            // Entering nextLoc ins, and boarding nextLoc ons
            action = nextLoc.contType == In ? Enter : Board;
        }
        else {
            // Getting out of oldLoc ins, and getting off of oldLoc ons
            action = oldLoc.contType == In ? GetOutOf : GetOff;
        }

        if (action != nil) {
            tryImplicitAction(action, goingUp ? nextLoc : oldLoc);
        }

        return actor.location == nextLoc;
    }

    #if __PARKOUR_PATHING_DEBUG
    reportLocList(lst) {
        for (local i = 1; i <= lst.length; i++) {
            extraReport(lst[i].nextLoc.theName + ' (' + lst[i].nextLoc.contType.prep + ')\n');
        }
    }
    #endif

    getPathToFloor(loc, goingUp) {
        #if __PARKOUR_PATHING_DEBUG
        extraReport('\bPATH TO FLOOR (' + (goingUp ? 'going up' : 'going down') + ')\n');
        #endif
        local travelProp = goingUp ? &stagingLocation : &exitLocation;
        local lst = [];
        local room = loc;
        if (!room.ofKind(Room)) {
            room = room.getOutermostRoom();
        }

        // Start us with our current spot
        //lst += new parkourPathStep(loc, nil);

        if (loc == room) {
            #if __PARKOUR_PATHING_DEBUG
            reportLocList(lst);
            #endif
            return lst;
        }

        local nextParkourMod = loc.getParkourModule();

        do {
            local next = loc.(travelProp);
            local locParkourMod = nextParkourMod;
            nextParkourMod = next.getParkourModule();

            local pathStep = getValidPathStep(
                loc, next, locParkourMod, nextParkourMod, goingUp
            );

            if (pathStep != nil) {
                lst += pathStep;
            }
            else {
                break;
            }

            loc = next;
        } while (loc != room);

        #if __PARKOUR_PATHING_DEBUG
        reportLocList(lst);
        #endif
        return lst;
    }

    getValidPathStep(loc, next, locParkourMod, nextParkourMod, goingUp) {
        local directionFound = nil;

        // Verify parkour path
        if (locParkourMod != nil && nextParkourMod != nil) {
            // Make sure we are not asking for jumps.
            // Also, direction matters, so find our start and end:
            local parkourStart = goingUp ? nextParkourMod : locParkourMod;
            local parkourEnd = goingUp ? locParkourMod : nextParkourMod;

            local path = parkourEnd.getPathFrom(
                parkourStart, parkourCache.autoPathCanDiscover
            );

            // Failed path
            if (path == nil) {
                // Looks this is as far as we go!
                return nil;
            }

            // Jump path
            if (path.requiresJump) {
                // Do not require jump to proceed!!
                return nil;
            }

            // Valid path
            directionFound = path.direction;
        }

        // Check valid simple path
        if (directionFound == nil) {
            if (goingUp) {
                if (loc.stagingLocation != next) return nil;
            }
            else {
                if (loc.exitLocation != next) return nil;
            }
        }

        return new parkourPathStep(
            goingUp ? loc : next,
            goingUp ? locParkourMod : nextParkourMod, directionFound);
    }
}

#define parkourPreCond touchObj

#define dobjParkourRemap(parkourAction, remapAction) \
    dobjFor(parkourAction) { \
        preCond = [parkourPreCond] \
        remap = (getParkourModule()) \
        verify() { } \
        check() { } \
        action() { \
            doInstead(remapAction, self); \
        } \
        report() { } \
    }

#define dobjParkourIntoRemap(remapAction, climbOrJump, parkourDir, remapDest) \
    dobjFor(Parkour##climbOrJump##parkourDir##Into) { \
        preCond = [parkourPreCond] \
        remap = (remapDest) \
        verify() { } \
        check() { \
            parkourCache.cacheParkourRunner(gActor); \
            if (!gParkourRunner.fitForParkour) { \
                parkourCache.sayParkourRunnerError(gActor); \
            } \
        } \
        action() { \
            if (gParkourRunner.location != stagingLocation) { \
                local stagingParkourModule = stagingLocation.getParkourModule(); \
                if (stagingParkourModule == nil) { \
                    tryImplicitAction(stagingLocation.climbOnAlternative, stagingLocation); \
                } \
                else { \
                    tryImplicitAction(Parkour##climbOrJump##parkourDir##To, stagingParkourModule); \
                } \
            } \
            doInstead(remapAction, self); \
        } \
        report() { } \
    }

#define fastParkourClimbMsg(upPrep, overPrep, downPrep, capsActionStr, conjActionString) \
    getClimbUpDiscoverMsg() { \
        return '(It seems that {i} {can} ' + capsActionStr + ' ' + upPrep + ' <<theName>>!) '; \
    } \
    getClimbOverDiscoverMsg() { \
        return '(It seems that {i} {can} ' + capsActionStr + ' ' + overPrep + ' <<theName>>!) '; \
    } \
    getClimbDownDiscoverMsg() { \
        return '(It seems that {i} {can} ' + capsActionStr + ' ' + downPrep + ' <<theName>>!) '; \
    } \
    getClimbUpMsg() { \
        return '{I} ' + conjActionString + ' ' + upPrep + ' <<theName>>. '; \
    } \
    getClimbOverMsg() { \
        return '{I} ' + conjActionString + ' ' + overPrep + ' <<theName>>. '; \
    } \
    getClimbDownMsg() { \
        return '{I} ' + conjActionString + ' ' + downPrep + ' <<theName>>. '; \
    }

#define fastParkourJumpMsg(upPrep, overPrep, downPrep, capsActionStr, conjActionString) \
    getJumpUpDiscoverMsg() { \
        return '(It seems that {i} {can} ' + capsActionStr + ' ' + upPrep + ' <<theName>>!) '; \
    } \
    getJumpOverDiscoverMsg() { \
        return '(It seems that {i} {can} ' + capsActionStr + ' ' + overPrep + ' <<theName>>!) '; \
    } \
    getJumpDownDiscoverMsg() { \
        return '(It seems that {i} {can} ' + capsActionStr + ' ' + downPrep + ' <<theName>>!) '; \
    }

#define fastParkourMessages(upPrep, overPrep, downPrep) \
    fastParkourClimbMsg(upPrep, overPrep, downPrep, 'CLIMB', 'climb{s/ed}') \
    fastParkourJumpMsg(upPrep, overPrep, downPrep, 'JUMP', 'jump{s/ed}') \
    getJumpUpMsg() { \
        return '{I} jump{s/ed} and climb{s/ed} ' + upPrep + ' <<theName>>. '; \
    } \
    getJumpOverMsg() { \
        return '{I} leap{s/ed} ' + overPrep + ' <<theName>>. '; \
    } \
    getJumpDownMsg() { \
        return '{I} carefully drop{s/?ed} ' + downPrep + ' <<theName>>. '; \
    } \
    getFallDownMsg() { \
        return '{I} {fall} ' + downPrep + ' <<theName>>, with a hard landing. '; \
    }

modify Thing {
    parkourModule = nil

    prepForParkour() {
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
        remapDobjJumpOver = parkourModule;
        remapDobjSlideUnder = parkourModule;
        remapDobjRunAcross = parkourModule;
        remapDobjSwingOn = parkourModule;
    }

    getParkourModule() {
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
        if (parkourModule != nil) return true;
        if (contType == Outside) return nil;
        if (contType == Carrier) return nil;
        if (isFixed) {
            if (gParkourRunner == self) return nil;
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

    climbOnAlternative = (isClimbable ? Climb : (canClimbUpMe ? ClimbUp : Board))
    climbOffAlternative = (canClimbDownMe ? ClimbDown : GetOff)
    enterAlternative = (canGoThroughMe ? GoThrough : Enter)
    jumpOffAlternative = JumpOff

    dobjParkourRemap(ParkourClimbGeneric, climbOnAlternative)
    dobjParkourRemap(ParkourJumpGeneric, climbOnAlternative)
    dobjParkourRemap(ParkourClimbUpTo, climbOnAlternative)
    dobjParkourRemap(ParkourJumpUpTo, climbOnAlternative)
    dobjParkourRemap(ParkourClimbOverTo, climbOnAlternative)
    dobjParkourRemap(ParkourJumpOverTo, climbOnAlternative)
    dobjParkourRemap(ParkourClimbDownTo, climbOnAlternative)
    dobjParkourRemap(ParkourJumpDownTo, climbOnAlternative)

    dobjParkourIntoRemap(enterAlternative, Climb, Up, remapIn)
    dobjParkourIntoRemap(enterAlternative, Jump, Up, remapIn)
    dobjParkourIntoRemap(enterAlternative, Climb, Over, remapIn)
    dobjParkourIntoRemap(enterAlternative, Jump, Over, remapIn)
    dobjParkourIntoRemap(enterAlternative, Climb, Down, remapIn)
    dobjParkourIntoRemap(enterAlternative, Jump, Down, remapIn)

    dobjParkourRemap(ParkourJumpOver, JumpOver)
    dobjParkourRemap(ParkourSlideUnder, SlideUnder)
    dobjParkourRemap(ParkourRunAcross, RunAcross)
    dobjParkourRemap(ParkourSwingOn, SwingOn)

    dobjParkourRemap(ParkourClimbOffOf, climbOffAlternative)
    dobjParkourRemap(ParkourJumpOffOf, jumpOffAlternative)

    // Simulate an object on top of this IObj, and do a reach test.
    passesGhostReachTest() {
        reachGhostTest_.moveInto(self);
        local canReachResult = Q.canReach(gActor, reachGhostTest_);
        reachGhostTest_.moveInto(nil);
        return canReachResult;
    }

    iobjFor(PutOn) {
        verift() {
            if (!passesGhostReachTest()) {
                illogical('{I} {cannot} reach the top of {the iobj}. ');
            }
            inherited();
        }
    }

    iobjFor(PutIn) {
        verift() {
            if (!passesGhostReachTest()) {
                illogical('{I} {cannot} reach inside of {the iobj}. ');
            }
            inherited();
        }
    }

    // Can this Thing perform parkour?
    fitForParkour = nil
    parkourBarriers = nil

    canSlideUnderMe = nil

    dobjFor(SlideUnder) {
        preCond = [parkourPreCond]

        remap = remapUnder

        verify() { 
            if(!canSlideUnderMe) {
                illogical(cannotSlideUnderMsg);
            }
        }
        action() { }
        report() {
            "{I} {slide} under {the subj dobj}. ";
        }
    }

    canRunAcrossMe = nil

    dobjFor(RunAcross) {
        preCond = [parkourPreCond]

        remap = remapOn

        verify() { 
            if(!canRunAcrossMe) {
                illogical(cannotRunAcrossMsg);
            }
        }
        action() { }
        report() {
            "{I} {run} across {the subj dobj}. ";
        }
    }

    canSwingOnMe = nil

    dobjFor(SwingOn) {
        preCond = [parkourPreCond]

        remap = remapUnder

        verify() { 
            if(!canSwingOnMe) {
                illogical(cannotSwingOnMsg);
            }
        }
        action() { }
        report() {
            "{I} {swing} on {the subj dobj}, and {let} go. ";
        }
    }

    #if __DEBUG
    dobjFor(DebugCheckForContainer) {
        preCond = nil
        verify() { }
        check() { }
        action() {
            if (remapOn != nil) {
                doNested(DebugCheckForContainer, remapOn);
            }
            if (remapIn != nil) {
                doNested(DebugCheckForContainer, remapIn);
            }
            if (remapUnder != nil) {
                doNested(DebugCheckForContainer, remapUnder);
            }
            if (remapBehind != nil) {
                doNested(DebugCheckForContainer, remapBehind);
            }
        }
        report() {
            local status = isLikelyContainer();
            local parkourStatusStr = (getParkourModule() == nil ?
                ', and is not prepared for parkour' :
                ', and is prepared for parkour'
            );
            if (status) {
                "{The subj dobj} is likely a container<<parkourStatusStr>>. ";
            }
            else {
                "{The subj dobj} is likely an item<<parkourStatusStr>>. ";
            }
        }
    }
    #endif

    cannotSlideUnderMsg =
        '{The subj dobj} {is} not something {i} {can} slide under. '
    cannotRunAcrossMsg =
        '{The subj dobj} {is} not something {i} {can} run across. '
    cannotSwingOnMsg =
        '{The subj dobj} {is} not something {i} {can} swing on. '
    noParkourPathFromHereMsg =
        '{I} {know} no path to get there. '
    parkourNeedsJumpMsg =
        '{I} need{s/ed} to JUMP instead, if {i} want{s/ed} to get there. '
    parkourNeedsFallMsg =
        '{I} need{s/ed} to JUMP instead, if {i} want{s/ed} to get there.
        However, the drop seems rather dangerous...! '
    parkourUnnecessaryJumpMsg =
        '({I} {can} get there easily, so {i} decide{s/d} against jumping.) '
    parkourCannotClimbUpMsg =
        '{I} {cannot} climb up to {that dobj}. '
    parkourCannotClimbOverMsg =
        '{I} {cannot} climb over to {that dobj}. '
    parkourCannotClimbDownMsg =
        '{I} {cannot} climb down to {that dobj}. '
    parkourCannotJumpUpMsg =
        '{I} {cannot} jump up to {that dobj}. '
    parkourCannotJumpOverMsg =
        '{I} {cannot} jump over to {that dobj}. '
    parkourCannotJumpDownMsg =
        '{I} {cannot} jump down to {that dobj}. '
    cannotDoParkourInMsg =
        ('{I} {cannot} do parkour in <<theName>>. ')
    cannotDoParkourMsg =
        '{I} {cannot} do parkour right now. '

    fastParkourMessages('up to the top of', 'over to', 'down to')
}

modify Room {
    parkourModule = perInstance(new ParkourModule(self))

    isLikelyContainer() {
        return true;
    }

    getParkourModule() {
        return parkourModule;
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
}

modify SubComponent {
    parkourModule = (lexicalParent == nil ? nil : lexicalParent.parkourModule)

    // In case the "IN" part is on the top of the container
    partOfParkourSurface = nil
    // For drawers on a short desk, for example
    isInReachOfParkourSurface = (partOfParkourSurface)

    isLikelyContainer() {
        if (parkourModule != nil) return true;
        return lexicalParent.isLikelyContainer();
    }

    getParkourModule() {
        if (lexicalParent != nil) {
            if (lexicalParent.remapOn == self || partOfParkourSurface) {
                return lexicalParent.getParkourModule();
            }
            return nil;
        }
        return inherited();
    }

    #if __DEBUG
    dobjFor(DebugCheckForContainer) {
        preCond = nil
        verify() { }
        check() { }
        action() {
            local status = isLikelyContainer();
            local parkourStatusStr = (getParkourModule() == nil ?
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
}

#define checkParkour(actor) \
    checkInsert(actor); \
    doParkourCheck(actor, gParkourLastPath)

#define parkourActionIntro \
    preCond = [parkourPreCond] \
    remap = nil

#define verifyClimbPathFromActor(actor, canBeUnknown) \
    verifyJumpPathFromActor(actor, canBeUnknown) \
    if (gParkourLastPath.requiresJump) { \
        illogical(parkourNeedsJumpMsg); \
    }

#define verifyJumpPathFromActor(actor, canBeUnknown) \
    parkourCache.cacheParkourRunner(actor); \
    gParkourLastPath = getPathFrom(gParkourRunner, canBeUnknown); \
    if (gParkourLastPath == nil) { \
        illogical(noParkourPathFromHereMsg); \
        return; \
    }

#define verifyDirection(parkourDir, climbOrJump) \
    if (gParkourLastPath.direction != parkour##parkourDir##Dir) { \
        illogical(parkourCannot##climbOrJump##parkourDir##Msg); \
        return; \
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

#define tryClimbInstead(climbAction) \
    if (!gParkourLastPath.requiresJump) { \
        extraReport(parkourUnnecessaryJumpMsg + '\n'); \
        doNested(climbAction, self); \
        return; \
    }

#define learnPath(path, reportMethod) \
    if (!path.isKnown) { \
        path.isTrulyKnown = true; \
        reportMethod('(It seems that ' + path.getDiscoverMsg() + '!)\n'); \
    }

#define doClimbFor(actor) \
    learnPath(gParkourLastPath, extraReport); \
    provideMoveFor(actor)

#define reportParkour \
    "<<gParkourLastPath.getPerformMsg()>>";

#define parkourSimplyClimb(parkourDir) \
    dobjFor(ParkourClimb##parkourDir##To) { \
        parkourActionIntro \
        verify() { \
            verifyClimbDirPathFromActor(gActor, parkourDir); \
        } \
        check() { checkParkour(gActor); } \
        action() { \
            doClimbFor(gParkourRunner); \
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
            tryClimbInstead(ParkourClimb##parkourDir##To); \
            doClimbFor(gParkourRunner); \
        } \
        report() { \
            reportParkour; \
        } \
    }

//TODO: Complete, and implement for providers
#define parkourSimpleUseProviderFromDest(providedAction) \
    dobjFor(Parkour##providedAction) { \
        /* FIXME: If we are just redirecting, do we need this PreCond? */ \
        preCond = [touchObj] \
        verify() { \
            if(!can##providedAction##Me) { \
                illogical(cannot##providedAction##Msg); \
            } \
            /*TODO: Check for known providers*/ \
        } \
        action() { \
            doClimbFor(gParkourRunner); \
        } \
        report() { \
            reportParkour; \
        } \
    }

#define parkourReshapeGetOff(originalAction, redirectAction) \
    dobjFor(originalAction) { \
        verify() { \
            parkourCache.cacheParkourRunner(gActor); \
            local myOn = getStandardOn(); \
            if(!gParkourRunner.isIn(myOn) || myOn.contType != On) { \
                illogicalNow(actorNotOnMsg); \
            } \
        } \
        action() { \
            doInstead(redirectAction, exitLocation); \
        } \
        report() { } \
    }

class ParkourModule: SubComponent {
    construct(prkrParent?) {
        if (prkrParent != nil) {
            lexicalParent = prkrParent;
            parent = prkrParent;
        }
        //say('\bConstructed!\b');
        inherited();
        preinitThing();
    }

    // Stuff for vocab
    // It seems like the init status of a room is not always
    // timed well for the init status of a ParkourModule,
    // so just require it to take the current info.
    aName = (getVocabFromParent(&aName))
    theName = (getVocabFromParent(&theName))
    theObjName = (getVocabFromParent(&theObjName))
    objName = (getVocabFromParent(&objName))
    possAdj = (getVocabFromParent(&possAdj))
    possNoun = (getVocabFromParent(&possNoun))
    name = (getVocabFromParent(&name))
    proper = (getVocabFromParent(&proper))
    qualified = (getVocabFromParent(&qualified))
    person = (getVocabFromParent(&person))
    plural = (getVocabFromParent(&plural))
    massNoun = (getVocabFromParent(&massNoun))
    isHim = (getVocabFromParent(&isHim))
    isHer = (getVocabFromParent(&isHer))
    isIt = (getVocabFromParent(&isIt))
    getVocabFromParent(vProp) {
        if (parent == nil) return '(oops)';
        if (parent.ofKind(Room)) {
            if (parent.floorObj != nil) {
                return parent.floorObj.(vProp);
            }
        }
        return parent.(vProp);
    }
    // End stuff for vocab

    parkourModule = self

    pathVector = perInstance(new Vector())
    preInitDone = nil

    preinitThing() { // Safety check
        if (preInitDone) return;
        inherited();
        //say('\bPreinit!\b');
        preInitDone = true;
    }

    // Mostly follows default SubComponent functionality
    initializeSubComponent(parent) {
        if(parent == nil) return;
        location = parent;
       
        // Parkour is typically "On", arbitrarily
        contType = On;
        listOrder = contType.listOrder;
    }

    getParkourModule() {
        return self;
    }

    //TODO: Parkour punishments and accidents

    checkLeaving(actor, traveler, path) {
        return true;
    }

    checkArriving(actor, traveler, path) {
        return true;
    }

    //TODO: Provider-specific checks
    doParkourCheck(actor, path) {
        local source = gParkourRunner.getParkourModule();

        if (gParkourRunner.fitForParkour) {
            if (source.checkLeaving(actor, gParkourRunner, path)) {
                if (checkArriving(actor, gParkourRunner, path)) {
                    local passed = true;
                    local barriers = [];
                    barriers += valToList(parkourBarriers);
                    barriers += valToList(path.parkourBarriers);

                    for (local i = 1; i <= barriers.length; i++) {
                        local barrier = barriers[i];
                        // Note: Args are traveler, path
                        // instead of     traveler, connector
                        passed = barrier.checkTravelBarrier(gParkourRunner, path);
                        if (!passed) {
                            barrier.explainTravelBarrier(gParkourRunner, path);
                            break;
                        }
                    }
                    if (!passed) return nil;
                }
                else {
                    return nil;
                }
            }
            else {
                return nil;
            }
        }
        else {
            parkourCache.sayParkourRunnerError(actor);
            return nil;
        }

        return true;
    }

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
        pathVector.append(parkourPath);
    }

    provideMoveFor(actor) {
        local plat = parent;
        if (plat.remapOn != nil) {
            plat = plat.remapOn;
        }
        actor.actionMoveInto(plat);
    }

    getPathFrom(source, canBeUnknown?) {
        local closestParkourMod = source.getParkourModule();
        if (closestParkourMod == nil) return nil;
        if (closestParkourMod == self) return nil;
        local jumpPath = nil;
        for (local i = 1; i <= closestParkourMod.pathVector.length; i++) {
            local path = closestParkourMod.pathVector[i];
            if (path.destination != self.lexicalParent) continue;
            if (path.isKnown || canBeUnknown) {
                if (path.requiresJump) {
                    jumpPath = path;
                }
                else {
                    return path; // Prioritize climbing
                }
            }
        }

        return jumpPath;
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

    isInReachFrom(source, canBeUnknown?, doNotFactorJump?) {
        return isInReachFromVerbose(source, canBeUnknown, doNotFactorJump) == parkourReachSuccessful;
    }

    isInReachFromVerbose(source, canBeUnknown?, doNotFactorJump?) {
        #if __PARKOUR_REACH_DEBUG
        extraReport('\bREACH TO: <<theName>>\b');
        #endif
        if (source == gActor) {
            parkourCache.cacheParkourRunner(source);
            source = gParkourRunner;
        }
        #if __PARKOUR_REACH_DEBUG
        extraReport('\bTesting source: <<source.theName>> (<<source.contType.prep>>)\b');
        #endif
        local closestParkourMod = source.getParkourModule();
        if (closestParkourMod == nil) {
            // Last ditch ideas for related non-parkour containers!
            // If the source left its current container,
            // would it be on us?
            local realSource = source;
            if (!source.isLikelyContainer() && source.location != nil) {
                // Likely an actor or item; test its location
                realSource = source.location;
            }
            #if __PARKOUR_REACH_DEBUG
            extraReport('\bNo parkour mod on <<realSource.theName>> (<<realSource.contType.prep>>).\b');
            #endif
            // Check two SubComponents a part of the same container
            if (realSource.lexicalParent == self.lexicalParent) {
                #if __PARKOUR_REACH_DEBUG
                extraReport('\bSame container; source: <<realSource.contType.prep>>\b');
                #endif
                // Confirmed SubComponent of same container.
                // Can we reach the parkour module from this SubComponent?
                if (realSource.partOfParkourSurface || realSource.isInReachOfParkourSurface) {
                    return parkourReachSuccessful;
                }
                return parkourSubComponentTooFar;
            }

            if (checkStagingExitLocationConnection(realSource.stagingLocation)) return parkourReachSuccessful;
            if (checkStagingExitLocationConnection(realSource.exitLocation)) return parkourReachSuccessful;

            return parkourReachTopTooFar;
        }
        #if __PARKOUR_REACH_DEBUG
        extraReport('\bParkour mod found on <<closestParkourMod.theName>>.\b');
        #endif

        // Assuming source is prepared for parkour...
        if (closestParkourMod == self) return parkourReachSuccessful;

        #if __PARKOUR_REACH_DEBUG
        if (doNotFactorJump) {
            extraReport('\bDO NOT FACTOR JUMP!\b');
        }
        #endif

        for (local i = 1; i <= closestParkourMod.pathVector.length; i++) {
            local path = closestParkourMod.pathVector[i];
            if (path.destination != lexicalParent) {
                #if __PARKOUR_REACH_DEBUG
                extraReport('\n<<closestParkourMod.theName>> goes to
                    <<path.destination.theName>>, which is not me
                    (<<theName>>).\n');
                #endif
                continue;
            }
            if (path.provider != nil) continue;
            if (path.requiresJump && !doNotFactorJump) continue;
            if (path.isKnown || canBeUnknown) {
                return parkourReachSuccessful;
            }
        }
        return parkourReachTopTooFar;
    }

    checkStagingExitLocationConnection(stagingExitLocation) {
        if (stagingExitLocation == self.lexicalParent) return true;
        if (stagingExitLocation == self.lexicalParent.remapOn) return true;
        if (checkStagingExitLocationConnectionRemap(
            stagingExitLocation, self.lexicalParent.remapIn
        )) return true;
        if (checkStagingExitLocationConnectionRemap(
            stagingExitLocation, self.lexicalParent.remapUnder
        )) return true;
        if (checkStagingExitLocationConnectionRemap(
            stagingExitLocation, self.lexicalParent.remapBehind
        )) return true;

        return nil;
    }

    checkStagingExitLocationConnectionRemap(stagingExitLocation, remapLoc) {
        if (remapLoc != nil) {
            if (remapLoc.partOfParkourSurface || remapLoc.isInReachOfParkourSurface) {
                return stagingExitLocation == remapLoc;
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
    dobjFor(Board) asDobjFor(ParkourClimbGeneric)
    dobjFor(Climb) asDobjFor(ParkourClimbGeneric)
    dobjFor(ClimbUp) asDobjFor(ParkourClimbGeneric)
    dobjFor(ClimbDown) asDobjFor(ParkourClimbOffOf)
    dobjFor(GetOff) asDobjFor(ParkourClimbOffOf)
    dobjFor(JumpOff) asDobjFor(ParkourJumpOffOf)
    dobjFor(JumpOver) asDobjFor(ParkourJumpOver)
    dobjFor(SlideUnder) asDobjFor(ParkourSlideUnder)
    dobjFor(RunAcross) asDobjFor(ParkourRunAcross)
    dobjFor(SwingOn) asDobjFor(ParkourSwingOn)

    dobjFor(ParkourClimbGeneric) {
        parkourActionIntro
        verify() {
            verifyClimbPathFromActor(gActor, parkourCache.autoPathCanDiscover);
        }
        check() { checkParkour(gActor); }
        action() {
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
            verifyJumpPathFromActor(gActor, parkourCache.autoPathCanDiscover);
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

    getStandardOn() {
        local res = lexicalParent;
        if (res.remapOn != nil) {
            res = res.remapOn;
        }
        return res;
    }

    parkourReshapeGetOff(ParkourClimbOffOf, ParkourClimbDownTo)
    parkourReshapeGetOff(ParkourJumpOffOf, ParkourJumpDownTo)

    parkourSimpleUseProviderFromDest(JumpOver)
    parkourSimpleUseProviderFromDest(SlideUnder)
    parkourSimpleUseProviderFromDest(RunAcross)
    parkourSimpleUseProviderFromDest(SwingOn)
}

enum parkourUpDir, parkourOverDir, parkourDownDir;

class ParkourPath: object {
    destination = nil
    provider = nil
    requiresJump = nil
    isHarmful = nil
    direction = parkourOverDir
    isTrulyKnown = nil

    isKnown = (isTrulyKnown || !parkourCache.requireRouteRecon)

    injectedDiscoverMsg = nil
    injectedPerformMsg = nil
    injectedParkourBarriers = nil

    getDiscoverMsg() {
        if (injectedDiscoverMsg != nil) {
            return injectedDiscoverMsg;
        }
        if (requiresJump) {
            switch (direction) {
                case parkourUpDir:
                    return destination.parkourModule.getJumpUpDiscoverMsg();
                case parkourOverDir:
                    return destination.parkourModule.getJumpOverDiscoverMsg();
                case parkourDownDir:
                    return destination.parkourModule.getJumpDownDiscoverMsg();
            }
        }

        switch (direction) {
            case parkourOverDir:
                return destination.parkourModule.getClimbOverDiscoverMsg();
            case parkourDownDir:
                return destination.parkourModule.getClimbDownDiscoverMsg();
        }

        return destination.parkourModule.getClimbUpDiscoverMsg();
    }

    getPerformMsg() {
        if (injectedPerformMsg != nil) {
            return injectedPerformMsg;
        }
        if (requiresJump) {
            if (isHarmful) {
                return destination.parkourModule.getFallDownMsg();
            }
            switch (direction) {
                case parkourUpDir:
                    return destination.parkourModule.getJumpUpMsg();
                case parkourOverDir:
                    return destination.parkourModule.getJumpOverMsg();
                case parkourDownDir:
                    return destination.parkourModule.getJumpDownMsg();
            }
        }

        switch (direction) {
            case parkourOverDir:
                return destination.parkourModule.getClimbOverMsg();
            case parkourDownDir:
                return destination.parkourModule.getClimbDownMsg();
        }

        return destination.parkourModule.getClimbUpMsg();
    }
}

class ParkourPathMaker: PreinitObject {
    location = nil
    destination = nil
    provider = nil
    requiresJump = nil
    isHarmful = nil
    direction = parkourOverDir

    discoverMsg = nil
    performMsg = nil
    parkourBarriers = nil

    getTrueLocation() {
        if (location.ofKind(SubComponent)) {
            return location.lexicalParent;
        }
        return location;
    }

    getTrueDestination() {
        if (destination.ofKind(SubComponent)) {
            return destination.lexicalParent;
        }
        return destination;
    }

    execute() {
        getTrueLocation().prepForParkour();
        getTrueDestination().prepForParkour();
        createForwardPath();
        createBackwardPath();
    }

    createForwardPath() {
        getTrueLocation().parkourModule.addPath(getNewPathObject());
    }

    createBackwardPath() { }

    getNewPathObject() {
        local path = new ParkourPath();
        path.injectedDiscoverMsg = discoverMsg;
        path.injectedPerformMsg = performMsg;
        path.injectedParkourBarriers = parkourBarriers;
        path.destination = getTrueDestination();
        path.provider = provider;
        path.requiresJump = requiresJump;
        path.isHarmful = isHarmful;
        path.direction = direction;
        return path;
    }
}

/*
 * PATH TYPES
 */

// Climb paths
ClimbUpPath template ->destination;
class ClimbUpPath: ParkourPathMaker {
    direction = parkourUpDir
}

ClimbOverPath template ->destination;
class ClimbOverPath: ParkourPathMaker {
    direction = parkourOverDir
}

ClimbDownPath template ->destination;
class ClimbDownPath: ParkourPathMaker {
    direction = parkourDownDir
}

// Jump paths
JumpUpPath template ->destination;
class JumpUpPath: ParkourPathMaker {
    direction = parkourUpDir
    requiresJump = true
}

JumpOverPath template ->destination;
class JumpOverPath: ParkourPathMaker {
    direction = parkourOverDir
    requiresJump = true
}

JumpDownPath template ->destination;
class JumpDownPath: ParkourPathMaker {
    direction = parkourDownDir
    requiresJump = true
}

FallDownPath template ->destination;
class FallDownPath: ParkourPathMaker {
    direction = parkourDownDir
    requiresJump = true
    isHarmful = true
}

// Two-way
class ParkourLinkMaker: ParkourPathMaker {
    requiresJumpBack = (requiresJump)
    isHarmfulBack = (isHarmful)

    discoverMsg = (discoverForwardMsg)
    performMsg = (performForwardMsg)
    parkourBarriers = (forwardParkourBarriers)
    discoverForwardMsg = nil // Just to circumvent mistakes
    performForwardMsg = nil // Just to circumvent mistakes
    forwardParkourBarriers = nil // Just to circumvent mistakes
    discoverBackwardMsg = nil
    performBackwardMsg = nil
    backwardParkourBarriers = nil

    createBackwardPath() {
        local backPath = getNewPathObject();
        backPath.injectedDiscoverMsg = discoverBackwardMsg;
        backPath.injectedPerformMsg = performBackwardMsg;
        backPath.injectedParkourBarriers = backwardParkourBarriers;
        backPath.destination = getTrueLocation();
        backPath.requiresJump = requiresJumpBack;
        backPath.isHarmful = isHarmfulBack;
        switch (backPath.direction) {
            case parkourUpDir:
                backPath.direction = parkourDownDir;
                break;
            case parkourDownDir:
                backPath.direction = parkourUpDir;
                break;
        }
        getTrueDestination().parkourModule.addPath(backPath);
    }
}

// Two-way climb paths
ClimbUpLink template ->destination;
class ClimbUpLink: ParkourLinkMaker {
    direction = parkourUpDir
}

ClimbOverLink template ->destination;
class ClimbOverLink: ParkourLinkMaker {
    direction = parkourOverDir
}

ClimbDownLink template ->destination;
class ClimbDownLink: ParkourLinkMaker {
    direction = parkourDownDir
}

// Two-way jump paths
JumpUpLink template ->destination;
class JumpUpLink: ParkourLinkMaker {
    direction = parkourUpDir
    requiresJump = true
    requiresJumpBack = nil
}

JumpOverLink template ->destination;
class JumpOverLink: ParkourLinkMaker {
    direction = parkourOverDir
    requiresJump = true
}

AwkwardClimbDownLink template ->destination;
class AwkwardClimbDownLink: ParkourLinkMaker {
    direction = parkourDownDir
    requiresJump = nil
    requiresJumpBack = true
}

// Floor heights
class FloorHeight: ParkourLinkMaker {
    destination = (location.stagingLocation)
    requiresJump = nil
    isHarmful = nil
    requiresJumpBack = nil
    isHarmfulBack = nil
    direction = parkourDownDir

    createBackwardPath() {
        local backPath = getNewPathObject();
        backPath.destination = location;
        backPath.direction = parkourUpDir;
        backPath.requiresJump = requiresJumpBack;
        backPath.isHarmful = isHarmfulBack;
        destination.parkourModule.addPath(backPath);
    }
}

class LowFloorHeight: FloorHeight {
    //
}

class AwkwardFloorHeight: FloorHeight {
    requiresJumpBack = true
}

class HighFloorHeight: FloorHeight {
    requiresJump = true

    createBackwardPath() { } // No way up
}

class DangerousFloorHeight: FloorHeight {
    requiresJump = true
    isHarmful = true

    createBackwardPath() { } // No way up
}