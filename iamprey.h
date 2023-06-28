#include "inventorCore.h"

#define gDefaultPOV 1

string template <<free action>> freeAction;
string template <<free actions>> freeActions;

// Begin compile modes
#define __IS_MAP_TEST nil
#define __BANISH_SKASHEK true

#ifdef __DEBUG

////////////////////////////////////////////////
/////        PROLOGUE CONTROLLER:          ////
//////////////////////////////////////////////

             #define __SHOW_PROLOGUE nil
            #define __FAST_DIFFICULTY 4
           #define __TEST_ROOM hangar
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

// End compile modes
#else
// DO NOT ALTER:
#include "defaultSettings.h"
// ^- This is the non-debug behavior!!!
#endif

#define gActorIsPrey (gActor == prey)
#define gActorIsCat (gActor == cat)
#define gEndingOptionsWin preySong, [finishOptionCredits, finishOptionUndo, finishOptionAmusing]
#define gEndingOptionsLoss skashekSong, [finishOptionCredits, finishOptionUndo]
#define actorCapacity 10
#define actorBulk 25
#include "moddedSearch.h"
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
#include "sneakyDoors.h"
#include "huntCore.t"
#include "shashekAI.h"
#include "parkour.h"
#include "trapsAndTracks.t"
#include "moduleUnion.t"
#include "prologuePrefs.t"
#include "musicPlayer.t"
#include "prologue.t"
#include "epilogue.t"
#include "preciseHelp.h"
#include "outfitDefs.t"
#include "enviroSuit.t"
#include "smartInventory.t"
#include "computers.h"
#include "mapMode.t"
#include "map/map.h"
#include "miscMods.t"