#include "inventorCore/versionInfo.h"

#define gFormatForScreenReader transScreenReader.formatForScreenReader
#define gActorIsPlayer (gActor == gPlayerChar)

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
#define __ALLOW_DEBUG_ACTIONS true
#else
#define cached new transient
#define __ALLOW_DEBUG_ACTIONS nil
#endif

#include "inventorCore/preferencesCore.t"
#include "inventorCore/printUtilities.t"
#include "inventorCore/gMoverCore.t"
#include "inventorCore/reachMod.t"
#include "inventorCore/vectorTools.t"
#include "inventorCore/compliantHyperlinks.t"
#include "inventorCore/betterChoices.t"
#include "inventorCore/forEveryone.t"
#include "inventorCore/cutsceneCore.t"
#include "inventorCore/disamDirection.t"
#include "inventorCore/distributedComponents.t"
#include "inventorCore/basicHandles.t"
#include "inventorCore/fakePlural.t"
#include "inventorCore/homeHaver.t"
#include "inventorCore/awareVehicles.t"
#include "inventorCore/trinkets.t"
#include "inventorCore/zippable.t"
#include "inventorCore/wardrobe.t"
#include "inventorCore/inventorCoreMisc.t"