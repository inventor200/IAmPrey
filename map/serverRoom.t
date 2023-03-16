serverRoomBottom: Room { 'Server Access'
    "The room is pretty barren; the server banks are all found upstairs.\b
    A ladder can be found here, and the exit to the <<hyperDir('east')>>
    goes to the IT Office, while a door to the <<hyperDir('west')>> goes
    to the Utility Corridor. "

    up = serverLadderBottom
    east = itOffice

    northMuffle = lifeSupportTop
    southeastMuffle = deliveryRoom
    southMuffle = breakroom

    ceilingObj = industrialCeiling
    floorObj = cementFloor

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
    "A ladder provides access to the chilled room above.
    It is inclined, and looks more like a steep stairway. "

    travelDesc =
        "{I} quickly<<one of>>{aac} 
        climb{s/ed}<<or>>{aac} 
        scale{s/ed}<<at random>> the ladder<<if gActorIsPrey>>,
        <<freezer.subclauseAmbienceOnEntry>><<end>>. "

    destination = serverRoomTop
}

DefineDoorWestTo(utilityPassage, serverRoomBottom, 'the server access door')

serverRoomTop: Room { 'The Chilled Server Room'
    "The room here would normally be engulfed in total darkness, if it weren't
    for light spilling in from the ladder, in addition to all the running lights
    of the surrounding server banks. "

    down = serverLadderTop
    out asExit(down)
    
    atmosphereObj = freezingAtmosphere
    isFreezing = true
}

//TODO: Refuse to break these
+serverBanks: Decoration { 'server banks;;computers servers'
    "Large, black cabinets full of running computers, wired together in
    complex ways. Thick cables run from their tops, and feed into an alcove
    to the southeast.\b
    To the north, there is a large vent grate, which pumps freezing air into
    the room. "
}

+serverLadderTop: ClimbDownIntoPlatform { 'ladder;access in[prep] the floor[n];opening[weak] hatch[weak] hole[weak]'
    "A ladder allows travel to the floor below. "

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