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