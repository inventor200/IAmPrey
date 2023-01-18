#define expandedOnto ('onto'|'on' 'to')
#define expandedInto ('in'|'into'|'in' 'to'|'through')
#define expandedUpSideOf (('the'|) 'side' 'of'|'to'|)
#define genericOnTopOfPrep ('on'|expandedOnto|'on' 'top' 'of'|expandedOnto 'the' 'top' 'of'|'atop')
#define genericAcrossPrep ('over'|'across'|'over' 'to'|'across' 'to'|'to'|'onto'|'on' 'to') (('the'|)'top' 'of'|)

VerbRule(ParkourClimbOverTo)
    ('climb'|'cl'|'get'|'step') genericAcrossPrep singleDobj
    : VerbProduction
    action = ParkourClimbOverTo
    verbPhrase = 'climb over to (what)'
    missingQ = 'what do you want to climb over to'
;

DefineTAction(ParkourClimbOverTo)
;

VerbRule(ParkourClimbOverInto)
    ('climb'|'cl'|'get'|'step') expandedInto singleDobj
    : VerbProduction
    action = ParkourClimbOverInto
    verbPhrase = 'climb through (what)'
    missingQ = 'what do you want to climb through'
;

DefineTAction(ParkourClimbOverInto)
;

VerbRule(ParkourJumpOverTo)
    ('jump'|'hop'|'leap') genericAcrossPrep singleDobj
    : VerbProduction
    action = ParkourJumpOverTo
    verbPhrase = 'jump to (what)'
    missingQ = 'what do you want to jump to'
;

DefineTAction(ParkourJumpOverTo)
;

VerbRule(ParkourJumpOverInto)
    ('jump'|'hop'|'leap') expandedInto singleDobj
    : VerbProduction
    action = ParkourJumpOverInto
    verbPhrase = 'jump through (what)'
    missingQ = 'what do you want to jump through'
;

DefineTAction(ParkourJumpOverInto)
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
;

VerbRule(ParkourJumpDownTo)
    ('jump'|'hop'|'leap'|'clamber'|'scramble'|'drop'|'fall') 'down' 'to' singleDobj
    : VerbProduction
    action = ParkourJumpDownTo
    verbPhrase = 'jump down to (what)'
    missingQ = 'what do you want to jump down to'
;

DefineTAction(ParkourJumpDownTo)
;

VerbRule(ParkourJumpDownInto)
    ('jump'|'hop'|'leap'|'clamber'|'scramble'|'drop'|'fall') 'down' expandedInto singleDobj
    : VerbProduction
    action = ParkourJumpDownInto
    verbPhrase = 'jump down into (what)'
    missingQ = 'what do you want to jump down into'
;

DefineTAction(ParkourJumpDownInto)
;

VerbRule(ParkourClimbDownTo)
    ('climb'|'cl'|'get'|'step') 'down' 'to' singleDobj
    : VerbProduction
    action = ParkourClimbDownTo
    verbPhrase = 'climb down to (what)'
    missingQ = 'what do you want to climb down to'
;

DefineTAction(ParkourClimbDownTo)
;

VerbRule(ParkourClimbDownInto)
    ('climb'|'cl'|'get'|'step') 'down' expandedInto singleDobj
    : VerbProduction
    action = ParkourClimbDownInto
    verbPhrase = 'climb down into (what)'
    missingQ = 'what do you want to climb down into'
;

DefineTAction(ParkourClimbDownInto)
;

VerbRule(ParkourClimbUpInto)
    ('climb'|'cl'|'mantel'|'mantle'|'go'|'walk'|'run'|'sprint') 'up' expandedInto singleDobj
    : VerbProduction
    action = ParkourClimbUpInto
    verbPhrase = 'climb up into (what)'
    missingQ = 'what do you want to climb up into'
;

DefineTAction(ParkourClimbUpInto)
;

VerbRule(ParkourClimbUpTo)
    ('climb'|'cl'|'mantel'|'mantle'|'go'|'walk'|'run'|'sprint') 'up' expandedUpSideOf singleDobj
    : VerbProduction
    action = ParkourClimbUpTo
    verbPhrase = 'climb up to (what)'
    missingQ = 'what do you want to climb up to'
;

DefineTAction(ParkourClimbUpTo)
;

VerbRule(ParkourJumpGeneric)
    ('jump'|'hop'|'leap'|'jm') singleDobj
    : VerbProduction
    action = ParkourJumpGeneric
    verbPhrase = 'jump to (what)'
    missingQ = 'what do you want to jump to'
;

DefineTAction(ParkourJumpGeneric)
;

VerbRule(ParkourClimbGeneric)
    ('climb'|'cl'|'mantel'|'mantle'|'mount'|'board') singleDobj |
    ('climb'|'cl'|'mantel'|'mantle'|'get'|'go') genericOnTopOfPrep singleDobj |
    ('climb'|'cl'|'mantel'|'mantle'|'go'|'walk'|'run'|'sprint') 'up' singleDobj |
    'parkour' ('to'|) singleDobj
    : VerbProduction
    action = ParkourClimbGeneric
    verbPhrase = 'parkour to (what)'
    missingQ = 'what do you want to parkour to'
;

DefineTAction(ParkourClimbGeneric)
;

VerbRule(ParkourSlideUnder)
    ('slide'|'dive'|'roll'|'go'|'crawl'|'scramble'|'slither') 'under' singleDobj
    : VerbProduction
    action = ParkourSlideUnder
    verbPhrase = 'slide under (what)'
    missingQ = 'what do you want to slide under'
;

DefineTAction(ParkourSlideUnder)
;

VerbRule(ParkourJumpOver)
    ('jump'|'hop'|'leap'|'vault') ('over'|) singleDobj
    : VerbProduction
    action = ParkourJumpOver
    verbPhrase = 'jump over (what)'
    missingQ = 'what do you want to jump over'
;

DefineTAction(ParkourJumpOver)
;

VerbRule(ParkourRunAcross)
    ('run'|'sprint'|'hop'|'go'|'walk') 'across' singleDobj
    : VerbProduction
    action = ParkourRunAcross
    verbPhrase = 'run across (what)'
    missingQ = 'what do you want to run across'
;

DefineTAction(ParkourRunAcross)
;

VerbRule(ParkourSwingOn)
    'swing' ('on'|'under'|'with'|'using'|'via'|'across') singleDobj
    : VerbProduction
    action = ParkourSwingOn
    verbPhrase = 'swing on (what)'
    missingQ = 'what do you want to swing on'
;

DefineTAction(ParkourSwingOn)
;

VerbRule(ParkourClimbOffOf)
    ('get'|'climb'|'cl'|'parkour') ('off'|'off' 'of'|'down' 'from') singleDobj
    : VerbProduction
    action = ParkourClimbOffOf
    verbPhrase = 'get off of (what)'
    missingQ = 'what do you want to get off of'
;

DefineTAction(ParkourClimbOffOf)
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
        doInstead(ParkourClimbOffOf, gActor.location);
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
        doInstead(ParkourJumpOffOf, gActor.location);
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
        /*local currentPlat = gActor.getParkourPlatform();
        if (currentPlat == nil) {
            currentPlat = gActor.getOutermostRoom();
        }
        "<<currentPlat.getConnectionString()>> ";*/
    }
;

// Mods to standard actions, so the player can use the rules they learned during parkour
/*modify VerbRule(Board)
    ('mount'|'board'|('get' ('on'|'onto'|'on' 'to'))|(('climb'|'cl'|'mantel'|'mantle') genericOnTopOfPrep)) singleDobj :
;

modify VerbRule(Climb)
    ('climb'|'cl'|'mantel'|'mantle'|'mount') singleDobj :
;

modify VerbRule(ClimbUp)
    ('climb'|'cl'|'mantel'|'mantle'|'get'|'go') genericOnTopOfPrep singleDobj |
    ('climb'|'cl'|'mantel'|'mantle'|'go'|'walk'|'run'|'sprint') 'up' singleDobj :
;

modify VerbRule(ClimbUpWhat)
    ('climb'|'cl') 'up' |
    ('mantel'|'mantle'|'mount') :
;

modify VerbRule(GetOff)
    ('get'|'climb'|'cl') ('off'|'off' 'of'|'down' 'from') singleDobj :
;

modify VerbRule(GetOut)
    'get' ('out'|'off'|'down') |
    'disembark' | 'dismount' |
    ('climb'|'cl') ('out'|'off') :
;

modify VerbRule(GetOutOf)
    ('out' 'of'|('climb'|'cl'|'get'|'jump') 'out' 'of'|'leave'|'exit') singleDobj :
;

modify VerbRule(ClimbDown)
    ('climb'|'cl'|'go'|'walk'|'run'|'sprint') 'down' singleDobj :
;

modify VerbRule(ClimbDownWhat)
    ('climb'|'cl'|'go'|'walk'|'run'|'sprint') 'down' :
;

modify VerbRule(Jump)
    'jump' | 'hop' | 'leap' :
;

modify VerbRule(JumpOff)
    ('jump'|'hop'|'leap'|'fall'|'drop') 'off' singleDobj :
;

modify VerbRule(JumpOffIntransitive)
    ('jump'|'hop'|'leap'|'fall'|'drop') 'off' |
    ('fall'|'drop') :
;

modify VerbRule(JumpOver)
    ('jump'|'hop'|'leap'|'vault') ('over'|) singleDobj :
;*/

parkourCache: object {
    requireRouteRecon = true
    formatForScreenReader = nil
}

#define dobjParkourRemap(parkourAction, remapAction) \
    dobjFor(parkourAction) { \
        preCond = nil \
        remap = (parkourModule) \
        verify() { } \
        check() { } \
        action() { \
            doInstead(remapAction, self); \
        } \
        report() { } \
    }

#define dobjParkourIntoRemap(parkourIntoAction, remapAction) \
    dobjFor(parkourIntoAction) { \
        preCond = nil \
        remap = (parkourModule) \
        verify() { } \
        check() { } \
        action() { \
            if (gActor.location != stagingLocation) { \
                if (stagingLocation.parkourModule == nil) { \
                    tryImplicitAction(stagingLocation.climbOnAlternative, stagingLocation); \
                } \
                else { \
                    tryImplicitAction(ParkourJumpGeneric, stagingLocation.parkourModule); \
                } \
            } \
            doInstead(remapAction, self); \
        } \
        report() { } \
    }

modify Thing {
    parkourModule = nil

    climbOnAlternative = (isClimbable ? Climb : (canClimbUpMe ? ClimbUp : Board))
    climbOffAlternative = (canClimbUpMe ? ClimbDown : GetOff)
    enterAlternative = (canGoThroughMe ? GoThrough : Enter)
    jumpOffAlternative = JumpOff

    dobjParkourRemap(ParkourClimbGeneric, climbOnAlternative)
    dobjParkourRemap(ParkourJumpGeneric, climbOnAlternative)
    dobjParkourRemap(ParkourClimbOverTo, climbOnAlternative)
    dobjParkourRemap(ParkourJumpOverTo, climbOnAlternative)
    dobjParkourRemap(ParkourClimbUpTo, climbOnAlternative)
    dobjParkourRemap(ParkourJumpUpTo, climbOnAlternative)
    dobjParkourRemap(ParkourClimbDownTo, climbOnAlternative)
    dobjParkourRemap(ParkourJumpDownTo, climbOnAlternative)

    //TODO: We are handling "into" differently.
    //      This time, we are chaining a parkour and gothrough action.
    dobjParkourIntoRemap(ParkourClimbOverInto, enterAlternative)
    dobjParkourIntoRemap(ParkourJumpOverInto, enterAlternative)
    dobjParkourIntoRemap(ParkourClimbUpInto, enterAlternative)
    dobjParkourIntoRemap(ParkourJumpUpInto, enterAlternative)
    dobjParkourIntoRemap(ParkourClimbDownInto, enterAlternative)
    dobjParkourIntoRemap(ParkourJumpDownInto, enterAlternative)

    dobjParkourRemap(ParkourJumpOver, JumpOver)

    dobjParkourRemap(ParkourClimbOffOf, climbOffAlternative)
    dobjParkourRemap(ParkourJumpOffOf, jumpOffAlternative)

    //TODO: Slide under
    //TODO: Run across
    //TODO: Swing on
}