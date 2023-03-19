class StoveVentDoor: VentGrateDoor {
    vocab = 'small metal hatch;access;door'
    desc = "A small, rectangular, metal door. It looks just large enough for
    a person to go through. "
    isTransparent = nil
    includeDistCompVentGrateDoorHinge = nil
}

kitchen: Room { 'The Kitchen'
    "TODO: Add description.\b
    An electric oven sits under a stove hood by the east wall,
    and the kitchen counter can be found beside it.\b
    An exit door is to the <<hyperDir('west')>>, and the freezer door is
    to the <<hyperDir('north')>>. "

    north = kitchenNorthExit

    eastMuffle = reservoirCorridor
    southMuffle = reactorNoiseRoom

    mapModeDirections = [&north, &west]
    familiar = roomsFamiliarByDefault
}

+kitchenCounter: FixedPlatform { 'counter;kitchen counter[weak];top[weak] countertop'
    "A granite counter top. Perfect for all of one's kitchen needs. "
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
}
++LowFloorHeight;

++kitchenStoveHood: ClimbUpEnterPlatform { 'stove hood;range fume vapor;vent'
    "A large, metal hood. When smoke and fumes become too intense,
    a cook can turn on its fan to clear the air. "

    missingFanMsg =
        'Apparently, the fan has actually been removed from the stove hood. '
    
    hiddenIn = [kitchenVentGrate]

    dobjFor(SwitchOff) asDobjFor(SwitchVague)
    dobjFor(SwitchOn) asDobjFor(SwitchVague)
    dobjFor(SwitchVague) {
        verify() {
            illogical(missingFanMsg);
        }
    }

    contType = In
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

    dobjFor(TravelVia) {
        verify() { }
        check() { }
        action() {
            revealStoveHoodDoor();
            doInstead(GoThrough, kitchenVentGrate);
        }
        report() { }
    }

    revealStoveHoodDoor() {
        if (!kitchenVentGrate.isIn(self)) {
            moveHidden(&hiddenIn, self);
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

    travelDesc = "It's awkward, but you climb up into the stove hood,
    and pull yourself through the small metal hatch you find inside.\b
    You land on a crate, on the other side of the wall. "
}

reservoirVentGrate: StoveVentDoor {
    location = reservoirCorridorCrate
    otherSide = kitchenVentGrate
    soundSourceRepresentative = (otherSide)

    travelVia(actor) {
        kitchenStoveHood.revealStoveHoodDoor();
        inherited(actor);
    }

    dobjFor(LookThrough) {
        verify() {
            illogical('This hatch is inside the stove hood,
            so not much is visible at all. ');
        }
    }

    travelDesc = "Using the crate to reach, you climb into the small,
    metal hatch. You find yourself in the stove hood, and drop down
    atop the oven. "
}
