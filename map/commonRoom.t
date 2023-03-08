commonRoomCeiling: Ceiling {
    desc =
        "The room here is taller than it should be, because the ceiling
        tiles and frames have been removed, exposing an extra meter of
        space. A support beam and ventilation duct would normally have been
        hidden behind these tiles, but the beam is exposed, and the duct
        has <i>also</i> been removed, leaving two vents on the east and
        west side of the upper ceiling. "
}

commonRoom: Room { 'The Common Room'
    "TODO: Add description. "

    ceilingObj = commonRoomCeiling

    north = assemblyShop
    //east = commonRoomNodeGrate
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
}

+enrichmentRoomHall: Passage { 'passage;curving curved;corridor hall'
    "A short passage to the <<hyperDir('south')>>, curving toward the west.
    <<standardDesc>>"

    standardDesc = 'TODO: Add description. '

    otherSide = commonRoomHall
    destination = enrichmentRoom

    dobjFor(PeekAround) asDobjFor(LookThrough)
    attachPeakingAbility('around {the dobj}')
}

+missingCeilingTiles: Unthing { 'missing ceiling[weak] tiles;;frames[weak]'
    'The ceiling tiles are gone, and likely have been for some time. '
    plural = true
}

+missingVentilationDuct: Unthing { 'missing ventilation duct;east-west east[weak] west[weak] length;shaft'
    '<<if gCatMode>>You remember<<else>>Evidence indicates<<end>>
    that a length of ventilation duct used to connect
    what are now the administration (west) and primary (east) vent grates.
    It\'s gone now, though.<<if gCatMode>> <<gSkashekName>> tore it all down
    during strange renovations.<<end>> '
}

+exposedSupportBeam: FixedPlatform { 'exposed support beam;ventilation[weak] structural north-south north[weak] south[weak];girder i-beam duct[weak] brackets'
    "A north-south structural beam.
    <<if gCatMode
    >>It used to be hidden behind the ceiling tiles, but <<gSkashekName>> tore them
    all out&mdash;along with a ventilation duct&mdash;long ago.
    You used to be able to run through
    that duct to go between administration and your secret eating spot.\b
    You still have a route, though, but it's trickier for your old bones.<<else
    >>It could have once secured a length of east-west ventilation duct,
    connecting the administration vent (west) to the primary vent (east) of this room.
    It was likely hidden behind ceiling tiles (which are also missing).<<end>> "

    canSwingOnMe = true
    stagingLocation = (gPlayerChar.isIn(topOfEastWall) ? topOfEastWall : displayShelf)
    exitLocation = commonRoom

    dobjFor(RunAcross) {
        preCond = [touchObj]
        verify() {
            inaccessible('The beam runs orthogonal to the line between the administration
            vent and primary vent. Running across the beam will just move you between
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

+displayShelf: FixedPlatform { 'display shelf;simple metal decorative'
    "A simple metal shelf for displaying decorative items. "
}
++DangerousFloorHeight;
++JumpOverLink ->exposedSupportBeam;

+topOfEastWall: FixedPlatform { 'top[n] of[prep] the east wall;e[weak] northern[weak] north[weak] n[weak] half[weak];ledge[weak]'
    "The northern half of the east wall is nearer to the primary vent.
    The southern half is actually angled toward the southwest.\b
    There seems to be enough of a ledge there to stand on. "
}
++DangerousFloorHeight;
++JumpOverLink ->exposedSupportBeam;

+topOfOtherWalls: Unthing { 'top[n] of[prep] the wall;west[weak] w[weak] south[weak] s[weak] north[weak] n[weak] upper lower'
    'Only the east wall seems to have a ledge. The upper and lower sections of the
    other walls are flush with each other. '
}

+chessTable: FixedPlatform { 'empty chess table;game chessboard'
    "An empty table against the west wall, with a chess board engraved into it. "
}
++LowFloorHeight;
++JumpUpLink ->snackFridge;

+snackFridge: Fixture { 'snack fridge'
    "TODO: Description. "

    betterStorageHeader

    remapOn: SubComponent {
        isBoardable = true
        betterStorageHeader
    }
    remapIn: SubComponent {
        isOpenable = true
        bulkCapacity = actorCapacity
        maxSingleBulk = 1
    }
}
++HighFloorHeight;
++JumpUpLink ->displayShelf;

//TODO: There is a support beam across the ceiling, exposed because the ceiling
// tiles were removed. Falling from this beam is a hard impact, and it takes more turns
// to reach it from the ground than Skashek will allow.
// This support beam can be used as a swing between the east and west sides of the room.
// It is only possible to climb from the floor to the vent leading to the central node.
// You must swing from that vent to access the one by admin.
// The one by admin is a hard fall to the floor.
// You can jump onto the beam, and jump to the other vent, but it is costly and loud
// Swinging is quieter and takes less energy
//DefineVentGrateEastTo(commonRoom, displayShelf, administration, nil, 'administration vent grate;ventilation;door', 'common room vent grate;ventilation;door')