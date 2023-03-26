commonRoomCeiling: industrialCeiling {
    desc = "The room here is taller than it should be, because the ceiling
    tiles and frames have been removed, exposing an extra meter of
    space. A support beam and ventilation duct would normally have been
    hidden behind these tiles, but the beam is exposed, and the duct
    has <i>also</i> been removed, leaving two vents on the east and
    west side of the upper ceiling. "

    notImportantMsg = (gActor.isIn(exposedSupportBeam) ?
        '{The dobj} {is} not important. '
        :
        '{That dobj} {is} too far above you. '
    )
    
    contType = On

    getOutermostRoom() {
        return commonRoom;
    }
}

+exposedSupportBeam: FixedPlatform { 'exposed support beam;ventilation[weak] structural north-south north south;girder i-beam duct[weak] brackets'
    "A north-south structural beam.
    <<if gCatMode
    >>It used to be hidden behind the ceiling tiles, but <<gSkashekName>> tore them
    all out&mdash;along with a ventilation duct&mdash;long ago.
    You used to be able to run through
    that duct to go between administration and your secret eating spot.\b
    You still have a route, though, but it's trickier for your old bones.<<else
    >>It could have once secured a length of east-west ventilation duct,
    connecting the west vent to the east vent of this room.
    It was likely hidden behind ceiling tiles (which are also missing).<<end>> "

    cannotSwingOnMsg = 'The beam is a little too thick to swing on. '

    omitFromStagingError() {
        return nil;
    }

    dobjFor(RunAcross) {
        preCond = [touchObj]
        verify() {
            inaccessible('The beam runs orthogonal to the line between the west
            vent and east vent. Running across the beam will just move you between
            the north and south walls. ');
        }
    }

    doAccident(actor, traveler, path) {
        "<.p>It's<<if gCatMode>>
        <<one of>>rough<<or>>hard<<or>>awkward<<or>>painful<<at random>>,
        but you leap across the divide, and come to a careful landing on the beam.
        You do a quick stretch before continuing.
        <<else>>
        terrifying, but you jump across the divide, and catch yourself on the
        beam. You manage to pull yourself up, and find your balance.
        <<end>>";
    }
}
++FallDownPath ->commonRoom;

commonRoom: Room { 'The Common Room'
    "<<if gCatMode
    >>You remember when <<gSkashekName>> went absolutely <i>wild</i> in here
    for a few days. He tore out all the ceiling tiles, and ripped out a length
    of ventilation duct, leaving a support beam and two vents exposed.
    That duct was your route from Administration to your favorite eating spot,
    and you're still grumpy about it.
    <<else
    >>This room looks like it's being renovated, except all the tools and
    scraps of trash are nowhere to be found. Someone seems to have torn out
    the ceiling tiles, leaving a support beam (and two vents) exposed.
    <<end>>\b
    Against the west wall, a chess table and fridge sit next to each other, and a
    decorative display shelf sits above both of them.
    To the <<hyperDir('north')>> is the Assembly Shop, and a passage
    to the <<hyperDir('south')>> (curving to the west) leads to the
    Enrichment Room. "

    ceilingObj = commonRoomCeiling
    wallsObj = topOfOtherWalls
    floorObj = carpetedFloor

    north = assemblyShop
    south = enrichmentRoomHall

    northwestMuffle = directorsOffice
    eastMuffle = lifeSupportTop
    westMuffle = administration

    hasVentSurprise = true

    getVentSurprise() {
        local hadSurprise = hasVentSurprise;
        hasVentSurprise = nil;
        return hadSurprise;
    }

    mapModeDirections = [&north, &south]
    familiar = roomsFamiliarByDefault

    /*filterResolveList(np, cmd, mode) {
        filterParkourList(np, cmd, mode, parkourModule);
    }
    
    filterParkourList(np, cmd, mode, pm) {
        if (np.matches.length > 1) {
            local eastWallMatched = nil;
            for (local i = 1; i <= np.matches.length; i++) {
                local matchObj = np.matches[i].obj;
                if (matchObj == topOfEastWall || matchObj == topOfEastWall.parkourModule) {
                    eastWallMatched = true;
                    break;
                }
            }
            if (eastWallMatched) {
                np.matches = np.matches.subset({m: m.obj != pm && m.obj != self });
            }
        }
    }*/
}

+Unthing { 'two vents'
    'The west vent and east vent are high up on the west and east walls,
    above the altitude which would normally have ceiling tiles. '
    matchPhrases = ['two vents', 'both vents']
}

+enrichmentRoomHall: Passage { 'passage;curving curved;corridor hall'
    "A short passage to the <<hyperDir('south')>>, curving toward the west. "

    otherSide = commonRoomHall
    destination = enrichmentRoom

    dobjFor(PeekAround) asDobjFor(LookThrough)
    attachPeakingAbility('around {the dobj}')
}

+missingCeilingTiles: Unthing { 'missing ceiling[weak] tiles;;frames[weak]'
    'The ceiling tiles are gone, and likely have been for some time. '
    plural = true
}

+missingVentilationDuct: Unthing { 'missing ventilation duct;east-west east west length;shaft'
    '<<if gCatMode>>You remember<<else>>Evidence indicates<<end>>
    that a length of ventilation duct used to connect
    what are now the west and east vent grates.
    It\'s gone now, though.<<if gCatMode>> <<gSkashekName>> tore it all down
    during strange renovations.<<end>> '
}

//TODO: Put a plant on this
+displayShelf: FixedPlatform { 'display shelf;simple metal decorative'
    "A simple metal shelf for displaying decorative items. "
}
++DangerousFloorHeight;
++JumpOverLink ->exposedSupportBeam;

+topOfEastWall: FixedPlatform { 'east wall;e northern north n half[weak] top[n] of[prep];ledge[weak]'
    "The northern half of the east wall is nearer to the primary vent.
    The southern half is actually angled toward the southwest.\b
    There seems to be enough of a ledge there to stand on. "

    matchPhrases = ['east wall', 'e wall', 'wall']

    isLikelyContainer() {
        return true;
    }
}
++DangerousFloorHeight;
++JumpOverLink ->exposedSupportBeam;

+topOfOtherWalls: Unthing { 'wall[weak];west w south s north n top[n] of[prep] other'
    'Only the east wall seems to have a ledge. The upper and lower sections of the
    other walls are flush with each other. '

    ambiguouslyPlural = true

    matchPhrases = [
        'west wall', 'w wall',
        'north wall', 'n wall',
        'south wall', 's wall'
    ]
}

+chessTable: FixedPlatform { 'chess[weak] table'
    "An empty table with a chess board engraved into it. "
}
++LowFloorHeight;
++JumpUpLink ->snackFridge;
++Decoration { 'chess board;empty[weak] game;chessboard board gameboard'
    "The chess board is carved into the table. "
    decorationActions = [Examine, Take, TakeFrom]
    cannotTakeMsg = 'The chess board is carved into the table,
        and not separate from it. '
}
++Unthing { 'chess[weak] pieces;game[weak];pawn knight rook queen king bishop'
    'The chess board is clear of any pieces. '
    ambiguouslyPlural = true
}

+snackFridge: Fridge {
    vocab = 'snack fridge'
}
++HighFloorHeight;
++JumpUpLink ->displayShelf;

commonRoomToAdministrationVentGrate: VentGrateDoor {
    vocab = 'Administration ' + defaultVentVocab + ' admin west' + defaultVentVocabSuffix
    location = displayShelf
    otherSide = administrationToCommonRoomVentGrate
}

administrationToCommonRoomVentGrate: VentGrateDoor {
    vocab = 'Common Room[weak] ' + defaultVentVocab + ' east' + defaultVentVocabSuffix
    location = northeastCubicleFilingCabinet
    subLocation = &remapOn
    otherSide = commonRoomToAdministrationVentGrate
    soundSourceRepresentative = (otherSide)

    travelDesc = "<<if gCatMode
        >><<if commonRoom.getVentSurprise()
        >>You know the route well.\b
        <<end>>Passing from Administration, in one practiced motion,
        you find yourself on a display shelf, high above the floor.<<
        else>><<if commonRoom.getVentSurprise()
        >>Your heart lurches.\b
        <<end>>
        The path abruptly ends with a sharp drop to the floor, far below.
        You grip the sides of the vent, and carefully find your footing
        on a convenient display shelf.<<end>> "
}