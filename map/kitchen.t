kitchen: Room { 'The Kitchen'
    "TODO: Add description. "

    north = kitchenNorthExit

    eastMuffle = reservoirCorridor
    southMuffle = reactorNoiseRoom
}

+kitchenVentGrate: VentGrateDoor {
    vocab = defaultVentVocab
    location = reservoirVentGrate
    otherSide = labAExitVentGrate
}

+kitchenNorthExit: Door { 'the freezer door'
    freezerDoorDesc
    otherSide = kitchenNorthEntry
    soundSourceRepresentative = kitchenNorthEntry

    airlockDoor = true
    pullHandleSide = true
}

kitchenNorthEntry: Door { 'the kitchen access door'
    freezerDoorDesc
    otherSide = kitchenNorthExit
    location = freezer

    airlockDoor = true
    pullHandleSide = nil
}

DefineDoorWestTo(southHall, kitchen, 'the kitchen door')

reservoirVentGrate: VentGrateDoor {
    vocab = defaultVentVocab
    location = reservoirCorridor
    otherSide = kitchenVentGrate
    soundSourceRepresentative = (otherSide)
}
