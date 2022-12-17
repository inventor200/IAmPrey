#charset "us-ascii"
#include <tads.h>
#include "advlite.h"
#define gWasFreeAction (gAction.ofKind(SystemAction))
#define gWasLenientAction (gAction.ofKind(SystemAction) || gActionIs(Look))
#define gWasObservantAction (gAction.ofKind(SystemAction) || gActionIs(Look) || gActionIs(Listen) || gActionIs(Smell))
#include "soundBleed.t"
#include "parkour.t"

gameMain: GameMainDef {
    initialPlayerChar = me

    showIntro() {
        soundBleedCore.activate();
    }
}

versionInfo: GameID {
    IFID = '8c61fd61-7595-4277-a7ba-af9d18a6fc0c'
    name = 'I Am Prey'
    byline = 'by Joey Cramsey'
    htmlByline = 'by <a href="mailto:josephcsoftware@gmail.com">Joey Cramsey</a>'
    version = '1'
    authorEmail = 'josephcsoftware@gmail.com'
    desc = 'A cat-and-mouse science fiction horror game.'
    htmlDesc = 'A cat-and-mouse science fiction horror game.'
}

centralRoom: Room { 'Central Room'
    "The main room in the center."

    north = hallwayDoor
    westMuffle = sideRoom
}

+vent: ParkourExit { 'vent;metal ventilation;grate'
    "A metal ventilation grate. It seems passable, but kinda high up. "
    destination = tallCrate
    height = damaging
    travelDesc = "{I} climb{s/ed} into the vent. "
    otherSide = subtleVent
}

+hallwayDoor: Door { 'hallway door'
    "The door to the hallway. "
    otherSide = centralRoomDoor
}

+me: Actor {
    person = 2
}

+cargoShelf: ParkourPlatform { 'tall cargo shelf'
    "A tall series of cargo shelves. "
    height = damaging
    climbUpLinks = [vent]
}

++bottle: Thing { 'water bottle'
    "A difficult water bottle. "
}

++dogCage: Booth { 'dog cage'
    "A weird dog cage. "
}

+cabinet: ParkourPlatform { 'tall lab cabinet'
    "A locked, metal cabinet, likely containing lab materials. "
    height = high
    climbUpLinks = [cargoShelf]
}

+desk: ParkourPlatform { 'lab desk'
    "A simple lab desk. "
    climbUpLinks = [cabinet]
    jumpUpLinks = [cargoShelf]
}

+table: Platform { 'generic table'
    "A generic table, outside of any parkour system. "
}

++cup: Thing { 'cup'
    "A ceramic cup. "
}

sideRoom: Room { 'Side Room'
    "The additional room to the side."

    north = centerHallway
    eastMuffle = centralRoom
}

longHallway: SenseRegion {
    //
}

centerHallway: Room { 'Hallway (Center)'
    "The central section of a long hallway. "

    southeast = centralRoomDoor
    southwest = sideRoom
    east = eastHallway

    regions = [longHallway]
}

+centralRoomDoor: Door { 'central room door'
    "The door to the central room. "
    otherSide = hallwayDoor
}

eastHallway: Room { 'Hallway (East)'
    "The eastern section of a long hallway. "
    west = centerHallway
    south = subtleRoom

    regions = [longHallway]
}

subtleRoom: Room { 'Subtle Room'
    "Just a subtle room. "
    north = eastHallway
}

+subtleVent: ParkourExit { 'vent;metal ventilation;grate'
    "A metal ventilation grate. It seems passable, but kinda high up. "
    destination = cargoShelf
    height = damaging
    travelDesc = "{I} climb{s/ed} into the vent. "
    otherSide = vent
}

+tallCrate: ParkourPlatform { 'tall wooden crate'
    "A really tall wooden crate. "
    height = high
    climbUpLinks = [subtleVent]
}