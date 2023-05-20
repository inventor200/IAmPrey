mapChapter: InstructionsChapter {
    name = 'Map of the Facility'

    script = [
        mapPage1,
        mapPage2
    ]
}

mapPage1: InstructionsPage {
    page() {
        """
        The map for the Facility has been provided for the
        player as an included image file. Please note that
        parkour routes are not visible on the map, as they
        are meant to be discovered during Cat Mode
        (or other difficulty modes, if the player is feeling risky).
        """;
    }
}

mapPage2: InstructionsPage {
    page() {
        """
        For those who prefer to create their own maps during gameplay,
        it is strongly recommended that this is done during Cat Mode,
        because itss much more difficult to create a map while an
        <b>active NPC antagonist is on the hunt</b>.
        There are only two locations that are not accessible to the cat,
        but the rest of the map can be explored freely in Cat Mode.
        """;
    }
}

screenReaderChapter: InstructionsChapter {
    name = 'For Screen-Reader Users'
    indented = true

    script = [
        screenReaderPage1,
        screenReaderPage2
    ]
}

screenReaderPage1: InstructionsPage {
    page() {
        """
        I Am Prey provides the player with an in-game map and
        compass system that allows the player to freely explore
        a replica of the visual map file, without ever costing
        a turn in-game.\b

        To access this, use the <<formatCommand('MAP')>> command.
        """;
    }
}

screenReaderPage2: InstructionsPage {
    page() {
        """
        The <<formatCommand('GO TO')>> command sets the player's
        mental compass, which will show the next step necessary
        to reach the goal set by the <<formatCommand('GO TO')>> command.
        To check this compass, simply use the <<formatCommand('COMPASS')>> command.
        """;
    }
}

missingContinueChapter: InstructionsChapter {
    name = 'What Happened to <u>GO TO</u> and <u>CONTINUE</u>?'
    indented = true

    script = [
        missingContinuePage
    ]
}

missingContinuePage: InstructionsPage {
    page() {
        """
        The default TADS commands of
        <<formatCommand('GO TO')>> and <<formatCommand('CONTINUE')>>
        have been remapped to the in-game map's 
        <<formatCommand('GO TO')>> and <<formatCommand('COMPASS')>>
        commands, respectively.\b

        This was done because having an active, hunting antagonist
        makes it too risky to use the <<formatCommand('CONTINUE')>>
        command, which would automatically (and recklessly) walk
        the player into the next room, without any concern for
        threats and dangers, which must be investigated.
        """;
    }
}