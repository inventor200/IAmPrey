fakePumpRoom: Room { 'The Pump Room'
    desc = wasteProcessing.desc

    north = southReservoirCorridorEntry
    floorObj = cementFloor
}

reservoirCorridor: Room { 'The Reservoir Corridor'
    "TODO: Add description. "

    north = northReservoirCorridorExit
    east = reservoirControlRoom
    south = southReservoirCorridorExit

    floorObj = cementFloor
}

+northReservoirCorridorExit: MaintenanceDoor { 'the exit door'
    desc = lockedDoorDescription
    otherSide = northReservoirCorridorEntry
    soundSourceRepresentative = northReservoirCorridorEntry
}

+southReservoirCorridorExit: MaintenanceDoor { 'the reactor access door'
    desc = lockedDoorDescription
    otherSide = southReservoirCorridorEntry
    travelBarriers = [wasteProcessingBarrier]
}

northReservoirCorridorEntry: MaintenanceDoor { 'the reservoir access door' @freezer
    desc = lockedDoorDescription
    otherSide = northReservoirCorridorExit
}

southReservoirCorridorEntry: MaintenanceDoor { 'the reservoir access south door' @fakePumpRoom
    desc = lockedDoorDescription
    otherSide = southReservoirCorridorExit
    soundSourceRepresentative = southReservoirCorridorExit
}

reservoirControlSightLine: WindowRegion;

reservoirControlRoom: Room { 'The Reservoir Control Room'
    "TODO: Add description. "

    east = reservoirDoorwayOut
    west = reservoirCorridor

    regions = [reservoirControlSightLine]
    floorObj = cementFloor

    getSpecialPeekDirectionTarget(dirObj) {
        if (dirObj == eastDir) return windowInreservoirControlRoom;
        return inherited(dirObj);
    }
}

+reservoirDoorwayOut: Passage { 'the access doorway;;door'
    "TODO: Add description. "
    destination = reservoir
}

DefineWindowPair(reservoirControlRoom, reservoir)
    vocab = 'observation window;reinforced monitoring control room[weak] reactor[weak] reservoir'
    desc = "TODO: Add description. "
    breakMsg = 'The window is reinforced, and designed to resist creatures like you. '
    remoteHeader = 'through the window'
;

reservoir: Room { 'The Reactor Reservoir'
    "TODO: Add description. "

    west = reservoirDoorwayIn
    down = diveIntoWaterConnector

    regions = [reservoirControlSightLine]
    floorObj = reservoirCatwalk

    descFrom(pov) {
        "TODO: Add remote description. ";
    }

    getSpecialPeekDirectionTarget(dirObj) {
        if (dirObj == westDir) return windowInreservoir;
        if (dirObj == downDir) return reservoirWaterFromAbove;
        return inherited(dirObj);
    }

    jumpIntoWater() {
        diveIntoWaterConnector.travelVia(gActor);
    }

    jumpOffFloor() {
        doInstead(ParkourJumpDownInto, reservoirWaterFromAbove);
    }

    canGetOffFloor = true

    roomBeforeAction() {
        if (gActionIs(JumpOffIntransitive) || gActionIs(ParkourJumpOffIntransitive) || gActionIs(Jump)) {
            jumpOffFloor();
            exit;
        }
    }
}

+diveIntoWaterConnector: TravelConnector {
    isConnectorListed = nil
    destination = reservoirStrainer

    travelDesc() {
        if (gCatMode) {
            "Your regal confidence might have been a little <i>too</i> high this time,
            but you only wonder this for a few moments before you are
            swallowed by the hot reactor water. In a split second, you think
            you see <<gSkashekName>>, searching the water for something.\b
            <i><q><<gCatName>>?!</q></i> he screams, already sputtering
            through the water after you, and ditching an armful of harvested kelp.\b
            You thrash and reach the steamy surface, as the channel
            carries you and your echoing, panicked meows. Everything in you
            is devoted to a singular purpose: <i>Stay above water!</i>\b
            You hit the grate wall of the strainer stage, where the water
            becomes colder. You wrap your limbs around the its metal structure,
            desperate to not be swept away further.\b
            Running along the wall of the channel&mdash;like a
            <i>giant spider</i>&mdash;is
            <<gSkashekName>>. He sweeps you up in his arms and holds you close.\b
            <q>Bloody <i>hell</i>, <<gCatNickname>>, there are <i>other</i> ways to
            get my attention! I guess we're skipping bath time, then...</q>";
            finishGameMsg(ftVictory, [
                finishOptionCredits
            ]);
        }
        else { //TODO: Write this better
            "You dive into the water, and the channel carries you. ";
        }
        inherited();
    }
}

+reservoirDoorwayIn: Passage { 'the control room doorway;;door'
    "TODO: Add description. "
    destination = reservoirControlRoom
}

+reservoirWaterFromAbove: Decoration { 'water;;reservoir pit below down'
    "TODO: Add description. "

    decorationActions = [
        Examine, Search, SearchClose, SearchDistant, PeekInto, PeekThrough,
        ParkourJumpGeneric, ParkourJumpOverTo, ParkourJumpDownTo,
        ParkourJumpOverInto, ParkourJumpDownInto
    ]
    notImportantMsg = '{The subj cobj} {is} too far away. '
    
    dobjFor(Search) asDobjFor(Examine)
    dobjFor(SearchClose) asDobjFor(Examine)
    dobjFor(SearchDistant) asDobjFor(Examine)
    dobjFor(PeekInto) asDobjFor(Examine)
    dobjFor(PeekThrough) asDobjFor(Examine)
    dobjFor(LookThrough) asDobjFor(Examine)

    dobjFor(ParkourJumpGeneric) asDobjFor(ParkourJumpDownInto)
    dobjFor(ParkourJumpOverTo) asDobjFor(ParkourJumpDownInto)
    dobjFor(ParkourJumpDownTo) asDobjFor(ParkourJumpDownInto)
    dobjFor(ParkourJumpOverInto) asDobjFor(ParkourJumpDownInto)
    dobjFor(ParkourJumpDownInto) {
        preCond = nil
        remap = nil
        verify() { }
        check() { }
        action() {
            reservoir.jumpIntoWater();
        }
        report() { }
    }
}

reservoirCatwalk: Floor { 'catwalk;;platform floor ground deck ledge edge'
    "TODO: Add description. "
}

reservoirStrainer: Room { 'The Strainer Stage'
    "TODO: Add description. "

    north = "Swimming against the current would only dead-end you in the reservoir. "
    south = "The grate won't budge. "
}

DefineDoorWestTo(lifeSupportBottom, reservoirStrainer, 'the reservoir access door')