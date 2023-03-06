serverRoomBottom: Room { 'Server Access'
    "TODO: Add description. "

    up = serverLadderBottom
    east = itOffice

    northMuffle = lifeSupportTop
    southeastMuffle = deliveryRoom
    southMuffle = breakroom

    roomDaemon() {
        "A <<freezer.coldSynonyms>> <<one of>>mist<<or>>fog<<at random>>
        <<one of>>falls<<or>>rolls<<at random>>
        <<one of>>down from<<or>>out of<<at random>> the
        <<one of>>opening above<<or>>opening<<or
        >>hatch in the ceiling<<or>>ladder<<at random>>. ";
        inherited();
    }
}

+serverFog: ColdFog;

+serverLadderBottom: ClimbUpIntoPlatform { 'ladder;access in[prep] the ceiling[n];opening hatch hole'
    "TODO: Add description. "

    travelDesc =
        "{I} quickly<<one of>>{aac} 
        climb{s/ed}<<or>>{aac} 
        scale{s/ed}<<at random>> the ladder<<if gActorIsPrey>>,
        <<freezer.subclauseAmbienceOnEntry>><<end>>. "

    destination = serverRoomTop
    travelBarriers = [catUpALadderBarrier]
}

catUpALadderBarrier: TravelBarrier {
    canTravelerPass(actor, connector) {
        return actor != cat;
    }
    
    explainTravelBarrier(actor, connector) {
        "Maybe you could have achieved this in your youth, but you are an old
        (but still very regal!) cat now. You might need to find another way to
        the room beyond this ladder. ";
    }
}

DefineDoorWestTo(utilityPassage, serverRoomBottom, 'the server access door')

serverRoomTop: Room { 'The Chilled Server Room'
    "TODO: Add description. "

    down = serverLadderTop
    out asExit(down)
    
    atmosphereObj = freezingAtmosphere
    isFreezing = true
}

+serverLadderTop: ClimbDownIntoPlatform { 'ladder;access in[prep] the floor[n];opening[weak] hatch[weak] hole[weak]'
    "TODO: Add description. "

    travelDesc =
        "<<if gActorIsCat>>It's a little painful for your old
        joints, but you manage to land on one of the rungs before
        getting on the floor.<<else
        >>{I} quickly<<one of>>{aac}
        climb{s/ed} down<<or>>{aac}
        descend{s/ed}<<at random>> the ladder<<if gActorIsPrey>>,
        <<freezer.subclauseAmbienceOnExit>><<end>>.<<end>> "

    destination = serverRoomBottom
}

+dataCableAlcove: FixedPlatform { 'floor[n] of[prep] the alcove;data cable to[prep] delivery[n] room[weak] raised'
    "Part of the room is built atop the northwest corner of the Delivery Room,
    which creates the shape of the raised alcove to the southeast. "

    simplyRerouteClimbInto = true
}
++AwkwardFloorHeight;
++dataCableServerExit: ClimbDownEnterPlatform { 'opening;extra[weak] in[prep] the floor[n] alcove[weak] cable[weak];hole hatch gap space[weak] exit'
    "There is a wide opening or hatch in the floor of the alcove.
    Through it, data cables feed into the Delivery Room.\b
    You notice some extra space around the cables, as if there
    are too few of them being threaded through. "

    oppositeLocalPlatform = deliveryRoomCables
    destination = deliveryRoom

    dobjFor(SqueezeThrough) asDobjFor(TravelVia)

    travelDesc = "You squeeze through the opening, climb down the data cables,
        and come to an uneasy landing on the northwest artificial womb. "
}
++serverRoomCables: ClimbDownPlatform { 'cables;server black dark insulated data hanging[weak] on[prep] ceiling[n];bundles[weak] wires cords connections'
    "Thick, dark, data cables feed into an
    <<if gPlayerChar.isIn(dataCableAlcove)>>alcove<<else
    >>opening in the floor of the alcove<<end
    >>, from multiple server banks in the small room. "
    plural = true

    dobjFor(SqueezeThrough) asDobjFor(TravelVia)

    asAliasFor(dataCableServerExit)
}

// Has access to coolingDuctUpperOuterGrate