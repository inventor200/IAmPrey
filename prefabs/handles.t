modify handleAccessRestrictions {
    handleAccessibilityFor(actor) {
        if (gActorIsCat) inaccessible(pawsCannotPullMsg);
    }
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
