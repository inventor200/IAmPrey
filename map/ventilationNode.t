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

    north = assemblyShopExitVentGrate
    east = labAExitVentGrate
    south = lifeSupportTopExitVentGrate
    west = commonRoomExitVentGrate
}

+assemblyShopExitVentGrate: VentGrateDoor {
    vocab = 'assembly shop ' + defaultVentVocab
    otherSide = assemblyShopNodeGrate
    isConnectorListed = true
}
+lifeSupportTopExitVentGrate: VentGrateDoor {
    vocab = 'life support ' + defaultVentVocab
    otherSide = lifeSupportTopNodeGrate
    isConnectorListed = true
}
+labAExitVentGrate: VentGrateDoor {
    vocab = 'lab A ' + defaultVentVocab
    otherSide = labANodeGrate
    isConnectorListed = true
}
+commonRoomExitVentGrate: VentGrateDoor {
    vocab = 'common room ' + defaultVentVocab
    otherSide = commonRoomNodeGrate
    isConnectorListed = true

    travelDesc = "<<if gCatMode
        >><<if commonRoom.getVentSurprise()
        >>You know the route well.\b
        <<end>>You smoothly exit the ventilation node,
        and skillfully find your footing on the ledge.\b
        <<else>><<if commonRoom.getVentSurprise()
        >>You damn-near have a heart attack.\b
        <<end>>
        The path abruptly ends with a sharp drop to the floor, far below.
        You grip the sides of the vent, and carefully find your footing
        on the ledge.\b
        <<end>>
        You are now atop the east wall; the only wall in the
        room where the upper and lower sections aren't flush with each other. "
}

//TODO: Put these in interesting locations
assemblyShopNodeGrate: VentGrateDoor {
    vocab = defaultVentVocab
    location = assemblyShop
    otherSide = assemblyShopExitVentGrate
    soundSourceRepresentative = (otherSide)
}
lifeSupportTopNodeGrate: VentGrateDoor {
    vocab = defaultVentVocab
    location = lifeSupportTop
    otherSide = lifeSupportTopExitVentGrate
    soundSourceRepresentative = (otherSide)
}
labANodeGrate: VentGrateDoor {
    vocab = defaultVentVocab
    location = labA
    otherSide = labAExitVentGrate
    soundSourceRepresentative = (otherSide)
}
commonRoomNodeGrate: VentGrateDoor {
    vocab = 'primary ' + defaultVentVocab
    location = topOfEastWall
    otherSide = commonRoomExitVentGrate
    soundSourceRepresentative = (otherSide)

    travelDesc = "<<if gCatMode
        >>You gracefully slip<<else
        >>You carefully (and awkwardly) shuffle atop
        the narrow ledge of the east wall, and climb<<end>>
        through the vent grate. It's only another meter before you reach
        <<if gCatMode>>your favorite eating spot:
        The Central Ventilation Node.<<else>>
        the central ventilation node.<<end>> "
}

class VentGrateDoor: Door {
    desc = "Thin cross-hatch wires over a rectangular, aluminum frame.
    Someone has installed a fabricated hinge,
    making it readily-accessible to someone in a pinch. "
    airlockDoor = true
    isTransparent = true
    isVentGrateDoor = true
    isConnectorListed = nil

    skipHandle = true

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

DefineDistComponentFor(VentGrateDoorHinge, VentGrateDoor)
    vocab = 'vent door hinge;grate'
    desc = "A 3D-printed, plastic hinge. This was a long-term, homemade modification. "

    isDecoration = true
    ambiguouslyPlural = true
;