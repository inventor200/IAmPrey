ventDuctCeiling: Ceiling {
    vocab = 'ventilation duct ceiling;vent air[weak] top;roof panel[weak]'
    desc = ventDuctWalls.desc
    ambiguouslyPlural = true
}

ventDuctWalls: Walls { 'ventilation duct walls;vent air[weak];sides siding panels[weak]'
    "Plain, bare metal panels form the walls, ceiling, and floor of the duct. "
}

ventDuctFloor: Floor {
    vocab = 'ventilation duct floor;vent air[weak] bottom;ground panel[weak]'
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

+Decoration { 'bones;human clone;remains corpse hand bone'
    "The bones of what could be a human hand, if the fingers were not so long. "
    ambiguouslyPlural = true
}

+assemblyShopExitVentGrate: VentGrateDoor {
    vocab = 'Assembly Shop ' + defaultVentVocab + defaultVentVocabSuffix
    otherSide = assemblyShopNodeGrate
    isConnectorListed = true

    travelDesc = "You climb through, and land on a CNC machine in the Assembly Shop. "
}
+lifeSupportTopExitVentGrate: VentGrateDoor {
    vocab = 'Life Support ' + defaultVentVocab + defaultVentVocabSuffix
    otherSide = lifeSupportTopNodeGrate
    isConnectorListed = true

    travelDesc = "You climb through, and find yourself on the structure of the
    primary fan unit. "
}
+labAExitVentGrate: VentGrateDoor {
    vocab = 'Lab A[weak] ' + defaultVentVocab + defaultVentVocabSuffix
    otherSide = labANodeGrate
    isConnectorListed = true

    travelDesc = "<<labAShelves.travelPreface>> the library vent grate. "
}
+commonRoomExitVentGrate: VentGrateDoor {
    vocab = 'Common Room[weak] ' + defaultVentVocab + defaultVentVocabSuffix
    otherSide = commonRoomNodeGrate
    isConnectorListed = true

    travelDesc = "<<if gCatMode
        >><<if commonRoom.getVentSurprise()
        >>You know the route well.\b
        <<end>>You smoothly exit the Ventilation Node,
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

assemblyShopNodeGrate: VentGrateDoor {
    vocab = defaultVentVocab + ' east' + defaultVentVocabSuffix
    location = cncMachine
    otherSide = assemblyShopExitVentGrate
    soundSourceRepresentative = (otherSide)
}
lifeSupportTopNodeGrate: VentGrateDoor {
    vocab = 'primary[weak] fan[weak] unit[weak] ' + defaultVentVocab + ' north' + defaultVentVocabSuffix
    location = primaryFanUnit
    otherSide = lifeSupportTopExitVentGrate
    soundSourceRepresentative = (otherSide)
}
labANodeGrate: VentGrateDoor {
    vocab = 'west ' + defaultVentVocab + defaultVentVocabSuffix
    location = labAShelves
    otherSide = labAExitVentGrate
    soundSourceRepresentative = (otherSide)
}
commonRoomNodeGrate: VentGrateDoor {
    vocab = 'east ' + defaultVentVocab + ' top[weak] wall' + defaultVentVocabSuffix
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
        the Central Ventilation Node.<<end>> "
}

class VentGrateDoor: PrefabDoor {
    desc = "Thin cross-hatch wires over a rectangular, aluminum frame.
    Someone has installed a fabricated hinge,
    making it readily-accessible to someone in a pinch. "
    airlockDoor = true
    isTransparent = true
    isVentGrateDoor = true
    isConnectorListed = nil

    skipHandle = true

    fellowMatchClass = VentGrateDoor

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

    hasPrefabMatchWith(obj) {
        return obj.ofKind(VentGrateDoor);
    }
}

DefineDistComponentFor(VentGrateDoorHinge, VentGrateDoor)
    vocab = 'vent door hinge;air[weak] grate'
    desc = "A 3D-printed, plastic hinge. This was a long-term, homemade modification. "

    isDecoration = true
    ambiguouslyPlural = true
    matchPhrases = 'hinge'
;