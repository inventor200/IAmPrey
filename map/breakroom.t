breakroom: Room {
    vocab = 'The Breakroom;break[weak];room[weak]'
    roomTitle = 'The Breakroom'
    desc =
    "TODO: Add description. "

    northMuffle = serverRoomBottom
    eastMuffle = deliveryRoom
    westMuffle = utilityPassage

    mapModeDirections = [&south]
    familiar = roomsFamiliarByDefault
    roomNavigationType = killRoom
}

DefineDoorSouthTo(southHall, breakroom, 'the Breakroom door')