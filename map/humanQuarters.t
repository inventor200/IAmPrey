humanQuarters: Room { 'Human Sleeping Quarters'
    "This room was one of three sleeping areas for facility staff,
    but the other two are not within <<gSkashekName>>\'s boundaries.\b
    It has been converted in a sort of scrap yard, with a massive junk pile
    taking up half the space.\b
    A single bunkbed and wardrobe sit in the southeast corner, like a museum to
    display how Humans once lived. "

    mapModeDirections = [&north, &east]
    familiar = roomsFamiliarByDefault
}
+Decoration { 'junk pile;trash recycling'
    "It seems to be the remnants of furniture and other utilities. {I} can see
    several bits which could have been ovens, and have been scrapped for parts. "
}
+Bunkbed;
+Wardrobe;
++AwkwardFloorHeight;

DefineDoorEastTo(southwestHall, humanQuarters, 'the Human Sleeping Quarters door')