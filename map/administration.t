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
+cubicleName##FilingCabinet: Fixture { \
    vocab = 'filing cabinet;office paper papers metal;drawer drawers' \
    desc = "TODO: Add description. \
        This will have individual drawers in the full release. " \
    betterStorageHeader \
    remapOn: SubComponent { \
        isBoardable = true \
        betterStorageHeader \
    } \
    remapIn: SubComponent { \
        isOpenable = true \
        bulkCapacity = actorCapacity \
        maxSingleBulk = 1 \
    } \
} \
++HighFloorHeight;

#define standardCubicleDesc "TODO: Add description. "
class Cubicle: Room {
    out = administration

    regions = [administrationAudioRegion]
}

//TODO: Implement cabinet drawers

administration: Room { 'Administration'
    "TODO: Add description. "

    northeast = northeastCubicle
    southeast = southeastCubicle
    northwest = northwestCubicle
    southwest = southwestCubicle

    eastMuffle = commonRoom
    southMuffle = enrichmentRoom

    regions = [administrationAudioRegion]
}

northeastCubicle: Cubicle { 'The Northeast Cubicle'
    standardCubicleDesc
}
populateCubicle(northeastCubicle)

JumpUpLink { ->northeastCubicleFilingCabinet
    location = northeastCubicleDesk
}

southeastCubicle: Cubicle { 'The Southeast Cubicle'
    standardCubicleDesc
}
populateCubicle(southeastCubicle)

northwestCubicle: Cubicle { 'The Northwest Cubicle'
    standardCubicleDesc
}
populateCubicle(northwestCubicle)

southwestCubicle: Cubicle { 'The Southwest Cubicle'
    standardCubicleDesc
}
populateCubicle(southwestCubicle)

DefineDoorWestTo(northwestHall, administration, 'the administration door')