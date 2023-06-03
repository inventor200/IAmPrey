class Bathroom: Room {
    desc = "The only light bounces around a privacy wall
    from the hallway, shrouding the room in near-darkness. However, the
    smell of industrial cleaning is in the air. <<gSkashekName>> has been busy.\b
    A row of toilets on the west wall sit across the row of sinks
    and mirror on the east wall.
    On the <<showerWall>> wall is a cluster of communal showers. "

    atmosphereObj = bathroomAir
}

bathroomAir: Atmosphere {
    desc = "{I} {see} nothing special about the air. "
    feelDesc = "There is the mildest of breezes, thanks to
    enduring life support systems. "
    smellDesc = "The air smells like industrial cleaning chemicals. "
}

northBathroom: Bathroom {
    vocab = 'north end[weak] restroom;north-end;bathroom lavatory'
    roomTitle = 'North-End Restroom'

    showerWall = 'north'
    south = northHall
    ambienceObject = industrialAmbience

    mapModeDirections = [&south]
    familiar = roomsFamiliarByDefault
    roomNavigationType = killRoom
}
+northBathroomSink: PluralSink;
+PluralShower;
+PluralToilet;
+Mirror;

southBathroom: Bathroom {
    vocab = 'south end[weak] restroom;south-end;bathroom lavatory'
    roomTitle = 'South-End Restroom'

    showerWall = 'south'
    north = southHall
    ambienceObject = industrialAmbience

    eastMuffle = reactorNoiseRoom

    mapModeDirections = [&north]
    familiar = roomsFamiliarByDefault
    roomNavigationType = killRoom
}
+southBathroomSink: PluralSink;
+PluralShower;
+PluralToilet;
+Mirror;