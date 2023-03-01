freezer: Room { 'The Freezer'
    "TODO: Add description. "

    north = freezerNorthExit
    west = freezerWestExit
    south = kitchenNorthEntry
    
    floorObj = cementFloor
    ceilingObj = industrialCeiling
    atmosphereObj = freezingAtmosphere
    isFreezing = true

    coldSynonyms =
        '<<one of>>cold<<or>>freezing<<or>>frozen<<or
        >>chilled<<or>>chilling<<or>>icy<<or>>ice-cold<<at random>>'
    coldAluminum = '<<coldSynonyms>>, <<one of>>metal<<or>>aluminum<<at random>>'
    coldSteel = '<<coldSynonyms>>, <<one of>>metal<<or>>steel<<at random>>'
    coldAir = '<<coldSynonyms>> air'
    coldAirVerbs = '<<one of>>engulfs<<or>>surrounds<<or>>encases<<at random>>'
    coldBreeze = '<<coldSynonyms>> <<one of>>breeze<<or>>wave of air<<at random>>'
    coldBreezeVerbs = '<<one of>>washes<<or>>passes<<at random>> over'
    coldBreezeWashesOver =
        '<<one of>>a <<coldBreeze>> <<coldBreezeVerbs>><<or
        >>the <<coldAir>> <<coldAirVerbs>><<at random>> you'
    shiverRollsThrough =
        'a shiver <<one of>>passes over<<or>>rolls through<<at random>> you'
    breathAmbienceSingular =
        'breath
        <<one of>>becomes<<or>>turns to<<or>>condenses into<<at random>>'
    breathAmbiencePlural =
        '<<one of>>breaths<<or>>exhales<<at random>>
        <<one of>>become<<or>>turn to<<or>>condense into<<at random>>'
    breathAmbience =
        'your <<one of>><<breathAmbienceSingular>><<or>><<breathAmbiencePlural
        >><<at random>><<one of>> visible<<or>><<at random>> fog
        <<one of>>before you<<or>>before your eyes<<or>>before your very eyes<<or
        >>from your mouth<<at random>>'
    expressAmbience =
        '<<one of>><<shiverRollsThrough>><<or>><<coldBreezeWashesOver>><<or
        >><<breathAmbience>><<at random>>'
    
    entryVerbs =
        '<<one of>>welcomes you<<or>>greets you<<or>>meets you<<or
        >>replies<<or>>responds<<or>>awaits<<or>>awaits you<<or
        >>waits for you<<at random>>'
    entrySuffixVerbs =
        '<<one of>>in greeting<<or>>in reply<<or>>in response<<at random>>'

    coldBreezeWashesOverOnEntryBasic =
        '<<one of>>a <<coldBreeze>><<or>>the <<coldAir>><<at random>> <<entryVerbs>>'
    coldBreezeWashesOverOnEntry =
        '<<one of
            >><<coldBreezeWashesOverOnEntryBasic
            >><<or
            >><<coldBreezeWashesOver>> <<entrySuffixVerbs
        >><<at random>>'
    shiverRollsThroughOnEntry =
        '<<one of>>a shiver <<entryVerbs>><<or
        >><<shiverRollsThrough>> <<entrySuffixVerbs>><<at random>>'
    expressAmbienceOnEntry =
        '<<one of>><<shiverRollsThroughOnEntry>><<or
        >><<coldBreezeWashesOverOnEntry>><<at random>>'
    subclauseAmbienceOnEntry =
        '<<one of>>and<<or>>as<<at random>> <<freezer.expressAmbienceOnEntry>>'
    expressAmbienceOnExit =
        'warmer air
        <<one of>>welcomes<<or>>greets<<or>>meets<<at random>>
        and
        <<one of>>revitalizes<<or>>comforts<<or>>warms<<or
        >>embraces<<or>>restores<<at random>> you'
    subclauseAmbienceOnExit =
        '<<one of>>while<<or>>where<<at random>> <<freezer.expressAmbienceOnExit>>'

    travelerEntering(traveler, origin) {
        inherited(traveler, origin);
        if (gPlayerChar.isOrIsIn(traveler)) {
            "<.p>You enter, <<subclauseAmbienceOnEntry>>.<.p> ";
        }
    }

    travelerLeaving(traveler, dest) {
        inherited(traveler, dest);
        if (gPlayerChar.isOrIsIn(traveler)) {
            "<.p>\^<<expressAmbienceOnExit>>.<.p> ";
        }
    }
}

+freezerNorthExit: Door { 'the loading door'
    freezerDoorDesc
    otherSide = freezerNorthEntry
    soundSourceRepresentative = freezerNorthEntry

    airlockDoor = true
}

+freezerWestExit: Door { 'the exit door'
    freezerDoorDesc
    otherSide = freezerWestEntry
    soundSourceRepresentative = freezerWestEntry

    airlockDoor = true
}

northFreezerFog: ColdFog;
westFreezerFog: ColdFog;

freezerNorthEntry: Door { 'the freezer loading door'
    freezerDoorDesc
    otherSide = freezerNorthExit
    location = storageBay

    airlockDoor = true

    makeOpen(stat) {
        inherited(stat);

        if (stat) {
            northFreezerFog.moveInto(storageBay);
        }
        else {
            northFreezerFog.moveInto(nil);
        }
    }
}

freezerWestEntry: Door { 'the freezer door'
    freezerDoorDesc
    otherSide = freezerWestExit
    location = southeastHall

    airlockDoor = true

    makeOpen(stat) {
        inherited(stat);

        if (stat) {
            westFreezerFog.moveInto(southeastHall);
        }
        else {
            westFreezerFog.moveInto(nil);
        }
    }
}