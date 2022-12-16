#charset "us-ascii"
#include <tads.h>
#include "advlite.h"
#include "soundBleed.t"
#include "parkour.t"

gameMain: GameMainDef {
    initialPlayerChar = me

    showIntro() {
        soundBleedCore.activate();
        new Fuse(sideRoom, &spawnBeep, 1);
        new Fuse(centerHallway, &spawnBeep, 2);
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

beepProfile: SoundProfile;

centralRoom: Room { 'Central Room'
    "The main room in the center."

    north = centerHallway
    westMuffle = sideRoom
}

+me: Actor {
    person = 2
}

+cargoShelf: ParkourPlatform { 'tall cargo shelf'
    "A tall series of cargo shelves. "
    height = damaging
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

    spawnBeep() {
        soundBleedCore.createSound(beepProfile, self);
    }
}

centerHallway: Room { 'Hallway (Center)'
    "The central section of a long hallway."

    southeast = centralRoom
    southwest = sideRoom

    spawnBeep() {
        soundBleedCore.createSound(beepProfile, self);
    }
}