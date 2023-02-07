#charset "us-ascii"
#include <tads.h>
#include "advlite.h"

#define gFormatForScreenReader gameMain.formatForScreenReader

#define gDirectCmdStr(command) \
    (gFormatForScreenReader ? \
        ('<b>' + (command).toUpper() + '</b>') : \
        aHrefAlt((command).toLower(), (command).toUpper(), \
        '<b>' + (command).toUpper() + '</b>') \
    )

#include "betterChoices.t"

// Begin compile modes
#define __IS_CAT_GAME true

#if __DEBUG
///////////////////////////////////////////////
////        PROLOGUE CONTROLLER:          ////
/////////////////////////////////////////////
/*()*/  #define __SHOW_PROLOGUE nil   /*()*/
///////////////////////////////////////////

// End compile modes

#else
// DO NOT ALTER:
#define __SHOW_PROLOGUE true
// ^- This is the non-debug behavior!!!
#endif

#include "forEveryone.t"
#include "cutsceneCore.t"
#include "awareVehicles.t"
#include "huntCore.t"
#include "soundBleed.t"
#include "parkour.t"
#include "trinkets.t"
#include "moduleUnion.t"
#include "preyPlayer.t"
#include "cat.t"
#include "prologue.t"

gameMain: GameMainDef {
    initialPlayerChar = (gCatMode ? pgCat: prey)

    formatForScreenReader = nil

    showIntro() {
        showPrologue;
    }
}

versionInfo: GameID {
    IFID = '8c61fd61-7595-4277-a7ba-af9d18a6fc0c'
    name = 'I Am Prey'
    byline = 'by Joey Cramsey'
    htmlByline = 'by <a href="mailto:josephcsoftware@gmail.com">Joey Cramsey</a>'
    version = '1'
    authorEmail = 'josephcsoftware@gmail.com'
    desc = 'A horror-lite science fiction game of evasion.'
    htmlDesc = 'A horror-lite science fiction game of evasion.'
    showAbout() {
        "I Am Prey is a game about situational awareness, evasion, and
        escape.\b
        Parkour mechanics are available for the complex navigation of obstacles,
        and spreading soundwaves reward a stealthy playstyle,
        especially because the predator is <i>always listening!</i>\b
        Ideally, the player will <i>never</i> want to be seen,
        but last-minute tricks can be used to ditch the predator during a chase!\b
        Find all seven pieces of the environment suit, and escape through the
        emergency airlock to win!\b
        <i>This game is designed for replayability, and can normally be finished
        in one sitting!</i>";
    }
    showCredit() {
        "<i>I stand on the shoulders of giants...</i>\n
        Author:
        <a href='mailto:josephcsoftware@gmail.com'>Joey Cramsey</a>\n
        Special thanks to my partners, friends, as well as the excellent community
        over at <a href='https://intfiction.org/'>Intfiction Forum</a>!\n
        Adv3Lite library:
        <a href='https://www.ifwiki.org/Eric_Eve'>Eric Eve</a>\n
        TADS 3:
        <a href='https://www.ifwiki.org/Michael_J._Roberts'>Michael J Roberts</a>";
    }
}

modify statusLine {
    showStatusHtml() {
        "<<statusHTML(0)>><<aHref('look around', nil, nil, AHREF_Plain)>>";
        showStatusLeft();
            
        /* 
         *   end the left portion and start the right portion, then
         *   generate the <A HREF> to link the score to a FULL SCORE
         *   command 
         */
        //"<./a></a><<statusHTML(1)>><<aHref('full score', nil, nil, AHREF_Plain)>>";
        "<./a></a><<statusHTML(1)>>";
        showStatusRight();

        "<./a></a><<statusHTML(2)>>";

        /* add the status-line exit list, if desired */
        if (gPlayerChar.location!= nil) {
            gPlayerChar.location.showStatuslineExits();
        }
    }

    showStatusRight() {
        local turnVerb = 'survived';
        if (gCatMode) {
            if (huntCore.wasBathTimeAnnounced) {
                turnVerb = 'stinky!';
            }
            else {
                turnVerb = 'explored';
            }
        }
        local turnStr = 'turn';
        if (gTurns != 1) turnStr += 's';
        "<b><<gTurns>> <<turnStr>> <<turnVerb>></b>";
    }
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

+exosuit: CoveredVehicle { 'exosuit;small exo;suit'
    "A small exosuit, not much larger than a person. "
    fitForParkour = true
}

+metalCrate: FixedPlatform { 'metal crate'
    "A big metal crate, sitting alone in the corner. "
    //parkourBarriers = [fragileCrateBarrier]
    /*doAccident(actor, traveler, path) {
        traveler.moveInto(centralRoom);
        "{I} {swing} on the flagpole, and land{s/ed} on the metal crate,
        but it collapses, and {i} {am} thrown to the floor. ";
    }*/
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
    /*doProviderAccident(actor, traveler, path) {
        traveler.moveInto(centralRoom);
        "{I} {swing} on the flagpole, but only for a moment.
        With a horrible, metal-wrenching sound, the pole snaps
        free of the wall, dropping {me} to the floor. ";
    }*/
}

/*+fragilePoleBarrier: TravelBarrier {
    canTravelerPass(actor, connector) {
        return nil;
    }
    
    explainTravelBarrier(actor, connector) {
        "The pole seems flimsy... ";
    }
}*/

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
    //doNotSuggestGetOff = true
}

++puzzleCube: Trinket { 'puzzle cube'
    "A 3x3 puzzle cube. "
}

++postItNote: Thing { 'note;postit post-it post sticky'
    "A simple note. "
    readDesc = "Hello world!"
}

/*+obviousLowVent: ParkourEasyExit { 'low vent;metal ventilation;grate'
    "A metal ventilation grate. It seems passable, and it's low to the floor. "
    isListed = true
    destination = shortCrate
    otherSide = lowVent
}*/

+eastGap: Fixture { 'east gap;eastern;divide'
    "The eastern wall has a hole, and a sudden drop-off meets the floor there. "
    isListed = true
    canJumpOverMe = true
}

+AwkwardProviderBridge @eastGap ->subtleRoom @westGap;

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

// East of central room
subtleRoom: Room { 'Subtle Room'
    "Just a subtle room. "
    north = eastHallway
}

+westGap: Fixture { 'west gap;western;divide'
    "The western wall has a hole, and a sudden drop-off meets the floor there. "
    isListed = true
    canJumpOverMe = true
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