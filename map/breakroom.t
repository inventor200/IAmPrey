breakroom: Room { 'The Breakroom'
    "TODO: Add description. "

    northMuffle = serverRoomBottom
    eastMuffle = deliveryRoom
    westMuffle = utilityPassage

    mapModeDirections = [&south]
    familiar = roomsFamiliarByDefault
    roomNavigationType = killRoom
}

DefineDoorSouthTo(southHall, breakroom, 'the Breakroom door')