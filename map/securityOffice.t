securityOffice: Room { 'The Security Office'
    "TODO: Add description. "

    south = armory

    mapModeDirections = [&south, &east]
    familiar = roomsFamiliarByDefault
}

DefineDoorEastTo(northwestHall, securityOffice, 'the security office door')