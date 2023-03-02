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
        scale{s/ed}<<at random>> the ladder<<if gActor == gPlayerChar>>,
        <<freezer.subclauseAmbienceOnEntry>><<end>>. "

    destination = serverRoomTop
}

DefineDoorWestTo(utilityPassage, serverRoomBottom, 'the server access door')

serverRoomTop: Room { 'The Chilled Server Room'
    "TODO: Add description. "

    down = serverLadderTop
    out asExit(down)
    
    atmosphereObj = freezingAtmosphere
    isFreezing = true
}

+serverLadderTop: ClimbDownIntoPlatform { 'ladder;access in[prep] the floor[n];opening hatch hole'
    "TODO: Add description. "

    travelDesc =
        "{I} quickly<<one of>>{aac}
        climb{s/ed} down<<or>>{aac}
        descend{s/ed}<<at random>> the ladder<<if gActor == gPlayerChar>>,
        <<freezer.subclauseAmbienceOnExit>><<end>>. "

    destination = serverRoomBottom
}

// Has access to coolingDuctUpperOuterGrate