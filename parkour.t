#define gParkourLastPath parkourCore.lastPath
#define gParkourRunner parkourCore.currentParkourRunner
#define gParkourRunnerModule parkourCore.currentParkourRunner.getParkourModule()
#define gTaxingRunnerModule(actor) parkourCore.cacheParkourRunner(gActor).getParkourModule()

#define expandedOnto ('onto'|'on' 'to')
#define expandedInto ('in'|'into'|'in' 'to'|'through')
#define expandedUpSideOf (('the'|) 'side' 'of'|'to'|)
#define genericOnTopOfPrep ('on'|expandedOnto|'on' 'top' 'of'|expandedOnto 'the' 'top' 'of'|'atop')
#define genericAcrossPrep ('over'|'across'|'over' 'to'|'across' 'to'|'to'|'onto'|'on' 'to') (('the'|)'top' 'of'|)

#define climbImplicitReport \
    implicitAnnouncement(success) { \
        local dobjName = parkourCore.theImplicitPlatformName; \
        if (success) { \
            return 'climbing to <<dobjName>>'; \
        } \
        return 'failing to climb to <<dobjName>>'; \
    }

#define climbForcesNoJumpFactor true

modify Action {
    forceDoNoFactorJump = nil
}

VerbRule(ParkourClimbOverTo)
    ('climb'|'cl'|'get'|'step') genericAcrossPrep singleDobj
    : VerbProduction
    action = ParkourClimbOverTo
    verbPhrase = 'climb/climbing over to (what)'
    missingQ = 'what do you want to climb over to'
;

DefineTAction(ParkourClimbOverTo)
    climbImplicitReport
    forceDoNoFactorJump = climbForcesNoJumpFactor
;

VerbRule(ParkourClimbOverInto)
    ('climb'|'cl'|'get'|'step') expandedInto singleDobj
    : VerbProduction
    action = ParkourClimbOverInto
    verbPhrase = 'climb/climbing through (what)'
    missingQ = 'what do you want to climb through'
;

DefineTAction(ParkourClimbOverInto)
    allowImplicit = nil
    forceDoNoFactorJump = climbForcesNoJumpFactor
;

VerbRule(ParkourJumpOverTo)
    ('jump'|'jm'|'hop'|'leap') genericAcrossPrep singleDobj
    : VerbProduction
    action = ParkourJumpOverTo
    verbPhrase = 'jump/jumping to (what)'
    missingQ = 'what do you want to jump to'
;

DefineTAction(ParkourJumpOverTo)
    allowImplicit = nil
    forceDoNoFactorJump = true
;

VerbRule(ParkourJumpOverInto)
    ('jump'|'jm'|'hop'|'leap'|'dive') expandedInto singleDobj
    : VerbProduction
    action = ParkourJumpOverInto
    verbPhrase = 'jump/jumping through (what)'
    missingQ = 'what do you want to jump through'
;

DefineTAction(ParkourJumpOverInto)
    allowImplicit = nil
    forceDoNoFactorJump = true
;

VerbRule(ParkourJumpUpTo)
    ('jump'|'jm'|'hop'|'leap'|'clamber'|'scramble'|'wall' 'run'|'wallrun'|'run'|'sprint') ('up' expandedUpSideOf|genericOnTopOfPrep) singleDobj |
    ('clamber'|'scale') singleDobj
    : VerbProduction
    action = ParkourJumpUpTo
    verbPhrase = 'jump/jumping up (what)'
    missingQ = 'what do you want to jump up'
;

DefineTAction(ParkourJumpUpTo)
    allowImplicit = nil
    forceDoNoFactorJump = true
;

VerbRule(ParkourJumpUpInto)
    ('jump'|'jm'|'hop'|'leap'|'clamber'|'scramble'|'wall' 'run'|'wallrun'|'run'|'sprint') 'up' expandedInto singleDobj
    : VerbProduction
    action = ParkourJumpUpInto
    verbPhrase = 'jump/jumping up into (what)'
    missingQ = 'what do you want to jump up into'
;

DefineTAction(ParkourJumpUpInto)
    allowImplicit = nil
    forceDoNoFactorJump = true
;

VerbRule(ParkourJumpDownTo)
    ('jump'|'jm'|'hop'|'leap'|'clamber'|'scramble'|'drop'|'fall') 'down' 'to' singleDobj
    : VerbProduction
    action = ParkourJumpDownTo
    verbPhrase = 'jump/jumping down to (what)'
    missingQ = 'what do you want to jump down to'
;

DefineTAction(ParkourJumpDownTo)
    allowImplicit = nil
    forceDoNoFactorJump = true
;

VerbRule(ParkourJumpDownInto)
    ('jump'|'jm'|'hop'|'leap'|'clamber'|'scramble'|'drop'|'fall'|'dive') 'down' expandedInto singleDobj
    : VerbProduction
    action = ParkourJumpDownInto
    verbPhrase = 'jump/jumping down into (what)'
    missingQ = 'what do you want to jump down into'
;

DefineTAction(ParkourJumpDownInto)
    allowImplicit = nil
    forceDoNoFactorJump = true
;

VerbRule(ParkourClimbDownTo)
    ('climb'|'cl'|'get'|'step'|'descend') 'down' 'to' singleDobj
    : VerbProduction
    action = ParkourClimbDownTo
    verbPhrase = 'climb/climbing down to (what)'
    missingQ = 'what do you want to climb down to'
;

DefineTAction(ParkourClimbDownTo)
    climbImplicitReport
    forceDoNoFactorJump = climbForcesNoJumpFactor
;

VerbRule(ParkourClimbDownInto)
    ('climb'|'cl'|'get'|'step'|'descend') 'down' expandedInto singleDobj
    : VerbProduction
    action = ParkourClimbDownInto
    verbPhrase = 'climb/climbing down into (what)'
    missingQ = 'what do you want to climb down into'
;

DefineTAction(ParkourClimbDownInto)
    allowImplicit = nil
    forceDoNoFactorJump = climbForcesNoJumpFactor
;

VerbRule(ParkourClimbUpInto)
    ('climb'|'cl'|'mantel'|'mantle'|'go'|'walk'|'parkour'|'scale'|'ascend') 'up' expandedInto singleDobj
    : VerbProduction
    action = ParkourClimbUpInto
    verbPhrase = 'climb/climbing up into (what)'
    missingQ = 'what do you want to climb up into'
;

DefineTAction(ParkourClimbUpInto)
    allowImplicit = nil
    forceDoNoFactorJump = climbForcesNoJumpFactor
;

VerbRule(ParkourClimbUpTo)
    ('climb'|'cl'|'mantel'|'mantle'|'go'|'walk'|'parkour'|'scale'|'ascend') ('up' expandedUpSideOf|genericOnTopOfPrep) singleDobj
    : VerbProduction
    action = ParkourClimbUpTo
    verbPhrase = 'climb/climbing up to (what)'
    missingQ = 'what do you want to climb up to'
;

DefineTAction(ParkourClimbUpTo)
    climbImplicitReport
    forceDoNoFactorJump = climbForcesNoJumpFactor
;

VerbRule(ParkourJumpGeneric)
    ('jump'|'hop'|'leap'|'jm') singleDobj
    : VerbProduction
    action = ParkourJumpGeneric
    verbPhrase = 'jump/jumping somehow to (what)'
    missingQ = 'what do you want to jump to'
;

DefineTAction(ParkourJumpGeneric)
    allowImplicit = nil
    forceDoNoFactorJump = true
;

VerbRule(ParkourClimbGeneric)
    ('climb'|'cl'|'mantel'|'mantle'|'mount'|'board'|'ascend'|'scale') singleDobj |
    /*('climb'|'cl'|'mantel'|'mantle'|'get'|'go') genericOnTopOfPrep singleDobj |*/
    'parkour' ('to'|) singleDobj
    : VerbProduction
    action = ParkourClimbGeneric
    verbPhrase = 'parkour/parkouring to (what)'
    missingQ = 'what do you want to parkour to'
;

DefineTAction(ParkourClimbGeneric)
    climbImplicitReport
    forceDoNoFactorJump = climbForcesNoJumpFactor
;

modify VerbRule(JumpOver)
    ('jump'|'jm'|'hop'|'leap'|'vault') ('over'|) singleDobj :
;

modify JumpOver {
    forceDoNoFactorJump = true
}

VerbRule(SlideUnder)
    ('slide'|'dive'|'roll'|'go'|'crawl'|'scramble'|'slither'|'climb'|'cl') 'under' singleDobj
    : VerbProduction
    action = SlideUnder
    verbPhrase = 'slide/sliding under (what)'
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
    verbPhrase = 'run/running across (what)'
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
    verbPhrase = 'swing/swinging on (what)'
    missingQ = 'what do you want to swing on'
;

DefineTAction(SwingOn)
    implicitAnnouncement(success) {
        if (success) {
            return 'swinging on {the dobj}';
        }
        return 'failing to swing on {the dobj}';
    }
    forceDoNoFactorJump = true
;

VerbRule(SqueezeThrough)
    [badness 10] ('squeeze'|'crawl'|'slide'|'fit' ('self'|'myself'|)|'go'|'climb'|'cl') ('through'|'thru'|'between'|'btwn'|'btw'|'bw'|'into') singleDobj
    : VerbProduction
    action = SqueezeThrough
    verbPhrase = 'squeeze/squeezing through (what)'
    missingQ = 'what do you want to squeeze through'
;

DefineTAction(SqueezeThrough)
    implicitAnnouncement(success) {
        if (success) {
            return 'squeezing through {the dobj}';
        }
        return 'failing to squeeze through {the dobj}';
    }
;

VerbRule(ParkourClimbOffOf)
    ('get'|'climb'|'cl'|'parkour') ('off'|'off' 'of'|'down' 'from') singleDobj |
    'off' singleDobj
    : VerbProduction
    action = ParkourClimbOffOf
    verbPhrase = 'get/getting off of (what)'
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
    ('get'|'climb'|'cl'|'parkour') ('off'|'down') | 'off'
    : VerbProduction
    action = ParkourClimbOffIntransitive
    verbPhrase = 'climb/climbing off'        
;

DefineIAction(ParkourClimbOffIntransitive)
    allowAll = nil

    execAction(cmd) {
        parkourCore.cacheParkourRunner(gActor);
        doInstead(ParkourClimbOffOf, gParkourRunner.location);
    }
;

VerbRule(ParkourJumpOffOf)
    ('jm'|'jump'|'hop'|'leap'|'fall'|'drop'|'dive') ('off'|'off' 'of'|'down' 'from') singleDobj
    : VerbProduction
    action = ParkourJumpOffOf
    verbPhrase = 'jump/jumping off of (what)'
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
    ('jm'|'jump'|'hop'|'leap'|'fall'|'drop'|'dive') ('off'|'down')
    : VerbProduction
    action = ParkourJumpOffIntransitive
    verbPhrase = 'jump/jumping off'        
;

DefineIAction(ParkourJumpOffIntransitive)
    execAction(cmd) {
        parkourCore.cacheParkourRunner(gActor);
        doInstead(ParkourJumpOffOf, gParkourRunner.location);
    }
;

VerbRule(ParkourJumpInPlace)
    ('jump'|'jm'|'hop') ('up'|) ('in' 'place'|'on' 'the' 'spot')
    : VerbProduction
    action = ParkourJumpInPlace
    verbPhrase = 'jump/jumping in place'        
;

DefineIAction(ParkourJumpInPlace)
    execAction(cmd) {
        "{I} jump{s/ed} on the spot, fruitlessly. ";
    }
;

modify VerbRule(Jump)
    ('jump'|'jm'|'hop') ('up'|)|'dive' :
;

modify VerbRule(ClimbUpWhat)
    ('climb'|'cl'|'shimmy'|'ascend') 'up' | 'ascend' :
;

modify VerbRule(ClimbDownWhat)
    ('climb'|'cl'|'shimmy'|'descend') 'down' | 'descend' :
;

modify VerbRule(ClimbUp)
    ('climb'|'cl'|'ascend'|'scale'|'go'|'walk') 'up' singleDobj |
    ('ascend'|'scale') singleDobj :
;

modify VerbRule(ClimbDown)
    ('climb'|'cl'|'descend'|'go'|'walk') 'down' singleDobj |
    'descend' singleDobj :
;

modify Climb {
    forceDoNoFactorJump = climbForcesNoJumpFactor
}

modify ClimbUp {
    forceDoNoFactorJump = climbForcesNoJumpFactor
}

modify ClimbDown {
    forceDoNoFactorJump = climbForcesNoJumpFactor
}

#define expandableLocalPlats 'platforms'|'plats'|'surfaces'|'supporters'
#define expandableParkourShowList ('show' ('list' ('of'|)|)|'list'|'remember'|'review'|'search')
#define expandableParkourAvailability ('available'|'known'|'familiar'|'traveled'|'travelled'|)
#define expandableRouteRoot ('parkour'|'prkr'|'pkr'|'pk'|expandableParkourTargetShort)
#define expandableParkourTargetShort 'paths'|'pathways'|'routes'|'route'|expandableLocalPlats

VerbRule(ShowParkourRoutes)
    expandableParkourShowList expandableParkourAvailability (expandableParkourTargetShort) |
    expandableParkourShowList (expandableParkourTargetShort) |
    expandableRouteRoot
    : VerbProduction
    action = ShowParkourRoutes
    verbPhrase = 'show/showing parkour routes'        
;

DefineSystemAction(ShowParkourRoutes)
    allowAll = nil
    turnsTaken = 0

    execAction(cmd) {
        parkourCore.printParkourRoutes();
    }
;

VerbRule(ShowParkourKey)
    ('show'|) expandableRouteRoot ('list'|) ('key'|'legend')
    : VerbProduction
    action = ShowParkourKey
    verbPhrase = 'show/showing parkour route list key'        
;

DefineSystemAction(ShowParkourKey)
    allowAll = nil
    turnsTaken = 0

    execAction(cmd) {
        parkourCore.printParkourKey();
    }
;

VerbRule(ShowParkourLocalPlatforms)
    ('show'|'list'|) (expandableRouteRoot|) (('local'|'near'|'nearby') (expandableLocalPlats)|expandableLocalPlats|'local'|'locals'|'near'|'nearby')
    : VerbProduction
    action = ShowParkourLocalPlatforms
    verbPhrase = 'show/showing parkour local platforms'        
;

DefineSystemAction(ShowParkourLocalPlatforms)
    allowAll = nil
    turnsTaken = 0

    execAction(cmd) {
        parkourCore.printLocalPlatforms();
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

DefineSystemAction(ShowAllParkourRoutes)
    allowAll = nil
    turnsTaken = 0

    execAction(cmd) {
        parkourCore.printParkourRoutes();
        "\b";
        parkourCore.printLocalPlatforms();
    }
;

#ifdef __DEBUG
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

getBulletPoint(requiresJump, isHarmful) {
    if (isHarmful && requiresJump) return '\n\t<tt><b>[!*]</b></tt>';
    if (isHarmful) return '\n\t<tt><b>[!!]</b></tt>';
    if (requiresJump) return '\n\t<tt><b>[**]</b></tt>';
    return '\n\t<tt><b>[&gt;&gt;]</b></tt>';
}

//TODO: Tutorial hinting
parkourCore: object {
    requireRouteRecon = true
    formatForScreenReader = (gFormatForScreenReader)
    //autoPathCanDiscover = (!requireRouteRecon)
    autoPathCanDiscover = true
    enforceDirectionality = nil
    announceRouteAfterTrying = true
    maxReconsPerTurn = 3

    cacheParkourRunner(actor) {
        local potentialVehicle = actor.location;
        while (potentialVehicle != nil && !potentialVehicle.ofKind(Room)) {
            if (potentialVehicle.isVehicle) {
                currentParkourRunner = potentialVehicle;
                return currentParkourRunner;
            }
            potentialVehicle = potentialVehicle.location;
        }
        
        currentParkourRunner = actor;
        return currentParkourRunner;
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

    getKeyString() {
        local strBfr = new StringBuffer(5);
        strBfr.append(formatTitle('Bullet Symbol Key'));
        createBasicListItem(strBfr,
            getBulletPoint(true, true), ' = dangerous jump'
        );
        createBasicListItem(strBfr,
            getBulletPoint(nil, true), ' = dangerous climb'
        );
        createBasicListItem(strBfr,
            getBulletPoint(true, nil), ' = jump'
        );
        createBasicListItem(strBfr,
            getBulletPoint(nil, nil), ' = simple climb'
        );
        return toString(strBfr);
    }

    loadParkourKeyHint(strBfr) {
        strBfr.append('\n');
        strBfr.append(aHrefAlt(
            'show parkour list key',
            '<small>Not sure what the bullet symbols mean?
            Click here!</small> ',
            '(Not sure what the bullet symbols mean?
            Type <<formatCommand('PARKOUR KEY')>> for clarification!) '
        ));
        strBfr.append('<.p>');
    }

    printParkourKey() {
        if (parkourCore.formatForScreenReader) {
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
            '\n<small>Click here for all known routes!</small><.p>',
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
        parkourCore.cacheParkourRunner(gActor);
        return gParkourRunner.getLocalPlatforms();
    }

    printLocalPlatforms() {
        local platList = getLocalPlatforms();
        platList = platList.subset({p: !p.omitFromPrintedLocalsList()});
        if (platList.length == 0) {
            "{I} {see} no known or notable surfaces in easy reach.<.p>";
            return;
        }
        "The following surfaces{plural} {is} either in easy reach,
        or rest{s/ed} on the same surface that {i} {do}:<.p>";
        if (formatForScreenReader) {
            "<<makeListStr(platList, &getPlatformName, 'and')>>";
        }
        else {
            local strBfr = new StringBuffer();
            for (local i = 1; i <= platList.length; i++) {
                local plat = platList[i];
                local platName = plat.getPlatformName();
                strBfr.append('\n\t');
                strBfr.append(aHrefAlt(
                    plat.getLocalPlatformBoardingCommand(),
                    platName,
                    platName
                ));
            }
            say(toString(strBfr));
        }
    }

    //TODO: Find a better way to print this hint
    loadAbbreviationReminder(strBfr) {
        if (hasShownClimbAbbreviationHint) return;
        strBfr.append(
            '<<remember>>
            <i>You can use parkour shorthand to enter commands faster!</i>\b
            <<formatCommand('CLIMB')>> can be shortened to <<abbr('CL')>>, and
            <<formatCommand('JUMP')>> can be shortened to <<abbr('JM')>>!
            <<formatTitle('Examples')>>
            <<formatCommand('CL UP DESK')>> for an <i>explicit</i> climb-up, or just
            <<formatCommand('CL DESK')>> for an <i>implicit</i> climb, which picks the
            most appropriate direction, but only if it was used before.'
        );
        hasShownClimbAbbreviationHint = true;
    }

    implicitPlatform = nil
    theImplicitPlatformName() {
        if (implicitPlatform == nil) return 'a better spot';
        return implicitPlatform.theName;
    }
    lastPath = nil
    currentParkourRunner = nil
    showNewRoute = nil
    hadAccident = nil
    hasShownClimbAbbreviationHint = nil
    noKnownRoutesMsg =
        '{I} {do} not {know} of any interesting routes from {here}. '
    
    isParkourPoorlyHandledFor(obj) {
        if (obj.parkourModule == nil && !obj.forcedLocalPlatform) {
            for (local i = 1; i < poorlyHandledActions.length; i++) {
                if (gActionIs(poorlyHandledActions[i])) {
                    return true;
                }
            }
        }
        return nil;
    }

    poorlyHandledActions = [
        Board, Climb, ClimbUp, ClimbDown,
        ParkourClimbUpTo, ParkourClimbOverTo, ParkourClimbDownTo,
        ParkourClimbUpInto, ParkourClimbOverInto, ParkourClimbDownInto,
        ParkourJumpUpTo, ParkourJumpOverTo, ParkourJumpDownTo,
        ParkourJumpUpInto, ParkourJumpOverInto, ParkourJumpDownInto
    ]
}

reachGhostTest_: Thing {
    isListed = nil
    isFixed = nil
    isLikelyContainer() {
        return nil;
    }
}

//TODO: Throw an error if link or path goes to a class, instead of object

#ifdef __DEBUG
#define __PARKOUR_REACH_DEBUG nil
#define __PARKOUR_REACH_TRUE_NAMES nil
#else
#define __PARKOUR_REACH_DEBUG nil
#define __PARKOUR_REACH_TRUE_NAMES nil
#endif

enum parkourReachSuccessful, parkourReachTopTooFar, parkourSubComponentTooFar;

QParkour: Special {
    priority = 16
    active = true

    reachProblemVerify(a, b) {
        local issues = [];

        if (a.ofKind(Floor)) {
            a = gPlayerChar.outermostVisibleParent();
        }
        if (b.ofKind(Floor)) {
            b = gPlayerChar.outermostVisibleParent();
        }

        // Don't worry about room connections
        //if (a.ofKind(Room) && b.ofKind(Room)) return issues;

        local aReach = a;
        local aItem = nil;
        local aLoc = nil;
        local aLocReach = nil;
        local doNotFactorJumpForA = nil;

        local bReach = b;
        local bItem = nil;
        local bLoc = nil;
        local bLocReach = nil;
        local doNotFactorJumpForB = nil;

        #if __PARKOUR_REACH_DEBUG
        extraReport('\n(Start special reach check for:
            <<gCommand.verbProd.verbPhrase>>)\n');
        #endif

        local needsTouchObj = nil;
        local preCondProp = nil;
        if (gDobj == b) {
            #if __PARKOUR_REACH_DEBUG
            extraReport('\n(B is Dobj.)\n');
            #endif
            if (b.isDecoration) {
                preCondProp = &preCondDobjDefault;
            }
            else {
                preCondProp = gAction.preCondDobjProp;
            }
        }
        else if (gIobj == b) {
            #if __PARKOUR_REACH_DEBUG
            extraReport('\n(B is Iobj.)\n');
            #endif
            if (b.isDecoration) {
                preCondProp = &preCondIobjDefault;
            }
            else {
                preCondProp = gAction.preCondIobjProp;
            }
        }
        else {
            #if __PARKOUR_REACH_DEBUG
            extraReport('\n(B is Aobj.)\n');
            #endif
            if (b.isDecoration) {
                preCondProp = &preCondAobjDefault;
            }
            else {
                preCondProp = gAction.preCondAobjProp;
            }
        }

        if (preCondProp != nil) {
            needsTouchObj = (valToList(b.(preCondProp)).indexOf(touchObj) != nil);
        }
        local doNotFactorJump = !needsTouchObj || gAction.forceDoNoFactorJump;

        local remapA = a.remapReach(gAction);
        local remapB = b.remapReach(gAction);

        if (a.isLikelyContainer()) {
            aLoc = a;
            if (remapA != nil) {
                aReach = remapA;
                aLocReach = remapA;
            }
            else {
                aLocReach = aLoc;
            }
            doNotFactorJumpForA = doNotFactorJump;
            #if __PARKOUR_REACH_DEBUG
            extraReport('\n(LOC A: <<aLoc.theName>> (<<aLoc.contType.prep>>)
                in <<aLoc.getOutermostRoom().theName>>.)\n');
            #endif
        }
        else {
            aItem = a;
            aLoc = a.location;
            if (remapA != nil) {
                aReach = remapA;
                aLocReach = remapA.location;
            }
            else {
                aLocReach = aLoc;
            }
            #if __PARKOUR_REACH_DEBUG
            extraReport('\n(ITEM A: <<aItem.theName>> (<<aItem.contType.prep>>)
                in <<aLoc.theName>>, <<aLoc.getOutermostRoom().theName>>.)\n');
            #endif
        }

        if (b.isLikelyContainer()) {
            bLoc = b;
            if (remapB != nil) {
                bReach = remapB;
                bLocReach = remapB;
            }
            else {
                bLocReach = bLoc;
            }
            doNotFactorJumpForB = doNotFactorJump;
            #if __PARKOUR_REACH_DEBUG
            extraReport('\n<<bLoc.getOutermostRoom() == nil ? 'nil' : 'found'>>');
            extraReport('\n(LOC B: <<bLoc.theName>> (<<bLoc.contType.prep>>)
                in <<bLoc.getOutermostRoom().theName>>.)\n');
            #endif
        }
        else {
            bItem = b;
            bLoc = b.location;
            if (remapB != nil) {
                bReach = remapB;
                bLocReach = remapB.location;
            }
            else {
                bLocReach = bLoc;
            }
            #if __PARKOUR_REACH_DEBUG
            extraReport('\n(ITEM B: <<bItem.theName>> (<<bItem.contType.prep>>)
                in <<bLoc.theName>>, <<bLoc.getOutermostRoom().theName>>.)\n');
            #endif
        }

        // Attempt to end early with bonus reaches
        if (aLocReach.canBonusReachDuring(bLocReach, gAction)) return issues;
        if (bLocReach.canBonusReachDuring(aLocReach, gAction)) return issues;

        local parkourA = aReach.getParkourModule();
        local parkourB = bReach.getParkourModule();

        if (parkourA == nil && parkourB == nil) {
            // Parkour checks will be useless here
            return issues;
        }

        if (parkourB == nil) {
            #if __PARKOUR_REACH_DEBUG
            extraReport('\nparkourB = nil\n');
            #endif
            if (parkourA != nil) {
                local reachResult = parkourA.isInReachFromVerbose(
                    bReach, true, doNotFactorJumpForA
                );
                if (reachResult != parkourReachSuccessful) {
                    issues += getMessageFromReachResult(
                        a, b, aItem, bItem, aLoc, bLoc, reachResult
                    );
                    return issues;
                }
            }
            else {
                #if __PARKOUR_REACH_DEBUG
                extraReport('\nparkourA = nil\n');
                #endif
                if (aLoc.stagingLocation != bLoc) {
                    issues += new ReachProblemDistance(a, b);
                    return issues;
                }
            }
        }
        else {
            local reachResult = parkourB.isInReachFromVerbose(
                aReach, true, doNotFactorJumpForB
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
                if (!bLoc.omitFromStagingError()) {
                    return new ReachProblemParkour(
                        a, b, aItem, bItem, aLoc, bLoc
                    );
                }
                else {
                    return new ReachProblemDistance(a, b);
                }
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

    srcItemName = (srcItem_.theName);
    srcItemIs() {
        if (srcItem_.person == 1) {
            return '{am|was}';
        }
        if (srcItem_.plural || srcItem_.person == 2) {
            return '{are|were}';
        }
        return '{is|was}';
    }
    srcItemNameIs = (srcItemName + ' ' + srcItemIs())

    srcLocSmart() {
        if (srcLoc_.ofKind(Room)) {
            if (srcLoc_.floorObj != nil) {
                return 'on ' + srcLoc_.floorObj.theName +
                    ' of ' + srcLoc_.roomTitle;
            }
        }
        return srcLoc_.contType.prep + ' ' + srcLoc_.theName;
    }

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

    getReasonPhrase = (
        ', because <<srcItemNameIs>> <<srcLocSmart()>>'
    )
}

// General error for being unable to reach, due to parkour limitations
class ReachProblemParkour: ReachProblemParkourBase {
    tooFarAwayMsg() {
        if (trgItem_ == nil) {
            if (trgLoc_.contType == On || trgLoc_.partOfParkourSurface) {
                return 'The top of <<trgLocNameIs>> out of reach<<getReasonPhrase>>. ';
            }
            return 'That part of <<trgLocNameIs>> out of reach<<getReasonPhrase>>. ';
        }

        if (trgLoc_.contType == On) {
            return '\^<<trgItemNameIs>> on top of <<trgLocName>>,
                which <<trgLocIs>> out of reach<<getReasonPhrase>>. ';
        }
        return '\^<<trgItemNameIs>> <<trgLoc_.contType.prep>> <<trgLocName>>,
            which <<trgLocIs>> out of reach<<getReasonPhrase>>. ';
    }
}

// Error for attempt to reach inside of container while standing on top of it
class ReachProblemParkourFromTopOfSame: ReachProblemParkourBase {
    tooFarAwayMsg() {
        if (trgItem_ == nil) {
            if (trgLoc_.contType == On || trgLoc_.partOfParkourSurface) {
                return 'The top of <<trgLocName>> {cannot} be reached from {here}<<getReasonPhrase>>. ';
            }
            return 'That part of <<trgLocName>> {cannot} be reached from {here}<<getReasonPhrase>>. ';
        }

        if (trgLoc_.contType == On) {
            return '\^<<trgItemNameIs>> on top of <<trgLocName>>,
                and that part {cannot} be reached from {here}<<getReasonPhrase>>. ';
        }
        return '\^<<trgItemNameIs>> <<trgLoc_.contType.prep>> <<trgLocName>>,
            and that part {cannot} be reached from {here}<<getReasonPhrase>>. ';
    }
}

// Modifying the behavior for moving actors into position
modify actorInStagingLocation {
    checkPreCondition(obj, allowImplicit) {
        //if (parkourPathFinder.mapBetween(gActor, obj, true, nil)) return true;
        local stagingLoc = obj.stagingLocation;
        return doPathCheck(stagingLoc, allowImplicit);
    }

    doPathCheck(stagingLoc, allowImplicit) {
        parkourCore.cacheParkourRunner(gActor);
        local loc = gParkourRunner.location;

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
            if (!gParkourRunner.fitForParkour) {
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
                parkourCore.implicitPlatform = impDest;
                local tried = tryImplicitAction(impAction, impDest);
                if (tried) {
                    spendImplicitTurn();
                }
                if (gParkourRunner.location == stagingLoc) return true;
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

#define fastParkourClimbMsg(upPrep, overPrep, downPrep, capsActionStr, conjActionString) \
    getClimbUpDiscoverMsg() { \
        return '({I} learned a new route: ' + \
            formatCommand(capsActionStr + ' ' + upPrep + ' ' + theName, longCmd) + \
            '!) '; \
    } \
    getClimbOverDiscoverMsg() { \
        return '({I} learned a new route: ' + \
            formatCommand(capsActionStr + ' ' + overPrep + ' ' + theName, longCmd) + \
            '!) '; \
    } \
    getClimbDownDiscoverMsg() { \
        return '({I} learned a new route: ' + \
            formatCommand(capsActionStr + ' ' + downPrep + ' ' + theName, longCmd) + \
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
        return '({I} learned a new route: ' + \
            formatCommand(capsActionStr + ' ' + upPrep + ' ' + theName, longCmd) + \
            '!) '; \
    } \
    getJumpOverDiscoverMsg() { \
        return '({I} learned a new route: ' + \
            formatCommand(capsActionStr + ' ' + overPrep + ' ' + theName, longCmd) + \
            '!) '; \
    } \
    getJumpDownDiscoverMsg() { \
        return '({I} learned a new route: ' + \
            formatCommand(capsActionStr + ' ' + downPrep + ' ' + theName, longCmd) + \
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

modify Thing {
    parkourModule = nil
    isPushable = nil

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

    filterParkourList(np, cmd, mode, pm) {
        //
    }

    climbOnAlternative = (isClimbable ? Climb : (canClimbUpMe ? ClimbUp : Board))
    climbOffAlternative = (canClimbDownMe ? ClimbDown : GetOff)
    enterAlternative = (canGoThroughMe ? GoThrough : Enter)
    jumpOffAlternative = JumpOff

    // If true, do not implicitly try an enter action for climb/jump into.
    // Just handle it as climb/jump to, instead.
    simplyRerouteClimbInto = nil

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
    hasParkourRecon = (!parkourCore.requireRouteRecon)
    // Other Things that this will share recon with
    shareReconWith = []
    // This gets added to the above list, and should not be touched by authors
    shareReconWithProcedural = perInstance(new Vector())
    // Do not show get off option (standard containers)
    doNotSuggestGetOff = nil
    // Forced local platforms are:
    //     1. Forcefully added to the locals list.
    //     2. NEVER a container.
    //     3. Implement very strange overrides to parkour actions.
    //     4. Cannot qualify for a parkour module
    forcedLocalPlatform = nil
    // If true, allows a local platform to NEVER show in the locals list
    unlistedLocalPlatform = nil
    // Allows a local platform to be hidden from the list
    // until either searched or utilized
    secretLocalPlatform = nil
    // The preferred action for using this local platform
    preferredBoardingAction = nil
    // The opposite side of a possible two-sided local platform
    oppositeLocalPlatform = nil
    // After moving into the destination, the traveler will be moved
    // to the destination platform
    destinationPlatform = nil
    // Has the player been here before?
    // SET WITH markAsClimbed()
    // GET WITH hasBeenClimbed()
    playerClimbed = nil

    markAsClimbed() {
        playerClimbed = true;
    }

    hasBeenClimbed() {
        return playerClimbed;
    }

    getPreferredBoardingAction() {
        if (preferredBoardingAction != nil) return preferredBoardingAction;
        if (isEnterable) return Enter;
        if (canClimbUpMe) return ClimbUp;
        if (canClimbDownMe) return ClimbDown;
        if (isClimbable) return Climb;
        return Board;
    }

    getLocalPlatformBoardingCommand() {
        local prefAct = getPreferredBoardingAction();
        return prefAct.getVerbPhrase1(
            true, prefAct.verbRule.verbPhrase, theName, nil
        ).trim().toLower();
    }

    omitFromStagingError() {
        // There isn't anything to suggest, so omit it.
        if (stagingLocation == nil) return true;

        // Being on the floor is obvious
        if (stagingLocation.ofKind(Room)) return nil;

        // Being on the same surface as it is obvious
        parkourCore.cacheParkourRunner(gPlayerChar);
        if (stagingLocation == gParkourRunner.location) return nil;

        // The rest is not obvious
        if (parkourCore.requireRouteRecon) {
            if (forcedLocalPlatform) return secretLocalPlatform;
            if (hasParkourRecon) return nil;
            return !hasBeenClimbed();
        }
        return nil;
    }

    // Do any solvers searching for local platforms consider this?
    omitFromLogicalLocalsList() {
        if (parkourCore.requireRouteRecon) {
            return secretLocalPlatform;
        }
        return nil;
    }

    // Do any printed lists for local platforms consider this?
    omitFromPrintedLocalsList() {
        if (unlistedLocalPlatform) return true;
        if (parkourCore.requireRouteRecon) {
            return secretLocalPlatform;
        }
        return nil;
    }

    applyRecon() {
        hasParkourRecon = true;
        local reconLst = valToList(shareReconWith);
        reconLst += valToList(shareReconWithProcedural);
        for (local i = 1; i <= reconLst.length; i++) {
            reconLst[i].hasParkourRecon = true;
        }
    }

    doParkourSearch() {
        doRecon();
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
        if (canSqueezeThroughMe) return self;

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

    checkLocalPlatformReconHandled(previousSignal) {
        if (!previousSignal && forcedLocalPlatform) {
            learnOnlyLocalPlatform(self, extraReport);
        }
        return forcedLocalPlatform || previousSignal;
    }

    doRecon() {
        if (checkLocalPlatformReconHandled(nil)) {
            return;
        }

        local provider = getParkourProvider(nil, nil);

        if (provider != nil) {
            if (!provider.hasParkourRecon) {
                local pm = gTaxingRunnerModule(gActor);
                if (pm != nil) {
                    pm.doReconForProvider(provider);
                }
            }
        }

        if (!isLikelyContainer()) return;

        if (parkourModule != nil) parkourModule.doRecon();
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
        if (!parkourCore.formatForScreenReader) {
            parkourCore.loadParkourKeyHint(strBfr);
        }
        loadGetOffSuggestion(strBfr, nil, nil);
        return toString(strBfr);
    }

    loadGetOffSuggestion(strBfr, requiresJump, isHarmful) {
        if (standardDoNotSuggestGetOff()) return;
        if (parkourCore.formatForScreenReader) {
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
            local commandText = ' GET OFF';
            if (requiresJump) {
                commandText = ' JUMP OFF';
            }
            strBfr.append(formatCommand(commandText, longCmd));
        }
    }

    checkProviderAccident(actor, traveler, path) {
        local hadAccident = gOutStream.watchForOutput({:
            doProviderAccident(actor, traveler, path)
        });
        parkourCore.hadAccident = parkourCore.hadAccident || hadAccident;
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

    // Objects to inject into the list of locals
    // This is used on the platform itself
    getBonusLocalPlatforms() {
        return nil;
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

        local platList = valToList(masterPlatform.getBonusLocalPlatforms());
        local contentList = valToList(masterPlatform.contents);

        // A local platform will be in the location's contents,
        // and pass the ghost reach test from an actor
        for (local i = 1; i <= contentList.length; i++) {
            local obj = contentList[i];

            if (omitFromLogicalLocalsList()) continue;

            // Check forced
            if (obj.forcedLocalPlatform) {
                reachGhostTest_.moveInto(
                    obj.stagingLocation.getGhostReachDestination()
                );
                if (!Q.canReach(self, reachGhostTest_)) continue;
                platList += obj;
                continue;
            }

            // Check typical
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

    getPlatformName() {
        if (forcedLocalPlatform) return theName;
        local pm = getParkourModule();
        if (pm != nil) return pm.theName;
        return theName;
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
        if (parkourCore.doParkourRunnerCheck(actor)) {
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
    canSqueezeThroughMe = nil

    parkourProviderAction(JumpOver, remapOn)
    parkourProviderAction(SlideUnder, remapUnder)
    parkourProviderAction(RunAcross, remapOn)
    parkourProviderAction(SwingOn, remapOn)
    parkourProviderAction(SqueezeThrough, remapIn)

    // Best for parkour surfaces only
    canBonusReachDuring(obj, action) {
        return nil;
    }

    // Best for parkour surfaces only
    remapReach(action) {
        return nil;
    }

    #ifdef __DEBUG
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
            local parkourStatusStr = (parkourModule == nil ?
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
    cannotSqueezeThroughMsg =
        '{The subj dobj} {is} not something {i} {can} squeeze through. '
    uselessSlideUnderMsg =
        'Sliding under {the dobj}{dummy} {do} very little from {here}. '
    uselessRunAcrossMsg =
        'Running across {the dobj}{dummy} {do} very little from {here}. '
    uselessJumpOverMsg =
        'Jumping over {the dobj}{dummy} {do} very little from {here}. '
    uselessSwingOnMsg =
        'Swinging on {the dobj}{dummy} {do} very little from {here}. '
    uselessSqueezeThroughMsg =
        'Squeezing through {the dobj}{dummy} {do} very little from {here}. '
    noParkourPathFromHereMsg =
        '{I} {know} no path to get there. '
    parkourNeedsJumpMsg =
        '{I} need{s/ed} to JUMP instead, if {i} want{s/ed} to get there. '
    parkourNeedsFallMsg =
        '{I} need{s/ed} to JUMP instead, if {i} want{s/ed} to get there.
        However, the drop seems rather dangerous...! '
    parkourUnnecessaryJumpMsg =
        '({i} {can} get there easily, so {i} decide{s/d} against jumping...) '
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
    noNewRoutesMsg =
        '{I} notice{s/d} no new parkour possibilities, beyond what{dummy} {is} already known. '
    alreadyOnFloorMsg =
        '{I} remain{s/ed} on <<gActor.getOutermostRoom().floorObj.theName>>. '

    getExitLocationName() {
        if (exitLocation == nil) return 'the void';
        if (parkourModule != nil) {
            return getBetterDestinationName(parkourModule);
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
        return '({I} learned a new route:
            <<formatCommand('jump over ' + theName, longCmd)>>,
            <<getProviderGoalDiscoverClause(destination)>>!) ';
    }

    getJumpOverToMsg(destination) {
        return '{I} jump{s/ed} over <<theName>>,
            <<getProviderGoalClause(destination)>>. ';
    }

    getRunAcrossToDiscoverMsg(destination) {
        return '({I} learned a new route:
            <<formatCommand('run across ' + theName, longCmd)>>,
            <<getProviderGoalDiscoverClause(destination)>>!) ';
    }

    getRunAcrossToMsg(destination) {
        return '{I} {run} across <<theName>>,
            <<getProviderGoalClause(destination)>>. ';
    }

    getSwingOnToDiscoverMsg(destination) {
        return '({I} learned a new route:
            <<formatCommand('swing on ' + theName, longCmd)>>,
            <<getProviderGoalDiscoverClause(destination)>>!) ';
    }

    getSwingOnToMsg(destination) {
        return '{I} {swing} on <<theName>>,
            <<getProviderGoalClause(destination)>>. ';
    }

    getSqueezeThroughToDiscoverMsg(destination) {
        return '({I} learned a new route:
            <<formatCommand('squeeze through ' + theName, longCmd)>>,
            <<getProviderGoalDiscoverClause(destination)>>!) ';
    }

    getSqueezeThroughToMsg(destination) {
        return '{I} squeeze{s/d} on <<theName>>,
            <<getProviderGoalClause(destination)>>. ';
    }

    getSlideUnderToDiscoverMsg(destination) {
        return '({I} learned a new route:
            <<formatCommand('slide under ' + theName, longCmd)>>,
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

class ParkourModule: SubComponent {
    construct(prkrParent?) {
        if (prkrParent != nil) {
            lexicalParent = prkrParent;
            parent = prkrParent;
        }
        //say('<.p>Constructed!<.p>');
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
        #if __PARKOUR_REACH_TRUE_NAMES
        //
        #else
        if (parent.ofKind(Room)) {
            if (parent.floorObj != nil) {
                return parent.floorObj.(vProp);
            }
        }
        #endif
        return parent.(vProp);
    }
    // End stuff for vocab

    parkourModule = self

    pathVector = perInstance(new Vector())
    preInitDone = nil

    preinitThing() { // Safety check
        if (preInitDone) return;
        inherited();
        //say('<.p>Preinit!<.p>');
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
        local platformSignal = checkLocalPlatformReconHandled(nil);
        if (lexicalParent != nil) {
            if (lexicalParent.checkLocalPlatformReconHandled(platformSignal)) {
                platformSignal = true;
            }

            if (platformSignal) return;

            if (!lexicalParent.hasParkourRecon) {
                parkourCore.cacheParkourRunner(gActor);
                local pm = gParkourRunnerModule;
                if (pm != nil) {
                    local path = getPathFrom(pm, true, true);
                    if (path != nil) {
                        lexicalParent.applyRecon();
                        parkourCore.showNewRoute = true;
                        learnPath(path, reportAfter);
                    }
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
                parkourCore.showNewRoute = true;
                learnPath(path, reportAfter);
                return;
            }
        }

        if (jumpPath != nil) {
            provider.applyRecon();
            parkourCore.showNewRoute = true;
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
        parkourCore.hadAccident = parkourCore.hadAccident || hadAccident;
        return !hadAccident;
    }

    checkLeaving(actor, traveler, path) {
        return true;
    }

    checkArriving(actor, traveler, path) {
        return true;
    }

    doParkourCheck(actor, path) {
        parkourCore.cacheParkourRunner(actor);
        local source = gParkourRunnerModule;

        if (parkourCore.doParkourRunnerCheck(actor)) {
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
            if (parkourCore.formatForScreenReader) {
                strBfr.append('<.p>');
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
                parkourCore.loadParkourKeyHint(strBfr);
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
                    strBfr.append('<.p><tt><b>(CL)</b> CLIMB ROUTES:</tt>');
                    for (local i = 1; i <= climbPaths.length; i++) {
                        formatForBulletPoint(strBfr, climbPaths[i]);
                    }
                }

                if (jumpPaths.length > 0) {
                    strBfr.append('<.p><tt><b>(JM)</b> JUMP ROUTES:</tt>');
                    for (local i = 1; i <= jumpPaths.length; i++) {
                        formatForBulletPoint(strBfr, jumpPaths[i]);
                    }
                }

                if (providerPaths.length > 0) {
                    strBfr.append('<.p><tt>COMPLEX ROUTES:</tt>');
                    for (local i = 1; i <= providerPaths.length; i++) {
                        local path = providerPaths[i];
                        local provider = path.provider.getParkourProvider(nil, nil);
                        if (provider == nil) continue;
                        strBfr.append(getBulletPoint(path.requiresJump, path.isHarmful));
                        strBfr.append(' ');
                        strBfr.append(getProviderHTML(provider));
                        strBfr.append('\n\t<i>leads to ');
                        strBfr.append(getBetterDestinationName(path.destination.parkourModule));
                        strBfr.append('</i>');
                    }
                }

                if (describedPaths.length > 0) {
                    strBfr.append('<.p><tt>MISC ROUTES:</tt>');
                    for (local i = 1; i <= describedPaths.length; i++) {
                        local path = describedPaths[i];
                        strBfr.append(getBulletPoint(path.requiresJump, path.isHarmful));
                        strBfr.append(' ');
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
        strBfr.append(' ');
        local destName = path.destination.parkourModule.theName;
        local commandAlt = getBetterPrepFromPath(path) + destName;
        strBfr.append(aHrefAlt(
            getClimbCommand(path).toLower(),
            commandAlt,
            formatCommand(getClimbCommand(path), longFakeCmd)
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
        return aHrefAlt(
            getClimbCommand(path).toLower(),
            commandText,
            formatCommand(commandText, longFakeCmd)
        );
    }

    getProviderCommand(provider) {
        local provName = provider.theName;
        if (provider.canSwingOnMe) return 'swing on ' + provName;
        if (provider.canJumpOverMe) return 'jump over ' + provName;
        if (provider.canRunAcrossMe) return 'run across ' + provName;
        if (provider.canSlideUnderMe) return 'slide under ' + provName;
        if (provider.canSqueezeThroughMe) return 'squeeze through ' + provName;
        return 'cl ' + provName;
    }

    getProviderVerb(provider) {
        local provName = provider.theName.toUpper();
        if (provider.canSwingOnMe) return 'SWING ON ' + provName;
        if (provider.canJumpOverMe) return 'JUMP OVER ' + provName;
        if (provider.canRunAcrossMe) return 'RUN ACROSS ' + provName;
        if (provider.canSlideUnderMe) return 'SLIDE UNDER ' + provName;
        if (provider.canSqueezeThroughMe) return 'SQUEEZE THROUGH ' + provName;
        return 'parkour via ' + provName;
    }

    getProviderHTML(provider, commandText?) {
        if (commandText == nil) {
            commandText = getProviderVerb(provider);
        }
        return aHrefAlt(
            getProviderCommand(provider),
            commandText, formatCommand(commandText, longFakeCmd)
        );
    }

    getBlindRouteDescription(strBfr, routeList, routeSuffix) {
        if (routeList.length > 0) {
            strBfr.append('<.p>');
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

    isInReachFrom(source, canBeUnknown?, doNotFactorJump?) {
        return isInReachFromVerbose(source, canBeUnknown, doNotFactorJump) == parkourReachSuccessful;
    }

    isInReachFromVerbose(source, canBeUnknown?, doNotFactorJump?) {
        #if __PARKOUR_REACH_DEBUG
        extraReport('\nREACH TO: <<theName>>\n');
        #endif
        if (source == gActor) {
            parkourCore.cacheParkourRunner(source);
            source = gParkourRunner;
        }
        #if __PARKOUR_REACH_DEBUG
        extraReport('\nTesting source: <<source.theName>> (<<source.contType.prep>>)\n');
        #endif
        local closestParkourMod = source.getParkourModule();

        // Real quick: Check in with bonus reaches to see if
        // we can skip this whole shitshow.
        /*local myParent = lexicalParent;
        local otherParent = (closestParkourMod != nil) ?
            closestParkourMod.lexicalParent : source;

        if (myParent != nil && otherParent != nil) {
            if (myParent.canBonusReachDuring(otherParent, gAction)) return true;
            if (otherParent.canBonusReachDuring(myParent, gAction)) return true;
        }*/

        // No luck... business as usual, then!

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
            //extraReport('\nNo parkour mod on <<realSource.theName>> (<<realSource.contType.prep>>).\n');
            extraReport('\nNo parkour mod on <<source.theName>> (<<source.contType.prep>>).\n');
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
            local testStagLoc = realSource.stagingLocation;
            local testExitLoc = realSource.stagingLocation;
            if (testStagLoc == nil) testStagLoc = realSource;
            if (testExitLoc == nil) testExitLoc = realSource;
            #if __PARKOUR_REACH_DEBUG
            extraReport('\nStaging: <<testStagLoc.theName>>\n');
            #endif
            if (checkStagingExitLocationConnection(testStagLoc)) {
                #if __PARKOUR_REACH_DEBUG
                extraReport('\nFOUND!\n');
                #endif
                return parkourReachSuccessful;
            }
            #if __PARKOUR_REACH_DEBUG
            extraReport('\nExit: <<testExitLoc.theName>>\n');
            #endif
            if (checkStagingExitLocationConnection(testExitLoc)) {
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

    filterResolveList(np, cmd, mode) {
        if (lexicalParent != nil) {
            lexicalParent.filterParkourList(np, cmd, mode, self);
        }
    }
}

enum parkourUpDir, parkourOverDir, parkourDownDir;

class ParkourPath: object {
    destination = nil
    provider = nil
    requiresJump = nil
    isHarmful = nil
    direction = parkourOverDir
    isAcknowledged = (!parkourCore.requireRouteRecon)
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
            if (provider.canSqueezeThroughMe) {
                return provider.getSqueezeThroughToDiscoverMsg(destination.parkourModule);
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
            if (provider.canSqueezeThroughMe) {
                return provider.getSqueezeThroughToMsg(destination.parkourModule);
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
    execBeforeMe = [distributedComponentDistributor]

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
        return createdForward;
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

// Creates a blank parkour module with no paths.
// Why? To fake standardized responses!
class BlankParkourInit: ParkourPathMaker {
    execute() {
        getTrueLocation().prepForParkour();
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

// Simple Handler Surfaces
modify TravelConnector {
    // Let it be known that on March 22nd of 2023,
    // Nightshademaker found a bug in the parkour code which
    // required me to modify the travel code of TravelConnectors,
    // which is one giant function.
    //
    // This is largely taken from travel.t of Adv3Lite, but I only
    // needed to make a few modifications.
    execTravel(actor, traveler, conn) {
        local oldLoc = traveler.getOutermostRoom();
        local dest = getDestination(oldLoc);
        local oldTravelInfo = nil;
        
        conn.beforeTravelNotifications(traveler);
        
        if (actor != gPlayerChar) {
            oldTravelInfo = actor.lastTravelInfo;
        }
        
        if (actor == gPlayerChar) {
            libGlobal.lastLoc = oldLoc;                               
        }
        else if (Q.canSee(gPlayerChar, actor)) {
            actor.lastTravelInfo = [oldLoc, conn];
        }
        
        if (gPlayerChar.isOrIsIn(traveler)) {
            local localPlat = getLocalPlatform();
            if (localPlat != nil) doBeforeTravelDiscovery(gPlayerChar.location);
        }
        
        conn.noteTraversal(actor); 
        oldLoc.notifyDeparture(actor, dest);
        
        doTravelMoveInto(traveler, dest);
        
        if (gPlayerChar.isOrIsIn(traveler)) {
            local notifyList = dest.allContents.subset({o: o.ofKind(Actor)});
            
            notifyList.forEach({a: a.pcArrivalTurn = gTurns });
            
            if (dest.lookOnEnter(actor)) {
                dest.lookAroundWithin();
            }

            local oppoPlat = getOppositePlatform();
            if (oppoPlat != nil) doAfterTravelDiscovery(oppoPlat);
        }
        
        if (dest != oldLoc) {               
            conn.afterTravelNotifications(traveler);
        }
        
        if (actor != gPlayerChar && actor.getOutermostRoom == oldLoc) {
            actor.lastTravelInfo = oldTravelInfo;
        }
    }

    doTravelMoveInto(traveler, dest) {
        traveler.actionMoveInto(dest);
    }

    doBeforeTravelDiscovery(oldPlat) {
        //
    }

    doAfterTravelDiscovery(newPlat) {
        //
    }

    getLocalPlatform() {
        return nil;
    }

    getOppositePlatform() {
        return nil;
    }
}

#define TravelConnectorUsesParkour \
    doTravelMoveInto(traveler, dest) { \
        if (destinationPlatform != nil) { \
            if (!destinationPlatform.ofKind(Room)) { \
                local pm = destinationPlatform.parkourModule; \
                if (pm == nil) { \
                    traveler.actionMoveInto(destinationPlatform); \
                    return; \
                } \
                else if (gOutStream.watchForOutput({: pm.checkParkour(traveler) }) == nil) { \
                    gParkourLastPath = self; \
                    pm.provideMoveFor(traveler); \
                    return; \
                } \
            } \
        } \
        traveler.actionMoveInto(dest); \
    } \
    doBeforeTravelDiscovery(oldPlat) { \
        learnOnlyLocalPlatform(self, say); \
    } \
    doAfterTravelDiscovery(newPlat) { \
        newPlat.doParkourSearch(); \
    } \
    getLocalPlatform() { \
        return self; \
    } \
    getOppositePlatform() { \
        return oppositeLocalPlatform; \
    }

#define rerouteBasicClimbForPlatform(oldAction, cancelMsg) \
    dobjFor(oldAction) { \
        preCond = [actorInStagingLocation] \
        verify() { \
            illogical(cancelMsg); \
        } \
    }

#define rerouteBasicJumpIntoForPlatform(oldAction, targetAction) \
    dobjFor(oldAction) { \
        preCond { return preCondDobj##targetAction; } \
        verify() { verifyDobj##targetAction; } \
        remap() { return remapDobj##targetAction; } \
        check() { checkDobj##targetAction; } \
        action() { \
            extraReport(parkourUnnecessaryJumpMsg); \
            actionDobj##targetAction; \
        } \
        report() { reportDobj##targetAction; } \
    }

#define setPreferredClimbToDirection(rightWay, wrongWay) \
    dobjFor(Climb) asDobjFor(TravelVia) \
    dobjFor(ParkourClimbGeneric) asDobjFor(TravelVia) \
    \
    dobjFor(Climb##rightWay) asDobjFor(TravelVia) \
    dobjFor(ParkourClimb##rightWay##To) asDobjFor(TravelVia) \
    rerouteBasicJumpIntoForPlatform(ParkourJump##rightWay##To, TravelVia) \
    \
    rerouteBasicClimbForPlatform(Climb##wrongWay, localPlatformGoes##rightWay##Msg) \
    rerouteBasicClimbForPlatform(ParkourClimb##wrongWay##To, localPlatformGoes##rightWay##Msg) \
    rerouteBasicClimbForPlatform(ParkourJump##wrongWay##To, localPlatformGoes##rightWay##Msg) \
    rerouteBasicClimbForPlatform(ParkourClimbOverTo, localPlatformGoes##rightWay##Msg) \
    rerouteBasicClimbForPlatform(ParkourJumpOverTo, localPlatformGoes##rightWay##Msg)

#define acceptClimbIntoDirection(rightWay, wrongWay) \
    dobjFor(ParkourClimb##rightWay##Into) asDobjFor(TravelVia) \
    rerouteBasicJumpIntoForPlatform(ParkourJump##rightWay##Into, TravelVia) \
    \
    rerouteBasicClimbForPlatform(ParkourClimb##wrongWay##Into, localPlatformGoes##rightWay##Msg) \
    rerouteBasicClimbForPlatform(ParkourJump##wrongWay##Into, localPlatformGoes##rightWay##Msg) \
    rerouteBasicClimbForPlatform(ParkourClimbOverInto, localPlatformGoes##rightWay##Msg) \
    rerouteBasicClimbForPlatform(ParkourJumpOverInto, localPlatformGoes##rightWay##Msg)

#define rejectClimbInto \
    rerouteBasicClimbForPlatform(ParkourClimbUpInto, cannotEnterMsg) \
    rerouteBasicClimbForPlatform(ParkourJumpUpInto, cannotEnterMsg) \
    rerouteBasicClimbForPlatform(ParkourClimbDownInto, cannotEnterMsg) \
    rerouteBasicClimbForPlatform(ParkourJumpDownInto, cannotEnterMsg) \
    rerouteBasicClimbForPlatform(ParkourClimbOverInto, cannotEnterMsg) \
    rerouteBasicClimbForPlatform(ParkourJumpOverInto, cannotEnterMsg)

#define asAliasFor(targetPlatform) \
    unlistedLocalPlatform = true \
    localAliasPlatform = targetPlatform \
    oppositeLocalPlatform = (targetPlatform.oppositeLocalPlatform) \
    dobjFor(TravelVia) { \
        remap = targetPlatform \
    } \
    dobjFor(Search) { \
        remap = targetPlatform \
    }

/*#define localPlatformAdjustMoveAction(inheritedRoot) \
    inheritedRoot \
    if (destinationPlatform != nil) { \
        if (!destinationPlatform.ofKind(Room)) { \
            parkourCore.cacheParkourRunner(gActor); \
            local pm = destinationPlatform.parkourModule; \
            if (pm == nil) { \
                gParkourRunner.actionMoveInto(destinationPlatform); \
                destinationPlatform.doParkourSearch(); \
            } \
            else { \
                gParkourLastPath = self; \
                pm.provideMoveFor(gParkourRunner); \
                pm.doParkourSearch(); \
            } \
        } \
    }*/

/*#define localPlatformAdjustMoveCheck \
    check() { \
        inherited(); \
        if (destinationPlatform != nil) { \
            local pm = destinationPlatform.parkourModule; \
            if (pm != nil) pm.checkParkour(gActor); \
        } \
    }*/

/*#define localPlatformAdjustMove \
    localPlatformAdjustMoveCheck \
    action() { \
        localPlatformAdjustMoveAction(inherited();) \
    }*/

class LocalClimbPlatform: TravelConnector, Fixture {
    forcedLocalPlatform = true
    isConnectorListed = !secretLocalPlatform
    destinationPlatform = (
        oppositeLocalPlatform == nil ? nil :
        (oppositeLocalPlatform.stagingLocation)
    )
    destination = (otherSide.getOutermostRoom())

    localAliasPlatform = self

    localPlatformGoesUpMsg =
        '{I} must go up to do that. '
    localPlatformGoesDownMsg =
        '{I} must go down to do that. '

    dobjFor(TravelVia) {
        preCond = (isOpenable ?
            [travelPermitted, actorInStagingLocation, objOpen] :
            [travelPermitted, actorInStagingLocation]
        )
    }

    dobjFor(Search) {
        preCond = [actorInStagingLocation]
        remap = nil
        verify() { }
        action() {
            doParkourSearch();
        }
    }

    TravelConnectorUsesParkour
}

class ClimbUpPlatform: LocalClimbPlatform {
    preferredBoardingAction = Climb
    setPreferredClimbToDirection(Up, Down)
    rejectClimbInto
}

class ClimbUpIntoPlatform: LocalClimbPlatform {
    preferredBoardingAction = Climb
    setPreferredClimbToDirection(Up, Down)
    acceptClimbIntoDirection(Up, Down)
    dobjFor(Enter) asDobjFor(TravelVia)
    dobjFor(GoThrough) asDobjFor(TravelVia)
}

class ClimbUpEnterPlatform: ClimbUpIntoPlatform {
    preferredBoardingAction = Enter
}

class ClimbDownPlatform: LocalClimbPlatform {
    preferredBoardingAction = ClimbDown
    setPreferredClimbToDirection(Down, Up)
    rejectClimbInto
}

class ClimbDownIntoPlatform: LocalClimbPlatform {
    preferredBoardingAction = ClimbDown
    setPreferredClimbToDirection(Down, Up)
    acceptClimbIntoDirection(Down, Up)
    dobjFor(Enter) asDobjFor(TravelVia)
    dobjFor(GoThrough) asDobjFor(TravelVia)
}

class ClimbDownEnterPlatform: ClimbDownIntoPlatform {
    preferredBoardingAction = Enter
}

#define configureDoorOrPassageAsLocalPlatform(targetAction) \
    forcedLocalPlatform = true \
    isConnectorListed = !secretLocalPlatform \
    getPreferredBoardingAction() { \
        return GoThrough; \
    } \
    rerouteBasicClimbForPlatform(Board, cannotBoardMsg) \
    rerouteBasicClimbForPlatform(Climb, cannotClimbMsg) \
    rerouteBasicClimbForPlatform(ClimbUp, cannotClimbMsg) \
    rerouteBasicClimbForPlatform(ClimbDown, cannotClimbMsg) \
    rerouteBasicClimbForPlatform(ParkourClimbDownTo, cannotClimbMsg) \
    rerouteBasicClimbForPlatform(ParkourJumpGeneric, parkourCannotJumpUpMsg) \
    rerouteBasicClimbForPlatform(ParkourJumpUpTo, parkourCannotJumpUpMsg) \
    rerouteBasicClimbForPlatform(ParkourJumpOverTo, parkourCannotJumpOverMsg) \
    rerouteBasicClimbForPlatform(ParkourJumpDownTo, parkourCannotJumpDownMsg) \
    dobjFor(SqueezeThrough) asDobjFor(targetAction) \
    dobjFor(ParkourClimbGeneric) asDobjFor(targetAction) \
    dobjFor(ParkourClimbUpTo) asDobjFor(targetAction) \
    dobjFor(ParkourClimbOverTo) asDobjFor(targetAction) \
    dobjFor(ParkourClimbUpInto) asDobjFor(targetAction) \
    dobjFor(ParkourClimbOverInto) asDobjFor(targetAction) \
    dobjFor(ParkourClimbDownInto) asDobjFor(targetAction) \
    rerouteBasicJumpIntoForPlatform(ParkourJumpUpInto, targetAction) \
    rerouteBasicJumpIntoForPlatform(ParkourJumpOverInto, targetAction) \
    rerouteBasicJumpIntoForPlatform(ParkourJumpDownInto, targetAction)

modify Door {
    oppositeLocalPlatform = (otherSide)
    destination = (otherSide.getOutermostRoom())
    destinationPlatform = (
        oppositeLocalPlatform == nil ? nil :
        (oppositeLocalPlatform.stagingLocation)
    )
    stagingLocation = (location)

    configureDoorOrPassageAsLocalPlatform(GoThrough)

    dobjFor(GoThrough) {
        preCond = [travelPermitted, actorInStagingLocation, objOpen]
    }

    dobjFor(Open) {
        action() {
            inherited();
            if (!gAction.isImplicit) {
                learnOnlyLocalPlatform(self, reportAfter);
            }
        }
    }

    getParkourModule() {
        return location.parkourModule;
    }

    TravelConnectorUsesParkour
}

#define RoomHasLadderDown(ladderObj) \
    roomBeforeAction() { \
        inherited(); \
        local actionMatches = nil; \
        if (gActionIs(ClimbDown)) actionMatches = true; \
        else if (gActionIs(ParkourClimbOffIntransitive)) actionMatches = true; \
        else if (gActionIs(ParkourJumpOffIntransitive)) actionMatches = true; \
        if (actionMatches && gActor.location == self) { \
            doInstead(ParkourClimbGeneric, ladderObj); \
            exit; \
        } \
    }