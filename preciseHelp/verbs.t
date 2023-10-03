verbsChapter: InstructionsChapter {
    name = 'Complete Index of Verbs'

    script = [
        verbsPage1,
        verbsPage2,
        verbsPage3,
        verbsPage4,
        verbsPage5,
        verbsPage6,
        verbsPage7,
        verbsPage8,
        verbsPage9
    ]
}

verbsPage1: InstructionsPage {
    page() {
        """
        The following is a complete list of the verbs
        which are necessary to complete this game.\b

        These are listed with
        <<formatCommand('VERB : object')>> notation.\b

        <<formatCommand('go')>>&nbsp;<i>(compass direction name)</i>\n
        Direction names include
        <i>(north)</i>,
        <i>(south)</i>,
        <i>(east)</i>,
        <i>(west)</i>,
        <i>(up)</i>,
        <i>(down)</i>,
        <i>(in)</i>,
        <i>(out)</i>, etc.\n
        Travel can be abbreviated with:\n
        <<abbr('N')>> <<abbr('S')>> <<abbr('E')>> <<abbr('W')>>
        <<abbr('NE')>> <<abbr('SE')>> <<abbr('NW')>> <<abbr('SW')>>
        <<abbr('U')>> <<abbr('D')>>
        """;
    }
}

verbsPage2: VerbsPage {
    page() {
        """
        <<formatVerb('climb up', nil, nil, nil, nil, 'platform name')>>
        <<formatVerb('climb over to', nil, nil, nil, nil, 'platform name')>>
        <<formatVerb('climb down to', nil, nil, nil, nil, 'platform name')>>
        <<formatVerb('climb up into', nil, nil, nil, nil, 'aperture name')>>
        <<formatVerb('climb over into', nil, nil, nil, nil, 'aperture name')>>
        <<formatVerb('climb down into', nil, nil, nil, nil, 'aperture name')>>
        """;
    }
}

verbsPage3: VerbsPage {
    page() {
        """
        <<formatVerb('jump up', nil, nil, nil, nil, 'platform name')>>
        <<formatVerb('jump over to', nil, nil, nil, nil, 'platform name')>>
        <<formatVerb('jump down to', nil, nil, nil, nil, 'platform name')>>
        <<formatVerb('jump up into', nil, nil, nil, nil, 'aperture name')>>
        <<formatVerb('jump over into', nil, nil, nil, nil, 'aperture name')>>
        <<formatVerb('jump down into', nil, nil, nil, nil, 'aperture name')>>
        """;
    }
}

verbsPage4: VerbsPage {
    page() {
        """
        <<formatVerb('get down', 'get off', nil, nil, nil, nil)>>
        <<formatVerb('get out', 'go out', nil, nil, nil, nil)>>
        <<formatVerb('go in', 'enter', nil, nil, nil, 'container')>>
        <<formatVerb('run across', nil, nil, nil, nil, 'obstacle')>>
        <<formatVerb('squeeze through', nil, nil, 'squeeze thru', nil, 'aperture name')>>
        """;
    }
}

verbsPage5: VerbsPage {
    page() {
        """
        <<formatVerb('parkour', 'routes', 'Lists known parkour routes.', nil, 'pk', nil)>>
        <<formatVerb('locals', nil, 'Lists surfaces in reach during parkour.', nil, nil, nil)>>
        <<formatVerb('routes full', nil, 'Lists all known routes and nearby surfaces.', 'pk full', nil, nil)>>
        <<formatVerb('go to', nil, nil, nil, nil, 'room')>>
        <<formatVerb('compass', nil, 'Shows next direction toward go-to goal.', nil, nil, nil)>>
        <<formatVerb('map', nil, 'Opens and closes the text-based map.', nil, nil, nil)>>
        """;
    }
}

verbsPage6: VerbsPage {
    page() {
        """
        <<formatVerb('open', nil, nil, nil, nil, 'door or container')>>
        <<formatVerb('close', nil, nil, nil, nil, 'door or container')>>
        <<formatVerb('slam', nil, nil, nil, nil, 'door')>>
        <<formatVerb('examine', nil, nil, nil, 'x', 'object')>>
        <<formatVerb('search', nil, 'Can reveal new parkour routes.', nil, 'sr', 'container/platform name')>>
        <<formatVerb('look in', nil, nil, nil, nil, 'container')>>
        <<formatVerb('look under', nil, nil, nil, nil, 'container')>>
        """;
    }
}

verbsPage7: VerbsPage {
    page() {
        """
        <<formatVerb('turn on', nil, nil, nil, nil, 'device')>>
        <<formatVerb('turn off', nil, nil, nil, nil, 'device')>>
        <<formatVerb('take', nil, nil, nil, nil, 'item')>>
        <<formatVerb('drop', nil, nil, nil, nil, 'item')>>
        <<formatVerb('wear', nil, nil, nil, nil, 'outfit name')>>
        <<formatVerb('take off', nil, nil, nil, nil, 'outfit name')>>
        """;
    }
}

verbsPage8: VerbsPage {
    page() {
        """
        <<formatVerb('look around', nil, 'Gives a description of surroundings.', nil, 'l', nil)>>
        <<formatVerb('look through', nil, nil, 'look thru', nil, 'aperture name')>>
        <<formatVerb('peek through', nil, nil, 'peek thru', nil, 'aperture name')>>
        <<formatVerb('peek', nil, 'Allows the player to look into other rooms.', nil, 'p', 'compass direction name')>>
        <<formatVerb('listen', nil, 'Listens for environmental sounds.', nil, nil, nil)>>
        <<formatVerb('sneak', nil, nil, nil, 'sn', 'compass direction name')>>
        <<formatVerb('sneak through', nil, nil, 'sn thru', nil, 'aperture name')>>
        """;
    }
}

verbsPage9: VerbsPage {
    page() {
        """
        <<formatVerb('wait', nil, 'Passes a turn.', nil, 'z', nil)>>
        <<formatVerb('undo', nil, nil, nil, nil, nil)>>
        <<formatVerb('save', nil, 'For player convenience.', nil, nil, nil)>>
        <<formatVerb('restore', nil, 'Loads a save file, for player convenience.', nil, nil, nil)>>
        <<formatVerb('restart', nil, 'Starts a new game.', nil, nil, nil)>>
        """;
    }
}
