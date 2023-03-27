/*administrationAudioRegion: SenseRegion {
    canSeeAcross = nil
    canHearAcross = true
    canSmellAcross = true
    canTalkAcross = true
    canThrowAcross = nil
    autoGoTo = nil
}*/

//TODO: Furnish more
#define populateCubicle(cubicleName) \
+cubicleName##Desk: FixedPlatform { \
    vocab = 'desk;office wide cubicle;table' \
    desc = "A wide office desk sits in the corner of the cubicle. " \
} \
++LowFloorHeight; \
++JumpUpLink ->cubicleName##FilingCabinet; \
+cubicleName##FilingCabinet: FilingCabinet; \
++HighFloorHeight;

class Cubicle: Room {
    desc() {
        "The cubicle is shaped by thin walls, which don't extend
        all the way to the ceiling.\b
        A wide office desk rests in the corner, with a metal filing cabinet
        beside it.\b
        From here, {i} can go <<hyperDir('out')>> to where the other cubicles
        connect. ";
    }

    out = administration

    //regions = [administrationAudioRegion]

    mapModeDirections = [&out]
    familiar = roomsFamiliarByDefault
}

class FakeCubicle: Passage {
    desc = "The cubicles take up most of the space here, and their walls form the
    L-shaped hall {i} find {myself} in. "
    ambiguouslyPlural = true
    otherSide = destination
    remappingSearch = true
    dobjFor(Search) asDobjFor(LookThrough)
    attachPeakingAbility('in {the dobj}')
}

administration: Room {
    vocab = 'Administration;;admin'
    roomTitle = 'Administration'
    desc = "The lights here are in low-power mode, with only a few still on.
    {I} {am} in a narrow, L-shaped hallway of cubicle walls, directing {my} attention
    to the door of the Director's Office, to the <<hyperDir('north')>>.
    To the <<hyperDir('west')>>, the cubicles shape a sharp turn to the
    exit.\b
    From this hallway, {i} can enter the <<hyperDir('northwest')>>,
    <<hyperDir('northeast')>>, <<hyperDir('southeast')>>, or
    <<hyperDir('southwest')>> cubicle. "

    northeast = fakeNortheastCubicle
    southeast = fakeSoutheastCubicle
    northwest = fakeNorthwestCubicle
    southwest = fakeSouthwestCubicle

    eastMuffle = commonRoom
    southMuffle = enrichmentRoom

    //regions = [administrationAudioRegion]

    mapModeDirections = [&north, &west, &northeast, &southeast, &northwest, &southwest]
    familiar = roomsFamiliarByDefault
}
+fakeNortheastCubicle: FakeCubicle { 'northeast cubicle;ne;office'
    destination = northeastCubicle
}
+fakeSoutheastCubicle: FakeCubicle { 'southeast cubicle;se;office'
    destination = southeastCubicle
}
+fakeNorthwestCubicle: FakeCubicle { 'northwest cubicle;nw;office'
    destination = northwestCubicle
}
+fakeSouthwestCubicle: FakeCubicle { 'southwest cubicle;sw;office'
    destination = southwestCubicle
}

northeastCubicle: Cubicle { 'The Northeast Cubicle'
    desc() {
        inherited();
        "\bAbove the filing cabinet, {i} can see a vent grate. ";
    }
}
populateCubicle(northeastCubicle)

southeastCubicle: Cubicle { 'The Southeast Cubicle'
    desc() {
        inherited();
    }
}
populateCubicle(southeastCubicle)

northwestCubicle: Cubicle { 'The Northwest Cubicle'
    desc() {
        inherited();
    }
}
populateCubicle(northwestCubicle)

southwestCubicle: Cubicle { 'The Southwest Cubicle'
    desc() {
        inherited();
    }
}
populateCubicle(southwestCubicle)

DefineDoorWestTo(northwestHall, administration, 'the Administration door;admin')