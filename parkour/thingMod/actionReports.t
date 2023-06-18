#define fastParkourClimbMsg(upPrep, overPrep, downPrep, capsActionStr, conjActionString) \
    getClimbUpDiscoverMsg() { \
        return '({I} learned a new route: ' + \
            formatCommand(capsActionStr + ' ' + upPrep + ' ' + theName, longCmd) + \
            '!) '; \
    } \
    getClimbOverDiscoverMsg() { \
        return '({I} learned a new route: ' + \
            formatCommand(capsActionStr + ' ' + overPrep + ' ' + theName, longCmd) + \
            '!) '; \
    } \
    getClimbDownDiscoverMsg() { \
        return '({I} learned a new route: ' + \
            formatCommand(capsActionStr + ' ' + downPrep + ' ' + theName, longCmd) + \
            '!) '; \
    } \
    getClimbUpMsg() { \
        return '{I} ' + conjActionString + ' ' + upPrep + ' <<theName>>. '; \
    } \
    getClimbOverMsg() { \
        return '{I} ' + conjActionString + ' ' + overPrep + ' <<theName>>. '; \
    } \
    getClimbDownMsg() { \
        return '{I} ' + conjActionString + ' ' + downPrep + ' <<theName>>. '; \
    }

#define fastParkourJumpMsg(upPrep, overPrep, downPrep, capsActionStr, conjActionString) \
    getJumpUpDiscoverMsg() { \
        return '({I} learned a new route: ' + \
            formatCommand(capsActionStr + ' ' + upPrep + ' ' + theName, longCmd) + \
            '!) '; \
    } \
    getJumpOverDiscoverMsg() { \
        return '({I} learned a new route: ' + \
            formatCommand(capsActionStr + ' ' + overPrep + ' ' + theName, longCmd) + \
            '!) '; \
    } \
    getJumpDownDiscoverMsg() { \
        return '({I} learned a new route: ' + \
            formatCommand(capsActionStr + ' ' + downPrep + ' ' + theName, longCmd) + \
            '!) '; \
    }

#define fastParkourMessages(upPrep, overPrep, downPrep) \
    fastParkourClimbMsg(upPrep, overPrep, downPrep, 'CLIMB', 'climb{s/ed}') \
    fastParkourJumpMsg(upPrep, overPrep, downPrep, 'JUMP', 'jump{s/ed}') \
    getJumpUpMsg() { \
        return '{I} jump{s/ed} and climb{s/ed} ' + upPrep + ' <<theName>>. '; \
    } \
    getJumpOverMsg() { \
        return '{I} leap{s/ed} ' + overPrep + ' <<theName>>. '; \
    } \
    getJumpDownMsg() { \
        return '{I} carefully drop{s/?ed} ' + downPrep + ' <<theName>>. '; \
    } \
    getFallDownMsg() { \
        return '{I} {fall} ' + downPrep + ' <<theName>>, with a hard landing. '; \
    }

modify Thing {
    cannotSlideUnderMsg =
        '{The subj dobj} {is} not something {i} {can} slide under. '
    cannotRunAcrossMsg =
        '{The subj dobj} {is} not something {i} {can} run across. '
    cannotSwingOnMsg =
        '{The subj dobj} {is} not something {i} {can} swing on. '
    cannotSqueezeThroughMsg =
        '{The subj dobj} {is} not something {i} {can} squeeze through. '
    uselessSlideUnderMsg =
        'Sliding under {the dobj}{dummy} {do} very little from {here}. '
    uselessRunAcrossMsg =
        'Running across {the dobj}{dummy} {do} very little from {here}. '
    uselessJumpOverMsg =
        'Jumping over {the dobj}{dummy} {do} very little from {here}. '
    uselessSwingOnMsg =
        'Swinging on {the dobj}{dummy} {do} very little from {here}. '
    uselessSqueezeThroughMsg =
        'Squeezing through {the dobj}{dummy} {do} very little from {here}. '
    noParkourPathFromHereMsg =
        '{I} {know} no path to get there. '
    parkourNeedsJumpMsg =
        '{I} need{s/ed} to JUMP instead, if {i} want{s/ed} to get there. '
    parkourNeedsFallMsg =
        '{I} need{s/ed} to JUMP instead, if {i} want{s/ed} to get there.
        However, the drop seems rather dangerous...! '
    parkourUnnecessaryJumpMsg =
        '({i} {can} get there easily, so {i} decide{s/d} against jumping...) '
    parkourCannotClimbUpMsg =
        '{I} {cannot} climb up to {that dobj}. '
    parkourCannotClimbOverMsg =
        '{I} {cannot} climb over to {that dobj}. '
    parkourCannotClimbDownMsg =
        '{I} {cannot} climb down to {that dobj}. '
    parkourCannotJumpUpMsg =
        '{I} {cannot} jump up to {that dobj}. '
    parkourCannotJumpOverMsg =
        '{I} {cannot} jump over to {that dobj}. '
    parkourCannotJumpDownMsg =
        '{I} {cannot} jump down to {that dobj}. '
    cannotDoParkourInMsg =
        ('{I} {cannot} do parkour in <<theName>>. ')
    cannotDoParkourMsg =
        '{I} {cannot} do parkour right now. '
    alreadyOnParkourModuleMsg =
        '{I} {am} already on {that dobj}. '
    noNewRoutesMsg =
        '{I} notice{s/d} no new parkour possibilities, beyond what{dummy} {is} already known. '
    alreadyOnFloorMsg =
        '{I} remain{s/ed} on <<gActor.getOutermostRoom().floorObj.theName>>. '

    getProviderGoalDiscoverClause(destination) {
        return 'which will let{dummy} {me} reach <<getBetterDestinationName(destination)>>';
    }

    getProviderGoalClause(destination) {
        return 'which{dummy} land{s/d} {me} <<getBetterDestinationName(destination, true, true)>>';
    }

    getJumpOverToDiscoverMsg(destination) {
        return '({I} learned a new route:
            <<formatCommand('jump over ' + theName, longCmd)>>,
            <<getProviderGoalDiscoverClause(destination)>>!) ';
    }

    getJumpOverToMsg(destination) {
        return '{I} jump{s/ed} over <<theName>>,
            <<getProviderGoalClause(destination)>>. ';
    }

    getRunAcrossToDiscoverMsg(destination) {
        return '({I} learned a new route:
            <<formatCommand('run across ' + theName, longCmd)>>,
            <<getProviderGoalDiscoverClause(destination)>>!) ';
    }

    getRunAcrossToMsg(destination) {
        return '{I} {run} across <<theName>>,
            <<getProviderGoalClause(destination)>>. ';
    }

    getSwingOnToDiscoverMsg(destination) {
        return '({I} learned a new route:
            <<formatCommand('swing on ' + theName, longCmd)>>,
            <<getProviderGoalDiscoverClause(destination)>>!) ';
    }

    getSwingOnToMsg(destination) {
        return '{I} {swing} on <<theName>>,
            <<getProviderGoalClause(destination)>>. ';
    }

    getSqueezeThroughToDiscoverMsg(destination) {
        return '({I} learned a new route:
            <<formatCommand('squeeze through ' + theName, longCmd)>>,
            <<getProviderGoalDiscoverClause(destination)>>!) ';
    }

    getSqueezeThroughToMsg(destination) {
        return '{I} squeeze{s/d} on <<theName>>,
            <<getProviderGoalClause(destination)>>. ';
    }

    getSlideUnderToDiscoverMsg(destination) {
        return '({I} learned a new route:
            <<formatCommand('slide under ' + theName, longCmd)>>,
            <<getProviderGoalDiscoverClause(destination)>>!) ';
    }

    getSlideUnderToMsg(destination) {
        return '{I} {slide} under <<theName>>,
            <<getProviderGoalClause(destination)>>. ';
    }

    fastParkourMessages('atop', 'over to', 'down to')
}