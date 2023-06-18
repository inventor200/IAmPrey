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

    isObjectHeldByOrComponentOfHeldBy(a, b) {
        if (b == nil) return nil;
        if (!b.ofKind(Actor)) return nil;
        /*while (
            (a.ofKind(SubComponent) || 
            (a.location != nil && a.location.ofKind(SubComponent))) &&
            a != nil
        ) {
            if (a.location != nil && a.location.ofKind(SubComponent)) {
                a = a.location.lexicalParent;
            }
            else {
                a = a.lexicalParent;
            }
        }
        return a.isOrIsIn(b);*/
        return simplifyComplexObject(a).isOrIsIn(b);
    }

    simplifyComplexObject(a) {
        if (a.ofKind(Actor)) return a;
        if (a.ofKind(ParkourModule)) return a;
        local obj = a;
        local keepLooping = true;
        while (keepLooping) {
            keepLooping = nil;
            if (obj.ofKind(ParkourModule)) return obj;
            if (obj.location == nil) return obj;
            if (obj.location.ofKind(Actor)) return obj;
            if (obj.location.parkourModule != nil) return obj;
            if (obj.stagingLocation.parkourModule != nil) return obj;
            //if (obj.location.ofKind(ParkourModule)) return obj;

            if (obj.ofKind(SubComponent)) {
                if (obj.lexicalParent == nil) return obj;
                if (obj.lexicalParent.parkourModule != nil) return obj;
                obj = obj.lexicalParent;
                keepLooping = true;
            }
            else if (obj.location.ofKind(SubComponent)) {
                obj = obj.location.lexicalParent;
                keepLooping = true;
            }
        }
        return obj;
    }

    debuggableSimplifyComplexObject(a) {
        local oldObj = a;
        local newObj = simplifyComplexObject(a);
        if (oldObj != newObj) {
            #if __PARKOUR_REACH_DEBUG
            extraReport('\n(Simplified <<oldObj.theName>> to <<newObj.theName>>)\n');
            #endif
        }
        return newObj;
    }

    reachProblemVerify(a, b) {
        local issues = [];

        if (a.ofKind(Floor)) {
            a = gPlayerChar.outermostVisibleParent();
        }
        if (b.ofKind(Floor)) {
            b = gPlayerChar.outermostVisibleParent();
        }

        // Don't worry about room connections
        if (a.ofKind(Room) && b.ofKind(Room)) return issues;

        // It's just inventory
        if (isObjectHeldByOrComponentOfHeldBy(a, b)) {
            #if __PARKOUR_REACH_DEBUG
            extraReport('\n(Item in an inventory; passing...)\n');
            #endif
            return issues;
        }
        if (isObjectHeldByOrComponentOfHeldBy(b, a)) {
            #if __PARKOUR_REACH_DEBUG
            extraReport('\n(Item in an inventory; passing...)\n');
            #endif
            return issues;
        }

        // Worry about everything else, though
        local aReach = debuggableSimplifyComplexObject(a);
        local aItem = nil;
        local aLoc = nil;
        local aLocReach = nil;
        local doNotFactorJumpForA = nil;

        local bReach = debuggableSimplifyComplexObject(b);
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

reachGhostTest_: Thing {
    isListed = nil
    isFixed = nil
    isLikelyContainer() {
        return nil;
    }
}