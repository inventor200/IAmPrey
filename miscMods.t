//TODO: Put score screen printing here
modify Score {
    execAction(cmd) {
        helpMessage.showHowToWinAndProgress();
    }
}

modify FullScore {
    execAction(cmd) {
        helpMessage.showHowToWinAndProgress();
    }
}

modify finishOptionAmusing {
    doOption() { //TODO: Mention XYZZY here
        "<b>Here are some silly things you could try:</b>\n
        Check Akira Lowe's credit in the CREDITS text. It changes!\n
        As soon as you start a new game (outside of Cat Mode), try to CRY.\n
        Try to HUG or KISS <<gSkashekName.toUpper()>>.\n
        Try to TAKE SHARD from a broken mirror, and be seen by <<gSkashekName>>.\n
        When <<gSkashekName>> is chasing you, try to TAKE OFF CLOTHES.\n
        You can MEOW in Cat Mode!\n
        Try to LICK DOOR HANDLE.\n
        Attempting to ATTACK <<gSkashekName.toUpper()>> ends in catastrophe!\n
        Outside of Nightmare Mode and Cat Mode, you can try waiting for
        <<gSkashekName>> to walk into the starting room, and then CRY
        in front of him.";
        return true;
    }
}

modify finishOptionFullScore {
    doOption() {
        "Ack!";
        return true;
    }
}

modify statusLine {
    showStatusRight() {
        local turnVerb = 'survived';
        if (gCatMode) {
            if (huntCore.wasBathTimeAnnounced) {
                turnVerb = 'stinky!';
            }
            else {
                turnVerb = 'explored';
            }
        }
        local turnStr = 'turn';
        if (gTurns != 1) turnStr += 's';
        "<b><<gTurns>> <<turnStr>> <<turnVerb>></b>";
    }
}