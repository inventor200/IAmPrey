northBathroom: Room { 'North-End Restroom'
    "TODO: Add description. "

    south = northHall

    mapModeDirections = [&south]
    familiar = roomsFamiliarByDefault
}

southBathroom: Room { 'South-End Restroom'
    "TODO: Add description. "

    north = southHall

    eastMuffle = reactorNoiseRoom

    mapModeDirections = [&north]
    familiar = roomsFamiliarByDefault
}