armory: Room { 'The Armory'
    "TODO: Add description. "

    north = securityOffice
    
    eastMuffle = westHall

    mapModeDirections = [&north, &south]
    familiar = roomsFamiliarByDefault
}

DefineDoorSouthTo(humanQuarters, armory, 'the Armory door')