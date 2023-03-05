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

+serverLadderTop: ClimbDownIntoPlatform { 'ladder;access in[prep] the floor[n];opening hatch hole'
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

// Has access to coolingDuctUpperOuterGrate