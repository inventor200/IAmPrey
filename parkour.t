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
    ('jump'|'jm'|'hop'|'leap') genericAcrossPrep singleDobj
    : VerbProduction
    action = ParkourJumpOverTo
    verbPhrase = 'jump to (what)'
    missingQ = 'what do you want to jump to'
;

DefineTAction(ParkourJumpOverTo)
    allowImplicit = nil
;

VerbRule(ParkourJumpOverInto)
    ('jump'|'jm'|'hop'|'leap') expandedInto singleDobj
    : VerbProduction
    action = ParkourJumpOverInto
    verbPhrase = 'jump through (what)'
    missingQ = 'what do you want to jump through'
;

DefineTAction(ParkourJumpOverInto)
    allowImplicit = nil
;

VerbRule(ParkourJumpUpTo)
    ('jump'|'jm'|'hop'|'leap'|'clamber'|'scramble'|'wall' 'run'|'wallrun'|'scale'|'run'|'sprint') ('up' expandedUpSideOf|genericOnTopOfPrep) singleDobj |
    ('clamber'|'scale') singleDobj
    : VerbProduction
    action = ParkourJumpUpTo
    verbPhrase = 'jump up (what)'
    missingQ = 'what do you want to jump up'
;

DefineTAction(ParkourJumpUpTo)
    allowImplicit = nil
;

VerbRule(ParkourJumpUpInto)
    ('jump'|'jm'|'hop'|'leap'|'clamber'|'scramble'|'wall' 'run'|'wallrun'|'scale'|'run'|'sprint') 'up' expandedInto singleDobj
    : VerbProduction
    action = ParkourJumpUpInto
    verbPhrase = 'jump up into (what)'
    missingQ = 'what do you want to jump up into'
;

DefineTAction(ParkourJumpUpInto)
    allowImplicit = nil
;

VerbRule(ParkourJumpDownTo)
    ('jump'|'jm'|'hop'|'leap'|'clamber'|'scramble'|'drop'|'fall') 'down' 'to' singleDobj
    : VerbProduction
    action = ParkourJumpDownTo
    verbPhrase = 'jump down to (what)'
    missingQ = 'what do you want to jump down to'
;

DefineTAction(ParkourJumpDownTo)
    allowImplicit = nil
;

VerbRule(ParkourJumpDownInto)
    ('jump'|'jm'|'hop'|'leap'|'clamber'|'scramble'|'drop'|'fall') 'down' expandedInto singleDobj
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
    ('climb'|'cl'|'mantel'|'mantle'|'go'|'walk'|'parkour') 'up' expandedInto singleDobj
    : VerbProduction
    action = ParkourClimbUpInto
    verbPhrase = 'climb up into (what)'
    missingQ = 'what do you want to climb up into'
;

DefineTAction(ParkourClimbUpInto)
    allowImplicit = nil
;

VerbRule(ParkourClimbUpTo)
    ('climb'|'cl'|'mantel'|'mantle'|'go'|'walk'|'parkour') ('up' expandedUpSideOf|genericOnTopOfPrep) singleDobj
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
    verbPhrase = 'jump somehow to (what)'
    missingQ = 'what do you want to jump to'
;

DefineTAction(ParkourJumpGeneric)
    allowImplicit = nil
;

VerbRule(ParkourClimbGeneric)
    ('climb'|'cl'|'mantel'|'mantle'|'mount'|'board') singleDobj |
    /*('climb'|'cl'|'mantel'|'mantle'|'get'|'go') genericOnTopOfPrep singleDobj |*/
    'parkour' ('to'|) singleDobj
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
    ('jump'|'jm'|'hop'|'leap'|'vault') ('over'|) singleDobj
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

#define expandableLocalPlats 'platforms'|'plats'|'surfaces'
#define expandableParkourShowList ('show' ('list' ('of'|)|)|'list'|'remember'|'review'|'ponder'|'study'|'find'|'search'|'scan')
#define expandableParkourAvailability ('available'|'known'|'familiar'|'traveled'|'travelled'|)
#define expandableRouteRoot ('parkour'|'prkr'|'pkr'|'pk'|expandableParkourTargetShort)
#define expandableParkourTargetShort 'paths'|'pathways'|'routes'|expandableLocalPlats

VerbRule(ShowParkourRoutes)
    expandableParkourShowList expandableParkourAvailability (expandableParkourTargetShort) |
    expandableParkourShowList (expandableParkourTargetShort) |
    expandableRouteRoot
    : VerbProduction
    action = ShowParkourRoutes
    verbPhrase = 'show/showing parkour routes'        
;

DefineIAction(ShowParkourRoutes)
    allowAll = nil
    turnsTaken = 0

    execAction(cmd) {
        parkourCache.printParkourRoutes();
    }
;

VerbRule(ShowParkourKey)
    ('show'|) expandableRouteRoot ('list'|) ('key'|'legend')
    : VerbProduction
    action = ShowParkourKey
    verbPhrase = 'show/showing parkour route list key'        
;

DefineIAction(ShowParkourKey)
    allowAll = nil
    turnsTaken = 0

    execAction(cmd) {
        parkourCache.printParkourKey();
    }
;

VerbRule(ShowParkourLocalPlatforms)
    ('show'|'list'|) (expandableRouteRoot|) (('local'|'near'|'nearby') (expandableLocalPlats)|expandableLocalPlats|'local'|'locals'|'near'|'nearby')
    : VerbProduction
    action = ShowParkourLocalPlatforms
    verbPhrase = 'show/showing parkour local platforms'        
;

DefineIAction(ShowParkourLocalPlatforms)
    allowAll = nil
    turnsTaken = 0

    execAction(cmd) {
        parkourCache.printLocalPlatforms();
    }
;

#define parkourAll ('all'|'each'|'every'|'full' ('list' ('of'|)|))

VerbRule(ShowAllParkourRoutes)
    expandableParkourShowList parkourAll expandableParkourAvailability (expandableParkourTargetShort) |
    expandableParkourShowList parkourAll (expandableParkourTargetShort) |
    parkourAll expandableRouteRoot |
    expandableRouteRoot ('all'|'full' ('list'|))
    : VerbProduction
    action = ShowAllParkourRoutes
    verbPhrase = 'show/showing parkour routes'        
;

DefineIAction(ShowAllParkourRoutes)
    allowAll = nil
    turnsTaken = 0

    execAction(cmd) {
        parkourCache.printParkourRoutes();
        parkourCache.printLocalPlatforms();
    }
;

/*modify Look {
    execAction(cmd) {
        inherited(cmd);
        ShowAllParkourRoutes.execAction(cmd);
    }
}*/

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
    turnsTaken = 0
;
#endif

//TODO: Tutorial hinting
//TODO: Rename this to parkourCore
//TODO: Go through all of our fucking \b chars, and replace them with <.p> chars
parkourCache: object {
    requireRouteRecon = true
    formatForScreenReader = (gFormatForScreenReader)
    autoPathCanDiscover = (!requireRouteRecon)
    announceRouteAfterTrying = true
    maxReconsPerTurn = 3

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

    doParkourRunnerCheck(actor) {
        if (gParkourRunner.fitForParkour) return true;
        sayParkourRunnerError(actor);
        return nil;
    }

    sayParkourRunnerError(actor) {
        if (gParkourRunner != actor) {
            say(gParkourRunner.cannotDoParkourInMsg);
            return;
        }

        say(actor.cannotDoParkourMsg);
    }

    currentReconCount = 0

    startRecon() {
        currentReconCount = 0;
    }

    accountForRecon() {
        local clear = currentReconCount < maxReconsPerTurn;
        currentReconCount++;
        return clear;
    }

    getKeyString() {
        local strBfr = new StringBuffer(5);
        strBfr.append('\t<i><b>Bullet Symbol Key:</b></i>\n');
        strBfr.append('\t<b><tt>[!*]</tt></b> = dangerous jump\n');
        strBfr.append('\t<b><tt>[!!]</tt></b> = dangerous climb\n');
        strBfr.append('\t<b><tt>[**]</tt></b> = jump\n');
        strBfr.append('\t<b><tt>[&gt;&gt;]</tt></b> = simple climb\b');
        return toString(strBfr);
    }

    loadParkourKeyHint(strBfr) {
        strBfr.append('\n');
        strBfr.append(aHrefAlt(
            'show parkour list key',
            '<small>Click here for bullet symbol key!</small> ',
            '(Enter <b>PARKOUR KEY</b> for help with bullet symbols.) '
        ));
        strBfr.append('\b');
    }

    printParkourKey() {
        if (parkourCache.formatForScreenReader) {
            "This command does nothing in screen reader mode.
            Outside of screen reader mode, it clarifies some
            ASCII symbols used when describing routes. ";
        }
        else {
            "<<getKeyString()>>";
        }
    }

    //TODO: Rework this into a hint for using the verb.
    printParkourFullRoutesHint() {
        "(Parkour verb hint will go here) ";
        /*return aHrefAlt(
            'all routes',
            '\n<small>Click here for all known routes!</small>\b',
            ''
        );*/
    }

    printParkourRoutes() {
        cacheParkourRunner(gActor);
        local str = gParkourRunner.location.getRouteListString();
        if (str.length > 0) {
            "<<str>>";
            return;
        }
        "<<noKnownRoutesMsg>>";
    }

    getLocalPlatforms() {
        parkourCache.cacheParkourRunner(gActor);
        return gParkourRunner.getLocalPlatforms();
    }

    printLocalPlatforms() {
        local platList = getLocalPlatforms();
        if (platList.length == 0) {
            "\b{I} notice{s/d} no (known) surfaces in easy reach,
            other than the one {i} {stand} on.\b";
            return;
        }
        "\bThe following surfaces{plural} {is} both in easy reach,
        and rest{s/ed} on the same surface that {i} {do}:\b";
        if (formatForScreenReader) {
            "<<makeListStr(platList, &theName, 'and')>>";
        }
        else {
            local strBfr = new StringBuffer();
            for (local i = 1; i <= platList.length; i++) {
                local plat = platList[i];
                strBfr.append('\n\t');
                strBfr.append(aHrefAlt(
                    'cl ' + plat.theName.toLower(),
                    plat.theName,
                    plat.theName
                ));
            }
            "<<toString(strBfr)>>";
        }
    }

    //TODO: Find a better way to print this hint
    loadAbbreviationReminder(strBfr) {
        if (hasShownClimbAbbreviationHint) return;
        strBfr.append(
            '\b\t<tt><b>REMEMBER:</b></tt>\n
            <i>You can use parkour shorthand to enter commands faster!</i>\b
            <b>CLIMB</b> can be shortened to <b>CL</b>, and
            <b>JUMP</b> can be shortened to <b>JM</b>!\b
            \t<tt><b>EXAMPLES:</b></tt>\n
            <b>CL UP DESK</b> for an <i>explicit</i> climb-up, or just
            <b>CL DESK</b> for an <i>implicit</i> climb, which picks the
            most appropriate direction, but only if it was used before.'
        );
        hasShownClimbAbbreviationHint = true;
    }

    lastPath = nil
    currentParkourRunner = nil
    showNewRoute = nil
    hadAccident = nil
    lookAroundAfter = nil
    hasShownClimbAbbreviationHint = nil
    noKnownRoutesMsg =
        '{I} {do} not {know} of any interesting routes from {here}. '
}

modify Examine {
    reset() {
        inherited();
        parkourCache.startRecon();
    }
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
        if (a.ofKind(Room) || b.ofKind(Room)) return issues;

        local aItem = nil;
        local aLoc = nil;
        local doNotFactorJumpForA = nil;
        local bItem = nil;
        local bLoc = nil;
        local doNotFactorJumpForB = nil;

        #if __PARKOUR_REACH_DEBUG
        extraReport('\n(Start special reach check for:
            <<gCommand.verbProd.verbPhrase>>)\n');
        #endif

        if (a.isLikelyContainer()) {
            aLoc = a;
            doNotFactorJumpForA = true;
            #if __PARKOUR_REACH_DEBUG
            extraReport('\n(LOC A: <<aLoc.theName>> (<<aLoc.contType.prep>>)
                in <<aLoc.getOutermostRoom().theName>>.)\n');
            #endif
        }
        else {
            aItem = a;
            aLoc = a.location;
            #if __PARKOUR_REACH_DEBUG
            extraReport('\n(ITEM A: <<aItem.theName>> (<<aItem.contType.prep>>)
                in <<aLoc.getOutermostRoom().theName>>.)\n');
            #endif
        }

        if (b.isLikelyContainer()) {
            bLoc = b;
            doNotFactorJumpForB = true;
            #if __PARKOUR_REACH_DEBUG
            extraReport('\n(LOC B: <<bLoc.theName>> (<<bLoc.contType.prep>>)
                in <<aLoc.getOutermostRoom().theName>>.)\n');
            #endif
        }
        else {
            bItem = b;
            bLoc = b.location;
            #if __PARKOUR_REACH_DEBUG
            extraReport('\n(ITEM B: <<bItem.theName>> (<<bItem.contType.prep>>)
                in <<aLoc.getOutermostRoom().theName>>.)\n');
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

// Modifying the behavior for moving actors into position
modify actorInStagingLocation {
    checkPreCondition(obj, allowImplicit) {
        //if (parkourPathFinder.mapBetween(gActor, obj, true, nil)) return true;
        local stagingLoc = obj.stagingLocation;
        parkourCache.cacheParkourRunner(gActor);
        local loc = gParkourRunner.location;

        local actorParkourMod = gParkourRunner.getParkourModule();
        local objectParkourMod = stagingLoc.getParkourModule();

        if (objectParkourMod != nil) {
            stagingLoc = objectParkourMod.getStandardOn();
        }

        if (loc == stagingLoc) return true; // FREE!!

        if (allowImplicit) {
            local impAction = nil;
            local impDest = nil;

            // Attempting to do parkour in invalid vehicle
            if (!gParkourRunner.fitForParkour) {
                parkourCache.sayParkourRunnerError(actor);
            }
            else if (actorParkourMod != nil && objectParkourMod != nil) {
                local connPath = objectParkourMod.getPathFrom(
                    actorParkourMod, parkourCache.autoPathCanDiscover
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
            else if (gParkourRunner.canReach(stagingLoc)) {
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
                tryImplicitAction(impAction, impDest);
                if (gParkourRunner.location == stagingLoc) return true;
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
        return '(It seems that {i} {can} ' + \
            gDirectCmdStr(capsActionStr + ' ' + upPrep + ' ' + theName) + \
            '!) '; \
    } \
    getClimbOverDiscoverMsg() { \
        return '(It seems that {i} {can} ' + \
            gDirectCmdStr(capsActionStr + ' ' + overPrep + ' ' + theName) + \
            '!) '; \
    } \
    getClimbDownDiscoverMsg() { \
        return '(It seems that {i} {can} ' + \
            gDirectCmdStr(capsActionStr + ' ' + downPrep + ' ' + theName) + \
            '!) '; \
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
        return '(It seems that {i} {can} ' + \
            gDirectCmdStr(capsActionStr + ' ' + upPrep + ' ' + theName) + \
            '!) '; \
    } \
    getJumpOverDiscoverMsg() { \
        return '(It seems that {i} {can} ' + \
            gDirectCmdStr(capsActionStr + ' ' + overPrep + ' ' + theName) + \
            '!) '; \
    } \
    getJumpDownDiscoverMsg() { \
        return '(It seems that {i} {can} ' + \
            gDirectCmdStr(capsActionStr + ' ' + downPrep + ' ' + theName) + \
            '!) '; \
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

#define learnPath(path, reportMethod) \
    if (!path.isAcknowledged) { \
        if (path.isKnown) { \
            path.acknowledge(); \
            if (parkourCache.showNewRoute) { \
                reportMethod(path.getDiscoverMsg() + '\b'); \
            } \
        } \
    }

// Actual parkour reporting
#define reportParkour \
    if (!parkourCache.hadAccident) { \
        "<<gParkourLastPath.getPerformMsg()>>\b"; \
        if (parkourCache.lookAroundAfter != nil) { \
            parkourCache.lookAroundAfter.lookAroundWithin(); \
            parkourCache.lookAroundAfter = nil; \
        } \
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
    if (!realProvider.can##ProviderAction##Me) { \
        illogical(cannot##ProviderAction##Msg); \
        return; \
    } \
    if (realProvider == nil) { \
        illogical(cannot##ProviderAction##Msg); \
        return; \
    } \
    parkourCache.cacheParkourRunner(actor); \
    local pm = gParkourRunner.getParkourModule(); \
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
    parkourCache.hadAccident = nil; \
    parkourCache.showNewRoute = announceNewRoute

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
    beginParkour(parkourCache.announceRouteAfterTrying); \
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
                parkourDestination.checkInsert(gActor); \
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
        if (isVehicle) return nil;
        if (isFixed) {
            //if (gParkourRunner == self) return nil;
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

    dobjFor(ParkourJumpOver) asDobjFor(JumpOver)
    dobjFor(ParkourSlideUnder) asDobjFor(SlideUnder)
    dobjFor(ParkourRunAcross) asDobjFor(RunAcross)
    dobjFor(ParkourSwingOn) asDobjFor(SwingOn)

    dobjParkourRemap(ParkourClimbOffOf, climbOffAlternative)
    dobjParkourRemap(ParkourJumpOffOf, jumpOffAlternative)

    iobjFor(PutOn) {
        verift() {
            if (!passesGhostReachTest(gActor)) {
                illogical('{I} {cannot} reach the top of {the iobj}. ');
            }
            inherited();
        }
    }

    iobjFor(PutIn) {
        verift() {
            if (!passesGhostReachTest(gActor)) {
                illogical('{I} {cannot} reach inside of {the iobj}. ');
            }
            inherited();
        }
    }

    // Can this Thing perform parkour?
    fitForParkour = nil
    // A list of TravelBarriers that prevent parkour with this Thing
    parkourBarriers = nil
    // Was this Thing recon'd for parkour?
    hasParkourRecon = (!parkourCache.requireRouteRecon)
    // Other Things that this will share recon with
    shareReconWith = []
    // This gets added to the above list, and should not be touched by authors
    shareReconWithProcedural = perInstance(new Vector())
    // Do not show get off option (standard containers)
    doNotSuggestGetOff = nil

    applyRecon() {
        hasParkourRecon = true;
        local reconLst = valToList(shareReconWith);
        reconLst += valToList(shareReconWithProcedural);
        for (local i = 1; i <= reconLst.length; i++) {
            reconLst[i].hasParkourRecon = true;
        }
    }

    dobjFor(Examine) {
        action() {
            doRecon();
            inherited();
        }
    }

    dobjFor(Board) {
        report() {
            reportStandardWithRoutes(self);
        }
    }

    dobjFor(GetOff) {
        report() {
            reportStandardWithRoutes(exitLocation);
        }
    }

    dobjFor(JumpOff) {
        report() {
            reportStandardWithRoutes(exitLocation);
        }
    }

    getParkourProvider(fromParent, fromChild) {
        if (canSlideUnderMe) return self;
        if (canJumpOverMe) return self;
        if (canSlideUnderMe) return self;
        if (canSwingOnMe) return self;

        if (!fromChild) {
            if (remapOn != nil) {
                local childProvider = remapOn.getParkourProvider(true, nil);
                if (childProvider != nil) {
                    return childProvider;
                }
            }
            if (remapIn != nil) {
                local childProvider = remapIn.getParkourProvider(true, nil);
                if (childProvider != nil) {
                    return childProvider;
                }
            }
            if (remapUnder != nil) {
                local childProvider = remapUnder.getParkourProvider(true, nil);
                if (childProvider != nil) {
                    return childProvider;
                }
            }
            if (remapBehind != nil) {
                local childProvider = remapBehind.getParkourProvider(true, nil);
                if (childProvider != nil) {
                    return childProvider;
                }
            }
        }

        if (!fromParent) {
            if (lexicalParent != nil) {
                local parentProvider = lexicalParent.getParkourProvider(nil, true);
                if (parentProvider != nil) {
                    return parentProvider;
                }
            }
        }

        return nil;
    }

    doRecon() {
        local provider = getParkourProvider(nil, nil);

        if (provider != nil) {
            local clear = nil;
            if (!provider.hasParkourRecon) {
                clear = parkourCache.accountForRecon();
            }
            
            if (clear) {
                parkourCache.cacheParkourRunner(gActor);
                gParkourRunner.getParkourModule().doReconForProvider(provider);
            }
        }

        local pm = getParkourModule();
        if (pm != nil) pm.doRecon();
    }

    isStandardPlatform(moduleChecked?, confirmedParkourModule?) {
        if (moduleChecked) {
            if (confirmedParkourModule) return nil;
        }
        else {
            if (getParkourModule() != nil) return nil;
        }
        if (remapOn != nil) {
            return remapOn.isStandardPlatform(moduleChecked, confirmedParkourModule);
        }
        if (!isBoardable) return nil;
        if (isVehicle) return nil;
        if (contType != On) return nil;
        return true;
    }

    standardDoNotSuggestGetOff() {
        if (doNotSuggestGetOff) return true;
        if (remapOn != nil) {
            return remapOn.doNotSuggestGetOff;
        }
        return nil;
    }

    getRouteListString() {
        local closestParkourMod = getParkourModule();
        if (!isStandardPlatform(true, closestParkourMod != nil)) {
            if (closestParkourMod != nil) {
                return closestParkourMod.getRouteListString();
            }
            return '';
        }

        if (remapOn != nil) {
            return remapOn.getRouteListString();
        }

        // Standard platform alternative
        if (standardDoNotSuggestGetOff()) {
            return '';
        }

        local strBfr = new StringBuffer(20);
        if (!parkourCache.formatForScreenReader) {
            parkourCache.loadParkourKeyHint(strBfr);
        }
        loadGetOffSuggestion(strBfr, nil, nil);
        return toString(strBfr);
    }

    loadGetOffSuggestion(strBfr, requiresJump, isHarmful) {
        if (standardDoNotSuggestGetOff()) return;
        if (parkourCache.formatForScreenReader) {
            strBfr.append('\n{I} believe{s/d} {i} {can} <b>');
            if (requiresJump) {
                strBfr.append('JUMP OFF');
            }
            else {
                strBfr.append('GET OFF');
            }
            strBfr.append('</b> to reach ');
            strBfr.append(getExitLocationName());
            strBfr.append('. ');
            if (isHarmful) {
                strBfr.append('However, this action seems dangerous. ');
            }
        }
        else {
            strBfr.append(getBulletPoint(requiresJump, isHarmful));
            local commandText = 'GET OFF';
            if (requiresJump) {
                commandText = 'JUMP OFF';
            }
            strBfr.append(gDirectCmdStr(commandText));
        }
    }

    getBulletPoint(requiresJump, isHarmful) {
        if (isHarmful && requiresJump) return '\n&nbsp;<tt><b>[!*]</b></tt> ';
        if (isHarmful) return '\n&nbsp;<tt><b>[!!]</b></tt> ';
        if (requiresJump) return '\n&nbsp;<tt><b>[**]</b></tt> ';
        return '\n&nbsp;<tt><b>[&gt;&gt;]</b></tt> ';
    }

    checkProviderAccident(actor, traveler, path) {
        local hadAccident = gOutStream.watchForOutput({:
            doProviderAccident(actor, traveler, path)
        });
        parkourCache.hadAccident = parkourCache.hadAccident || hadAccident;
        return !hadAccident;
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

    // Simulate an object on top of this IObj, and do a reach test.
    passesGhostReachTest(actor) {
        reachGhostTest_.moveInto(getGhostReachDestination());
        local canReachResult = Q.canReach(actor, reachGhostTest_);
        reachGhostTest_.moveInto(nil);
        return canReachResult;
    }

    getLocalPlatforms() { // Used for actors and non-containers only
        local masterPlatform = location;
        if (masterPlatform == nil) return [];
        // Find outermost platform or room
        // in case in another non-platform container
        while (!(masterPlatform.contType == On || masterPlatform.ofKind(Room))) {
            masterPlatform = masterPlatform.exitLocation;
            if (masterPlatform == nil) return [];
        }

        if (masterPlatform == nil) return [];

        local platList = [];
        local contentList = valToList(masterPlatform.contents);

        // A local platform will be in the location's contents,
        // and pass the ghost reach test from an actor
        for (local i = 1; i <= contentList.length; i++) {
            local obj = contentList[i];
            local pm = obj.getParkourModule();
            local validPlatform = true;
            local otherOn = (pm != nil ? pm.getStandardOn() : obj.getStandardOn());
            if (!otherOn.isLikelyContainer()) continue;
            if (otherOn == masterPlatform) continue;
            if (pm == nil) {
                validPlatform = obj.isStandardPlatform(true, nil);
            }
            if (!validPlatform) continue;
            reachGhostTest_.moveInto(otherOn.getGhostReachDestination());
            if (!Q.canReach(self, reachGhostTest_)) continue;
            platList += otherOn;
        }

        reachGhostTest_.moveInto(nil);

        return platList;
    }

    doProviderAccident(actor, traveler, path) {
        // For author implementation
    }

    doAccident(actor, traveler, path) {
        // For author implementation
    }

    doClimbPunishment(actor, traveler, path) {
        // For author implementation
    }

    doJumpPunishment(actor, traveler, path) {
        // For author implementation
    }

    doHarmfulPunishment(actor, traveler, path) {
        // For author implementation
    }

    checkAsParkourProvider(actor, traveler, path) {
        return true;
    }

    checkParkourProviderBarriers(actor, path) {
        if (parkourCache.doParkourRunnerCheck(actor)) {
            if (checkAsParkourProvider(actor, gParkourRunner, path)) {
                local barriers = valToList(parkourBarriers);

                for (local i = 1; i <= barriers.length; i++) {
                    local barrier = barriers[i];
                    // Note: Args are traveler, path
                    // instead of     traveler, connector
                    if (!barrier.checkTravelBarrier(gParkourRunner, path)) {
                        return nil;
                    }
                }

                return true;
            }
        }

        return nil;
    }

    canSlideUnderMe = nil
    canRunAcrossMe = nil
    canSwingOnMe = nil

    parkourProviderAction(JumpOver, remapOn)
    parkourProviderAction(SlideUnder, remapUnder)
    parkourProviderAction(RunAcross, remapOn)
    parkourProviderAction(SwingOn, remapOn)

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
    uselessSlideUnderMsg =
        'Sliding under {the dobj}{dummy} {do} very little from {here}. '
    uselessRunAcrossMsg =
        'Running across {the dobj}{dummy} {do} very little from {here}. '
    uselessJumpOverMsg =
        'Jumping over {the dobj}{dummy} {do} very little from {here}. '
    uselessSwingOnMsg =
        'Swinging on {the dobj}{dummy} {do} very little from {here}. '
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
    alreadyOnParkourModuleMsg =
        '{I} {am} already on {that dobj}. '

    getExitLocationName() {
        if (exitLocation == nil) return 'the void';
        local pm = exitLocation.getParkourModule();
        if (pm != nil) {
            return getBetterDestinationName(pm);
        }
        return exitLocation.theName;
    }
    
    getBetterDestinationName(destination, usePrep?, intelOverride?) {
        local roomA = gParkourRunner.getOutermostRoom();
        local roomB = destination.getOutermostRoom();
        local prep = destination.objInPrep + ' ';

        if (roomA == roomB) {
            return (usePrep ? prep : '') + destination.theName;
        }
        if (roomB.visited || intelOverride) {
            if (destination.lexicalParent.ofKind(Room)) {
                prep = destination.lexicalParent.objInPrep + ' ';
                return (usePrep ? prep : '') + destination.lexicalParent.theName;
            }
            return (usePrep ? prep : '') + '<<destination.theName>>
                (<<roomB.objInPrep>> <<roomB.theName>>)';
        }

        prep = 'to ';
        return (usePrep ? prep : '') + 'another location';
    }

    getProviderGoalDiscoverClause(destination) {
        return 'which will let{dummy} {me} reach <<getBetterDestinationName(destination)>>';
    }

    getProviderGoalClause(destination) {
        return 'which{dummy} land{s/d} {me} <<getBetterDestinationName(destination, true, true)>>';
    }

    getJumpOverToDiscoverMsg(destination) {
        return '(It seems that {i} {can}
            <<gDirectCmdStr('jump over ' + theName)>>,
            <<getProviderGoalDiscoverClause(destination)>>!) ';
    }

    getJumpOverToMsg(destination) {
        return '{I} jump{s/ed} over <<theName>>,
            <<getProviderGoalClause(destination)>>. ';
    }

    getRunAcrossToDiscoverMsg(destination) {
        return '(It seems that {i} {can}
            <<gDirectCmdStr('run across ' + theName)>>,
            <<getProviderGoalDiscoverClause(destination)>>!) ';
    }

    getRunAcrossToMsg(destination) {
        return '{I} {run} across <<theName>>,
            <<getProviderGoalClause(destination)>>. ';
    }

    getSwingOnToDiscoverMsg(destination) {
        return '(It seems that {i} {can}
            <<gDirectCmdStr('swing on ' + theName)>>,
            <<getProviderGoalDiscoverClause(destination)>>!) ';
    }

    getSwingOnToMsg(destination) {
        return '{I} {swing} on <<theName>>,
            <<getProviderGoalClause(destination)>>. ';
    }

    getSlideUnderToDiscoverMsg(destination) {
        return '(It seems that {i} {can}
            <<gDirectCmdStr('slide under ' + theName)>>,
            <<getProviderGoalDiscoverClause(destination)>>!) ';
    }

    getSlideUnderToMsg(destination) {
        return '{I} {slide} under <<theName>>,
            <<getProviderGoalClause(destination)>>. ';
    }

    fastParkourMessages('atop', 'over to', 'down to')
}

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
}

modify SubComponent {
    parkourModule = (lexicalParent == nil ? nil : lexicalParent.parkourModule)

    hasParkourRecon = (lexicalParent == nil ? true : lexicalParent.hasParkourRecon)

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

    loadGetOffSuggestion(strBfr, requiresJump, isHarmful) {
        if (lexicalParent == nil) return;
        lexicalParent.loadGetOffSuggestion(strBfr, requiresJump, isHarmful);
    }

    standardDoNotSuggestGetOff() {
        if (lexicalParent != nil) {
            return lexicalParent.standardDoNotSuggestGetOff();
        }
        return nil;
    }

    getStandardOn() {
        local res = lexicalParent;
        if (res.remapOn != nil) {
            res = res.remapOn;
        }
        return res;
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

    isStandardPlatform(moduleChecked?, confirmedParkourModule?) {
        return nil;
    }
}

#define checkParkour(actor) \
    checkInsert(actor); \
    doParkourCheck(actor, gParkourLastPath)

#define parkourActionIntro \
    preCond = [parkourPreCond] \
    remap = nil

#define verifyJumpPathFromActor(actor, canBeUnknown) \
    parkourCache.cacheParkourRunner(actor); \
    gParkourLastPath = nil; \
    verifyAlreadyAtDestination(gParkourRunner); \
    local closestParkourMod = gParkourRunner.getParkourModule(); \
    if (closestParkourMod == nil) { \
        local closestSurface = gParkourRunner.location; \
        if (!checkStagingExitLocationConnection(closestSurface.exitLocation)) { \
            illogical(noParkourPathFromHereMsg); \
            return; \
        } \
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
    beginParkourReset(parkourCache.announceRouteAfterTrying); \
    doNested(GetOff, closestSurface)

#define doClimbFor(actor) \
    local closestParkourMod = gParkourRunner.getParkourModule(); \
    if (closestParkourMod == nil) { \
        doGetOffParkourAlt(actor); \
    } \
    else { \
        beginParkour(parkourCache.announceRouteAfterTrying); \
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

    getGhostReachDestination() {
        return getStandardOn();
    }

    doRecon() {
        if (lexicalParent != nil) {
            local clear = nil;
            if (!lexicalParent.hasParkourRecon) {
                clear = parkourCache.accountForRecon();
            }
            if (clear) {
                local path = getPathFrom(gParkourRunner.getParkourModule(), true, true);
                if (path != nil) {
                    lexicalParent.applyRecon();
                    parkourCache.cacheParkourRunner(gActor);
                    parkourCache.showNewRoute = true;
                    learnPath(path, reportAfter);
                }
            }
        }
    }

    doReconForProvider(provider) {
        local jumpPath = nil;
        for (local i = 1; i <= pathVector.length; i++) {
            local path = pathVector[i];
            if (path.provider != provider) continue;
            if (path.requiresJump) {
                jumpPath = path;
            }
            else {
                provider.applyRecon();
                parkourCache.showNewRoute = true;
                learnPath(path, reportAfter);
                return;
            }
        }

        if (jumpPath != nil) {
            provider.applyRecon();
            parkourCache.showNewRoute = true;
            learnPath(jumpPath, reportAfter);
        }
    }

    doAllPunishmentsAndAccidents(actor, traveler, path) {
        if (lexicalParent == nil) return true;
        if (path.requiresJump) {
            lexicalParent.doJumpPunishment(actor, traveler, path);
        }
        else {
            lexicalParent.doClimbPunishment(actor, traveler, path);
        }
        if (path.isHarmful) {
            lexicalParent.doHarmfulPunishment(actor, traveler, path);
        }
        local hadAccident = gOutStream.watchForOutput({:
            lexicalParent.doAccident(actor, traveler, path)
        });
        parkourCache.hadAccident = parkourCache.hadAccident || hadAccident;
        return !hadAccident;
    }

    checkLeaving(actor, traveler, path) {
        return true;
    }

    checkArriving(actor, traveler, path) {
        return true;
    }

    doParkourCheck(actor, path) {
        local source = gParkourRunner.getParkourModule();

        if (parkourCache.doParkourRunnerCheck(actor)) {
            local clearedLeaving = true;
            if (source != nil) {
                clearedLeaving = source.checkLeaving(actor, gParkourRunner, path);
            }
            if (clearedLeaving) {
                if (checkArriving(actor, gParkourRunner, path)) {
                    local barriers = [];
                    if (path != nil) {
                        barriers += valToList(path.injectedParkourBarriers);
                    }
                    if (lexicalParent != nil) {
                        barriers += valToList(lexicalParent.parkourBarriers);
                    }

                    for (local i = 1; i <= barriers.length; i++) {
                        local barrier = barriers[i];
                        // Note: Args are traveler, path
                        // instead of     traveler, connector
                        if (!barrier.checkTravelBarrier(gParkourRunner, path)) {
                            return nil;
                        }
                    }

                    return true;
                }
            }
        }

        return nil;
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
        checkForValidFloor();
        parkourPath.destination.checkForValidFloor();
        pathVector.append(parkourPath);
    }

    checkForValidFloor() {
        if (lexicalParent.ofKind(Room)) {
            if (lexicalParent.floorObj == nil) {
                throw new Exception(
                    'Attempted parkour surface from missing floor in ' +
                    lexicalParent.theName + '!'
                );
            }
        }
    }

    getRouteListString() {
        local strBfr = new StringBuffer(20);
        local climbPaths = [];
        local climbHarmfulPaths = [];
        local jumpPaths = [];
        local jumpHarmfulPaths = [];
        local fallPaths = [];
        local providerPaths = [];
        local providerHarmfulPaths = [];
        local describedPaths = [];
        local describedHarmfulPaths = [];

        local blindEasyPaths = [];
        local blindEasyDescribedPaths = [];
        local blindJumpPaths = [];
        local blindJumpDescribedPaths = [];
        local blindHarmfulPaths = [];
        local blindHarmfulDescribedPaths = [];
        local blindHarmfulJumpPaths = [];
        local blindHarmfulJumpDescribedPaths = [];

        local exitPath = nil;
        local currPlat = getStandardOn();
        local outerPlat = currPlat.exitLocation;
        local outerPM = nil;
        if (outerPlat != nil) outerPM = outerPlat.getParkourModule();
        local canSuggestExits = !standardDoNotSuggestGetOff();

        for (local i = 1; i <= pathVector.length; i++) {
            local path = pathVector[i];
            // Do not suggest stupid paths
            if (path.destination.parkourModule == self) continue;

            // Reserve the GET/JUMP OFF path
            if (outerPM != nil) {
                if (path.destination.parkourModule == outerPM) {
                    if (canSuggestExits && exitPath == nil) {
                        exitPath = path;
                    }
                    continue; // Do not add any other exit paths
                }
            }

            // Do not suggest basic climb-on actions
            if (!path.requiresJump && !path.isHarmful) {
                local destPlat = path.destination.getStandardOn();
                if (destPlat.stagingLocation != nil) {
                    if (destPlat.stagingLocation == currPlat) continue;
                }
            }

            // Filter:
            if (path.isKnown) {
                if (path.injectedPathDescription != nil) {
                    if (path.isHarmful) {
                        describedHarmfulPaths += path;
                        if (path.requiresJump) {
                            blindHarmfulJumpDescribedPaths += path;
                        }
                        else {
                            blindHarmfulDescribedPaths += path;
                        }
                    }
                    else {
                        describedPaths += path;
                        if (path.requiresJump) {
                            blindJumpDescribedPaths += path;
                        }
                        else {
                            blindEasyDescribedPaths += path;
                        }
                    }
                }
                else if (path.provider != nil) {
                    if (path.isHarmful) {
                        providerHarmfulPaths += path;
                        if (path.requiresJump) {
                            blindHarmfulJumpPaths += path;
                        }
                        else {
                            blindHarmfulPaths += path;
                        }
                    }
                    else {
                        providerPaths += path;
                        if (path.requiresJump) {
                            blindJumpPaths += path;
                        }
                        else {
                            blindEasyPaths += path;
                        }
                    }
                }
                else if (path.requiresJump) {
                    if (path.isHarmful) {
                        if (path.direction == parkourDownDir) {
                            fallPaths += path;
                        }
                        else {
                            jumpHarmfulPaths += path;
                            blindHarmfulJumpPaths += path;
                        }
                    }
                    else {
                        jumpPaths += path;
                        blindJumpPaths += path;
                    }
                }
                else {
                    if (path.isHarmful) {
                        climbHarmfulPaths += path;
                        blindHarmfulPaths += path;
                    }
                    else {
                        climbPaths += path;
                        blindEasyPaths += path;
                    }
                }
            }
        }

        local totalCount =
            climbPaths.length +
            climbHarmfulPaths.length +
            jumpPaths.length +
            jumpHarmfulPaths.length +
            fallPaths.length +
            providerPaths.length +
            providerHarmfulPaths.length +
            describedPaths.length +
            describedHarmfulPaths.length;
        
        if (exitPath != nil) totalCount++;
        
        if (totalCount > 0) {
            blindEasyPaths += blindEasyDescribedPaths;
            blindJumpPaths += blindJumpDescribedPaths;
            blindHarmfulPaths += blindHarmfulDescribedPaths;
            blindHarmfulJumpPaths += blindHarmfulJumpDescribedPaths;
            local routeCount =
                blindEasyPaths.length +
                blindJumpPaths.length +
                blindHarmfulPaths.length +
                blindHarmfulJumpPaths.length;
            strBfr.append('<i>{I} review{s/ed} the parkour routes {i} {can} use from {here}...</i>');
            if (parkourCache.formatForScreenReader) {
                strBfr.append('\b');
                strBfr.append(
                    'In total, {i} {see} <<spellNumber(routeCount)>>
                    viable <<getRouteCase(routeCount)>>.'
                );
                if (exitPath != nil) {
                    loadGetOffSuggestion(
                        strBfr, exitPath.requiresJump, exitPath.isHarmful
                    );
                }
                getBlindRouteDescription(strBfr, blindEasyPaths,
                    'can be performed with ease. '
                );
                getBlindRouteDescription(strBfr, blindJumpPaths,
                    'can be performed with difficulty. '
                );
                getBlindRouteDescription(strBfr, blindHarmfulPaths,
                    'can be performed at the risk of injury. '
                );
                getBlindRouteDescription(strBfr, blindHarmfulJumpPaths,
                    'can be performed with both great difficulty and risk of injury. '
                );
            }
            else {
                parkourCache.loadParkourKeyHint(strBfr);
                climbPaths += climbHarmfulPaths;
                jumpPaths += jumpHarmfulPaths;
                jumpPaths += fallPaths;
                providerPaths += providerHarmfulPaths;
                describedPaths += describedHarmfulPaths;

                if (exitPath != nil) {
                    loadGetOffSuggestion(
                        strBfr, exitPath.requiresJump, exitPath.isHarmful
                    );
                }

                if (climbPaths.length > 0) {
                    strBfr.append('\b<tt><b>(CL)</b> CLIMB ROUTES:</tt>');
                    for (local i = 1; i <= climbPaths.length; i++) {
                        formatForBulletPoint(strBfr, climbPaths[i]);
                    }
                }

                if (jumpPaths.length > 0) {
                    strBfr.append('\b<tt><b>(JM)</b> JUMP ROUTES:</tt>');
                    for (local i = 1; i <= jumpPaths.length; i++) {
                        formatForBulletPoint(strBfr, jumpPaths[i]);
                    }
                }

                if (providerPaths.length > 0) {
                    strBfr.append('\b<tt>COMPLEX ROUTES:</tt>');
                    for (local i = 1; i <= providerPaths.length; i++) {
                        local path = providerPaths[i];
                        local provider = path.provider.getParkourProvider(nil, nil);
                        if (provider == nil) continue;
                        strBfr.append(getBulletPoint(path.requiresJump, path.isHarmful));
                        strBfr.append(getProviderHTML(provider));
                        strBfr.append('\n\t<i>leads to ');
                        strBfr.append(getBetterDestinationName(path.destination.parkourModule));
                        strBfr.append('</i>');
                    }
                }

                if (describedPaths.length > 0) {
                    strBfr.append('\b<tt>MISC ROUTES:</tt>');
                    for (local i = 1; i <= describedPaths.length; i++) {
                        local path = describedPaths[i];
                        strBfr.append(getBulletPoint(path.requiresJump, path.isHarmful));
                        if (path.provider == nil) {
                            strBfr.append(getClimbHTML(
                                path, path.injectedPathDescription.toUpper()
                            ));
                        }
                        else {
                            local provider = path.provider.getParkourProvider(nil, nil);
                            strBfr.append(getProviderHTML(
                                provider, path.injectedPathDescription.toUpper()
                            ));
                        }
                    }
                }
            }
        }

        return toString(strBfr);
    }

    getRouteCase(count) {
        if (count == 1) return 'route';
        return 'routes';
    }

    getVerbFromPath(path) {
        if (path.requiresJump) return 'JUMP ';
        return 'CLIMB ';
    }

    getPrepFromPath(path) {
        switch (path.direction) {
            case parkourUpDir:
                return 'up ';
            default:
                return 'over ';
            case parkourDownDir:
                return 'down ';
        }
    }

    getBetterPrepFromPath(path) {
        switch (path.direction) {
            case parkourUpDir:
                return 'atop ';
            default:
                return 'over to ';
            case parkourDownDir:
                return 'down to ';
        }
    }

    formatForBulletPoint(strBfr, path) {
        strBfr.append(getBulletPoint(path.requiresJump, path.isHarmful));
        local destName = path.destination.parkourModule.theName;
        local commandAlt = getBetterPrepFromPath(path) + destName;
        strBfr.append(aHrefAlt(
            getClimbCommand(path).toLower(),
            commandAlt, commandAlt
        ));
    }

    getClimbCommand(path) {
        return getVerbFromPath(path) +
            getBetterPrepFromPath(path) +
            path.destination.parkourModule.theName;
    }

    getClimbHTML(path, commandText?) {
        if (commandText == nil) {
            commandText = getProviderVerb(provider) +
                getPrepFromPath(path) + 'to ' +
                path.destination.parkourModule.theName;
        }
        return aHrefAlt(getClimbCommand(path).toLower(), commandText, commandText);
    }

    getProviderCommand(provider) {
        local provName = provider.theName;
        if (provider.canSwingOnMe) return 'swing on ' + provName;
        if (provider.canJumpOverMe) return 'jump over ' + provName;
        if (provider.canRunAcrossMe) return 'run across ' + provName;
        if (provider.canSlideUnderMe) return 'slide under ' + provName;
        return 'cl ' + provName;
    }

    getProviderVerb(provider) {
        local provName = provider.theName.toUpper();
        if (provider.canSwingOnMe) return 'SWING ON ' + provName;
        if (provider.canJumpOverMe) return 'JUMP OVER ' + provName;
        if (provider.canRunAcrossMe) return 'RUN ACROSS ' + provName;
        if (provider.canSlideUnderMe) return 'SLIDE UNDER ' + provName;
        return 'parkour via ' + provName;
    }

    getProviderHTML(provider, commandText?) {
        if (commandText == nil) {
            commandText = getProviderVerb(provider);
        }
        return aHrefAlt(
            getProviderCommand(provider),
            commandText, commandText
        );
    }

    getBlindRouteDescription(strBfr, routeList, routeSuffix) {
        if (routeList.length > 0) {
            strBfr.append('\b');
            for (local i = 1; i <= routeList.length; i++) {
                local path = routeList[i];
                if (path.injectedPathDescription != nil) {
                    strBfr.append('<b>');
                    strBfr.append(path.injectedPathDescription.toUpper());
                    strBfr.append('</b>');
                }
                else if (path.provider == nil) {
                    strBfr.append('<b>');
                    strBfr.append(getVerbFromPath(path));
                    strBfr.append(getBetterPrepFromPath(path).toUpper());
                    strBfr.append(path.destination.parkourModule.theName.toUpper());
                    strBfr.append('</b>');
                }
                else {
                    local provider = path.provider.getParkourProvider(nil, nil);
                    strBfr.append('<b>');
                    strBfr.append(getProviderVerb(provider));
                    strBfr.append('</b>');
                    if (path.injectedPathDescription == nil) {
                        strBfr.append(' <i>(which leads to ');
                        strBfr.append(getBetterDestinationName(path.destination.parkourModule));
                        strBfr.append(')</i>');
                    }
                }
                if (i == routeList.length) {
                    strBfr.append(' ');
                }
                else if (i == routeList.length - 1) {
                    strBfr.append(', and ');
                }
                else {
                    strBfr.append(', ');
                }
            }
            strBfr.append(routeSuffix);
        }
    }

    provideMoveFor(actor) { // actor is usually gParkourRunner
        local plat = parent;
        if (plat.remapOn != nil) {
            plat = plat.remapOn;
        }
        local roomA = actor.getOutermostRoom();
        local roomB = plat.getOutermostRoom();
        if (roomA == roomB) {
            // We are moving within the same room.
            // No issues.
            actor.actionMoveInto(plat);
        }
        else {
            // We are moving into another room.
            // We need to perform the necessary steps.
            local oldLoc = roomA;
            local lookAroundOnEntering = roomB.lookOnEnter(actor);
            local playerIsOrIsInActor = gPlayerChar.isOrIsIn(actor);
            local oldTravelInfo = actor.lastTravelInfo;

            if (playerIsOrIsInActor) {
                libGlobal.lastLoc = oldLoc;
            }
            else if (Q.canSee(gPlayerChar, actor)) {
                actor.lastTravelInfo = [oldLoc, gParkourLastPath];
            }

            actor.actionMoveInto(plat);

            if (playerIsOrIsInActor) {
                local notifyList = roomB.allContents.subset({o: o.ofKind(Actor)});
                notifyList.forEach({a: a.pcArrivalTurn = gTurns });
                
                if (lookAroundOnEntering) {
                    parkourCache.lookAroundAfter = roomB;
                }
            }
            else if (roomA == oldLoc) {
                actor.lastTravelInfo = oldTravelInfo;
            }
        }
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

    isInReachFrom(source, canBeUnknown?, doNotFactorJump?) {
        return isInReachFromVerbose(source, canBeUnknown, doNotFactorJump) == parkourReachSuccessful;
    }

    isInReachFromVerbose(source, canBeUnknown?, doNotFactorJump?) {
        #if __PARKOUR_REACH_DEBUG
        extraReport('\nREACH TO: <<theName>>\n');
        #endif
        if (source == gActor) {
            parkourCache.cacheParkourRunner(source);
            source = gParkourRunner;
        }
        #if __PARKOUR_REACH_DEBUG
        extraReport('\nTesting source: <<source.theName>> (<<source.contType.prep>>)\n');
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
            extraReport('\nNo parkour mod on <<realSource.theName>> (<<realSource.contType.prep>>).\n');
            #endif
            // Check two SubComponents a part of the same container
            if (realSource.lexicalParent == self.lexicalParent) {
                #if __PARKOUR_REACH_DEBUG
                extraReport('\nSame container; source: <<realSource.contType.prep>>\n');
                #endif
                // Confirmed SubComponent of same container.
                // Can we reach the parkour module from this SubComponent?
                if (realSource.partOfParkourSurface || realSource.isInReachOfParkourSurface) {
                    return parkourReachSuccessful;
                }
                return parkourSubComponentTooFar;
            }

            #if __PARKOUR_REACH_DEBUG
            extraReport('\nCHECKING PROVIDERS NEXT!\n');
            #endif

            // If paths use the source as a provider, then it must be within reach
            for (local i = 1; i <= pathVector.length; i++) {
                if (pathVector[i].provider == source) return true;
            }

            #if __PARKOUR_REACH_DEBUG
            extraReport('\nCHECKING STAGE/EXIT NEXT! (<<realSource.theName>>)\n');
            #endif

            // Check other normal container relations
            #if __PARKOUR_REACH_DEBUG
            extraReport('\nStaging: <<realSource.stagingLocation.theName>>\n');
            #endif
            if (checkStagingExitLocationConnection(realSource.stagingLocation)) {
                #if __PARKOUR_REACH_DEBUG
                extraReport('\nFOUND!\n');
                #endif
                return parkourReachSuccessful;
            }
            #if __PARKOUR_REACH_DEBUG
            extraReport('\nExit: <<realSource.exitLocation.theName>>\n');
            #endif
            if (checkStagingExitLocationConnection(realSource.exitLocation)) {
                #if __PARKOUR_REACH_DEBUG
                extraReport('\nFOUND!\n');
                #endif
                return parkourReachSuccessful;
            }

            return parkourReachTopTooFar;
        }
        #if __PARKOUR_REACH_DEBUG
        extraReport('\nParkour mod found on <<closestParkourMod.theName>>
            in <<closestParkourMod.getOutermostRoom().roomTitle>>.\n');
        #endif

        // Assuming source is prepared for parkour...
        if (closestParkourMod == self) return parkourReachSuccessful;

        #if __PARKOUR_REACH_DEBUG
        extraReport('\nSTANDARD PARKOUR CHECKS APPLY!\n');
        #endif

        #if __PARKOUR_REACH_DEBUG
        if (doNotFactorJump) {
            extraReport('\nDO NOT FACTOR JUMP!\n');
        }
        #endif

        for (local i = 1; i <= closestParkourMod.pathVector.length; i++) {
            local path = closestParkourMod.pathVector[i];
            if (path.destination != lexicalParent) continue;
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
    dobjFor(Board) asDobjFor(ParkourClimbUpTo)
    dobjFor(Climb) asDobjFor(ParkourClimbGeneric)
    dobjFor(ClimbUp) asDobjFor(ParkourClimbUpTo)
    dobjFor(ClimbDown) asDobjFor(ParkourClimbOffOf)
    dobjFor(GetOff) asDobjFor(ParkourClimbOffOf)
    dobjFor(JumpOff) asDobjFor(ParkourJumpOffOf)
    /*dobjFor(JumpOver) asDobjFor(ParkourJumpOver)
    dobjFor(SlideUnder) asDobjFor(ParkourSlideUnder)
    dobjFor(RunAcross) asDobjFor(ParkourRunAcross)
    dobjFor(SwingOn) asDobjFor(ParkourSwingOn)*/

    dobjFor(ParkourClimbGeneric) {
        parkourActionIntro
        verify() {
            verifyClimbPathFromActor(gActor, parkourCache.autoPathCanDiscover);
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

    parkourReshapeGetOff(ParkourClimbOffOf, ParkourClimbDownTo)
    parkourReshapeGetOff(ParkourJumpOffOf, ParkourJumpDownTo)
}

enum parkourUpDir, parkourOverDir, parkourDownDir;

class ParkourPath: object {
    destination = nil
    provider = nil
    requiresJump = nil
    isHarmful = nil
    direction = parkourOverDir
    isAcknowledged = (!parkourCache.requireRouteRecon)
    maker = nil
    cachedOtherSide = nil
    isBackward = nil
    otherSide() {
        if (maker != nil) {
            cachedOtherSide = maker.createdOtherSide(isBackward);
            maker = nil;
        }
        return cachedOtherSide;
    }

    isProviderKnown = (provider == nil ? nil : provider.hasParkourRecon)
    isProviderEffectivelyKnown = (provider == nil ? true : provider.hasParkourRecon)
    isKnown = (destination.hasParkourRecon && isProviderEffectivelyKnown)

    injectedDiscoverMsg = nil
    injectedPerformMsg = nil
    injectedParkourBarriers = nil
    injectedPathDescription = nil

    acknowledge() {
        isAcknowledged = true;
        if (otherSide() != nil) {
            otherSide().isAcknowledged = true;
        }
    }

    getScore() {
        local score = 0;
        if (isHarmful) score += 4;
        if (requiresJump) score += 2;
        if (provider != nil) score++;
        return score;
    }

    getDiscoverMsg() {
        if (injectedDiscoverMsg != nil) {
            return injectedDiscoverMsg;
        }

        if (provider != nil) {
            if (provider.canJumpOverMe) {
                return provider.getJumpOverToDiscoverMsg(destination.parkourModule);
            }
            if (provider.canRunAcrossMe) {
                return provider.getRunAcrossToDiscoverMsg(destination.parkourModule);
            }
            if (provider.canSwingOnMe) {
                return provider.getSwingOnToDiscoverMsg(destination.parkourModule);
            }
            if (provider.canSlideUnderMe) {
                return provider.getSlideUnderToDiscoverMsg(destination.parkourModule);
            }
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

        if (provider != nil) {
            if (provider.canJumpOverMe) {
                return provider.getJumpOverToMsg(destination.parkourModule);
            }
            if (provider.canRunAcrossMe) {
                return provider.getRunAcrossToMsg(destination.parkourModule);
            }
            if (provider.canSwingOnMe) {
                return provider.getSwingOnToMsg(destination.parkourModule);
            }
            if (provider.canSlideUnderMe) {
                return provider.getSlideUnderToMsg(destination.parkourModule);
            }
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

    isSafeForAutoParkour() {
        if (requiresJump) return nil;
        if (isHarmful) return nil;
        return true;
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
    pathDescription = nil

    startKnown = nil

    otherSide = nil
    createdForward = nil
    createdBackward = (otherSide != nil ? otherSide.createdForward : nil)
    createdOtherSide(isBackward) {
        if (isBackward) return createdForward;
        return createdBackward;
    }

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
        createdForward = getNewPathObject(startKnown);
        createdForward.maker = self;
        getTrueLocation().parkourModule.addPath(createdForward);
    }

    createBackwardPath() { }

    getNewPathObject(startKnown_?) {
        local path = new ParkourPath();
        path.injectedPathDescription = pathDescription;
        path.injectedDiscoverMsg = discoverMsg;
        path.injectedPerformMsg = performMsg;
        path.injectedParkourBarriers = parkourBarriers;
        path.destination = getTrueDestination();
        path.provider = provider;
        path.requiresJump = requiresJump;
        path.isHarmful = isHarmful;
        path.direction = direction;
        if (startKnown_) {
            path.isKnown = true;
            path.isAcknowledged = true;
        }
        return path;
    }
}

/*
 * PATH TYPES
 */

// Climb paths
ProviderPath template @provider ->destination;
class ProviderPath: ParkourPathMaker {
    direction = parkourOverDir
}

AwkwardProviderPath template @provider ->destination;
class AwkwardProviderPath: ParkourPathMaker {
    direction = parkourOverDir
    requiresJump = true
}

DangerousProviderPath template @provider ->destination;
class DangerousProviderPath: ParkourPathMaker {
    direction = parkourOverDir
    requiresJump = true
    isHarmful = true
}

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

    pathDescription = (forwardPathDescription)
    discoverMsg = (discoverForwardMsg)
    performMsg = (performForwardMsg)
    parkourBarriers = (forwardParkourBarriers)
    forwardPathDescription = nil // Just to circumvent mistakes
    discoverForwardMsg = nil // Just to circumvent mistakes
    performForwardMsg = nil // Just to circumvent mistakes
    forwardParkourBarriers = nil // Just to circumvent mistakes
    backwardPathDescription = nil
    discoverBackwardMsg = nil
    performBackwardMsg = nil
    backwardParkourBarriers = nil

    startKnown = (startForwardKnown)
    startForwardKnown = nil // Just to circumvent mistakes
    startBackwardKnown = nil

    createBackwardPath() {
        createdBackward = getNewPathObject(startBackwardKnown);
        createdBackward.maker = self;
        createdBackward.isBackward = true;
        createdBackward.injectedPathDescription = backwardPathDescription;
        createdBackward.injectedDiscoverMsg = discoverBackwardMsg;
        createdBackward.injectedPerformMsg = performBackwardMsg;
        createdBackward.injectedParkourBarriers = backwardParkourBarriers;
        createdBackward.destination = getTrueLocation();
        createdBackward.requiresJump = requiresJumpBack;
        createdBackward.isHarmful = isHarmfulBack;
        switch (createdBackward.direction) {
            case parkourUpDir:
                createdBackward.direction = parkourDownDir;
                break;
            case parkourDownDir:
                createdBackward.direction = parkourUpDir;
                break;
        }
        getTrueDestination().parkourModule.addPath(createdBackward);
    }
}

ProviderLink template @provider ->destination;
class ProviderLink: ParkourLinkMaker {
    direction = parkourOverDir
}

AwkwardProviderLink template @provider ->destination;
class AwkwardProviderLink: ParkourLinkMaker {
    direction = parkourOverDir
    requiresJump = true
}

DangerousProviderLink template @provider ->destination;
class DangerousProviderLink: ParkourLinkMaker {
    direction = parkourOverDir
    requiresJump = true
    isHarmful = true
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

    createForwardPath() {
        getTrueLocation().parkourModule.addPath(getNewPathObject(true));
    }

    createBackwardPath() {
        local backPath = getNewPathObject(startKnown || startBackwardKnown);
        backPath.destination = location;
        backPath.direction = parkourUpDir;
        backPath.requiresJump = requiresJumpBack;
        backPath.isHarmful = isHarmfulBack;
        destination.parkourModule.addPath(backPath);
    }
}

class LowFloorHeight: FloorHeight {
    startKnown = true; // Maintain functional parity with standard platforms
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

// Two-way bridges
class ParkourBridgeMaker: ParkourLinkMaker {
    backwardProvider = nil

    createBackwardPath() {
        createdBackward = getNewPathObject(startBackwardKnown);
        createdBackward.maker = self;
        createdBackward.isBackward = true;
        createdBackward.injectedPathDescription = backwardPathDescription;
        createdBackward.injectedDiscoverMsg = discoverBackwardMsg;
        createdBackward.injectedPerformMsg = performBackwardMsg;
        createdBackward.injectedParkourBarriers = backwardParkourBarriers;
        createdBackward.destination = getTrueLocation();
        createdBackward.provider = backwardProvider;
        createdBackward.requiresJump = requiresJumpBack;
        createdBackward.isHarmful = isHarmfulBack;
        switch (createdBackward.direction) {
            case parkourUpDir:
                createdBackward.direction = parkourDownDir;
                break;
            case parkourDownDir:
                createdBackward.direction = parkourUpDir;
                break;
        }
        createdForward.provider.shareReconWithProcedural.appendUnique(
            createdBackward.provider
        );
        createdBackward.provider.shareReconWithProcedural.appendUnique(
            createdForward.provider
        );
        getTrueDestination().parkourModule.addPath(createdBackward);
        #if __DEBUG
        if (provider == backwardProvider && provider != nil) {
            if (!provider.ofKind(MultiLoc)) {
                "WARNING: There is a provider bridge (initialized in
                <<location.getOutermostRoom().theName>>) which has a
                matching forward provider and backward provider. There
                are two likely mistakes at play here:\n
                <ol>
                <li>This single provider wasn't a MultiLoc.</li>
                <li>A copy-and-paste error filled set the same provider
                for both directions in a template.</li>
                </ol>";
            }
        }
        #endif
    }
}

ProviderBridge template @provider ->destination @backwardProvider;
class ProviderBridge: ParkourBridgeMaker {
    direction = parkourOverDir
}

AwkwardProviderBridge template @provider ->destination @backwardProvider;
class AwkwardProviderBridge: ParkourBridgeMaker {
    direction = parkourOverDir
    requiresJump = true
}

DangerousProviderBridge template @provider ->destination @backwardProvider;
class DangerousProviderBridge: ParkourBridgeMaker {
    direction = parkourOverDir
    requiresJump = true
    isHarmful = true
}