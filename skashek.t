skashek: Actor { 'Skashek;;predator hunter royal[weak] subject sheki shek'
    "A rather terrifying visage! "
    isHim = true
    theName = (globalParamName)
    trueNameKnown = nil
    #if __DEBUG
    location = deliveryRoom
    #else
    location = kitchen
    #endif

    globalParamName = (gCatMode ? '<b>The Royal Subject</b>' :
        (trueNameKnown ? '<b>Skashek</b>' : '<b>The Predator</b>'))

    doPerception() {
        //TODO: Handle Skashek sound perception
    }

    doPlayerPeek() {
        //TODO: Player peeks in while he is in the room
    }

    doPlayerCaughtLooking() {
        //TODO: The player sees Skashek through a grate or cat flap,
        // but Skashek was ready!
        //TODO: Do not accept this if it happened last turn
    }

    describePeekedAction() {
        //TODO: Allow for him to be described according to his current action
        "<.p><i>\^<<gSkashekName>> is in there!</i> ";
    }

    dobjFor(Kiss) {
        verify() { }
        check() { }
        action() { }
        report() {
            "<.p>
            You decide to push the limits of what is thought to be possible.\b
            You lean in, lips at the ready, and...\b
            <i>...he thought you were attempting to bite him.</i>\b
            In the blink of an eye, most of your teeth are shattered, and his
            bleeding fist pulls away from you. You think your lower jaw has
            suffered multiple fractures, but you're too dazed to be sure.\b
            You collapse to <<getOutermostRoom().floorObj.theName>>,
            overwhelmed by pain, shock, and <i>rejection</i>.\b
            <q>What the <i>fuck</i>, Prey?</q> he demands, now realizing what
            you were trying to do. With a deep sigh, he looks over your crumpled
            form, deciding what to do next.\b
            He rolls his eyes in disappointment, raises his boot over your skull,
            and swiftly ends your existence.
            <.p>";
            finishGameMsg(ftDeath, gEndingOptions);
        }
    }
}

+maintenanceKey: Key { 'maintenance keycard;rfid;key chip'
    "A small, white card with thin, silvery strips.
    This must have been used by the original researchers to
    unlocked maintenance areas. "

    owner = [skashek]
}