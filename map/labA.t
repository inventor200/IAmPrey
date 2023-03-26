labA: Room { 'Lab A'
    "TODO: Add description.\b
    A tall set of storage shelves can be found in the southwest corner.\b
    The exit door is to the <<hyperDir('east')>>. "

    northMuffle = northHall
    westMuffle = lifeSupportTop
    southMuffle = library

    mapModeDirections = [&east]
    familiar = roomsFamiliarByDefault
}

+labAShelves: FixedPlatform { 'storage shelf{shelves};cargo;rack'
    "Rough, metal shelves for storing boxes and equipment.
    They are arranged into an L-shape, to conform to the corner of
    the room. "
    ambiguouslyPlural = true

    travelPreface = 'You find yourself on a tall set of storage shelves,
        placed in the corner of the room, and in reach of'
}
++AwkwardFloorHeight;

labAToLibraryVentGrate: VentGrateDoor {
    vocab = 'Library ' + defaultVentVocab + ' south' + defaultVentVocabSuffix
    location = labAShelves
    otherSide = LibraryTolabAVentGrate

    travelDesc = "You carefully find your balance on a stepladder, once you're on
    the other side of the vent grate. "
}

LibraryTolabAVentGrate: VentGrateDoor {
    vocab = 'Lab A ' + defaultVentVocab + ' north' + defaultVentVocabSuffix
    location = stepLadder
    otherSide = labAToLibraryVentGrate
    soundSourceRepresentative = (otherSide)

    travelDesc = "<<labAShelves.travelPreface>> the primary vent grate. "
}

DefineDoorEastTo(northeastHall, labA, 'the door[n] to[prep] Lab[n] A[weak]')