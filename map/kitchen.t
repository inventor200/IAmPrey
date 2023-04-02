class StoveVentDoor: VentGrateDoor {
    vocab = 'small metal hatch;access;door'
    desc = "A small, rectangular, metal door. It looks just large enough for
    a person to go through. "
    isTransparent = nil
    includeDistCompVentGrateDoorHinge = nil
}

#define remapHoodParkour(parkourAction) \
    dobjFor(parkourAction) { \
        preCond = [actorInStagingLocation] \
        remap = nil \
        verify() { } \
        check() { } \
        action() { attemptJump(); } \
        report() { } \
    }

kitchen: Room { 'The Kitchen'
    "There are a lot of empty spaces, probably where extra utilities were
    once housed. Since only <<gSkashekName>> uses this space, there is
    no need to redundancy.\b
    An electric oven sits under a stove hood by the east wall,
    and the kitchen counter can be found beside it. A walk-in fridge
    takes up a good bit of the south wall. The northeast corner houses a metal sink. "

    north = kitchenNorthExit

    eastMuffle = reservoirCorridor
    southMuffle = reactorNoiseRoom

    mapModeDirections = [&north, &west]
    familiar = roomsFamiliarByDefault
}

+walkInFridge: Fixture {
    vocab = 'walk-in fridge;walk[weak] in[weak] walkin;refrigerator cooler'
    desc = "A large, narrow, walk-in fridge. It can open and close, and store a
    large number of items. A person could probably fit inside, but they
    would not be unable to see the room outside. "

    contType = In
    isLikelyContainer() {
        return true;
    }
    isOpenable = true
    isEnterable = true
    canHearOut = true
    //isLit = true
    litWithin() { return true; }
    roomTitle = 'Inside of the walk-in fridge'
    interiorDesc = "The inside of the fridge is cold and claustrophobic,
    and {i} cannot see the rest of <<getOutermostRoom().roomTitle>> from
    in here.<<end>> "
    betterStorageHeader
}

+Sink;

+kitchenCounter: CounterTop {
    desc = "A granite counter top. Perfect for all of one's kitchen needs. "
    adjectivesFromItems = 'kitchen '
}
++LowFloorHeight;
++ClimbOverLink -> kitchenOven;

+kitchenOven: Fixture { 'oven;kitchen electric stove[weak];stove top[weak] stovetop'
    "A simple electric oven, but the knobs and
    control panel have apparently been removed, likely to
    prey-proof the device. "

    betterStorageHeader

    IncludeDistComponent(TinyDoorHandle)

    remapOn: SubComponent {
        isBoardable = true
    }
    remapIn: SubComponent {
        bulkCapacity = 4
        maxSingleBulk = 2

        isOpenable = true
        isTransparent = true
    }

    cannotCookMsg =
        'The knobs and control panel have all been removed, because <<gSkashekName>>
        knew a prey clone would try something. '

    dobjFor(SwitchOff) asDobjFor(SwitchVague)
    dobjFor(SwitchOn) asDobjFor(SwitchVague)
    dobjFor(SwitchVague) {
        verify() {
            illogical(cannotCookMsg);
        }
    }

    getBonusLocalPlatforms() {
        if (kitchenVentGrate.isIn(kitchenStoveHood.remapIn)) return [kitchenVentGrate];
        return nil;
    }
}
++LowFloorHeight;

++kitchenStoveHood: Fixture { 'stove hood;range fume vapor;vent'
    "A large, metal hood. When smoke and fumes become too intense,
    a cook can turn on its fan to clear the air. "

    missingFanMsg =
        'Apparently, the fan has actually been removed from the stove hood. '

    dobjFor(SwitchOff) asDobjFor(SwitchVague)
    dobjFor(SwitchOn) asDobjFor(SwitchVague)
    dobjFor(SwitchVague) {
        verify() {
            illogical(missingFanMsg);
        }
    }
    subLocation = &remapOn

    dobjFor(LookUnder) asDobjFor(LookIn)
    dobjFor(SlideUnder) {
        preCond = nil
        remap = nil
        verify() { }
        check() { }
        action() {
            extraReport('(the stove hood is over the oven)\n');
            doInstead(ParkourClimbUpTo, kitchenOven);
        }
        report() { }
    }

    remapIn: SubComponent {
        hiddenIn = [kitchenVentGrate]

        canBonusReachDuring(obj, action) {
            return kitchenStoveHood.canBonusReachDuring(obj, action);
        }
    }
    remapOn: SubComponent {
        canBonusReachDuring(obj, action) {
            return kitchenStoveHood.canBonusReachDuring(obj, action);
        }
    }

    isLikelyContainer() {
        return true;
    }
    
    canBonusReachDuring(obj, action) {
        if (action.ofKind(LookIn) || action.ofKind(LookUnder)) {
            return obj == kitchen || obj == kitchenCounter;
        }
        return nil;
    }

    attemptJump() {
        if (kitchenVentGrate.isIn(remapIn)) {
            "{I} can't find a way of staying in or on the stove hood.
            <<if gActor.isIn(kitchenVentGrate.stagingLocation)
            >>However, {i} <i>probably</i> could enter the little hatch
            inside...<<end>> ";
        }
        else {
            "{I} scope out the surfaces of the stove hood,
            but then {i} think {i} see something inside... ";
        }
    }

    remapHoodParkour(ParkourJumpGeneric)
    remapHoodParkour(ParkourClimbGeneric)
    remapHoodParkour(ParkourClimbUpTo)
    remapHoodParkour(ParkourClimbOverTo)
    remapHoodParkour(ParkourClimbDownTo)
    remapHoodParkour(ParkourJumpUpTo)
    remapHoodParkour(ParkourJumpOverTo)
    remapHoodParkour(ParkourJumpDownTo)
    remapHoodParkour(ParkourClimbUpInto)
    remapHoodParkour(ParkourClimbOverInto)
    remapHoodParkour(ParkourClimbDownInto)
    remapHoodParkour(ParkourJumpUpInto)
    remapHoodParkour(ParkourJumpOverInto)
    remapHoodParkour(ParkourJumpDownInto)
    remapHoodParkour(Climb)
    remapHoodParkour(ClimbUp)
    remapHoodParkour(Enter)
    remapHoodParkour(Board)
    remapHoodParkour(StandOn)
}

+missingFan: Unthing { 'hood fan'
    '<<kitchenStoveHood.missingFanMsg>>'
}

+missingStoveControls: Unthing { 'knob;oven stove control[weak] heating cooking;panel button controls[weak] burner coil'
    '<<kitchenOven.cannotCookMsg>>'
    ambiguouslyPlural = true
}

+kitchenNorthExit: PrefabDoor { 'the Freezer door'
    freezerDoorDesc
    isFreezerDoor = true
    otherSide = kitchenNorthEntry
    soundSourceRepresentative = kitchenNorthEntry

    airlockDoor = true
    pullHandleSide = true
}

kitchenNorthEntry: PrefabDoor { 'the Kitchen access door'
    freezerDoorDesc
    isFreezerDoor = true
    otherSide = kitchenNorthExit
    location = freezer

    airlockDoor = true
    pullHandleSide = nil
}

DefineDoorWestTo(southHall, kitchen, 'the Kitchen door')

kitchenVentGrate: StoveVentDoor {
    otherSide = reservoirVentGrate
    isListed = true

    stagingLocation = kitchenOven.remapOn
    exitLocation = kitchenOven.remapOn

    travelDesc = "It's awkward, but {i} climb up into the stove hood,
    and pull {myself} through the small metal hatch {i} find inside.\b
    {I} land on a crate, on the other side of the wall. "

    rerouteBasicJumpIntoForPlatform(ParkourJumpGeneric, GoThrough)
}

reservoirVentGrate: StoveVentDoor {
    location = reservoirCorridorCrate
    otherSide = kitchenVentGrate
    soundSourceRepresentative = (otherSide)

    dobjFor(LookThrough) {
        verify() {
            illogical('This hatch is inside the stove hood,
            so not much is visible at all. ');
        }
    }

    travelDesc = "Using the crate to reach, {i} climb into the small,
    metal hatch. {I} find {myself} in the stove hood, and drop down
    atop the oven. "
}
