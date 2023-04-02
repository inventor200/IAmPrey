labA: Room { 'Lab A'
    "The Lab is a sizeable room, largely built around a control surface table.\b
    A tall set of storage shelves can be found in the southwest corner, and the
    north wall houses a massive screen, across from the whiteboard on the south wall. "

    northMuffle = northHall
    westMuffle = lifeSupportTop
    southMuffle = library

    mapModeDirections = [&east]
    familiar = roomsFamiliarByDefault
    roomNavigationType = escapeRoom
}
+Whiteboard;
+Decoration { 'massive screen;big giant;display'
    "The screen is populated by a brilliant array of moving colors. "
}
+FixedPlatform { 'control surface table'
    "The table is the biggest one in the facility, and acts as one giant
    controller. When the humans still lived here, the table was capable of
    tracking hand movements, and showing diagrams on its surface, allowing
    for a high level of control between multiple users. "
    isBoardable = true
    isLikelyContainer() {
        return true;
    }

    cannotTurnOnMsg = 'There does not seem to be a way to turn on the control surface. '
    alreadyTurnedOffMsg = 'The control surface is already off. '

    dobjFor(SwitchVague) { verify() { illogical(cannotTurnOnMsg); } }
    dobjFor(SwitchOn) { verify() { illogical(cannotTurnOnMsg); } }
    dobjFor(TurnOn) { verify() { illogical(cannotTurnOnMsg); } }
    dobjFor(SwitchOff) { verify() { illogical(alreadyTurnedOffMsg); } }
    dobjFor(TurnOff) { verify() { illogical(alreadyTurnedOffMsg); } }
}

+labAShelves: MetalShelves {
    desc = "Rough, metal shelves for storing boxes and equipment.
    They are arranged into an L-shape, to conform to the corner of
    the room. "

    isSafeParkourPlatform = true

    travelPreface = '{I} find {myself} on a tall set of storage shelves,
        placed in the corner of the room, and in reach of'
}
++AwkwardFloorHeight;

labAToLibraryVentGrate: VentGrateDoor {
    vocab = 'Library ' + defaultVentVocab + ' south' + defaultVentVocabSuffix
    location = labAShelves
    otherSide = LibraryTolabAVentGrate

    travelDesc = "{I} carefully find {my} balance on a stepladder,
    once {i}{'m} on the other side of the vent grate. "
}

LibraryTolabAVentGrate: VentGrateDoor {
    vocab = 'Lab A ' + defaultVentVocab + ' north' + defaultVentVocabSuffix
    location = stepLadder
    otherSide = labAToLibraryVentGrate
    soundSourceRepresentative = (otherSide)

    travelDesc = "<<labAShelves.travelPreface>> the primary vent grate. "
}

DefineDoorEastTo(northeastHall, labA, 'the door[n] to[prep] Lab[n] A[weak]')