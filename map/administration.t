administrationAudioRegion: SenseRegion {
    canSeeAcross = nil
    canHearAcross = true
    canSmellAcross = true
    canTalkAcross = true
    canThrowAcross = nil
    autoGoTo = nil
}

#define populateCubicle(cubicleName) \
+cubicleName##Desk: FixedPlatform { \
    vocab = 'desk;office cubicle;table' \
    desc = "TODO: Add description. " \
} \
++LowFloorHeight; \
+cubicleName##FilingCabinet: FilingCabinet; \
++HighFloorHeight;

class Cubicle: Room {
    desc() {
        "TODO: Add description. ";
    }

    out = administration

    regions = [administrationAudioRegion]
}

class FakeCubicle: Passage {
    otherSide = destination
    attachPeakingAbility('in {the dobj}')
}

administration: Room { 'Administration'
    "TODO: Add description. "

    northeast = fakeNortheastCubicle
    southeast = fakeSoutheastCubicle
    northwest = fakeNorthwestCubicle
    southwest = fakeSouthwestCubicle

    eastMuffle = commonRoom
    southMuffle = enrichmentRoom

    regions = [administrationAudioRegion]
}
+fakeNortheastCubicle: FakeCubicle { 'northeast[weak] cubicle;ne[weak];office'
    destination = northeastCubicle
}
+fakeSoutheastCubicle: FakeCubicle { 'southeast[weak] cubicle;se[weak];office'
    destination = southeastCubicle
}
+fakeNorthwestCubicle: FakeCubicle { 'northwest[weak] cubicle;nw[weak];office'
    destination = northwestCubicle
}
+fakeSouthwestCubicle: FakeCubicle { 'southwest[weak] cubicle;sw[weak];office'
    destination = southwestCubicle
}

northeastCubicle: Cubicle { 'The Northeast Cubicle'
    desc() {
        inherited();
    }
}
populateCubicle(northeastCubicle)

JumpUpLink { ->northeastCubicleFilingCabinet
    location = northeastCubicleDesk
}

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

DefineDoorWestTo(northwestHall, administration, 'the administration door')