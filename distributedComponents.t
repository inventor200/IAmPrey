class AbstractDistributedComponent: object {
    includeMeProp = nil
    hasMeProp = nil
    includeMeOnOtherSide = nil
    myOtherSideProp = nil
    subReferenceProp = nil
    targetParentClass = nil
    distComponentOwnerNamed = true
    distFromSubComponent = nil
    distOrder = 0
    prototypeVocab = nil

    originalPrototype = nil

    constructStageOne(_lexParent) {
        prototypeVocab = (vocab == nil ? 'prototype object' : vocab);
        if (_lexParent != nil) {
            vocab = getPrototypeVocab(_lexParent); // Revert prototype alterations
        }
        else if (vocab == nil) {
            vocab = prototypeVocab;
        }
        if (_lexParent != nil) {
            preCreate(_lexParent);
            if (distComponentOwnerNamed) {
                owner = _lexParent;
                ownerNamed = true;
            }
        }
    }

    preCreate(_lexParent) {
        // Author implementation
    }

    constructStageTwo(_lexParent) {
        if (_lexParent != nil) {
            lexicalParent = _lexParent;
            if (!distFromSubComponent) {
                moveInto(_lexParent);
            }
            postCreate(_lexParent);
        }
    }

    postCreate(_lexParent) {
        // Author implementation
    }

    getPrototypeVocab(_lexParent) {
        return prototypeVocab;
    }

    includeMeOn(obj) {
        return includeMeOnBasic(obj) || includeOnOtherSide(obj);
    }

    includeMeOnBasic(obj) {
        local inclusionResult = nil;
        if (includeMeProp != nil) inclusionResult = obj.(includeMeProp);
        return getMiscInclusionCheck(obj, inclusionResult);
    }

    hasMeOn(obj) {
        if (hasMeProp == nil) return nil;
        return obj.(hasMeProp);
    }

    includeOnOtherSide(obj) {
        if (includeMeOnOtherSide == nil) return nil;
        if (myOtherSideProp == nil) return nil;
        local objOtherSide = obj.(myOtherSideProp);
        if (objOtherSide == nil) return nil;
        return includeMeOnBasic(objOtherSide);
    }

    getMiscInclusionCheck(obj, normalInclusionCheck) {
        return normalInclusionCheck;
    }

    distributeAcross() {
        if (hasMeProp == nil) {
            return;
        }
        local distributionTargets = new Vector(64);
        if (targetParentClass == nil) {
            targetParentClass = Thing;
        }
        for (local cur = firstObj(targetParentClass);
            cur != nil ; cur = nextObj(cur, targetParentClass)) {
            if (cur.ofKind(AbstractDistributedComponent)) continue;
            distributionTargets.append(cur);
        }
        for (local i = 1; i <= distributionTargets.length; i++) {
            local cur = distributionTargets[i];
            if (includeMeOn(cur) && !hasMeOn(cur)) {
                local myClone = createInstance(cur);
                // Just in case instances don't init this
                // or init themselves into this
                myClone.originalPrototype = originalPrototype;
                cur.(hasMeProp) = true;
                if (subReferenceProp != nil) {
                    cur.(subReferenceProp) = myClone;
                }
                if (!distFromSubComponent) {
                    myClone.preinitThing();
                }
            }
        }
    }
}

//#include "reflect.t"

class PrefabObject: object {
    // Filter matches
    filterResolveList(np, cmd, mode) {
        if (isOutOfContext(np, cmd, mode)) {
            np.matches = np.matches.subset({m: m.obj != self});
        }
    }

    // Do we filter ourselves out?
    isOutOfContext(np, cmd, mode) {
        local matchProp;
        switch (np.role) {
            default:
                matchProp = &dobjMatch;
                break;
            case IndirectObject:
                matchProp = &iobjMatch;
                break;
            case AccessoryObject:
                matchProp = &accMatch;
                break;
        }
        local fellowMatches = getMatchCountForFellowClass(np.matches);
        if (actionIsSpecific(cmd) || (np.role != DirectObject)) {
            if (cmd.verbProd.(matchProp).grammarTag == 'single') return nil;
            if (fellowMatches <= 1) return nil;
            if (mode == Definite) return nil;
        }
        return fellowMatches > 1;
    }

    // We primarily want to skip redundant responses,
    // and these actions are the usual suspects:
    actionIsSpecific(cmd) {
        if (cmd.action.ofKind(Examine)) return nil;
        if (cmd.action.ofKind(Feel)) return nil;
        if (cmd.action.ofKind(SmellSomething)) return nil;
        if (cmd.action.ofKind(Taste)) return nil;
        if (cmd.action.ofKind(ListenTo)) return nil;
        return true;
    }

    // How many matches of our fellow class were there?
    getMatchCountForFellowClass(matches) {
        local count = 0;
        for (local i = 1; i <= matches.length; i++) {
            if (hasPrefabMatchWith(matches[i].obj)) {
                count++;
            }
        }

        return count;
    }

    // What determines a fellow prefab?
    hasPrefabMatchWith(obj) {
        return true;
    }
}

class DistributedComponent: AbstractDistributedComponent, PrefabObject, Thing {
    construct(_lexParent) {
        constructStageOne(_lexParent);
        inherited Thing.construct();
        constructStageTwo(_lexParent);
    }

    isFixed = true

    hasPrefabMatchWith(obj) {
        if (!obj.ofKind(AbstractDistributedComponent)) return nil;
        return obj.originalPrototype == originalPrototype;
    }
}

class DistributedSubComponent: AbstractDistributedComponent, PrefabObject, SubComponent {
    construct(_lexParent) {
        constructStageOne(_lexParent);
        inherited SubComponent.construct();
        constructStageTwo(_lexParent);
    }

    distFromSubComponent = true

    hasPrefabMatchWith(obj) {
        if (!obj.ofKind(AbstractDistributedComponent)) return nil;
        return obj.originalPrototype == originalPrototype;
    }
}

class DistributedComponentDistributor: PreinitObject {
    focusSubComponents = nil

    execute() {
        local distributionPrototypes = new Vector(16);
        for (local cur = firstObj(AbstractDistributedComponent);
            cur != nil ; cur = nextObj(cur, AbstractDistributedComponent)) {
            if (cur.distFromSubComponent != focusSubComponents) continue;
            distributionPrototypes.append(cur);
        }

        distributionPrototypes.sort(nil, { a, b: a.distOrder - b.distOrder });

        for (local i = 1; i <= distributionPrototypes.length; i++) {
            distributionPrototypes[i].distributeAcross();
        }
    }
}

distributedComponentDistributor: DistributedComponentDistributor {
    execBeforeMe = [thingPreinit, multiLocInitiator]
}

distributedSubComponentDistributor: DistributedComponentDistributor {
    focusSubComponents = true

    execBeforeMe = [pronounPreinit]
}

modify thingPreinit {
    execBeforeMe = [distributedSubComponentDistributor]
}

#define DefineDistComponent(ComponentClassName) \
    modify Thing { \
        includeDistComp##ComponentClassName = nil \
        hasDistComp##ComponentClassName = nil \
    } \
    prototype##ComponentClassName: DistributedComponent \
        includeMeProp = &includeDistComp##ComponentClassName \
        hasMeProp = &hasDistComp##ComponentClassName \
        originalPrototype = prototype##ComponentClassName

#define DefineDistComponentFor(ComponentClassName, TargetClassName) \
    modify TargetClassName { \
        includeDistComp##ComponentClassName = true \
        hasDistComp##ComponentClassName = nil \
    } \
    prototype##ComponentClassName: DistributedComponent \
        includeMeProp = &includeDistComp##ComponentClassName \
        hasMeProp = &hasDistComp##ComponentClassName \
        targetParentClass = TargetClassName \
        originalPrototype = prototype##ComponentClassName

#define DefineDistSubComponent(ComponentClassName, mySubReferenceProp) \
    modify Thing { \
        includeDistComp##ComponentClassName = nil \
        hasDistComp##ComponentClassName = nil \
        mySubReferenceProp = nil \
    } \
    prototype##ComponentClassName: DistributedSubComponent \
        includeMeProp = &includeDistComp##ComponentClassName \
        hasMeProp = &hasDistComp##ComponentClassName \
        subReferenceProp = &mySubReferenceProp \
        originalPrototype = prototype##ComponentClassName

#define DefineDistSubComponentFor(ComponentClassName, TargetClassName, mySubReferenceProp) \
    modify TargetClassName { \
        includeDistComp##ComponentClassName = true \
        hasDistComp##ComponentClassName = nil \
        mySubReferenceProp = nil \
    } \
    prototype##ComponentClassName: DistributedSubComponent \
        includeMeProp = &includeDistComp##ComponentClassName \
        hasMeProp = &hasDistComp##ComponentClassName \
        targetParentClass = TargetClassName \
        subReferenceProp = &mySubReferenceProp \
        originalPrototype = prototype##ComponentClassName

#define IncludeDistComponent(ComponentClassName) \
    includeDistComp##ComponentClassName = true
