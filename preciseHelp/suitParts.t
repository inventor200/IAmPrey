suitPartsChapter: InstructionsChapter {
    name = 'Suit Parts (How to Win)'

    script = [
        suitPartsPage
    ]
}

suitPartsPage: InstructionsPage {
    page() {
        """
        There are <b>seven<<if !gFormatForScreenReader>> (7)<<end>></b>
        parts of an environment suit, which will
        grant escape through the emergency airlock.
        These include the <b>helmet</b>, <b>torso</b>, <b>bottoms</b>,
        <b>left glove</b>, <b>right glove</b>, <b>left boot</b>, and <b>right boot</b>.\b

        There is also a <b>fake helmet</b>, which will reveal
        itself only when the player tries to take it.\b

        <b>The suit parts cannot be worn until the
        player enters the emergency airlock.</b>\b
        """;
        if (gCatMode) {
            "You are currently in <b>Cat Mode</b>, so suit parts are not a concern
            right now. Instead, focus on learning the map, and finding secret routes!";
        }
        else {
            """
            To review the suit parts that are still missing, use the
            <<formatCommand('progress')>> command.
            <<suitTracker.getProgressLists()>>
            """;
        }
    }
}