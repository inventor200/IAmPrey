#ifdef __DEBUG
#define __SIMPLIFICATION_DEBUG nil
#define __INVENTOR_REACH_DEBUG nil
#else
#define __SIMPLIFICATION_DEBUG nil
#define __INVENTOR_REACH_DEBUG nil
#endif

#define __USE_INVENTOR_REACH_MOD true

modify Thing {
    // Can return another thing to act as a proxy for reach checks
    remapReach(action) {
        return nil;
    }
}

class InventorSpecial: Special {
    priority = 16

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

    getExtraSimpleStatusFor(obj) {
        return nil;
    }

    getExtraSimpleLocationStatusFor(obj) {
        return nil;
    }

    getExtraSimpleSubComponentStatusFor(obj) {
        return nil;
    }

    simplifyComplexObject(a) {
        if (a.ofKind(Actor)) return a;
        if (getExtraSimpleStatusFor(a)) return a;
        local obj = a;
        local keepLooping = true;
        while (keepLooping) {
            keepLooping = nil;
            if (getExtraSimpleStatusFor(obj)) return obj;
            if (obj.location == nil) return obj;
            if (obj.location.ofKind(Actor)) return obj;
            if (getExtraSimpleLocationStatusFor(obj)) return obj;

            if (obj.ofKind(SubComponent)) {
                if (obj.lexicalParent == nil) return obj;
                if (getExtraSimpleSubComponentStatusFor(obj)) return obj;
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
            #if __SIMPLIFICATION_DEBUG
            extraReport('\n(Simplified <<oldObj.theName>> to <<newObj.theName>>)\n');
            #endif
        }
        return newObj;
    }
}

QInventorGenericChecks: InventorSpecial {
    active() {
        return __USE_INVENTOR_REACH_MOD;
    }

    reachProblemVerify(a, b) {
        #if __INVENTOR_REACH_DEBUG
        extraReport('\nUSING INVENTOR\'S REACH MECHANICS\n');
        #endif

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
            #if __INVENTOR_REACH_DEBUG
            extraReport('\n(Item in an inventory; passing...)\n');
            #endif
            return issues;
        }
        if (isObjectHeldByOrComponentOfHeldBy(b, a)) {
            #if __INVENTOR_REACH_DEBUG
            extraReport('\n(Item in an inventory; passing...)\n');
            #endif
            return issues;
        }

        // Worry about everything else, though
        local aReach = debuggableSimplifyComplexObject(a);
        local bReach = debuggableSimplifyComplexObject(b);

        #if __INVENTOR_REACH_DEBUG
        extraReport('\n(Start special reach check for:
            <<gCommand.verbProd.verbPhrase>>)\n');
        #endif

        local remapA = a.remapReach(gAction);
        local remapB = b.remapReach(gAction);

        if (remapA != nil) {
            aReach = remapA;
        }

        #if __INVENTOR_REACH_DEBUG
        local aLocStr = '';
        if (aReach.location != nil) locStr = aReach.location.theName + ', ';
        extraReport('\n(ITEM A: <<aReach.theName>> (<<aReach.contType.prep>>)
            <<aLocStr>><<aReach.getOutermostRoom().theName>>.)\n');
        #endif

        if (remapB != nil) {
            bReach = remapB;
        }
        #if __INVENTOR_REACH_DEBUG
        local bLocStr = '';
        if (bReach.location != nil) locStr = bReach.location.theName + ', ';
        extraReport('\n(ITEM B: <<bReach.theName>> (<<bReach.contType.prep>>)
            <<bLocStr>><<bReach.getOutermostRoom().theName>>.)\n');
        #endif

        return QDefaults.reachProblemVerify(aReach, bReach);
    }
}