freezer: Room { 'The Freezer'
    "TODO: Add description. "

    north = freezerNorthExit
    west = freezerWestExit
    south = kitchenNorthEntry
    
    floorObj = cementFloor
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

freezerNorthEntry: Door { 'the freezer loading door'
    freezerDoorDesc
    otherSide = freezerNorthExit
    location = storageBay

    airlockDoor = true
}

freezerWestEntry: Door { 'the freezer door'
    freezerDoorDesc
    otherSide = freezerWestExit
    location = southeastHall

    airlockDoor = true
}