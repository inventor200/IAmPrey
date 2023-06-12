awarenessChapter: InstructionsChapter {
    name = 'Environmental Awareness'

    script = [
        awarenessPage1,
        awarenessPage2
    ]
}

awarenessPage1: InstructionsPage {
    page() {
        """
        The player can use <<formatTheCommand('LISTEN')>> and
        <<formatTheCommand('PEEK')>> to gather environmental
        clues about <<gSkashekName>>.
        Other clues can be gathered by hearing muffled sounds
        through walls, and doors automatically closing.
        """;
    }
}

awarenessPage2: InstructionsPage {
    page() {
        """
        If the player hears <b>ominous clicking</b> sounds,
        then <<gSkashekName>> is likely waiting outside
        the room, ready to strike!
        """;
    }
}

doorsChapter: InstructionsChapter {
    name = 'Doors'

    script = [
        doorsPage1,
        doorsPage2
    ]
}

doorsPage1: InstructionsPage {
    page() {
        """
        Most doors (other than small ones and the Freezer doors)
        will automatically close. If the player closes the door
        behind themself, then a safe level of stealth can be maintained.
        If the door automatically slams shut when <<gSkashekName>>
        doesn't expect it, then he will go to investigate.
        """;
    }
}

doorsPage2: InstructionsPage {
    page() {
        """
        This can also be leveraged by using
        <<formatTheCommand('SLAM DOOR')>>,
        which will create a loud sound.\b

        Additionally, if the player opens or closes doors in view of
        <<gSkashekName>>, then he will go to investigate.
        """;
    }
}

tricksChapter: InstructionsChapter {
    name = 'Tricks'

    script = [
        tricksPage1,
        tricksPage2,
        tricksPage3,
        tricksPage4,
        tricksPage5
    ]
}

tricksPage1: InstructionsPage {
    page() {
        """
        The player has a list of tricks that can be utilized,
        but only for a limited number of times.
        The number of tricks available depends on the difficulty mode.
        """;
    }
}

tricksPage2: InstructionsPage {
    page() {
        """
        <<formatTitle('Door Slam Trick')>>

        When <<gSkashekName>> opens a door to enter a room,
        the player has an option to <<formatCommand('SLAM')>>
        it in his face to stun him.
        This can be handy when escaping rooms with no alternative exits.\b

        Additionally, during a chase, the player can <<formatCommand('SLAM')>>
        a door just before he passes through it.
        A special choice selection might appear in this case
        to provide the player with a bonus action.
        """;
    }
}

tricksPage3: InstructionsPage {
    page() {
        """
        If this trick runs out, then <<gSkashekName>>
        will always control the door when passing through.
        """;
    }
}

tricksPage4: InstructionsPage {
    page() {
        """
        <<formatTitle('Annoying Sink Trick')>>

        <<gSkashekName>> absolutely hates the sound of running water.
        He will be distracted when the player opens a sink's tap,
        and will be compelled to turn the water back off.
        """;
    }
}

tricksPage5: InstructionsPage {
    page() {
        """
        <<formatTitle('Reservoir Dive Trick')>>

        The player can dive in the Reservoir to make a daring escape.
        If this trick runs out, then <<gSkashekName>> will grab the
        player before escape can be made.
        """;
    }
}