ventDuctCeiling: Ceiling {
    vocab = 'ventilation duct ceiling;vent air[weak] top;roof panel[weak]'
    desc = ventDuctWalls.desc
    
    filterResolveList(np, cmd, mode) {
        if (np.matches.length > 1) {
            np.matches = np.matches.subset({m: m.obj != self});
        }
    }
}

ventDuctWalls: Walls { 'ventilation duct walls;vent air[weak];sides siding panels[weak]'
    "Plain, bare metal panels form the walls, ceiling, and floor of the duct. "
}

ventDuctFloor: Floor {
    vocab = 'ventilation duct floor;vent air[weak] bottom;ground panel[weak]'
    desc = ventDuctWalls.desc

    filterResolveList(np, cmd, mode) {
        if (np.matches.length > 1) {
            np.matches = np.matches.subset({m: m.obj != self});
        }
    }
}

ventilationNode: Room { 'The Central Ventilation Node'
    "<<if !gCatMode>>{I} find that {i} have to crawl here, confined to a
    claustrophobic duct of metal panels.<<end>>
    The Central Ventilation Node is the heart of air circulation systems
    for the core facility rooms. <<if gCatMode>>It also serves as {my}
    favorite eating spot!<<end>> There is hardly any light here,
    which{dummy} forces {me} to rely entirely on {my} natural night vision.\b
    The ducts contort into four directions: <<hyperDir('north')>> to
    the Assembly Shop, <<hyperDir('east')>> to Lab A, <<hyperDir('south')>>
    to Life Support, and <<hyperDir('west')>> to the Common Room. "
    ceilingObj = ventDuctCeiling
    wallsObj = ventDuctWalls
    floorObj = ventDuctFloor
    ambienceObject = ventNodeAmbience

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

+FakePlural, Decoration { 'bones;human clone one[weak] of[prep];remains corpse hand bone'
    "The bones of what could be a human hand, if the fingers were not so long. "
    fakeSingularPhrase = 'bone'
}

+assemblyShopExitVentGrate: VentGrateDoor {
    vocab = 'Assembly Shop ' + defaultVentVocab + defaultVentVocabSuffix
    otherSide = assemblyShopNodeGrate
    isConnectorListed = true

    travelDesc = "{I} climb through, and land on a CNC machine in the Assembly Shop. "
}
+lifeSupportTopExitVentGrate: VentGrateDoor {
    vocab = 'Life Support ' + defaultVentVocab + defaultVentVocabSuffix
    otherSide = lifeSupportTopNodeGrate
    isConnectorListed = true

    travelDesc = "{I} climb through, and find {myself} on the structure of the
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
        >>{I} know the route well.\b
        <<end>>{I} smoothly exit the Ventilation Node,
        and skillfully find {my} footing on the ledge.\b
        <<else>><<if commonRoom.getVentSurprise()
        >>{I} damn-near have a heart attack.\b
        <<end>>
        The path abruptly ends with a sharp drop to the floor, far below.
        {I} grip the sides of the vent, and carefully find {my} footing
        on the ledge.\b
        <<end>>
        {I} {am} now atop the east wall; the only wall in the
        room where the upper and lower sections aren't flush with each other. "
}

class ScrambledVentGrateDoor: VentGrateDoor {
    destinationChoices = nil
    mostLikelyDestination() {
        local choices = valToList(destinationChoices);
        if (choices.length == 0) return lifeSupportTop;
        if (choices.length == 1) return choices[1];
        local choiceIndex = skashek.getRandomResult(choices.length);
        return choices[choiceIndex];
    }
}

assemblyShopNodeGrate: ScrambledVentGrateDoor {
    vocab = defaultVentVocab + ' east' + defaultVentVocabSuffix
    location = cncMachine
    otherSide = assemblyShopExitVentGrate
    soundSourceRepresentative = (otherSide)

    destinationChoices = [lifeSupportTop, labA, commonRoom]
}
lifeSupportTopNodeGrate: ScrambledVentGrateDoor {
    vocab = 'primary[weak] fan[weak] unit[weak] ' + defaultVentVocab + ' north' + defaultVentVocabSuffix
    location = primaryFanUnit
    otherSide = lifeSupportTopExitVentGrate
    soundSourceRepresentative = (otherSide)

    destinationChoices = [assemblyShop, labA, commonRoom]
}
labANodeGrate: ScrambledVentGrateDoor {
    vocab = 'west ' + defaultVentVocab + defaultVentVocabSuffix
    location = labAShelves
    otherSide = labAExitVentGrate
    soundSourceRepresentative = (otherSide)

    destinationChoices = [lifeSupportTop, assemblyShop, commonRoom]
}
commonRoomNodeGrate: ScrambledVentGrateDoor {
    vocab = 'east ' + defaultVentVocab + ' top[weak] wall' + defaultVentVocabSuffix
    location = topOfEastWall
    otherSide = commonRoomExitVentGrate
    soundSourceRepresentative = (otherSide)

    destinationChoices = [lifeSupportTop, labA, assemblyShop]

    travelDesc = "<<if gCatMode
        >>{I} gracefully slip<<else
        >>{I} carefully (and awkwardly) shuffle atop
        the narrow ledge of the east wall, and climb<<end>>
        through the vent grate. It's only another meter before {i} reach
        <<if gCatMode>>{my} favorite eating spot:
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

    doSoundPropagation = nil

    dobjFor(Open) {
        report() {
            if (gActorIsCat) {
                "{I} open <<theName>> with {my} paws. ";
            }
            else {
                inherited();
            }
        }
    }

    makeOpen(state) {
        inherited(state);
        if (!gPlayerChar.canSee(self) && !gPlayerChar.canSee(otherSide)) return;
        if (state) {
            addSFX(ventOpenSnd);
        }
        else {
            addSFX(ventCloseSnd);
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