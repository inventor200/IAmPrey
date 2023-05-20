catModeChapter: InstructionsChapter {
    name = 'Cat Mode'

    script = [
        catModePage
    ]
}

catModePage: InstructionsPage {
    page() {
        """
        Cat Mode has no active antagonist, and allows the player
        to freely explore the map at their own pace.
        When the player is done exploring, they can freely
        <<formatCommand('RESTART')>> the game,
        and choose another difficulty mode.
        """;
    }
}

autoSneakChapter: InstructionsChapter {
    name = 'Auto-Sneaking'

    script = [
        autoSneakPage1,
        autoSneakPage2
    ]
}

autoSneakPage1: InstructionsPage {
    page() {
        """
        In the Prey Tutorial mode, there is a system
        known as <q>auto-sneak</q>, which automatically performs
        the general practices for checking danger before moving in a direction.
        """;
    }
}

autoSneakPage2: InstructionsPage {
    page() {
        """
        It's not perfect, and it often uses excessive turns,
        but it's meant to help demonstrate to the player the sort of
        risk-averse mindset that will avoid most dangers.
        As the player gets more skilled, they can afford to take more risks.\b

        To turn off auto-sneak, use the <<formatCommand('SNEAK MODE OFF')>> command.
        """;
    }
}

nightmareModeChapter: InstructionsChapter {
    name = 'Nightmare Mode'

    script = [
        nightmareModePage
    ]
}

nightmareModePage: InstructionsPage {
    page() {
        """
        Nightmare Mode has the <<gSkashekName>> moving at a
        full sprint at all times. He refuses you any mercy,
        and you have access to none of your tricks.
        Additionally, <<formatCommand('undo')>> is locked out in this difficulty mode.
        """;
    }
}