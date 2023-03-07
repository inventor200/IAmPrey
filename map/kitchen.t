kitchen: Room { 'The Kitchen'
    "TODO: Add description. "

    north = kitchenNorthExit

    eastMuffle = reservoirCorridor
    southMuffle = reactorNoiseRoom
}

+kitchenNorthExit: Door { 'the freezer door'
    freezerDoorDesc
    otherSide = kitchenNorthEntry
    soundSourceRepresentative = kitchenNorthEntry

    airlockDoor = true
}

kitchenNorthEntry: Door { 'the kitchen access door'
    freezerDoorDesc
    otherSide = kitchenNorthExit
    location = freezer

    airlockDoor = true
}

DefineDoorWestTo(southHall, kitchen, 'the kitchen door')

DefineVentGrateEastTo(reservoirCorridor, nil, kitchen, nil, 'kitchen vent grate;ventilation;door', 'vent grate;ventilation;door')