#charset "us-ascii"
#include <tads.h>
#include "advlite.h"
#define gWasFreeAction ( \
    gActionIs(SystemAction) || \
    gActionIs(ShowParkourRoutes) || \
    gActionIs(ShowParkourKey) || \
    gActionIs(Inventory) || \
    gActionIs(Examine) || \
    gActionIs(Look) \
)
#define gWasLenientAction ( \
    gWasFreeAction || \
    gActionIs(Open) || \
    gActionIs(Close) \
)
#define gWasObservantAction ( \
    gWasLenientAction || \
    gActionIs(Listen) || \
    gActionIs(Smell) || \
    gActionIs(Taste) || \
    gActionIs(LookBehind) || \
    gActionIs(LookIn) || \
    gActionIs(LookThrough) || \
    gActionIs(LookUnder) \
)
#include "awareVehicles.t"
#include "soundBleed.t"
#include "parkour.t"
#include "trinkets.t"
#if __DEBUG
//
#else
#include "ForEveryone.t"
#endif
#include "moduleUnion.t"

gameMain: GameMainDef {
    initialPlayerChar = me

    showIntro() {
        //
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

/*+vent: ParkourExit { 'vent;metal ventilation;grate'
    "A metal ventilation grate. It seems passable, but kinda high up. "
    destination = tallCrate
    height = damaging
    otherSide = subtleVent
}*/

+hallwayDoor: Door { 'hallway door'
    "The door to the hallway. "
    otherSide = centralRoomDoor
}

+cargoShelf: FixedPlatform { 'tall cargo shelf'
    "A tall series of cargo shelves. "
    isListed = true
    //climbUpLinks = [vent]
}
++DangerousFloorHeight;

++bottle: Thing { 'water bottle'
    "A difficult water bottle. "
}

++dogCage: Booth { 'dog cage'
    "A weird dog cage. "
}

+cabinet: FixedPlatform { 'tall lab cabinet'
    "A locked, metal cabinet, likely containing lab materials. "
    isListed = true

    remapIn: SubComponent {
        isOpenable = true
        isOpen = true
        isEnterable = true
    }
    remapOn: SubComponent {
        isBoardable = true
    }
}
++HighFloorHeight;
++ClimbUpLink -> cargoShelf;

++grayCrate: FixedPlatform { 'gray crate;grey'
    "A gray crate. It looks suspiciously-boring to climb on. "
    subLocation = &remapOn
    isListed = true
}

++blueCrate: FixedPlatform { 'blue crate'
    "A gray crate. It looks suspiciously-fun to climb on. "
    subLocation = &remapOn
    isListed = true
}
+++LowFloorHeight;

++cup: Thing { 'cup'
    "A ceramic cup. "
    subLocation = &remapOn
}

+me: Actor {
    person = 2
    //subLocation = &remapOn
}

+exosuit: CoveredVehicle { 'exosuit;small exo;suit'
    "A small exosuit, not much larger than a person. "
    fitForParkour = true
}

+metalCrate: FixedPlatform { 'metal crate'
    "A big metal crate, sitting alone in the corner. "
    //parkourBarriers = [fragileCrateBarrier]
}
++LowFloorHeight;

+fragileCrateBarrier: TravelBarrier {
    canTravelerPass(actor, connector) {
        return nil;
    }
    
    explainTravelBarrier(actor, connector) {
        "The crate doesn't seem very sturdy... ";
    }
}

//++ParkourProviderPath @flagPole ->desk;
//++ParkourProviderPath @flagPole ->centralRoom;

+flagPole: Fixture { 'flagpole'
    "A barren flagpole, sticking horizontally out of the wall,
    between the lab desk and metal crate. "
    isListed = true
    canSwingOnMe = true
    //parkourBarriers = [fragilePoleBarrier]
}

+fragilePoleBarrier: TravelBarrier {
    canTravelerPass(actor, connector) {
        return nil;
    }
    
    explainTravelBarrier(actor, connector) {
        "The pole seems flimsy... ";
    }
}

+desk: FixedPlatform { 'lab desk'
    "A simple lab desk. "
    isListed = true
    canSlideUnderMe = true
}
++LowFloorHeight;
++ClimbUpLink -> cabinet;
++JumpUpLink -> cargoShelf
    pathDescription = 'scale the cargo shelves'
;
++ProviderLink @flagPole ->metalCrate;

+table: FixedPlatform { 'generic table'
    "A generic table, outside of any parkour system. "
    isListed = true
}

++puzzleCube: Trinket { 'puzzle cube'
    "A 3x3 puzzle cube. "
}

/*+obviousLowVent: ParkourEasyExit { 'low vent;metal ventilation;grate'
    "A metal ventilation grate. It seems passable, and it's low to the floor. "
    isListed = true
    destination = shortCrate
    otherSide = lowVent
}*/

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

/*+subtleVent: ParkourExit { 'vent;metal ventilation;grate'
    "A metal ventilation grate. It seems passable, but kinda high up. "
    destination = cargoShelf
    height = damaging
    otherSide = vent
}*/

/*+lowVent: ParkourExit { 'low vent;metal ventilation;grate'
    "A metal ventilation grate. It seems passable, and it's low to the floor. "
    destination = centralRoom
    height = low
    otherSide = obviousLowVent
}*/

/*+tallCrate: ParkourPlatform { 'tall wooden crate'
    "A really tall wooden crate. "
    height = high
    climbUpLinks = [subtleVent]
    climbDownLinks = [shortCrate]
}*/

/*+shortCrate: ParkourPlatform { 'short wooden crate'
    "A short wooden crate. "
    height = low
    climbUpLinks = [lowVent]
    jumpUpLinks = [tallCrate]
}*/