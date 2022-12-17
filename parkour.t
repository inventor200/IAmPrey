VerbRule(ParkourTo)
    ('climb'|'cl'|'get'|'parkour'|'step') ('over'|'across'|'over' 'to'|'across' 'to'|'to'|'onto'|'on' 'to') (('the'|)'top' 'of'|) singleDobj
    : VerbProduction
    action = ParkourTo
    verbPhrase = 'climb to (what)'
    missingQ = 'what do you want to climb to'
;

DefineTAction(ParkourTo)
;

VerbRule(ParkourJumpTo)
    ('jump'|'hop'|'leap') ('over'|'across'|'over' 'to'|'across' 'to'|'to'|'onto'|'on' 'to') (('the'|)'top' 'of'|) singleDobj |
    ('jump'|'hop'|'leap'|'jm') singleDobj
    : VerbProduction
    action = ParkourJumpTo
    verbPhrase = 'jump to (what)'
    missingQ = 'what do you want to jump to'
;

DefineTAction(ParkourJumpTo)
;

VerbRule(ParkourJumpUp)
    ('jump'|'hop'|'leap'|'clamber'|'scramble'|'wall' 'run'|'wallrun') 'up' (('the'|) 'side' 'of'|'to'|) singleDobj |
    'clamber' singleDobj
    : VerbProduction
    action = ParkourJumpUp
    verbPhrase = 'jump up (what)'
    missingQ = 'what do you want to jump up'
;

DefineTAction(ParkourJumpUp)
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

VerbRule(ParkourClimbDownTo)
    ('climb'|'cl'|'get'|'parkour'|'step') 'down' 'to' singleDobj
    : VerbProduction
    action = ParkourClimbDownTo
    verbPhrase = 'climb down to (what)'
    missingQ = 'what do you want to climb down to'
;

DefineTAction(ParkourClimbDownTo)
;

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
    ('jump'|'hop'|'leap'|'vault') ('over'|'across'|('on'|'over' ('the'|)) 'top' 'of'|) singleDobj :
;

//TODO: Slide under

QParkour: Special {
    priority = 16
    active = true

    reachProblemVerify(a, b) {
        local issues = [];

        // Don't worry about room connections
        if (a.ofKind(Room) || b.ofKind(Room)) return issues;

        if (!a.canReachThroughParkour(b)) {
            issues += new ReachProblemDistance(a, b);
        }

        return issues;
    }
}

modify Thing {
    parkourAvailableRangeCache = nil;

    dobjFor(ParkourClimbDownTo) asDobjFor(ParkourTo)
    dobjFor(ParkourJumpTo) asDobjFor(ParkourTo)
    dobjFor(ParkourJumpDownTo) asDobjFor(ParkourTo)

    dobjFor(ParkourTo) {
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

    dobjFor(ParkourJumpUp) {
        preCond = [touchObj]

        remap = remapOn

        verify() { 
            if(!canClimbUpMe) {
                illogical(cannotJumpUp);
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

    cannotParkourOnMsg = BMsg(cannot parkour on,
        '{The subj dobj} {is} not something {i} {can} get on from {here}.
        {I} might need to get on something else first... ')
    cannotSimplyParkourOnMsg = BMsg(cannot simply parkour on,
        'While {i} cannot simply climb {the subj dobj} from {here},
        {i} can JUMP UP {them dobj}, at the cost of making noise. ')
    cannotParkourToMsg = BMsg(cannot parkour to,
        '{The subj dobj} {is} too far away.
        {I} might need to get on something closer... ')
    tooHighClimbDownMsg = BMsg(too high to climb down,
        'The floor is too far below;
        {i} might need to get on something lower first.
        {I} could JUMP OFF, but {i} might make a lot of noise... ')
    tooRiskyClimbDownMsg = BMsg(too risky to climb down,
        'The floor is too far below;
        {i} might need to get on something lower first.
        {I} could JUMP OFF, but {i} might risk injury and make a lot of noise... ')
    tooHighClimbDownToMsg = BMsg(too high to climb down to,
        '{The subj dobj} {is} too far below;
        {i} might need to get on something lower first.
        {I} could JUMP DOWN TO {them dobj},
        but {i} might make a lot of noise... ')
    tooRiskyClimbDownToMsg = BMsg(too risky to climb down to,
        '{The subj dobj} {is} too far below;
        {i} might need to get on something lower first.
        {I} could JUMP DOWN TO {them dobj},
        but {i} might risk injury and make a lot of noise... ')
    wayTooHighClimbDownMsg = BMsg(way too high to climb down,
        'The floor is way too far below;
        {i} might need to get on something lower first.
        {I} certainly cannot JUMP OFF, without risking death. ')
    wayTooHighClimbDownToMsg = BMsg(way too high to climb down to,
        '{The subj dobj} {is} way too far below;
        {i} might need to get on something lower first.
        {I} certainly cannot JUMP OFF, without risking death. ')
    platformLowEnoughMsg = BMsg(platform low enough,
        '({The subj dobj} {is} low enough for a quieter approach.)\n')
    cannotJumpUp = BMsg(cannot parkour jump up,
        '{The subj dobj} {is} not something {i} {can} jump up. ')
    cannotStepToMsg = BMsg(cannot step to,
        'While {i} cannot simply step over to {the subj dobj},
        {i} can LEAP TO {them dobj}, at the cost of making noise. ')
    stuckOnPlatformMsg = BMsg(stuck on platform,
        '{I} cannot move from {here}. ')
    cannotReachPlatformTopMsg = BMsg(cannot reach top,
        '{I} cannot reach top of {the subj iobj}. ')
}

modify Floor {
    decorationActions = [
        Examine, 
        ParkourClimbDownTo, Climb, ParkourTo, Board,
        ParkourJumpDownTo, ParkourJumpTo,
        ParkourJumpUp, ClimbUp
    ]

    dobjFor(ParkourClimbDownTo) asDobjFor(Board)
    dobjFor(Climb) asDobjFor(Board)
    dobjFor(ParkourTo) asDobjFor(Board)
    dobjFor(Board) {
        preCond = nil

        verify() { doOnFloorCheck(); }
        check() { }
        action() {
            unpackOtherContainers();
            doInstead(GetOff, gActor.location);
        }
        report() { }
    }

    dobjFor(ParkourJumpDownTo) asDobjFor(ParkourJumpTo)
    dobjFor(ParkourJumpTo) {
        preCond = nil

        verify() { doOnFloorCheck(); }
        check() { }
        action() {
            unpackOtherContainers();
            doInstead(JumpOff, gActor.location);
        }
        report() { }
    }

    dobjFor(ParkourJumpUp) asDobjFor(ClimbUp)
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

defaultLabFloor: Floor { 'the floor'
    //
}

modify Room {
    floorObj = defaultLabFloor

    getParkourPlatform() {
        return nil;
    }

    isSomehowOnParkourPlatform() {
        return nil;
    }
}

modify Platform {
    dobjFor(ParkourClimbDownTo) asDobjFor(Board)
    dobjFor(ParkourTo) asDobjFor(Board)
    dobjFor(ParkourJumpTo) {
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
            doInstead(Board, self);
        }
    }
    dobjFor(ParkourJumpDownTo) asDobjFor(ParkourJumpTo)
    dobjFor(Climb) asDobjFor(Board)
    dobjFor(ClimbUp) asDobjFor(Board)
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
// leapRange = can leap across link
enum climbUpRange, climbDownRange, stepRange, jumpUpRange,
    jumpDownRange, leapRange, fallDownRange;

class ParkourLink: object {
    construct(_dst, _range) {
        dst = _dst;
        range = _range;
    }

    dst = nil
    range = nil
}

#define gActorIsOnGenericPlatform (!gActor.location.ofKind(ParkourPlatform) && gActor.location.isBoardable)

//TODO: SoundProfile for someone jumping off of a platform, and another for a hard landing. Emit both appropriately.

class ParkourPlatform: Platform {
    totalParkourLinks = perInstance(new Vector()) // This is modified at runtime
    climbUpLinks = [] // This is modified by the author
    climbDownLinks = [] // This is modified by the author
    stepLinks = [] // This is modified by the author
    jumpUpLinks = [] // This is modified by the author
    jumpDownLinks = [] // This is modified by the author
    fallDownLinks = [] // This is modified by the author
    leapLinks = [] // This is modified by the author
    //wasClimbed = nil
    height = low

    iobjFor(PutOn) {
        verify() {
            local actorPlat = gActor.getParkourPlatform();
            // The actor is not on this platform
            if (actorPlat != self) {
                // The actor is just in the room
                if (actorPlat == nil && height != low) {
                    illogicalNow(cannotReachPlatformTopMsg);
                }

                // The actor is on another platform
                if (actorPlat != nil) {
                    local range = actorPlat.getParkourRangeTo(self);
                    switch (range) {
                        case jumpUpRange:
                        case jumpDownRange:
                        case leapRange:
                        case fallDownRange:
                            illogicalNow(cannotReachPlatformTopMsg);
                            break;
                    }
                }
            }
        }
    }

    dobjFor(Board) {
        preCond = [touchObj]

        remap = remapOn

        verify() {
            verifyMinimal();
            gActor.parkourAvailableRangeCache = getRangeFromSource();
            verifyGeneral();
            verifyClimb(
                [climbUpRange, climbDownRange, stepRange],
                [jumpUpRange, jumpDownRange, leapRange, fallDownRange]);
        }
        check() { checkInsert(gActor); }
        action() {
            handleGenericSource();
            doClimbAction();
        }
        report() {
            switch (gActor.parkourAvailableRangeCache) {
                case climbUpRange:
                    doRepClimbUp('{the subj dobj}');
                    break;
                case climbDownRange:
                    doRepClimbDown('{the subj dobj}');
                    break;
                case stepRange:
                    doRepStep('{the subj dobj}');
                    break;
            }
        }
    }

    dobjFor(ClimbUp) {
        preCond = [touchObj]

        remap = remapOn

        verify() {
            verifyMinimal();
            gActor.parkourAvailableRangeCache = getRangeFromSource();
            verifyGeneral();
            verifyClimb([climbUpRange], [jumpUpRange]);
        }
        check() { checkInsert(gActor); }
        action() {
            handleGenericSource();
            doClimbAction();
        }
        report() {
            doRepClimbUp('{the subj dobj}');
        }
    }

    dobjFor(ParkourTo) {
        preCond = [touchObj]

        remap = remapOn

        verify() {
            verifyMinimal();
            gActor.parkourAvailableRangeCache = getRangeFromSource();
            verifyGeneral();
            verifyClimb([stepRange], [leapRange]);
        }
        check() { checkInsert(gActor); }
        action() {
            handleGenericSource();
            doClimbAction();
        }
        report() {
            doRepStep('{the subj dobj}');
        }
    }

    dobjFor(ParkourClimbDownTo) {
        preCond = [touchObj]

        remap = remapOn

        verify() {
            verifyMinimal();
            gActor.parkourAvailableRangeCache = getRangeFromSource();
            verifyGeneral();
            verifyClimb([climbDownRange], [jumpDownRange, fallDownRange]);
        }
        check() { checkInsert(gActor); }
        action() {
            handleGenericSource();
            doClimbAction();
        }
        report() {
            doRepClimbDown('{the subj dobj}');
        }
    }

    dobjFor(ParkourJumpUp) {
        preCond = [touchObj]

        remap = remapOn

        verify() {
            verifyMinimal();
            gActor.parkourAvailableRangeCache = getRangeFromSource();
            verifyGeneral();
            verifyJump([climbUpRange], [jumpUpRange]);
        }
        check() { checkInsert(gActor); }
        action() {
            handleGenericSource();
            doClimbAttempt('{The subj dobj} {is}');
        }
        report() {
            doRepJumpUp('{the subj dobj}');
        }
    }

    dobjFor(ParkourJumpTo) {
        preCond = [touchObj]

        remap = remapOn

        verify() {
            verifyMinimal();
            gActor.parkourAvailableRangeCache = getRangeFromSource();
            verifyGeneral();
            verifyJump(
                [climbUpRange, climbDownRange, stepRange],
                [jumpUpRange, jumpDownRange, leapRange, fallDownRange]);
        }
        check() { checkInsert(gActor); }
        action() {
            handleGenericSource();
            doClimbAttempt('{The subj dobj} {is}');
        }
        report() {
            switch (parkourAvailableRangeCache) {
                case jumpUpRange:
                    doRepJumpUp('{the subj dobj}');
                    break;
                case jumpDownRange:
                    doRepJumpDown('{the subj dobj}');
                    break;
                case leapRange:
                    doRepLeap('{the subj dobj}');
                    break;
                case fallDownRange:
                    doRepFall('{the subj dobj}');
                    break;
            }
        }
    }

    dobjFor(ParkourJumpDownTo) {
        preCond = [touchObj]

        remap = remapOn

        verify() {
            verifyMinimal();
            gActor.parkourAvailableRangeCache = getRangeFromSource();
            verifyGeneral();
            verifyJump([climbDownRange], [jumpDownRange, fallDownRange]);
        }
        check() { checkInsert(gActor); }
        action() {
            handleGenericSource();
            doClimbAttempt('{The subj dobj} {is}');
        }
        report() {
            if (gActor.parkourAvailableRangeCache == fallDownRange) {
                doRepFall('{the subj dobj}');
            }
            else {
                doRepJumpDown('{the subj dobj}');
            }
        }
    }

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
        report() {
            doRepClimbDown(gActor.getOutermostRoom().floorObj.theName);
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
                //if (height == damaging) {
                    //
                //}
            }
            else {
                inherited();
            }
        }
        report() {
            if (height == damaging) {
                doRepFall(gActor.getOutermostRoom().floorObj.theName);
            }
            else {
                doRepJumpDown(gActor.getOutermostRoom().floorObj.theName);
            }
        }
    }

    canReachThroughParkour(obj) {
        if (obj.ofKind(ParkourPlatform)) {
            return hasConnectionTo(obj);
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

    getRangeFromSource() {
        // If we are on a generic, then we will start climbing from the floor
        // If we are already on the floor, then get range from height
        if (gActorIsOnGenericPlatform || gActor.location == gActor.getOutermostRoom()) {
            switch (height) {
                case low:
                    return climbUpRange;
                case awkward:
                    return jumpUpRange;
                default:
                    return nil;
            }
        }
        else {
            for (local i = 1; i <= gActor.location.totalParkourLinks.length; i++) {
                local link = gActor.location.totalParkourLinks[i];
                if (link.dst == self) {
                    return link.range;
                }
            }
        }
        return nil;
    }

    verifyMinimal() {
        if(gActor.isIn(self)) {
            illogicalNow(actorAlreadyOnMsg);
        }
        if(isIn(gActor)) {
            illogicalNow(cannotGetOnCarriedMsg);
        }
    }

    verifyMinimalJump() {
        if(!gActor.isIn(self)) {
            illogicalNow(actorNotOnMsg);
        }
    }

    verifyGeneral() {
        if (gActor.parkourAvailableRangeCache == nil) {
            illogical(cannotParkourToMsg);
        }
    }

    verifyClimb(climbRangeList, jumpRangeList) {
        local isInClimbRange = (climbRangeList.indexOf(gActor.parkourAvailableRangeCache) != nil);
        local isInJumpRange = (jumpRangeList.indexOf(gActor.parkourAvailableRangeCache) != nil);

        if (!isInClimbRange) {
            if (isInJumpRange) {
                switch (gActor.parkourAvailableRangeCache) {
                    case jumpUpRange:
                        illogicalNow(cannotSimplyParkourOnMsg);
                        break;
                    case jumpDownRange:
                        illogicalNow(tooHighClimbDownToMsg);
                        break;
                    case leapRange:
                        illogicalNow(cannotStepToMsg);
                        break;
                    case fallDownRange:
                        illogicalNow(tooRiskyClimbDownToMsg);
                        break;
                    default:
                        illogical(cannotParkourOnMsg);
                        break;
                }
            }
        }
    }

    verifyJump(climbRangeList, jumpRangeList) {
        local isInClimbRange = (climbRangeList.indexOf(gActor.parkourAvailableRangeCache) != nil);
        local isInJumpRange = (jumpRangeList.indexOf(gActor.parkourAvailableRangeCache) != nil);

        if (!isInJumpRange && !isInClimbRange) {
            switch (jumpRangeList[1]) {
                case jumpUpRange:
                    illogicalNow(cannotJumpUp);
                    break;
                case jumpDownRange:
                case fallDownRange:
                    illogicalNow(wayTooHighClimbDownToMsg);
                    break;
                default:
                    illogical(cannotParkourToMsg);
                    break;
            }
        }
    }

    handleGenericSource() {
        if (gActorIsOnGenericPlatform) {
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

    doClimbAction() {
        gActor.actionMoveInto(self);

        reportAfter(getConnectionString());
    }

    doClimbAttempt(subjectPhrase) {
        switch (gActor.parkourAvailableRangeCache) {
            case climbUpRange:
                extraReport('(' + subjectPhrase + ' low enough for a quieter approach.)\n');
                doInstead(ClimbUp, self);
                break;
            case climbDownRange:
                extraReport('(' + subjectPhrase + ' close enough for a quieter approach.)\n');
                doInstead(ParkourClimbDownTo, self);
                break;
            case stepRange:
                extraReport('(' + subjectPhrase + ' high enough for a quieter approach.)\n');
                doInstead(ParkourTo, self);
                break;
            default:
                doClimbAction();
                break;
        }
    }

    doRepClimbUp(target) {
        "{I} climb{s/ed} onto <<target>>. ";
    }

    doRepClimbDown(target) {
        "{I} climb{s/ed} down to <<target>>. ";
    }

    doRepStep(target) {
        "{I} step{s/?ed} over to <<target>>. ";
    }

    doRepJumpUp(target) {
        "It's noisy, but {i} jump{s/ed} up, and clamber{s/ed} onto <<target>>. ";
    }

    doRepJumpDown(target) {
        local letVers = 'let';
        if (gActor != gPlayerChar) letVers += 's';
        "It's noisy, but {i} {hold} onto the edge, drop{s/?ed} to a hanging position,
        <<letVers>> go, and land hard on <<target>> below. ";
    }

    doRepLeap(target) {
        "It's noisy, but {i} jump{s/ed} over to <<target>>,
        and tr{ies/ied} to keep {my} balance. ";
    }

    doRepFall(target) {
        local letVers = 'let';
        if (gActor != gPlayerChar) letVers += 's';
        "{I} {hold} onto the edge, drop{s/?ed} to a hanging position,
        and <<letVers>> go. The loud impact fires a sharp, lancing pain through {my} bones.
        {I} {am} stunned, but then recover{s/ed} after a moment to find {myself}
        on <<target>>. ";
    }

    preinitThing() {
        inherited();

        // Init climb-up/down and step links
        for (local i = 1; i <= climbUpLinks.length; i++) {
            totalParkourLinks.appendUnique(new ParkourLink(
                climbUpLinks[i], climbUpRange));
            climbUpLinks[i].totalParkourLinks.appendUnique(new ParkourLink(
                self, climbDownRange));
        }
        for (local i = 1; i <= climbDownLinks.length; i++) {
            totalParkourLinks.appendUnique(new ParkourLink(
                climbDownLinks[i], climbDownRange));
            climbDownLinks[i].totalParkourLinks.appendUnique(new ParkourLink(
                self, climbUpRange));
        }
        for (local i = 1; i <= stepLinks.length; i++) {
            totalParkourLinks.appendUnique(new ParkourLink(
                stepLinks[i], stepRange));
            stepLinks[i].totalParkourLinks.appendUnique(new ParkourLink(
                self, stepRange));
        }

        // Init jump-up links
        for (local i = 1; i <= jumpUpLinks.length; i++) {
            totalParkourLinks.appendUnique(new ParkourLink(
                jumpUpLinks[i], jumpUpRange));
            jumpUpLinks[i].totalParkourLinks.appendUnique(new ParkourLink(
                self, climbDownRange));
        }

        // Init jump-down links
        for (local i = 1; i <= jumpDownLinks.length; i++) {
            totalParkourLinks.appendUnique(new ParkourLink(
                jumpDownLinks[i], jumpDownRange));
        }

        // Init fall-down links
        for (local i = 1; i <= fallDownLinks.length; i++) {
            totalParkourLinks.appendUnique(new ParkourLink(
                fallDownLinks[i], fallDownRange));
        }

        // Init leap links
        for (local i = 1; i <= leapLinks.length; i++) {
            totalParkourLinks.appendUnique(new ParkourLink(
                leapLinks[i], leapRange));
            leapLinks[i].totalParkourLinks.appendUnique(new ParkourLink(
                self, leapRange));
        }
    }

    getConnectionString() {
        local floorAccessCount = (height == lethal) ? 0 : 1;

        if (totalParkourLinks.length + floorAccessCount == 0) {
            return stuckOnPlatformMsg;
        }

        local strBfr = new StringBuffer(40);
        local climbUpLinkList = getClimbUpLinkList();
        local climbDownLinkList = getClimbDownLinkList();
        local stepLinkList = getStepLinkList();
        local jumpUpLinkList = getJumpUpLinkList();
        local jumpDownLinkList = getJumpDownLinkList();
        local leapLinkList = getLeapLinkList();
        local fallLinkList = getFallLinkList();

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
            strBfr.append('\n<tt>(CL)</tt> <b>Climbing routes:</b>');
            getConnectionListString(climbUpLinkList, strBfr, 'climb on');
            getConnectionListString(climbDownLinkList, strBfr, 'climb down to');
            getConnectionListString(stepLinkList, strBfr, 'step over to');
        }
        if (jumpCount > 0) {
            strBfr.append('\n<tt>(JM)</tt> <b>Jumping routes:</b>');
            getConnectionListString(jumpUpLinkList, strBfr, 'jump up');
            getConnectionListString(jumpDownLinkList, strBfr, 'jump down to');
            getConnectionListString(leapLinkList, strBfr, 'leap to');
            getConnectionListString(fallLinkList, strBfr, 'jump <i>(recklessly)</i> down to');
        }

        if (climbCount == 0 && jumpCount == 0) return stuckOnPlatformMsg;

        return toString(strBfr);
    }

    getConnectionListString(lst, bfr, actionStr) {
        if (lst.length == 0) return;
        bfr.append('\n{I} can ');
        bfr.append(actionStr);
        bfr.append(' ');
        //say('lst length: ' + lst.length);
        bfr.append(makeListStr(lst, &theName, 'or'));
        bfr.append('. ');
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

    getClimbUpLinkList() {
        local lst = [];
        for (local i = 1; i <= totalParkourLinks.length; i++) {
            local link = totalParkourLinks[i];
            if (link.range == climbUpRange) {
                lst += link.dst;
            }
        }
        return lst;
    }

    getClimbDownLinkList() {
        local lst = [];
        if (height == low || height == awkward) lst += getOutermostRoom().floorObj;
        for (local i = 1; i <= totalParkourLinks.length; i++) {
            local link = totalParkourLinks[i];
            if (link.range == climbDownRange) {
                lst += link.dst;
            }
        }
        return lst;
    }

    getStepLinkList() {
        local lst = [];
        for (local i = 1; i <= totalParkourLinks.length; i++) {
            local link = totalParkourLinks[i];
            if (link.range == stepRange) {
                lst += link.dst;
            }
        }
        return lst;
    }

    getJumpUpLinkList() {
        local lst = [];
        for (local i = 1; i <= totalParkourLinks.length; i++) {
            local link = totalParkourLinks[i];
            if (link.range == jumpUpRange) {
                lst += link.dst;
            }
        }
        return lst;
    }

    getJumpDownLinkList() {
        local lst = [];
        if (height == high) lst += getOutermostRoom().floorObj;
        for (local i = 1; i <= totalParkourLinks.length; i++) {
            local link = totalParkourLinks[i];
            if (link.range == jumpDownRange) {
                lst += link.dst;
            }
        }
        return lst;
    }

    getLeapLinkList() {
        local lst = [];
        for (local i = 1; i <= totalParkourLinks.length; i++) {
            local link = totalParkourLinks[i];
            if (link.range == leapRange) {
                lst += link.dst;
            }
        }
        return lst;
    }

    getFallLinkList() {
        local lst = [];
        if (height == damaging) lst += getOutermostRoom().floorObj;
        for (local i = 1; i <= totalParkourLinks.length; i++) {
            local link = totalParkourLinks[i];
            if (link.range == fallDownRange) {
                lst += link.dst;
            }
        }
        return lst;
    }
}
