breakroom: Room { 'The Breakroom'
    "TODO: Add description. "

    northMuffle = serverRoomBottom
    eastMuffle = deliveryRoom
    westMuffle = utilityPassage

    mapModeDirections = [&south]
    familiar = roomsFamiliarByDefault
}

DefineDoorSouthTo(southHall, breakroom, 'the breakroom door')