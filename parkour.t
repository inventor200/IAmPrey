#include "aac.t"

VerbRule(ParkourClimbOverTo)
    ('climb'|'cl'|'get'|'parkour'|'step') ('over'|'across'|'over' 'to'|'across' 'to'|'to'|'onto'|'on' 'to') (('the'|)'top' 'of'|) singleDobj
    : VerbProduction
    action = ParkourClimbOverTo
    verbPhrase = 'climb over to (what)'
    missingQ = 'what do you want to climb over to'
;

DefineTAction(ParkourClimbOverTo)
;

VerbRule(ParkourClimbOverInto)
    ('climb'|'cl'|'get'|'parkour'|'step') ('in'|'into'|'in' 'to'|'through') singleDobj
    : VerbProduction
    action = ParkourClimbOverInto
    verbPhrase = 'climb through (what)'
    missingQ = 'what do you want to climb through'
;

DefineTAction(ParkourClimbOverInto)
;

VerbRule(ParkourJumpOverTo)
    ('jump'|'hop'|'leap') ('over'|'across'|'over' 'to'|'across' 'to'|'to'|'onto'|'on' 'to') (('the'|)'top' 'of'|) singleDobj
    : VerbProduction
    action = ParkourJumpOverTo
    verbPhrase = 'jump to (what)'
    missingQ = 'what do you want to jump to'
;

DefineTAction(ParkourJumpOverTo)
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

VerbRule(ParkourJumpOverInto)
    ('jump'|'hop'|'leap') ('in'|'into'|'in' 'to'|'through') singleDobj
    : VerbProduction
    action = ParkourJumpOverInto
    verbPhrase = 'jump through (what)'
    missingQ = 'what do you want to jump through'
;

DefineTAction(ParkourJumpOverInto)
;

VerbRule(ParkourJumpUpTo)
    ('jump'|'hop'|'leap'|'clamber'|'scramble'|'wall' 'run'|'wallrun') 'up' (('the'|) 'side' 'of'|'to'|) singleDobj |
    'clamber' singleDobj
    : VerbProduction
    action = ParkourJumpUpTo
    verbPhrase = 'jump up (what)'
    missingQ = 'what do you want to jump up'
;

DefineTAction(ParkourJumpUpTo)
;

VerbRule(ParkourJumpUpInto)
    ('jump'|'hop'|'leap'|'clamber'|'scramble'|'wall' 'run'|'wallrun') 'up' ('into'|'in' 'to'|'through') singleDobj |
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
    ('jump'|'hop'|'leap'|'clamber'|'scramble'|'drop'|'fall') 'down' ('into'|'in' 'to'|'through') singleDobj
    : VerbProduction
    action = ParkourJumpDownInto
    verbPhrase = 'jump down into (what)'
    missingQ = 'what do you want to jump down into'
;

DefineTAction(ParkourJumpDownInto)
;

VerbRule(ParkourClimbDownTo)
    ('climb'|'cl'|'get'|'parkour'|'step') 'down' 'to' singleDobj
    : VerbProduction
    action = ParkourClimbDownTo
    verbPhrase = 'climb down to (what)'
    missingQ = 'what do you want to climb down to'
;

DefineTAction(ParkourClimbDownTo)
;

VerbRule(ParkourClimbDownInto)
    ('climb'|'cl'|'get'|'parkour'|'step') 'down' ('into'|'in' 'to'|'through') singleDobj
    : VerbProduction
    action = ParkourClimbDownInto
    verbPhrase = 'climb down into (what)'
    missingQ = 'what do you want to climb down into'
;

DefineTAction(ParkourClimbDownInto)
;

VerbRule(ParkourClimbUpInto)
    ('climb'|'cl'|'mantel'|'mantle'|'go'|'walk'|'run'|'sprint') 'up' ('into'|'in' 'to'|'through') singleDobj
    : VerbProduction
    action = ParkourClimbUpInto
    verbPhrase = 'climb up into (what)'
    missingQ = 'what do you want to climb up into'
;

DefineTAction(ParkourClimbUpInto)
;

VerbRule(ParkourClimbUpTo)
    ('climb'|'cl'|'mantel'|'mantle'|'go'|'walk'|'run'|'sprint') 'up' (('the'|) 'side' 'of'|'to'|) singleDobj
    : VerbProduction
    action = ParkourClimbUpTo
    verbPhrase = 'climb up to (what)'
    missingQ = 'what do you want to climb up to'
;

DefineTAction(ParkourClimbUpTo)
;

//Generic climbing
modify VerbRule(Climb)
    ('climb'|'cl'|'mantel'|'mantle'|'mount') singleDobj :
;

modify VerbRule(ClimbUp)
    ('climb'|'cl'|'mantel'|'mantle'|'get'|'go') ('on'|('onto'|'on' 'to')|'on' 'top' 'of'|('onto'|'on' 'to') 'the' 'top' 'of'|'atop') singleDobj |
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
    ('jump'|'hop'|'leap'|'fall'|'drop') 'off' singleDobj |
    ('fall'|'drop') singleDobj :
;

modify VerbRule(JumpOffIntransitive)
    ('jump'|'hop'|'leap'|'fall'|'drop') 'off' |
    ('fall'|'drop') :
;

modify VerbRule(JumpOver)
    ('jump'|'hop'|'leap'|'vault') ('over'|) singleDobj :
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
        local currentPlat = gActor.getParkourPlatform();
        if (currentPlat == nil) {
            currentPlat = gActor.getOutermostRoom();
        }
        "<<currentPlat.getConnectionString()>> ";
    }
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

//TODO: Jump over (to go between two places)
//TODO: Run across (to go between two places)
//TODO: Swing on (to go between two places)

QParkour: Special {
    priority = 16
    active = true

    reachProblemVerify(a, b) {
        local issues = [];

        // Don't worry about room connections
        if (a.ofKind(Room) || b.ofKind(Room)) return issues;

        local sca = findSubComponentFor(a);
        local scb = findSubComponentFor(b);

        // Are sca and scb both valid SubComponents?
        if (sca != nil && scb != nil) {
            // Are sca and scb two different SubComponents?
            if (sca != scb) {
                local ourParent = sca.lexicalParent;
                // Do both sca and scb have a valid lexicalParent,
                // and do they both share a lexicalParent?
                if (ourParent != nil && ourParent == scb.lexicalParent) {
                    // Is this lexicalParent capable of parkour?
                    if (ourParent.ofKind(ParkourMultiContainer)) {
                        // Are we reaching from the top of the lexicalParent?
                        if (ourParent.remapOn == sca) {
                            issues += new ReachProblemParkourFromTopOfSame(a, b, ourParent);
                        }
                        // Are we reaching from the bottom of the lexicalParent?
                        else {
                            issues += new ReachProblemParkour(a, b, ourParent);
                        }
                        return issues;
                    }
                }
            }
        }

        if (!a.canReachThroughParkour(b)) {
            issues += new ReachProblemParkour(a, b, b);
        }

        return issues;
    }

    findSubComponentFor(obj) {
        if (obj.ofKind(SubComponent)) return obj;

        if (obj.location != nil) {
            if (obj.location.ofKind(SubComponent)) return obj.location;
        }

        return nil;
    }
}

class ReachProblemParkourBase: ReachProblemDistance {
    construct(src, trg, lexparent) {
        inherited(src, trg);
        lexicalParent_ = lexparent;
    }

    lexicalParent_ = nil;
}

// General error for being unable to reach, due to parkour limitations
class ReachProblemParkour: ReachProblemParkourBase {
    tooFarAwayMsg() {
        local isMultiContainer = lexicalParent_.ofKind(ParkourMultiContainer);
        local isParkourPlatform = lexicalParent_.ofKind(ParkourPlatform) || isMultiContainer;
        local isReachingForTop = isParkourPlatform ? (lexicalParent_.contType == On || isMultiContainer) : nil;
        local specificLocation = (isReachingForTop ? 'The top of ' : '\^');
        return specificLocation + lexicalParent_.theName + ' is out of reach. ';
    }
}

// Error for attempt to reach inside of container while standing on top of it
class ReachProblemParkourFromTopOfSame: ReachProblemParkourBase {
    tooFarAwayMsg() {
        return 'The rest of ' + lexicalParent_.theName + ' is too far below. ';
    }
}

#define gParkourAvailableRange parkourCache.availableRange
#define gParkourAttemptedRange parkourCache.attemptedRange
#define gParkourLastPlatform parkourCache.lastPlatform
#define gParkourTheEdgeName parkourCache.lastPlatform.theEdgeName

parkourCache: object {
    availableRange = nil
    attemptedRange = nil
    lastPlatform = nil

    rememberLastPlatform() {
        lastPlatform = gActor.getParkourPlatform();
    }
}

modify Thing {
    dobjFor(ParkourClimbUpTo) asDobjFor(Board)
    dobjFor(ParkourClimbDownTo) asDobjFor(ParkourClimbOverTo)
    dobjFor(ParkourJumpOverTo) asDobjFor(ParkourClimbOverTo)
    dobjFor(ParkourJumpDownTo) asDobjFor(ParkourClimbOverTo)

    dobjFor(ParkourClimbOverTo) {
        preCond = [touchObj, actorInStagingLocation]
        
        remap = remapOn

        verify() {
            if(!isBoardable || contType != On) {
                illogical(cannotBoardMsg);
            }
            if(gActor.isIn(self)) {
                illogicalNow(actorAlreadyOnMsg);
            }
            if(isIn(gActor)) {
                illogicalNow(cannotGetOnCarriedMsg);
            }
            illogical(cannotParkourToMsg);
        }
    }

    dobjFor(ParkourJumpGeneric) asDobjFor(ParkourJumpUpTo)
    dobjFor(ParkourJumpUpTo) {
        preCond = [touchObj]

        remap = remapOn

        verify() { 
            if(!canClimbUpMe) {
                illogical(cannotJumpUpMsg);
            }
        }
        action() {
            extraReport(platformLowEnoughMsg);
            doInstead(ClimbUp, self);
        }
    }

    dobjFor(ParkourClimbUpInto) asDobjFor(Enter)
    dobjFor(ParkourClimbDownInto) asDobjFor(Enter)
    dobjFor(ParkourClimbOverInto) asDobjFor(Enter)
    dobjFor(ParkourJumpOverInto) asDobjFor(Enter)
    dobjFor(ParkourJumpDownInto) asDobjFor(Enter)

    dobjFor(ParkourJumpUpInto) {
        preCond = [touchObj]

        remap = remapOn

        verify() { 
            if(!canClimbUpMe) {
                illogical(cannotJumpUpMsg);
            }
        }
        action() {
            extraReport(platformLowEnoughMsg);
            doInstead(ClimbUp, self);
        }
    }
    
    dobjFor(JumpOff) {
        action() {
            extraReport(platformLowEnoughMsg);
            doInstead(GetOff, self);
        }
    }

    canSlideUnderMe = nil

    dobjFor(ParkourSlideUnder) {
        preCond = [touchObj]

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

    dobjFor(ParkourRunAcross) {
        preCond = [touchObj]

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

    dobjFor(ParkourSwingOn) {
        preCond = [touchObj]

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

    canReachThroughParkour(obj) {
        if (obj.ofKind(ParkourPlatform)) {
            return obj.edgeCanBeReachedBy(self);
        }
        local myPlat = getParkourPlatform();
        local objPlat = obj.getParkourPlatform();
        if (myPlat != nil && objPlat == nil) {
            return myPlat.height == low;
        }
        if (myPlat == nil && objPlat != nil) {
            return objPlat.height == low;
        }
        if (myPlat != nil && objPlat != nil) {
            if (myPlat == objPlat) return true;
            local forwardRange = myPlat.getParkourRangeTo(objPlat);
            local backwardRange = objPlat.getParkourRangeTo(myPlat);
            return forwardRange == climbUpRange || backwardRange == climbUpRange;
        }
        return true;
    }

    getIndirectParkourPlatform() {
        return nil;
    }

    getParkourPlatform() {
        if (location == nil) {
            return nil;
        }
        return location.getParkourPlatform();
    }

    isSomehowOnParkourPlatform() {
        if (location == nil) {
            return nil;
        }
        return location.isSomehowOnParkourPlatform();
    }

    hasBeenClimbed = nil
    hasBeenClimbedProp = &hasBeenClimbed

    hasBeenClimbedBy(obj) {
        local prop = obj.hasBeenClimbedProp;
        return self.(prop);
    }

    setHasClimbed(obj) {
        setClimbKnowledgeOf(obj);
        obj.(hasBeenClimbedProp) = true;
    }

    isKnownToBeClimbable = nil
    isKnownToBeClimbableProp = &isKnownToBeClimbable

    isKnownToBeClimbableBy(obj) {
        local prop = obj.isKnownToBeClimbableProp;
        return self.(prop);
    }

    setClimbKnowledgeOf(obj) {
        obj.(isKnownToBeClimbableProp) = true;
    }

    cannotParkourToMsg =
        ('{The subj dobj} {is} too far away.
        {I} might need to get on something closer... ')
    platformLowEnoughMsg =
        ('({The subj dobj} {is} ' + ParkourPlatform.getClimbAdvantageReason('low') + '.)\n')
    cannotJumpUpMsg =
        ('{The subj dobj} {is} not something {i} {can} jump up. ')
    cannotSlideUnderMsg =
        ('{The subj dobj} {is} not something {i} {can} slide under. ')
    cannotRunAcrossMsg =
        ('{The subj dobj} {is} not something {i} {can} run across. ')
    cannotSwingOnMsg =
        ('{The subj dobj} {is} not something {i} {can} swing on. ')
}

modify Floor {
    decorationActions = [
        Examine, Board, Enter, ClimbUp,
        Climb, ParkourJumpGeneric,
        ParkourClimbUpTo, ParkourClimbDownTo, ParkourClimbOverTo,
        ParkourClimbUpInto, ParkourClimbDownInto, ParkourClimbOverInto,
        ParkourJumpUpTo, ParkourJumpDownTo, ParkourJumpOverTo,
        ParkourJumpUpInto, ParkourJumpDownInto, ParkourJumpOverInto
    ]

    dobjFor(ParkourClimbUpInto) asDobjFor(Enter)
    dobjFor(ParkourClimbDownInto) asDobjFor(Enter)
    dobjFor(ParkourClimbOverInto) asDobjFor(Enter)
    dobjFor(ParkourJumpUpInto) asDobjFor(Enter)
    dobjFor(ParkourJumpDownInto) asDobjFor(Enter)
    dobjFor(ParkourJumpOverInto) asDobjFor(Enter)
    dobjFor(Enter) {
        verify() {
            illogical(cannotEnterMsg);
        }
    }

    dobjFor(ParkourClimbDownTo) asDobjFor(Climb)
    dobjFor(ParkourClimbOverTo) asDobjFor(Climb)
    dobjFor(Climb) {
        preCond = nil

        verify() { doOnFloorCheck(); }
        check() { }
        action() {
            unpackOtherContainers();
            doInstead(GetOff, gActor.location);
        }
        report() { }
    }

    dobjFor(ParkourJumpDownTo) asDobjFor(ParkourJumpGeneric)
    dobjFor(ParkourJumpOverTo) asDobjFor(ParkourJumpGeneric)
    dobjFor(ParkourJumpGeneric) {
        preCond = nil

        verify() { doOnFloorCheck(); }
        check() { }
        action() {
            unpackOtherContainers();
            doInstead(JumpOff, gActor.location);
        }
        report() { }
    }

    dobjFor(ParkourClimbUpTo) asDobjFor(ClimbUp)
    dobjFor(ParkourJumpUpTo) asDobjFor(ClimbUp)
    dobjFor(ClimbUp) {
        preCond = nil

        verify() {
            doOnFloorCheck();
            illogical('\^' + theName + ' is the other way, silly. ');
        }
    }

    doOnFloorCheck() {
        if (gActor.location == gActor.getOutermostRoom()) {
            illogical('{I} {am} already on ' + theName + '. ');
        }
    }

    unpackOtherContainers() {
        if (gActor.location == gActor.getOutermostRoom()) return;
        if (gActor.location == nil) return;

        // If our container is not a parkour plat, and is not immediately
        // in the room, then try leaving the container.
        while (!gActor.location.ofKind(ParkourPlatform)) {
            if (gActor.location.exitLocation == gActor.getOutermostRoom()) break;

            if (gActor.location.contType == On) {
                // Get off of generic platforms first
                tryImplicitAction(GetOff, gActor.location);
            }
            else {
                // Get out of generic platforms first
                tryImplicitAction(GetOutOf, gActor.location);
            }
        }
    }
}

modify Room {
    knownFloorLinks = perInstance(new Vector())

    getParkourPlatform() {
        return nil;
    }

    isSomehowOnParkourPlatform() {
        return nil;
    }

    getLinksByRange(parkourRange) {
        local lst = [];

        for (local i = 1; i <= knownFloorLinks.length; i++) {
            local link = knownFloorLinks[i];
            if (link.range == parkourRange) {
                lst += link.dst;
            }
        }

        return lst;
    }

    knowsLinkTo(otherPlat) {
        for (local i = 1; i <= knownFloorLinks.length; i++) {
            local link = knownFloorLinks[i];
            if (link.dst == otherPlat) {
                return true;
            }
        }
        return nil;
    }

    getConnectionString() { //TODO: Support better listing options for screen readers
        if (knownFloorLinks.length == 0) return '{I} {do} not know of any parkour routes from {here}. ';

        local strBfr = new StringBuffer(40);
        local climbUpLinkList = getLinksByRange(climbUpRange);
        local jumpUpLinkList = getLinksByRange(jumpUpRange);

        if (climbUpLinkList.length > 0) {
            strBfr.append('\b<tt>(CL)</tt> <i>known <b>climb</b>ing routes:</i>');
            climbUpLinkList[1].getConnectionListString(climbUpLinkList, strBfr, climbUpRange);
        }
        if (jumpUpLinkList.length > 0) {
            strBfr.append('\b<tt>(JM)</tt> <i>known <b>jump</b>ing routes:</i>');
            jumpUpLinkList[1].getConnectionListString(jumpUpLinkList, strBfr, jumpUpRange);
        }

        //strBfr.append('\b');

        return toString(strBfr);
    }
}

modify Platform {
    isFixed = true

    dobjFor(ParkourClimbDownTo) asDobjFor(ParkourClimbUpTo)
    dobjFor(ParkourClimbOverTo) asDobjFor(ParkourClimbUpTo)
    dobjFor(ParkourJumpOverTo) {
        preCond = [touchObj, actorInStagingLocation]
        
        remap = remapOn

        verify() {
            if(!isBoardable || contType != On) {
                illogical(cannotBoardMsg);
            }
            if(gActor.isIn(self)) {
                illogicalNow(actorAlreadyOnMsg);
            }
            if(isIn(gActor)) {
                illogicalNow(cannotGetOnCarriedMsg);
            }
        }
        action() {
            extraReport(platformLowEnoughMsg);
            doInstead(ParkourClimbUpTo, self);
        }
    }
    dobjFor(ParkourJumpGeneric) asDobjFor(ParkourJumpOverTo)
    dobjFor(ParkourJumpDownTo) asDobjFor(ParkourJumpOverTo)
    dobjFor(Climb) asDobjFor(ParkourClimbUpTo)
    dobjFor(ClimbUp) asDobjFor(ParkourClimbUpTo)
    dobjFor(ClimbDown) asDobjFor(GetOff)
}

// low = climb up and down from the floor with ease
// awkward = requires jump up, but can climb down
// high = cannot climb up at all, and requires jump down
// damaging = cannot climb up at all, and requires damaging jump down
// lethal = cannot climb up or down at all; no jumps
enum low, awkward, high, damaging, lethal;

// climbUpRange = can climb up link
// climbDownRange = can climb down link
// jumpUpRange = can jump up link, but not climb up
// jumpDownRange = can jump down link, but not climb down
// fallDownRange = can jump down with fall damage, but not climb down
// jumpOverRange = can leap across link
enum climbUpRange, climbDownRange, climbOverRange, jumpUpRange,
    jumpDownRange, jumpOverRange, fallDownRange;

class ParkourLink: object {
    construct(_dst, _range) {
        dst = _dst;
        range = _range;
        isKnown = _dst.isKnownToBeClimbableBy(gPlayerChar);
    }

    dst = nil
    range = nil
    isKnown = nil
}

// Abstract functionality for a parkour-interfacing exit.
class ParkourTwoSidedTravelConnector: TravelConnector {
    isDestinationKnown = nil

    handleParkourTravelTransfer(actor) {
        local nextRoom = destination.getOutermostRoom();
        local traveler = getTraveler(actor);
        if (actor == gPlayerChar) {
            local lastPlatform = actor.getParkourPlatform();
            if (lastPlatform != nil) {
                lastPlatform.learnLinkBetweenHereAnd(self);
            }
            actor.setHasClimbed(self);
        }
        if (checkTravelBarriers(traveler)) {
            nextRoom.execTravel(actor, traveler, self);
            if (!destination.ofKind(Room)) {
                traveler.moveInto(destination);
            }
            if (destination.ofKind(ParkourPlatform)) {
                local travelPrep = destination.contType == On ? 'on' : 'just inside';
                reportAfter('\n{I} {am} {then} <<travelPrep>> <<destination.theName>>. ');
                if (actor == gPlayerChar) {
                    otherSide.isDestinationKnown = true;
                    isDestinationKnown = true;
                    actor.setHasClimbed(otherSide);
                    if (destination.ofKind(ParkourPlatform)) {
                        actor.setHasClimbed(destination);
                        if (destination != otherSide) {
                            destination.learnLinkBetweenHereAnd(otherSide);
                        }
                    }
                    reportAfter(destination.getIndirectParkourPlatform().getConnectionString());
                }
            }
        }
    }
}

// Partial door-based traits for a parkour exit
class ParkourPartialDoor: Door {
    isEnterable = true
    contType = In
    leaveOpen = nil // Have the open to have permanently-open exits

    iobjFor(PutIn) {
        action() {
            gDobj.actionMoveInto(destination);
        }
    }

    initLeaveOpen() {
        if (leaveOpen && otherSide.leaveOpen) { 
            isOpenable = nil;
            isOpen = true;
        }
    }
}

// A TravelConnector that can connect a ParkourPlatform to a standard Room exit.
class ParkourEasyExit: ParkourTwoSidedTravelConnector, ParkourPartialDoor {
    travelDesc = "{I} {go} through <<theName>>. "

    preinitThing() {
        inherited();
        initLeaveOpen();
    }

    dobjFor(TravelVia) asDobjFor(GoThrough)
    dobjFor(GoIn) asDobjFor(GoThrough)
    dobjFor(Climb) asDobjFor(GoThrough)
    dobjFor(GoThrough) {
        preCond = [travelPermitted, touchObj, objOpen, actorInStagingLocation]

        action() {
            handleParkourTravelTransfer(gActor);
        }
    }
}

#define parkourExitActionMod(actionName) \
    dobjFor(actionName) { \
        preCond = [travelPermitted, touchObj, objOpen] \
        action() { \
            inherited(); \
            handleParkourTravelTransfer(gActor); \
        } \
        report() { } \
    }

// A TravelConnector for exclusively allowing travel only through
// the parkour system.
class ParkourExit: ParkourTwoSidedTravelConnector, ParkourPlatform, ParkourPartialDoor {
    isConnectorListed = nil
    contType = In

    preinitThing() {
        inherited();
        initLeaveOpen();
    }

    iobjFor(PutOn) {
        action() {
            gDobj.actionMoveInto(destination);
        }
    }

    travelDesc() {
        switch (gParkourAvailableRange) {
            case climbUpRange:
                doRepClimbUp(self);
                break;
            case climbDownRange:
                doRepClimbDown(self);
                break;
            case climbOverRange:
                doRepStep(self);
                break;
            case jumpUpRange:
                doRepJumpUp(self);
                break;
            case jumpDownRange:
                doRepJumpDown(self);
                break;
            case jumpOverRange:
                doRepLeap(self);
                break;
            case fallDownRange:
                doRepFall(self);
                break;
        }
    }

    hasConnectionStringOverride = true

    dobjFor(TravelVia) asDobjFor(ParkourClimbOverInto)

    parkourExitActionMod(ParkourClimbUpTo)
    parkourExitActionMod(ParkourClimbUpInto)
    parkourExitActionMod(ParkourClimbOverTo)
    parkourExitActionMod(ParkourClimbOverInto)
    parkourExitActionMod(ParkourClimbDownTo)
    parkourExitActionMod(ParkourClimbDownInto)
    parkourExitActionMod(ParkourJumpUpTo)
    parkourExitActionMod(ParkourJumpUpInto)
    parkourExitActionMod(ParkourJumpOverTo)
    parkourExitActionMod(ParkourJumpOverInto)
    parkourExitActionMod(ParkourJumpDownTo)
    parkourExitActionMod(ParkourJumpDownInto)
}

// A version of ParkourPlatform that is a compatible SubComponent
class SubParkourPlatform: ParkourPlatform, SubComponent {
    //
}

#define parkourMultiContainerMod(actionName) \
    dobjFor(actionName) { \
        remap = remapOn \
    }

// All Fixtures that have a SubParkourPlatform must also inherit
// from this class!!
class ParkourMultiContainer: Fixture {
    parkourMultiContainerMod(Climb)
    parkourMultiContainerMod(ParkourJumpGeneric)
    parkourMultiContainerMod(ParkourClimbUpInto)
    parkourMultiContainerMod(ParkourClimbOverTo)
    parkourMultiContainerMod(ParkourClimbDownTo)
    parkourMultiContainerMod(ParkourJumpUpTo)
    parkourMultiContainerMod(ParkourJumpOverTo)
    parkourMultiContainerMod(ParkourJumpDownTo)
    parkourMultiContainerMod(GetOff)
    parkourMultiContainerMod(JumpOff)

    dobjFor(ClimbUp) asDobjFor(ParkourClimbUpInto)
    dobjFor(ClimbDown) asDobjFor(GetOff)

    dobjFor(Examine) {
        action() {
            inherited();
            getIndirectParkourPlatform().observePossibleLink();
        }
    }

    getIndirectParkourPlatform() {
        return remapOn;
    }
}

#define parkourPreCond [touchObj]
#define parkourCheck { checkInsert(gActor); }

#define parkourGenDisamBranch(proxyAction, parkourMode) \
    dobjFor(proxyAction) { \
        preCond = parkourPreCond \
        verify() { \
            gParkourAvailableRange = getRangeFromSource(); \
            verifyGeneral(); \
        } \
        check() { } \
        action() { \
            if (contType == In) { \
                parkourGenDisamSwitch(parkourMode, Into) \
            } \
            else { \
                parkourGenDisamSwitch(parkourMode, To) \
            } \
        } \
        report() { } \
    }

#define parkourGenDisamSwitch(parkourMode, prep) \
    switch (gParkourAvailableRange) { \
        default: \
            doInstead(Parkour##parkourMode##Up##prep, self); \
            break; \
        case climbDownRange: \
        case jumpDownRange: \
        case fallDownRange: \
            doInstead(Parkour##parkourMode##Down##prep, self); \
            break; \
        case climbOverRange: \
        case jumpOverRange: \
            doInstead(Parkour##parkourMode##Over##prep, self); \
            break; \
    }

#define parkourClimbPair(dir, jumpList, miscActions) \
    parkourClimbBranch(dir, To, On, jumpList, miscActions) \
    parkourClimbBranch(dir, Into, In, jumpList, miscActions)

#define parkourClimbBranch(dir, prep, mContType, jumpList, miscActions) \
    dobjFor(ParkourClimb##dir##prep) { \
        preCond = parkourPreCond \
        remap = remap##mContType \
        verify() { \
            verifyMinimal(mContType); \
            gParkourAvailableRange = getRangeFromSource(); \
            parkourCache.rememberLastPlatform(); \
            gParkourAttemptedRange = climb##dir##Range; \
            verifyGeneral(); \
            verifyClimb([climb##dir##Range], jumpList); \
        } \
        check() parkourCheck \
        action() { \
            handleGenericSource(); \
            doClimbAction(); \
            miscActions \
        } \
        report() { \
            switch (gParkourAvailableRange) { \
                case climbUpRange: \
                    doRepClimbUp(self); \
                    break; \
                case climbDownRange: \
                    doRepClimbDown(self); \
                    break; \
                case climbOverRange: \
                    doRepStep(self); \
                    break; \
            } \
        } \
    }

#define parkourJumpPair(dir, jumpList, miscActions) \
    parkourJumpBranch(dir, To, On, jumpList, miscActions) \
    parkourJumpBranch(dir, Into, In, jumpList, miscActions)

#define parkourJumpBranch(dir, prep, mContType, jumpList, miscActions) \
    dobjFor(ParkourJump##dir##prep) { \
        preCond = parkourPreCond \
        remap = remap##mContType \
        verify() { \
            verifyMinimal(mContType); \
            gParkourAvailableRange = getRangeFromSource(); \
            parkourCache.rememberLastPlatform(); \
            gParkourAttemptedRange = climb##dir##Range; \
            verifyGeneral(); \
            verifyJump([climb##dir##Range], jumpList); \
        } \
        check() parkourCheck \
        action() { \
            handleGenericSource(); \
            doClimbAttempt(); \
            miscActions \
        } \
        report() { \
            switch (gParkourAvailableRange) { \
                case jumpUpRange: \
                    doRepJumpUp(self); \
                    break; \
                case jumpDownRange: \
                    doRepJumpDown(self); \
                    break; \
                case jumpOverRange: \
                    doRepLeap(self); \
                    break; \
                case fallDownRange: \
                    doRepFall(self); \
                    break; \
            } \
        } \
    }

#define parkourAdjustPutPair \
    parkourAdjustPutBranch(On) \
    parkourAdjustPutBranch(In)

#define parkourAdjustPutBranch(mContType) \
    iobjFor(Put##mContType) { \
        verify() { \
            local actorPlat = gActor.getParkourPlatform(); \
            /* The actor is not on this platform */ \
            if (actorPlat != self) { \
                /* The actor is just in the room */ \
                if (actorPlat == nil && height != low) { \
                    illogicalNow(cannotReachPlatformTopMsg); \
                } \
                /* The actor is on another platform */ \
                if (actorPlat != nil) { \
                    local range = actorPlat.getParkourRangeTo(self); \
                    switch (range) { \
                        case jumpUpRange: \
                        case jumpDownRange: \
                        case jumpOverRange: \
                        case fallDownRange: \
                            illogicalNow(cannotReachPlatformTopMsg); \
                            break; \
                    } \
                } \
            } \
            inherited(); \
        } \
    }

class ParkourPlatform: Platform {
    totalParkourLinks = perInstance(new Vector()) // This is modified at runtime

    climbUpLinks = [] // This is modified by the author
    climbDownLinks = [] // This is modified by the author
    stepLinks = [] // This is modified by the author
    jumpUpLinks = [] // This is modified by the author
    jumpDownLinks = [] // This is modified by the author
    fallDownLinks = [] // This is modified by the author
    leapLinks = [] // This is modified by the author
    height = low
    isFixed = true

    // Prepositions for parkour links
    climbUpDirPrep = (contType == On ? 'on' : 'into')
    climbDownDirPrep = (contType == On ? 'down to' : 'down into')
    stepDirPrep = (contType == On ? 'over to' : 'through')
    jumpUpDirPrep = (contType == On ? 'up' : 'up into')
    jumpDownDirPrep = (climbDownDirPrep)
    leapDirPrep = (stepDirPrep)
    theEdgeName = ('the edge')
    landingDirPrep = (contType == On ? 'on' : 'near')
    landingConclusionMsg = (contType == On ? '' : 'From{aac} {here}, {i} climb{s/ed} through. ')

    cannotParkourOnMsg =
        ('{The subj dobj} {is} not something {i} {can} get on from {here}.
        {I} might need to get on something else first... ')
    cannotSimplyParkourOnMsg =
        ('While {i} {cannot} simply climb {the dobj} from {here},
        {i} {can} JUMP UP {them dobj}'
        + getJumpRisk())
    tooHighClimbDownMsg =
        ('The floor is too far below;
        {i} might need to get on something lower first.
        {I} could JUMP OFF'
        + getJumpRisk())
    tooRiskyClimbDownMsg =
        ('The floor is too far below;
        {i} might need to get on something lower first.
        {I} could JUMP OFF'
        + getFallRisk())
    tooHighClimbDownToMsg =
        ('{The subj dobj} {is} too far below;
        {i} might need to get on something lower first.
        {I} could JUMP DOWN TO {them dobj}'
        + getJumpRisk())
    tooRiskyClimbDownToMsg =
        ('{The subj dobj} {is} too far below;
        {i} might need to get on something lower first.
        {I} could JUMP DOWN TO {them dobj}'
        + getFallRisk())
    wayTooHighClimbDownMsg =
        ('The floor is way too far below;
        {i} might need to get on something lower first. '
        + getPlummetRisk())
    wayTooHighClimbDownToMsg =
        ('{The subj dobj} {is} way too far below;
        {i} might need to get on something lower first. '
        + getPlummetRisk())
    cannotStepToMsg =
        ('While {i} {cannot} simply step over to {the dobj},
        {i} {can} LEAP TO {them dobj}'
        + getJumpRisk())
    stuckOnPlatformMsg =
        ('{I} {cannot} move from {here}. ')
    cannotReachPlatformTopMsg =
        ('{I} {cannot} reach top of {the iobj}. ')
    parkourCannotClimbUpMsg =
        ('{I} {cannot} climb up to {that dobj}. ')
    parkourCannotClimbDownMsg =
        ('{I} {cannot} climb down to {that dobj}. ')
    parkourCannotStepMsg =
        ('{I} {cannot} step over to {that dobj}. ')

    getClimbAdvantageReason(preferredQuality) {
        return preferredQuality + ' enough for an easier approach';
    }

    getJumpRisk() {
        return ', however.  ';
    }

    getFallRisk() {
        return ', however. ';
    }

    getPlummetRisk() {
        return '{I} certainly {cannot} JUMP OFF, without risking death. ';
    }

    doRepClimbUp(destThing) {
        local obj = destThing;
        gMessageParams(obj);
        "{I} climb{s/ed} <<climbUpDirPrep>> {the obj}. ";
    }

    doRepClimbDown(destThing) {
        local obj = destThing;
        gMessageParams(obj);
        "{I} climb{s/ed} <<climbDownDirPrep>> {the obj}. ";
    }

    doRepStep(destThing) {
        local obj = destThing;
        gMessageParams(obj);
        "{I} step{s/?ed} <<stepDirPrep>> {the obj}. ";
    }

    doRepJumpUp(destThing) {
        local obj = destThing;
        gMessageParams(obj);
        "{I} jump{s/ed} up,{aac}
        and clamber{s/ed} <<jumpUpDirPrep>> {the obj}. ";
    }

    doRepJumpDown(destThing) {
        local obj = destThing;
        gMessageParams(obj);
        "{I} {hold} onto
        <<gParkourTheEdgeName>>,{aac}
        drop{s/?ed} to a hanging position,{aac}
        {let} go,{aac}
        and land{s/ed} hard <<landingDirPrep>> {the obj} below. <<landingConclusionMsg>>";
    }

    doRepLeap(destThing) {
        local obj = destThing;
        gMessageParams(obj);
        "{I} jump{s/ed} <<leapDirPrep>> {the obj},
        and{aac} tr{ies/ied} to keep {my} balance. ";
    }

    doRepFall(destThing) {
        local obj = destThing;
        gMessageParams(obj);
        "{I} {hold} onto <<gParkourTheEdgeName>>,{aac}
        drop{s/?ed} to a hanging position,{aac}
        and {let} go. {I} land{s/ed} hard, and{aac} {find} {myself}
        <<landingDirPrep>> {the obj}. <<landingConclusionMsg>>";
    }

    // Override for travel inheritors
    hasConnectionStringOverride = nil

    canPutInMe = (contType != On)
    isEnterable = (contType != On)

    getIndirectParkourPlatform() {
        return self;
    }

    dobjFor(Examine) {
        action() {
            inherited();
            observePossibleLink();
        }
    }

    dobjFor(Board) asDobjFor(ParkourClimbUpTo)

    // Expand checks for PutOn and PutIn via macro
    parkourAdjustPutPair

    // Generic disambiguation
    parkourGenDisamBranch(Climb, Climb)
    parkourGenDisamBranch(ParkourJumpGeneric, Jump)

    // Actions
    parkourClimbPair(Up, [jumpUpRange],
        handleClimbUpDifficulty(gActor);
    )

    parkourClimbPair(Over, [jumpOverRange],
        handleStepDifficulty(gActor);
    )

    dobjFor(Enter) asDobjFor(ParkourClimbOverInto)
    dobjFor(GoThrough) asDobjFor(ParkourClimbOverInto)
    dobjFor(GoIn) asDobjFor(ParkourClimbOverInto)

    parkourClimbPair(Down, [jumpDownRange, fallDownRange],
        handleClimbDownDifficulty(gActor);
    )

    parkourJumpPair(Up, [jumpUpRange],
        handleJumpUpDifficulty(gActor);
    )

    parkourJumpPair(Over, [jumpOverRange],
        handleLeapDifficulty(gActor);
    )

    parkourJumpPair(Down, [jumpDownRange, fallDownRange],
        if (gParkourAvailableRange == fallDownRange) {
            handleFallDownDifficulty(gActor);
        }
        else {
            handleJumpDownDifficulty(gActor);
        }
    )

    dobjFor(GetOff) {
        remap = remapOn
        
        verify() {
            verifyMinimalJump();
            switch (height) {
                case high:
                    illogicalNow(tooHighClimbDownMsg);
                    break;
                case damaging:
                    illogicalNow(tooRiskyClimbDownMsg);
                    break;
                case lethal:
                    illogicalNow(wayTooHighClimbDownMsg);
                    break;
            }
        }
        action() {
            inherited();
            handleClimbDownDifficulty(gActor);
        }
        report() {
            doRepClimbDown(gActor.getOutermostRoom().floorObj);
        }
    }

    dobjFor(JumpOff) {
        remap = remapOn
        
        verify() {
            verifyMinimalJump();
            if (height == lethal) {
                illogical(wayTooHighClimbDownMsg);
            }
        }
        action() {
            if (height == high || height == damaging) {
                gActor.actionMoveInto(exitLocation);
                if (height == damaging) {
                    handleFallDownDifficulty(gActor);
                }
                else {
                    handleJumpDownDifficulty(gActor);
                }
            }
            else {
                inherited();
            }
        }
        report() {
            if (height == damaging) {
                doRepFall(gActor.getOutermostRoom().floorObj);
            }
            else {
                doRepJumpDown(gActor.getOutermostRoom().floorObj);
            }
        }
    }

    canReachThroughParkour(obj) {
        if (obj.ofKind(ParkourPlatform)) {
            return hasConnectionTo(obj.ofKind(ParkourPlatform));
        }

        if (obj.getParkourPlatform() == self) return true;

        return edgeCanBeReachedBy(obj);
    }

    getParkourPlatform() {
        return self;
    }

    isSomehowOnParkourPlatform() {
        return true;
    }

    edgeCanBeReachedBy(obj) {
        if (obj.ofKind(ParkourPlatform)) {
            return obj.hasConnectionTo(self);
        }

        local objPlat = obj.getParkourPlatform();
        if (objPlat == nil) {
            return height == low || height == awkward;
        }
        
        return objPlat.hasConnectionTo(self);
    }

    hasConnectionTo(otherPlat) {
        if (otherPlat == self) return true;
        for (local i = 1; i <= totalParkourLinks.length; i++) {
            if (totalParkourLinks[i].dst == otherPlat) {
                return true;
            }
        }
        return nil;
    }

    getRangeFromFloor() {
        switch (height) {
            case low:
                return climbUpRange;
            case awkward:
                return jumpUpRange;
        }

        return nil;
    }

    getRangeFromSource() {
        local currentPlat = gActor.getParkourPlatform();

        // If we are on a generic, then we will start climbing from the floor
        // If we are already on the floor, then get range from height
        if (currentPlat == nil) {
            return getRangeFromFloor();
        }
        else {
            for (local i = 1; i <= currentPlat.totalParkourLinks.length; i++) {
                local link = currentPlat.totalParkourLinks[i];
                if (link.dst == self) {
                    return link.range;
                }
            }
        }

        return nil;
    }

    verifyMinimal(actionContType) {
        if (contType == In) {
            if(contType != actionContType) {
                illogical(cannotBoardMsg);
            }
            if(gActor.isIn(self)) {
                illogicalNow(actorAlreadyInMsg);
            }
            if(isIn(gActor)) {
                illogicalNow(cannotGetInCarriedMsg);
            }
        }
        else {
            if(contType != actionContType) {
                illogical(cannotEnterMsg);
            }
            if(gActor.isIn(self)) {
                illogicalNow(actorAlreadyOnMsg);
            }
            if(isIn(gActor)) {
                illogicalNow(cannotGetOnCarriedMsg);
            }
        }
    }

    verifyMinimalJump() {
        if(!gActor.isIn(self)) {
            illogicalNow(actorNotOnMsg);
        }
    }

    verifyGeneral() {
        if (gParkourAvailableRange == nil) {
            illogical(cannotParkourToMsg);
        }
    }

    verifyClimb(climbRangeList, jumpRangeList) {
        local isInClimbRange = (climbRangeList.indexOf(gParkourAvailableRange) != nil);
        local isInJumpRange = (jumpRangeList.indexOf(gParkourAvailableRange) != nil);

        if (!isInClimbRange) {
            if (isInJumpRange) {
                switch (gParkourAvailableRange) {
                    case jumpUpRange:
                        illogicalNow(cannotSimplyParkourOnMsg);
                        break;
                    case jumpDownRange:
                        illogicalNow(tooHighClimbDownToMsg);
                        break;
                    case jumpOverRange:
                        illogicalNow(cannotStepToMsg);
                        break;
                    case fallDownRange:
                        illogicalNow(tooRiskyClimbDownToMsg);
                        break;
                }
            }
            else {
                switch (gParkourAttemptedRange) {
                    case climbUpRange:
                        illogical(parkourCannotClimbUpMsg);
                        break;
                    case climbDownRange:
                        illogical(parkourCannotClimbDownMsg);
                        break;
                    case climbOverRange:
                        illogical(parkourCannotStepMsg);
                        break;
                }
            }

            illogical(cannotParkourOnMsg);
        }
    }

    verifyJump(climbRangeList, jumpRangeList) {
        local isInClimbRange = (climbRangeList.indexOf(gParkourAvailableRange) != nil);
        local isInJumpRange = (jumpRangeList.indexOf(gParkourAvailableRange) != nil);

        if (!isInJumpRange && !isInClimbRange) {
            switch (gParkourAttemptedRange) {
                case climbUpRange:
                    illogical(cannotJumpUpMsg);
                    break;
                case climbDownRange:
                    illogical(wayTooHighClimbDownToMsg);
                    break;
                default:
                    illogical(cannotParkourToMsg);
                    break;
            }
        }
    }

    handleGenericSource() {
        if (gActor.getParkourPlatform() == nil && gActor.location.location != nil) {
            if (gActor.location.contType == On) {
                // Get off of generic platforms first
                tryImplicitAction(GetOff, gActor.location);
            }
            else {
                // Get out of generic platforms first
                tryImplicitAction(GetOutOf, gActor.location);
            }
        }
    }

    learnFloorLink() {
        local floorRange = getRangeFromFloor();
        if (floorRange != nil) {
            local room = gActor.getOutermostRoom();
            for (local i = 1; i <= room.knownFloorLinks.length; i++) {
                if (room.knownFloorLinks[i].dst == self) return; // Already known
            }
            local newLink = new ParkourLink(self, floorRange);
            newLink.isKnown = true;
            room.knownFloorLinks.append(newLink);
        }
    }

    learnLinkTo(otherPlat) {
        for (local i = 1; i <= totalParkourLinks.length; i++) {
            local link = totalParkourLinks[i];
            if (link.dst == otherPlat) {
                link.isKnown = true;
            }
        }
    }

    knowsLinkTo(otherPlat) {
        for (local i = 1; i <= totalParkourLinks.length; i++) {
            local link = totalParkourLinks[i];
            if (link.dst == otherPlat) {
                if (link.isKnown) return true;
            }
        }
        return nil;
    }

    learnLinkBetweenHereAnd(actor) {
        local currentPlatform = actor.getParkourPlatform();
        if (currentPlatform != nil) {
            currentPlatform.learnLinkTo(self);
            learnLinkTo(currentPlatform);
            currentPlatform.learnFloorLink();
        }
        learnFloorLink();
        actor.setClimbKnowledgeOf(self);
    }

    doClimbAction() {
        learnLinkBetweenHereAnd(gActor);
        gActor.actionMoveInto(self);
        gActor.setHasClimbed(self);

        // Only list connection strings if the inheritor won't handle it
        if (!hasConnectionStringOverride && gActor == gPlayerChar) {
            reportAfter(getConnectionString());
        }
    }

    observePossibleLink() {
        if (gActor == gPlayerChar) {
            local currentPlat = gPlayerChar.getParkourPlatform();
            local knowsLink = nil;
            if (currentPlat == nil) { // Knows link from floor
                knowsLink = gPlayerChar.getOutermostRoom().knowsLinkTo(self);
            }
            else {
                knowsLink = currentPlat.knowsLinkTo(self);
            }

            if (knowsLink == nil) {
                local range = getRangeFromSource();
                if (range != nil) {
                    local obj = self;
                    gMessageParams(obj);
                    local rangeString = getConnectionActionStr(self, range);
                    learnLinkBetweenHereAnd(gActor);
                    reportAfter('\b(It{dummy} look{s/ed} like {i} {can} ' +
                        rangeString + ' {that obj} from {here}.) ');
                }
            }
        }
    }

    doClimbAttempt() {
        switch (gParkourAvailableRange) {
            case climbUpRange:
                extraReport('({the subj dobj} {is} ' + getClimbAdvantageReason('low') + '.)\n');
                doInstead(ClimbUp, self);
                break;
            case climbDownRange:
                extraReport('({the subj dobj} {is} ' + getClimbAdvantageReason('close') + '.)\n');
                doInstead(ParkourClimbDownTo, self);
                break;
            case climbOverRange:
                extraReport('({the subj dobj} {is} ' + getClimbAdvantageReason('high') + '.)\n');
                doInstead(ParkourClimbOverTo, self);
                break;
            default:
                doClimbAction();
                break;
        }
    }

    //TODO: Implement unexpected accidents for parkour

    handleClimbUpDifficulty(actor) {
        //
    }

    handleClimbDownDifficulty(actor) {
        //
    }

    handleStepDifficulty(actor) {
        //
    }

    handleJumpUpDifficulty(actor) {
        //
    }

    handleJumpDownDifficulty(actor) {
        //
    }

    handleLeapDifficulty(actor) {
        //
    }

    handleFallDownDifficulty(actor) {
        //
    }

    preinitThing() {
        inherited();

        // Init climb-up/down and step links
        for (local i = 1; i <= climbUpLinks.length; i++) {
            totalParkourLinks.appendUnique(new ParkourLink(
                climbUpLinks[i].getIndirectParkourPlatform(), climbUpRange));
            climbUpLinks[i].getIndirectParkourPlatform().totalParkourLinks.appendUnique(new ParkourLink(
                self, climbDownRange));
        }
        for (local i = 1; i <= climbDownLinks.length; i++) {
            totalParkourLinks.appendUnique(new ParkourLink(
                climbDownLinks[i].getIndirectParkourPlatform(), climbDownRange));
            climbDownLinks[i].getIndirectParkourPlatform().totalParkourLinks.appendUnique(new ParkourLink(
                self, climbUpRange));
        }
        for (local i = 1; i <= stepLinks.length; i++) {
            totalParkourLinks.appendUnique(new ParkourLink(
                stepLinks[i].getIndirectParkourPlatform(), climbOverRange));
            stepLinks[i].getIndirectParkourPlatform().totalParkourLinks.appendUnique(new ParkourLink(
                self, climbOverRange));
        }

        // Init jump-up links
        for (local i = 1; i <= jumpUpLinks.length; i++) {
            totalParkourLinks.appendUnique(new ParkourLink(
                jumpUpLinks[i].getIndirectParkourPlatform(), jumpUpRange));
            jumpUpLinks[i].getIndirectParkourPlatform().totalParkourLinks.appendUnique(new ParkourLink(
                self, climbDownRange));
        }

        // Init jump-down links
        for (local i = 1; i <= jumpDownLinks.length; i++) {
            totalParkourLinks.appendUnique(new ParkourLink(
                jumpDownLinks[i].getIndirectParkourPlatform(), jumpDownRange));
        }

        // Init fall-down links
        for (local i = 1; i <= fallDownLinks.length; i++) {
            totalParkourLinks.appendUnique(new ParkourLink(
                fallDownLinks[i].getIndirectParkourPlatform(), fallDownRange));
        }

        // Init leap links
        for (local i = 1; i <= leapLinks.length; i++) {
            totalParkourLinks.appendUnique(new ParkourLink(
                leapLinks[i].getIndirectParkourPlatform(), jumpOverRange));
            leapLinks[i].getIndirectParkourPlatform().totalParkourLinks.appendUnique(new ParkourLink(
                self, jumpOverRange));
        }
    }

    getConnectionString() {
        local floorAccessCount = (height == lethal) ? 0 : 1;

        if (totalParkourLinks.length + floorAccessCount == 0) {
            return stuckOnPlatformMsg;
        }

        local strBfr = new StringBuffer(40);
        local climbUpLinkList = getParkourLinkList(climbUpRange);
        local climbDownLinkList = getParkourLinkList(climbDownRange);
        local stepLinkList = getParkourLinkList(climbOverRange);
        local jumpUpLinkList = getParkourLinkList(jumpUpRange);
        local jumpDownLinkList = getParkourLinkList(jumpDownRange);
        local leapLinkList = getParkourLinkList(jumpOverRange);
        local fallLinkList = getParkourLinkList(fallDownRange);

        local climbCount =
            climbUpLinkList.length +
            climbDownLinkList.length +
            stepLinkList.length;
        
        local jumpCount =
            jumpUpLinkList.length +
            jumpDownLinkList.length +
            leapLinkList.length +
            fallLinkList.length;

        if (climbCount > 0) {
            strBfr.append('\b<tt>(CL)</tt> <i>known <b>climb</b>ing routes:</i>');
            getConnectionListString(climbUpLinkList, strBfr, climbUpRange);
            getConnectionListString(climbDownLinkList, strBfr, climbDownRange);
            getConnectionListString(stepLinkList, strBfr, climbOverRange);
        }
        if (jumpCount > 0) {
            strBfr.append('\b<tt>(JM)</tt> <i>known <b>jump</b>ing routes:</i>');
            getConnectionListString(jumpUpLinkList, strBfr, jumpUpRange);
            getConnectionListString(jumpDownLinkList, strBfr, jumpDownRange);
            getConnectionListString(leapLinkList, strBfr, jumpOverRange);
            getConnectionListString(fallLinkList, strBfr, fallDownRange);
        }

        if (climbCount == 0 && jumpCount == 0) return stuckOnPlatformMsg;

        return toString(strBfr);
    }

    getConnectionActionFromRange(parkourRange) {
        switch (parkourRange) {
            case climbUpRange:
            case climbDownRange:
                return 'climb';
            case jumpUpRange:
            case jumpDownRange:
                return 'jump';
            case fallDownRange:
                return 'jump <i>(recklessly)</i>';
            case climbOverRange:
                return 'step';
        }
        return 'leap';
    }

    getDirPrepFromRange(parkourRange) {
        switch (parkourRange) {
            case climbUpRange:
                return &climbUpDirPrep;
            case climbDownRange:
                return &climbDownDirPrep;
            case jumpUpRange:
                return &jumpUpDirPrep;
            case jumpDownRange:
            case fallDownRange:
                return &jumpDownDirPrep;
            case climbOverRange:
                return &stepDirPrep;
        }
        return &leapDirPrep;
    }

    getGetMultiClassDirPrep(dest, parkourRange) {
        local prepPtr = getDirPrepFromRange(parkourRange);
        if (dest.ofKind(ParkourPlatform)) return dest.(prepPtr);
        else if (dest.ofKind(Platform)) return 'onto';
        return 'to';
    }

    getConnectionActionStr(dest, parkourRange) {
        return getConnectionActionFromRange(parkourRange) + ' ' + getGetMultiClassDirPrep(dest, parkourRange);
    }

    getConnectionListString(lst, bfr, parkourRange) {
        if (lst.length == 0) return;
        local actionStr = getConnectionActionFromRange(parkourRange);
        bfr.append('\n\t{I} {can} ');
        bfr.append(actionStr);
        bfr.append(' ');
        for (local i = 1; i <= lst.length; i++) {
            local dest = lst[i];
            bfr.append(getGetMultiClassDirPrep(dest, parkourRange));
            bfr.append(' ');
            bfr.append(dest.theName);
            if (i == lst.length) {
                bfr.append('. ');
            }
            else if (i == lst.length - 1) {
                bfr.append(', or ');
            }
            else {
                bfr.append(', ');
            }
        }
    }

    getParkourRangeTo(dst) {
        for (local i = 1; i <= totalParkourLinks.length; i++) {
            local link = totalParkourLinks[i];
            if (link.dst == dst) {
                return link.range;
            }
        }
        return nil;
    }

    getParkourLinkList(parkourRange) {
        local lst = [];

        local matchesRange = nil;
        switch (height) {
            case low:
            case awkward:
                matchesRange = parkourRange == climbDownRange;
                break;
            case high:
                matchesRange = parkourRange == jumpDownRange;
                break;
            case damaging:
                matchesRange = parkourRange == fallDownRange;
                break;
        }
        if (matchesRange) lst += getOutermostRoom().floorObj;

        for (local i = 1; i <= totalParkourLinks.length; i++) {
            local link = totalParkourLinks[i];

            if (link.range != parkourRange) continue;
            if (!link.isKnown) continue;
            if (!gPlayerChar.knowsAbout(link.dst)) continue;
            
            lst += link.dst;
        }

        return lst;
    }
}
