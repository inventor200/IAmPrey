experiencedWarningChapter: InstructionsChapter {
    name = 'A Warning for Experienced Parser Players'

    script = [
        experiencedWarningPage1,
        experiencedWarningPage2,
        experiencedWarningPage3
    ]
}

experiencedWarningPage1: InstructionsPage {
    page() {
        """
        This game makes use of <<formatTheCommand('SEARCH')>>, but not
        quite in the same way it has been used, traditionally.\b

        Objects in the game are always <q>in play</q>, and not added
        to the game's world after the player uses <<formatTheCommand('SEARCH')>> on a
        container. There are only two possible exceptions in <i>I Am Prey</i>,
        and one has multiple alternative discovery methods,
        while the other exception is completely optional during gameplay.\b

        The list of search verbs is as follows:

        <<createUnorderedList([
            '<<formatCommand('search')>>\n
            For containers that have multiple parts, or can be looked through.',
            '<<formatCommand('look in')>>\n
            For containers that open and enclose other objects.',
            '<<formatCommand('look under')>>\n
            For containers that can store objects underneath themselves.'
        ])>>
        """;
    }
}

experiencedWarningPage2: InstructionsPage {
    page() {
        """
        <<formatTitle(
            titleCommand('SEARCH') + ' ' +
            (gFormatForScreenReader ? 'versus' : 'vs') +
            ' ' + titleCommand('EXAMINE')
        )>>

        <<formatCommand('SEARCH')>> takes a turn to use, and will allow the player
        to gather usable data about an object.\n
        <<formatCommand('SEARCH')>> also reveals <b>new parkour routes</b>, but
        <b>only if they are accessible from the player's current position</b>.\b

        <<formatCommand('EXAMINE')>> is a <<freeAction>>, and can still
        reveal objects within containers.\n
        <<formatCommand('EXAMINE')>> is meant to be a reflex-based or
        recall-based review of immediate information.
        """;
    }
}

experiencedWarningPage3: InstructionsPage {
    page() {
        """
        <<formatTitle(titleCommand('SEARCH') + ' via Exploration')>>

        Most applications of <<formatCommand('SEARCH')>> can be
        alternatively achieved by exploring something.
        A parkour route does not need to be revealed if the
        player simply tries attempting to
        <<formatCommand('CLIMB')>> or <<formatCommand('JUMP')>>
        there, experimentally.\b
        
        Additionally, objects <q>hidden</q> under something,
        for example, can often be discovered if the player tries to
        <<formatCommand('CRAWL UNDER')>> the container.
        """;
    }
}