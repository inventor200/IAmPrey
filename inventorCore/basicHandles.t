handleAccessRestrictions: object {
    lickedHandle = nil

    handleAccessibilityFor(actor) {
        //
    }
}

#define basicHandleTabProperties \
    distOrder = 2 \
    isDecoration = true \
    addParentVocab(_lexParent) { \
        if (_lexParent != nil) { \
            local lexParentWords = _lexParent.name.split(' '); \
            local startIndex = 1; \
            if (lexParentWords[1] == 'the' || lexParentWords[1] == 'a') { \
                startIndex = 2; \
            } \
            local weakLexParentWords = lexParentWords[startIndex] + '[weak]'; \
            for (local i = startIndex + 1; i <= lexParentWords.length; i++) { \
                weakLexParentWords += ' ' + lexParentWords[i] + '[weak]'; \
            } \
            addVocab(';' + weakLexParentWords + ';'); \
        } \
    }

#define basicHandleProperties \
    basicHandleTabProperties \
    decorationActions = [Examine, Push, Pull, Taste, Lick] \
    matchPhrases = ['handle', 'bar', 'latch'] \
    dobjFor(Taste) { \
        verify() { } \
        check() { } \
        action() { } \
        report() { \
            if (handleAccessRestrictions.lickedHandle) { \
                "Tastes like it's been well-used. "; \
            } \
            else { \
                handleAccessRestrictions.lickedHandle = true; \
                "As {my} tongue leaves its surface, subtle flashbacks of someone \
                else's memories pass through {my} mind, like muffled echoes.\b \
                {I} think {i} remember a name, reaching out from the whispers:\b \
                <center><i><q>Rovarsson...</q></i></center>\b \
                {I}{'m} not really sure what to make of that. Probably should not \
                lick random handles anymore, though. "; \
            } \
        } \
    }

#define hatchHandlerProperties \
    hatch = nil \
    preCreate(_lexParent) { \
        hatch = getLikelyHatch(_lexParent); \
        if (hatch != nil) { \
            owner = hatch; \
            ownerNamed = true; \
        } \
    } \
    postCreate(_lexParent) { \
        addParentVocab(hatch); \
    } \
    remapReach(action) { \
        return hatch; \
    }

#define handleActions(targetAction, actionTarget) \
    dobjFor(Push) { \
        verify() { \
            if (!isPushable) illogical(cannotPushMsg); \
        } \
        check() { } \
        action() { \
            doInstead(targetAction, actionTarget); \
        } \
        report() { } \
    } \
    dobjFor(Pull) { \
        verify() { \
            if (!isPullable) illogical(cannotPullMsg); \
            handleAccessRestrictions.handleAccessibilityFor(gActor); \
        } \
        check() { } \
        action() { \
            doInstead(targetAction, actionTarget); \
        } \
        report() { } \
    }

#define tinyDoorHandleProperties \
    vocab = 'handle;metal[weak] pull[weak];latch' \
    desc = "A tiny pull latch, which can open \
        <<hatch == nil ? 'containers' : hatch.theName>>. " \
    basicHandleProperties \
    cannotPushMsg = '{That dobj} {is} not a push latch. ' \
    cannotPullMsg = '{That dobj} {is} not a pull latch. ' \
    isPullable = true \
    getMiscInclusionCheck(obj, normalInclusionCheck) { \
        return normalInclusionCheck && !obj.ofKind(Door) && (getLikelyHatch(obj) != nil); \
    } \
    hatchHandlerProperties \
    handleActions(Open, hatch)

DefineDistComponent(TinyDoorHandle)
    tinyDoorHandleProperties
    getLikelyHatch(obj) {
        if (obj.remapIn != nil) {
            if (obj.remapIn.contType == In && obj.remapIn.isOpenable) {
                return obj.remapIn;
            }
        }
        if (obj.remapOn != nil) {
            if (obj.remapOn.contType == In && obj.remapOn.isOpenable) {
                return obj.remapOn;
            }
        }
        return nil;
    }
;