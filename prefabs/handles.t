#define basicHandleProperties \
    distOrder = 2 \
    isDecoration = true \
    decorationActions = [Examine, Push, Pull, Taste, Lick] \
    matchPhrases = ['handle', 'bar', 'latch'] \
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
    } \
    dobjFor(Taste) { \
        verify() { } \
        check() { } \
        action() { } \
        report() { \
            if (gameMain.lickedHandle) { \
                "Tastes like it's been well-used. "; \
            } \
            else { \
                gameMain.lickedHandle = true; \
                "As {my} tongue leaves its surface, subtle flashbacks of someone \
                else's memories pass through {my} mind, like muffled echoes.\b \
                {I} think {i} remember a name, reaching out from the whispers:\b \
                <center><i><q>Rovarsson...</q></i></center>\b \
                {I}{'m} not really sure what to make of that. Probably should not \
                lick random handles anymore, though. "; \
            } \
        } \
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
            if (gActorIsCat) inaccessible(pawsCannotPullMsg); \
        } \
        check() { } \
        action() { \
            doInstead(targetAction, actionTarget); \
        } \
        report() { } \
    }

#define pushPullHandleProperties \
    basicHandleProperties \
    postCreate(_lexParent) { \
        addParentVocab(_lexParent); \
    } \
    cannotPushMsg = '{That dobj} {is} not a push door. ' \
    cannotPullMsg = '{That dobj} {is} not a pull door. ' \
    handleActions(Open, lexicalParent)

DefineDistComponentFor(PushDoorHandle, Door)
    vocab = 'handle;door[weak] push[weak] pull[weak];bar'
    desc = "A push bar spans the width of the door. "

    getMiscInclusionCheck(obj, normalInclusionCheck) {
        return normalInclusionCheck && !obj.skipHandle && !obj.pullHandleSide;
    }

    isPushable = true

    pushPullHandleProperties
;

DefineDistComponentFor(PullDoorHandle, Door)
    vocab = 'handle;door[weak] push[weak] pull[weak] metal[weak];bar loop'
    desc = "A large, metal loop sits in a track, which spans half the width
        of the door. "

    getMiscInclusionCheck(obj, normalInclusionCheck) {
        return normalInclusionCheck && !obj.skipHandle && obj.pullHandleSide;
    }

    isPullable = true

    pushPullHandleProperties
;

#define tinyDoorHandleProperties \
    vocab = 'handle;metal[weak] pull[weak];latch' \
    desc = "A tiny pull latch, which can open \
        <<hatch == nil ? 'containers' : hatch.theName>>. " \
    basicHandleProperties \
    cannotPushMsg = '{That dobj} {is} not a push latch. ' \
    cannotPullMsg = '{That dobj} {is} not a pull latch. ' \
    isPullable = true \
    hatch = nil \
    getMiscInclusionCheck(obj, normalInclusionCheck) { \
        return normalInclusionCheck && !obj.ofKind(Door) && (getLikelyHatch(obj) != nil); \
    } \
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
    } \
    handleActions(Open, hatch)

DefineDistComponent(TinyDoorHandle)
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

    tinyDoorHandleProperties
;