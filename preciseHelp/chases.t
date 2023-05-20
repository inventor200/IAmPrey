chasesChapter: InstructionsChapter {
    name = 'Chase Sequences'

    script = [
        chasesPage1,
        chasesPage2,
        chasesPage3
    ]
}

chasesPage1: InstructionsPage {
    page() {
        """
        When the player is spotted, a chase sequence begins.
        If the current room has more than one standard
        (and/or parkour exit), then the player will get two
        turns to find a way to evade.
        <<gSkashekName>> will follow the player into the next room.
        """;
    }
}

chasesPage2: InstructionsPage {
    page() {
        """
        The chase can last for <b>five<<if !gFormatForScreenReader>> (5)<<end>>
        rooms</b> (assuming standard circumstances) before <<gSkashekName>>
        finally catches the player. Large rooms like the Storage Bay and
        Hangar are large enough to allow the player to extend the chase
        for a little longer, but results may vary.
        """;
    }
}

chasesPage3: InstructionsPage {
    page() {
        """
        <<formatTitle('Parkour During Chase Sequences')>>

        Depending on the available exits of a room,
        <<gSkashekName>> will have varying levels of
        patience for parkour antics.
        Generally, if there are two or more standard exits from a room,
        he will not permit parkour or climbing of any kind.
        """;
    }
}

exitControlChapter: InstructionsChapter {
    name = 'Predator Exit Control'

    script = [
        exitControlPage1,
        exitControlPage2
    ]
}

exitControlPage1: InstructionsPage {
    page() {
        """
        <<gSkashekName>> controls the last exit he passed
        through, which denies access to the player.
        This becomes a serious problem in a room with only
        one exit and no alternative parkour exits.
        In situations like this, the player can <<formatCommand('SLAM')>>
        the exit door as <<gSkashekName>> attempts to enter,
        assuming the <b>slam door trick</b> has not be depleted.
        While he is stunned, the player can escape without death,
        or find somewhere to hide in the room.
        """;
    }
}

exitControlPage2: InstructionsPage {
    page() {
        """
        The Hangar and Storage Bay are both too large for
        <<gSkashekName>> control the exits,
        so these rooms are the exception to this rule.
        """;
    }
}