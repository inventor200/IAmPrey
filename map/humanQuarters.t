humanQuarters: Room { 'Human Sleeping Quarters'
    "TODO: Add description. "

    mapModeDirections = [&north, &east]
    familiar = roomsFamiliarByDefault
}

DefineDoorEastTo(southwestHall, humanQuarters, 'the human sleeping quarters door')