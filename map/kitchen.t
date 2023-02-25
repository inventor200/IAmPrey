kitchen: Room { 'The Kitchen'
    "TODO: Add description. "

    north = kitchenNorthExit
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

//TODO: East parkour exit to reservoir corridor