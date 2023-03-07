ventDuctCeiling: Ceiling { 'ventilation duct ceiling;vent top;roof panel[weak]'
    "TODO: Add description. "
    ambiguouslyPlural = true
}

ventDuctWalls: Walls { 'ventilation duct walls;vent;sides siding panels[weak]'
    "TODO: Add description. "
}

ventDuctFloor: Floor { 'ventilation duct floor;vent bottom;ground panel[weak]'
    "TODO: Add description. "
    ambiguouslyPlural = true
}

ventilationNode: Room { 'The Central Ventilation Node'
    "TODO: Add description. "
    ceilingObj = ventDuctCeiling
    wallsObj = ventDuctWalls
    floorObj = ventDuctFloor

    east = labAEntryVentGrate
    west = commonRoomEntryVentGrate
}

//TODO: Put these in interesting locations
DefineNodeVentGrateNorthTo(ventilationNode, lifeSupportTop, nil, 'life support vent grate;ventilation;door')
DefineNodeVentGrateSouthTo(ventilationNode, assemblyShop, nil, 'assembly shop vent grate;ventilation;door')
DefineVentGrateEastTo(ventilationNode, nil, commonRoom, nil, 'common room vent grate;ventilation;door', 'primary vent grate;main central node ventilation;door')
DefineVentGrateWestTo(ventilationNode, nil, labA, nil, 'lab A vent grate;ventilation;door', 'primary vent grate;main central node ventilation;door')

modify commonRoomEntryVentGrate {
    isConnectorListed = true
}

modify labAEntryVentGrate {
    isConnectorListed = true
}

class VentGrateDoor: Door {
    desc = "Thin cross-hatch wires over a rectangular, aluminum frame.
    Someone has installed a fabricated hinge,
    making it readily-accessible to someone in a pinch. "
    airlockDoor = true
    isTransparent = true
    isVentGrateDoor = true
    isConnectorListed = nil

    dobjFor(Open) {
        report() {
            if (gActorIsCat) {
                "You open <<theName>> with your paws. ";
            }
            else {
                inherited();
            }
        }
    }

    travelVia(actor) {
        inherited(actor);
        makeOpen(nil);
        "<.p>(\^<<theName>> falls closed behind{dummy} {me}.) ";
    }
}

ventGrateDoorHinge: MultiLoc, Thing { 'vent door hinge;grate'
    "A 3D-printed, plastic hinge. This was a long-term, homemade modification. "

    initialLocationClass = VentGrateDoor
    isDecoration = true
}