lifeOfPreyChapter: InstructionsChapter {
    name = 'Life of Prey'

    script = [
        lifeOfPreyPage
    ]
}

lifeOfPreyPage: InstructionsPage {
    page() {
        """
        While the player searches for the suit parts,
        <<gSkashekName>> is on the hunt!\b

        <b>Falling</b> and <b>jumping</b> both make more noise than
        simply <b>climbing</b>, so use any known <b>jump routes</b> sparingly!\b

        Additionally, doors automatically closing will draw his
        attention if the player does not manually close them first
        (see the chapter on <b>doors</b> for more information).\b

        Leaving doors open clues <<gSkashekName>> in on the player's
        location, <b>unless the Predator was the one to open the
        door in the first place</b>.\b

        <i>Try hiding in lockers and other large storage containers,
        before he enters the room!</i>
        """;
    }
}

parkourEvasionChapter: InstructionsChapter {
    name = 'Parkour: Evasion by Climbing'
    indented = true

    script = [
        parkourEvasionPage1,
        parkourEvasionPage2,
        parkourEvasionPage3
    ]
}

parkourEvasionPage1: InstructionsPage {
    page() {
        """
        In addition to hiding, parkour opportunities and climbing
        routes can be discovered by using the
        <<formatCommand('search')>>&nbsp;(<<abbr('sr')>>) command
        on various surfaces (such as <<formatInput('search table')>>).
        If the player can access the surface <b>from where they currently
        stand</b>, then the route will be added to their list of
        <b>known parkour routes</b>, which can be reviewed with
        <<formatTheCommand('ROUTES all')>>.
        """;
    }
}

parkourEvasionPage2: InstructionsPage {
    page() {
        """
        Note that only routes accessible from the player's
        current location will appear when using
        <<formatTheCommand('routes')>> or <<formatTheCommand('routes all')>>.\b

        <i>Use these hidden routes to find
        shortcuts and emergency escape routes!</i>
        """;
    }
}

parkourEvasionPage3: InstructionsPage {
    page() {
        """
        Remember that some routes require <<formatCommand('climb')>>,
        while others require <<formatCommand('jump')>>,
        and this will affect the benefits and consequences of
        traversing these obstacles! A speedy player might want to
        <<formatCommand('jump')>>, while a stealthy player might want to
        <<formatCommand('climb')>>!
        """;
    }
}