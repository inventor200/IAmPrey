#include "versionInfo.h"

#define gFormatForScreenReader transScreenReader.formatForScreenReader
#define gDefaultPOV 1

string template <<free action>> freeAction;
string template <<free actions>> freeActions;
string template <<wait for player>> waitForPlayer;
string template <<remember>> formatRemember;
string template <<note>> formatNote;
string template <<warning>> formatWarning;

// Macro keyword "cached" acts like "new" for preinit cache data.
// If this is a debug build, then the data is not transient, to
// allow the use of save files.
// In release versions, it WILL be transient, slimming down saves
// quite a bit.
#ifdef __DEBUG
#define cached new
#else
#define cached new transient
#endif

#include "betterChoices.t"

// Begin compile modes
#define __IS_MAP_TEST nil
#define __BANISH_SKASHEK true

#ifdef __DEBUG

////////////////////////////////////////////////
/////        PROLOGUE CONTROLLER:          ////
//////////////////////////////////////////////

             #define __SHOW_PROLOGUE nil
            #define __FAST_DIFFICULTY 4
           #define __TEST_ROOM lifeSupportBottom
          #define __SKASHEK_START nil
         #define __SKASHEK_STATE nil
        #define __SKASHEK_FROZEN nil
       #define __SKASHEK_TOOTHLESS nil
      #define __SKASHEK_IMMOBILE nil
     #define __SKASHEK_NO_TARGET nil
    #define __SKASHEK_ALLOW_TESTING_LURK nil
   #define __SKASHEK_ALLOW_TESTING_LURK_GOAL nil
  #define __SKASHEK_ALLOW_TESTING_CHASE nil
 #define __ALLOW_CLS true
#define __DEBUG_PREFS nil

// End compile modes
#else
// DO NOT ALTER:
#include "defaultSettings.h"
// ^- This is the non-debug behavior!!!
#endif

#define gActorIsPlayer (gActor == gPlayerChar)
#define gActorIsPrey (gActor == prey)
#define gActorIsCat (gActor == cat)
#define gEndingOptionsWin preySong, [finishOptionCredits, finishOptionUndo, finishOptionAmusing]
#define gEndingOptionsLoss skashekSong, [finishOptionCredits, finishOptionUndo]
#define actorCapacity 10
#define actorBulk 25
#include "forEveryone.t"
#include "cutsceneCore.t"
#include "disamDirection.t"
#include "distributedComponents.t"
#include "moddedSearch.t"
#include "awareVehicles.t"
#define gCatMode huntCore.inCatMode
#define gPreyMode (!huntCore.inCatMode)
#define gSkashekName skashek.globalParamName
#define gCatName (huntCore.printApologyNoteForPG())
#define gCatNickname (huntCore.printApologyNoteForPG(true))
#include "invSoundCore.t"
#include "moddedActors.t"
#include "cat.t"
#include "preyPlayer.t"
#include "skashek.t"
#include "soundBleed.t"
#include "sneakyDoors.t"
#include "huntCore.t"
#include "parkour.t"
#include "trapsAndTracks.t"
#include "trinkets.t"
#include "moduleUnion.t"
#include "prologuePrefs.t"
#include "musicPlayer.t"
#include "prologue.t"
#include "epilogue.t"
#include "preciseHelp.h"
#include "wardrobe.t"
#include "enviroSuit.t"
#include "smartInventory.t"
#include "computers.t"
#include "mapMode.t"
#include "map/map.h"
#include "miscMods.t"