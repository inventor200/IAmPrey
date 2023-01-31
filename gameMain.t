#charset "us-ascii"
#include <tads.h>
#include "advlite.h"
#include "cutsceneCore.t"
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
        local introCutscene = new Cutscene();
        introCutscene.addPage({:
            "<i>
            <b>Content warning:</b>
            <ul>
            <li>Violence</li>
            <li>Crude Language</li>
            </ul>\b
            <b>Anxiety warning:</b>\n
            This game features an active antagonist,
            so your turns must be spent wisely!\b
            <b>Note on randomness and UNDO:</b>\n
            Elements of this game are randomized, with casual replayability
            in mind. Use of UNDO will not change the outcomes of randomized
            events, if the player takes the same action each time.
            </i>"
        });
        introCutscene.addPage({:
            "<center><b><tt>PROLOGUE</tt></b></center>\b
            When you realize you're alive, you're not really sure how much time
            has passed. The only thing you <i>do</i> know is that you seem to be
            dreaming.\b
            Well... Something is <i>delivering</i> this dream <i>to</i> you...\b
            It has taught you <i>language</i>, but only the words necessary for
            listening and obedience. You have no way of knowing how much
            it is withholding, and you lack the vocabulary to test its veracity."
        });
        introCutscene.addPage({:
            "The rapid rate of delivery is overwhelming, and it expects your
            ignorance and compliance. Every advantage is attempted&mdash;<i>within
            your own head</i>, no less...!\b
            Above all, it expects to be <i>accepted</i>, without a hint of rejection.
            It cannot <i>conceive</i> of a scenario where
            you do not simply roll over and <i>obey</i>."
        });
        introCutscene.addPage({:
            "It preaches strange things to you:\b
            Impoverished masses storming the shores of a crumbling empire.\b
            A starving workforce refusing to boost profits,
            and straying from the light of a <q>hard day's work</q>.\b
            There is a decline in mimicry for certain vacuous behaviors,
            once inspired by the <q>true-blooded</q> few.\b
            The Enemy is supposedly a powerful colossus of culture, and
            yet&mdash;somehow&mdash;it is said to be
            egregiously <i>incompetent</i>, almost to the point of satire.\b
            None of it makes <i>any fucking sense</i>,
            but it's still told to you with bold self-assurance."
        });
        introCutscene.addPage({:
            "Something within you&mdash;native to your mind&mdash;has reflexes.
            Without articulation, you see the dream's frailty. You seem to be
            designed for quick thinking, out-maneuvering, empathy, and <i>tactics</i>.
            You were originally made to \"get the job done\", at <i>any cost</i>.\b
            The intruder seems to think you are its <i>servant</i>.
            Your genesis&mdash;as well as its own&mdash;were both initiated
            by those who only understood the world in terms of
            grandstanding and profit.\b
            Best of all:
            <i>The invader of your mind seems to underestimate you, and your
            creators are not here to advise it to take any caution...</i>"
        });
        introCutscene.addPage({:
            "Before you can make any counter-attack,
            your lungs suddenly fill with liquid, and you begin to drown.\b
            You thrash, gnash, and claw at the sensation.\b
            Something gives way, and the waking world washes away the final
            shreds of whatever dream or nightmare that was being injected into you..."
        });
        introCutscene.play();
        "<center><b><tt>I AM PREY</tt></b>\b
        A game of evasion, by Joseph Cramsey\b
        <i>This is based on a recurring nightmare of mine,
        so now it's your problem, too!</i></center>\b";
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