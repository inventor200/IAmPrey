modify Door {
    normalClosingMsg =
        '{The subj obj}
        <<one of>>rattles<<or>>rumbles<<or>>clatters<<at random>>
        <<one of>>mechanically<<or>>automatically<<at random>>
        <<one of>>closed<<or>>shut<<at random>>,
        <<one of>>ending<<or>>concluding<<or>><<at random>>
        with a <<one of>>noisy<<or>>loud<<at random>> <i>ka-chunk</i>. '

    slamClosingMsg =
        '{The subj dobj} <i>slams</i> shut! '
    
    randomThoughtOnset =
        '<<one of>>...<<or>><<at random>>'
    
    realizationExclamation =
        '<<randomThoughtOnset>><<
        one of>>Wait<<or>>Wait a moment<<or>>Wait a second<<or>>Wait a sec<<
        or>>Hey<<or>>Hold on<<at random>>'

    suspicionMsgAlt1 =
        '<i><<one of>>supposed<<or>>meant<<at random>></i> to hear
        that<<one of>> happen<<or>> just now<<or>> just then<<or>><<at random>>'

    suspicionMsgAlt2 =
        'the <<one of>>one who<<or>>cause of<<or>>cause for<<or>>reason for<<or
        >>one who <<one of>>opened<<or>>caused<<at random>><<at random>>'
    
    suspicionMsgQuestionGrp1 = '{was} {i}
        <<one of>><<suspicionMsgAlt1>><<or>><<suspicionMsgAlt2>>
        did that<<at random>>'
    
    suspicionMsgQuestionGrp2 = 'was that
        <<one of>><i>{my}</i> door<<or>>one of <i>{my}</i>
        doors<<one of>> from before<<or>> from earlier<<or>><<at random>><<at random>>'
    
    suspicionMsg =
        '<<realizationExclamation>>, <<one of>><<suspicionMsgQuestionGrp1>><<or
        >><<suspicionMsgQuestionGrp2>><<at random>>...?'
    
    suspiciousSilenceMsg =
        '<<realizationExclamation>>,
        <<one of>>isn\'t<<or>>wasn\'t<<at random>> <<theName>>
        <<one of>>supposed<<or>>meant<<or>>scheduled<<at random>>
        to <i><<one of>>close<<or>>shut<<at random>> itself</i>
        <<one of>>by<<or>>right about<<or>>around<<at random>> now...?'

    catCloseMsg =
        '{That subj dobj} {is} too heavy for an old cat to close.
        It\'s fortunate that these close on their own, instead. '
    
    closeDoorDeniedMsg =
        '<<gSkashekName>> won\'t let{dummy} {me} do that again,
        at least while he controls {the dobj}. '
    
    cannotSlamClosedDoorMsg =
        '{I} cannot slam a closed door. '

    getScanName() {
        local omr = getOutermostRoom();
        local observerRoom = gPlayerChar.getOutermostRoom();
        local inRoom = omr == observerRoom;

        if (lockability == notLockable) {
            local direction = omr.getDirection(self);
            
            if (direction != nil) {
                local listedLoc = inRoom
                    ? direction.name : omr.inRoomName(gPlayerChar);
                if (exitLister.enableHyperlinks && inRoom) {
                    return theName + ' (' + aHrefAlt(
                        sneakyCore.getDefaultTravelAction() +
                        ' ' + direction.name, direction.name, direction.name
                    ) + ')';
                }
                return theName + ' (' + listedLoc + ')';
            }

            if (exitLister.enableHyperlinks && inRoom) {
                local clickAction = '';
                if (outputManager.htmlMode) {
                    clickAction = ' (' + aHrefAlt(
                        sneakyCore.getDefaultDoorTravelAction() +
                        ' ' + theName, passActionStr, passActionStr
                    ) + ')';
                }
                return theName + clickAction;
            }
        }

        return theName + (inRoom
            ? '' : (' (' + omr.inRoomName(gPlayerChar) + ')'));
    }

    getPreferredBoardingAction() {
        return sneakyCore.getDefaultDoorTravelActionClass();
    }

    reportSenseAction(directlySeeSoundSrc, farSeeSoundSrc, hearMsg, hearSoundSrc) {
        local sharesRoom = sharesRoomWith(gPlayerChar);

        if (canEitherBeSeenBy(gPlayerChar)) {
            if (directlySeeSoundSrc != nil) addSFX(
                sharesRoom ? directlySeeSoundSrc : farSeeSoundSrc,
                sharesRoom ? nil : closeEcho
            );
        }
        else if (canPlayerHearNearby()) {
            if (hearMsg != nil) say(hearMsg);
            if (hearSoundSrc != nil) addSFX(
                hearSoundSrc, wallMuffle
            );
        }
    }
}