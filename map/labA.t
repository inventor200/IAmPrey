labA: Room { 'Lab A'
    "TODO: Add description. "

    northMuffle = northHall
    westMuffle = lifeSupportTop
    southMuffle = itOffice
}

+labAShelves: FixedPlatform { 'storage shelves;cargo;rack'
    "Rough, metal shelves for storing boxes and equipment.
    They are arranged into an L-shape, to conform to the corner of
    the room. "
    ambiguouslyPlural = true

    travelPreface = 'You find yourself on a tall set of storage shelves,
        placed in the corner of the room, and in reach of'
}
++AwkwardFloorHeight;

labAToITOfficeVentGrate: VentGrateDoor {
    vocab = 'it office ' + defaultVentVocab
    location = labAShelves
    otherSide = ITOfficeTolabAVentGrate

    travelDesc = "<<labAShelves.travelPreface>> the primary vent grate. "
}

ITOfficeTolabAVentGrate: VentGrateDoor {
    vocab = 'lab A ' + defaultVentVocab
    location = itOffice
    otherSide = labAToITOfficeVentGrate
    soundSourceRepresentative = (otherSide)

    travelDesc = "<<if gCatMode
        >><<if commonRoom.getVentSurprise()
        >>You know the route well.\b
        <<end>>Exiting the ventilation node, in one practiced motion,
        you find yourself on a display shelf, high above the floor.<<
        else>><<if commonRoom.getVentSurprise()
        >>Your heart lurches.\b
        <<end>>
        The path abruptly ends with a sharp drop to the floor, far below.
        You grip the sides of the vent, and carefully find your footing
        on a convenient display shelf.<<end>> "
}

DefineDoorEastTo(northeastHall, labA, 'the door to[weak] lab A[weak]')