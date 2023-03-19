humanQuarters: Room { 'Human Sleeping Quarters'
    "TODO: Add description. "

    mapModeDirections = [&north, &east]
    familiar = roomsFamiliarByDefault
}

DefineDoorEastTo(southwestHall, humanQuarters, 'the Human Sleeping Quarters door')