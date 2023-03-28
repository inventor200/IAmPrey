northBathroom: Room {
    vocab = 'north end[weak] restroom;north-end;bathroom toilet lavatory'
    roomTitle = 'North-End Restroom'
    desc = "<<standardRestroomDesc()>>\b
    And more description. "
    standardRestroomDesc = "TODO: Add description."

    south = northHall

    mapModeDirections = [&south]
    familiar = roomsFamiliarByDefault
    roomNavigationType = killRoom
}

southBathroom: Room {
    vocab = 'south end[weak] restroom;south-end;bathroom toilet lavatory'
    roomTitle = 'South-End Restroom'
    desc = "<<northBathroom.standardRestroomDesc()>>\b
    And more description. "

    north = southHall

    eastMuffle = reactorNoiseRoom

    mapModeDirections = [&north]
    familiar = roomsFamiliarByDefault
    roomNavigationType = killRoom
}