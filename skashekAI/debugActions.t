#ifdef __ALLOW_DEBUG_ACTIONS
VerbRule(ReportSkashekRouteToPlayer)
    ('check'|'report'|'print'|'get'|'show'|'what' 'is'|'what\'s')
    ('skashek'|'skashek\'s'|) (
        ('route'|'path') ('to'|'toward'|'towards') ('me'|'player') |
        ('hunt'|'hunting') ('route'|'path')
    )
    : VerbProduction
    action = ReportSkashekRouteToPlayer
    verbPhrase = 'report/reporting Skashek\'s route to the player'
;

DefineSystemAction(ReportSkashekRouteToPlayer)
    execAction(cmd) {
        skashek.reportPathToPlayer();
    }
;

VerbRule(FreezeSkashekAI)
    ('freeze'|'pause') ('skashek'|'ai'|)
    : VerbProduction
    action = FreezeSkashekAI
    verbPhrase = 'freeze/freezing Skashek\'s AI'
;

DefineSystemAction(FreezeSkashekAI)
    execAction(cmd) {
        skashekAIControls.isFrozen = !skashekAIControls.isFrozen;
        if (skashekAIControls.isFrozen) {
            "Skashek's AI is now frozen. ";
        }
        else {
            "Skashek's AI is now unfrozen. ";
        }
    }
;

VerbRule(CheckVisibilityToSkashekAI)
    'can' 'you' 'see' 'me'
    : VerbProduction
    action = CheckVisibilityToSkashekAI
    verbPhrase = 'check/checking if Skashek can see you'
;

DefineSystemAction(CheckVisibilityToSkashekAI)
    execAction(cmd) {
        if (skashek.canSee(skashek.getPracticalPlayer())) {
            "Skashek can see you. ";
        }
        else {
            "Skashek cannot see you. ";
        }
    }
;

VerbRule(ToggleSkashekAINoTarget)
    'notarget'
    : VerbProduction
    action = ToggleSkashekAINoTarget
    verbPhrase = 'toggle/toggling Skashek\'s notarget mode'
;

DefineSystemAction(ToggleSkashekAINoTarget)
    execAction(cmd) {
        skashekAIControls.isNoTargetMode = !skashekAIControls.isNoTargetMode;
        if (skashekAIControls.isNoTargetMode) {
            "notarget ON. ";
        }
        else {
            "notarget OFF. ";
        }
    }
;
#endif

modify skashek {
    reportPathToPlayer() {
        local goalRoom = getRoomFromGoalObject(
            getPracticalPlayer()
        );
        local goalMapModeRoom = goalRoom.mapModeVersion;
        local path = getFullPathToMapModeRoom(goalMapModeRoom);

        if (path == nil) {
            "Skashek has no way to <<goalRoom.roomTitle>>. ";
            return;
        }

        "Skashek's path would be the following...";
        for (local i = 1; i <= path.length; i++) {
            if (i == 1) {
                "\n\tStarting in <<path[i].actualRoom.roomTitle>>";
            }
            else {
                "\n\t\^<<path[i].getSkashekDir()>>";
            }
        }
    }
}