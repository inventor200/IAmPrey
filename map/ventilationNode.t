ventDuctCeiling: Ceiling {
    vocab = 'ventilation duct ceiling;vent top;roof panel[weak]'
    desc = ventDuctWalls.desc
    ambiguouslyPlural = true
}

ventDuctWalls: Walls { 'ventilation duct walls;vent;sides siding panels[weak]'
    "Plain, bare metal panels form the walls, ceiling, and floor of the duct. "
}

ventDuctFloor: Floor {
    vocab = 'ventilation duct floor;vent bottom;ground panel[weak]'
    desc = ventDuctWalls.desc
    ambiguouslyPlural = true
}

ventilationNode: Room { 'The Central Ventilation Node'
    "<<if !gCatMode>>You find that you have to crawl here, confined to a
    claustrophobic duct of metal panels.<<end>>
    The Central Ventilation Node is the heart of air circulation systems
    for the core facility rooms. <<if gCatMode>>It also serves as your
    favorite eating spot!<<end>> There is hardly any light here, which forces
    you to rely entirely on your natural night vision.\b
    The ducts contort into four directions: <<hyperDir('north')>> to
    the Assembly Shop, <<hyperDir('east')>> to Lab A, <<hyperDir('south')>>
    to Life Support, and <<hyperDir('west')>> to the Common Room. "
    ceilingObj = ventDuctCeiling
    wallsObj = ventDuctWalls
    floorObj = ventDuctFloor

    north = assemblyShopExitVentGrate
    east = labAExitVentGrate
    south = lifeSupportTopExitVentGrate
    west = commonRoomExitVentGrate
}

+Decoration { 'dried blood;favorite eating;spot place evidence meal food'
    "<<if gCatMode
    >>The remains of my last meal!<<else
    >>Something probably ate a previous prey clone here...<<end>> "
    specialDesc = "A patch of dried blood and bones can be seen in the corner."
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

    travelDesc = "<<labAShelves.travelPreface>> the IT Office vent grate. "
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
    location = primaryFanUnit
    otherSide = lifeSupportTopExitVentGrate
    soundSourceRepresentative = (otherSide)
}
labANodeGrate: VentGrateDoor {
    vocab = 'primary ' + defaultVentVocab
    location = labAShelves
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