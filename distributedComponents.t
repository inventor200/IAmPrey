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

class DistributedComponent: AbstractDistributedComponent, Thing {
    construct(_lexParent) {
        constructStageOne(_lexParent);
        inherited Thing.construct();
        constructStageTwo(_lexParent);
    }

    isFixed = true
}

class DistributedSubComponent: AbstractDistributedComponent, SubComponent {
    construct(_lexParent) {
        constructStageOne(_lexParent);
        inherited SubComponent.construct();
        constructStageTwo(_lexParent);
    }

    distFromSubComponent = true
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
        hasMeProp = &hasDistComp##ComponentClassName

#define DefineDistComponentFor(ComponentClassName, TargetClassName) \
    modify TargetClassName { \
        includeDistComp##ComponentClassName = true \
        hasDistComp##ComponentClassName = nil \
    } \
    prototype##ComponentClassName: DistributedComponent \
        includeMeProp = &includeDistComp##ComponentClassName \
        hasMeProp = &hasDistComp##ComponentClassName \
        targetParentClass = TargetClassName

#define DefineDistSubComponent(ComponentClassName, mySubReferenceProp) \
    modify Thing { \
        includeDistComp##ComponentClassName = nil \
        hasDistComp##ComponentClassName = nil \
        mySubReferenceProp = nil \
    } \
    prototype##ComponentClassName: DistributedSubComponent \
        includeMeProp = &includeDistComp##ComponentClassName \
        hasMeProp = &hasDistComp##ComponentClassName \
        subReferenceProp = &mySubReferenceProp

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
        subReferenceProp = &mySubReferenceProp

#define IncludeDistComponent(ComponentClassName) \
    includeDistComp##ComponentClassName = true
