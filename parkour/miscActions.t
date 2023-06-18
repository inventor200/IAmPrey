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

#ifdef __ALLOW_DEBUG_ACTIONS
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