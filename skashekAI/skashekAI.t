#ifdef __DEBUG
VerbRule(ReportSkashekRouteToPlayer)
    ('check'|'report'|'print'|'get'|'show'|'what' 'is'|'what\'s')
    ('skashek'|'skashek\'s'|) (
        ('route'|'path') ('to'|'toward'|'towards') ('me'|'player') |
        ('hunt'|'hunting') ('route'|'path')
    )
    : VerbProduction
    action = ReportSkashekRouteToPlayer
    verbPhrase = 'report/reporting Skashek\'s route to the player'
;

DefineSystemAction(ReportSkashekRouteToPlayer)
    execAction(cmd) {
        skashek.reportPathToPlayer();
    }
;

VerbRule(FreezeSkashekAI)
    ('freeze'|'pause') ('skashek'|'ai'|)
    : VerbProduction
    action = FreezeSkashekAI
    verbPhrase = 'freeze/freezing Skashek\'s AI'
;

DefineSystemAction(FreezeSkashekAI)
    execAction(cmd) {
        skashekAIControls.isFrozen = !skashekAIControls.isFrozen;
        if (skashekAIControls.isFrozen) {
            "Skashek's AI is now frozen. ";
        }
        else {
            "Skashek's AI is now unfrozen. ";
        }
    }
;
#endif

skashekAIControls: object {
    lastTurn = -1
    currentTurn = -1
    bonusTurns = 0
    availableTurns = 0
    isFrozen = nil
    currentState = skashekIntroState

    startTurn() {
        currentTurn += 1 + bonusTurns;
        bonusTurns = 0;
        availableTurns = currentTurn - lastTurn;
    }

    endTurn() {
        lastTurn = currentTurn;
    }
}

class SkashekAIState: object {
    stateName = 'Unnamed State'
    needsGameStartSetup = nil

    activate() {
        local prevState = skashekAIControls.currentState;
        if (prevState != nil) prevState.end(self);
        #if __DEBUG_SKASHEK_ACTIONS
        "<.p>Skashek is entering a new state: <<stateName>> ";
        #endif
        skashekAIControls.currentState = self;
        if (needsGameStartSetup) {
            needsGameStartSetup = nil;
            startGameFrom();
        }
        start(prevState);
    }

    startGameFrom() { }
    start(prevState) { }
    end(nextState) { }

    // Run per-turn logic
    doTurn() { }
    // Process sounds
    doPerception() { }
    // Process player peeking at him
    doPlayerPeek() { }
    // Process player getting caught peeking
    doPlayerCaughtLooking() { }
    // Print desc from peek
    describePeekedAction() { }
    // Shows up during peek?
    showsDuringPeek() {
        return true;
    }
    // Will the player get caught peeking?
    playerWillGetCaughtPeeking() {
        return nil;
    }
}

modify skashek {
    doTurn() {
        skashekAIControls.currentState.doTurn();
    }

    doPerception() {
        skashekAIControls.currentState.doPerception();
    }

    doPlayerPeek() {
        skashekAIControls.currentState.doPlayerPeek();
        if (playerWillGetCaughtPeeking()) {
            huntCore.revokeFreeTurn();
            doPlayerCaughtLooking();
        }
    }

    doPlayerCaughtLooking() {
        skashekAIControls.currentState.doPlayerCaughtLooking();
    }

    describePeekedAction() {
        "<.p>";
        skashekAIControls.currentState.describePeekedAction();
    }

    showsDuringPeek() {
        return skashekAIControls.currentState.showsDuringPeek();
    }

    playerWillGetCaughtPeeking() {
        return skashekAIControls.currentState.playerWillGetCaughtPeeking();
    }

    playerWasSeenEntering() {
        return huntCore.playerWasSeenEntering;
    }

    getRoomFromGoalObject(goalObj) {
        if (goalObj.location == nil) return nil;
        if (goalObj.ofKind(MultiLoc)) return nil;
        local actualRoom = goalObj.getOutermostRoom();
        if (actualRoom.isMapModeRoom) {
            // Should never happen, but just in case
            actualRoom = actualRoom.actualRoom;
        }
        return actualRoom;
    }

    getBestWayTowardGoalObject(goalObj) {
        local goalRoom = getRoomFromGoalObject(goalObj);
        if (goalRoom == nil) return nil; // Can't find our way off-grid

        return getBestWayTowardGoalRoom(goalRoom);
    }

    getBestWayTowardGoalRoom(goalRoom) {
        local goalMapModeRoom = goalRoom.mapModeVersion;
        if (goalMapModeRoom == nil) return nil; // Can't find our way off-grid

        return getBestWayTowardGoalMapModeRoom(goalMapModeRoom);
    }

    getCurrentMapModeRoom() {
        if (location == nil) return nil; // Can't find our way in the void
        return getOutermostRoom().mapModeVersion;
    }

    getBestWayTowardGoalMapModeRoom(goalMapModeRoom) {
        return getBestWayBetweenMapModeRooms(
            getCurrentMapModeRoom(),
            goalMapModeRoom
        );
    }

    getBestWayBetweenMapModeRooms(mapModeRoomA, mapModeRoomB) {
        if (mapModeRoomB == nil) return nil; // Can't find our way off-grid
        if (mapModeRoomA == nil) return nil; // Can't find our way off-grid

        return mapModeRoomA.skashekRouteTable
            .findBestDirectionTo(mapModeRoomB);
    }

    getFullPathToMapModeRoom(goalMapModeRoom) {
        return getFullPathBetweenRooms(
            getCurrentMapModeRoom(),
            goalMapModeRoom
        );
    }

    getFullPathBetweenRooms(mapModeRoomA, mapModeRoomB) {
        if (mapModeRoomB == nil) return nil; // Can't find our way off-grid
        if (mapModeRoomA == nil) return nil; // Can't find our way off-grid

        local currentRoom = mapModeRoomA;
        local path = [mapModeRoomA];

        while (currentRoom != mapModeRoomB) {
            local nextDir = getBestWayBetweenMapModeRooms(
                currentRoom,
                mapModeRoomB
            );

            if (nextDir == nil) return nil;
            if (nextDir == compassAlreadyHereSignal) return path;

            currentRoom = nextDir.destination;
            path += nextDir;
        }

        if (path.length == 1) return nil;

        return path;
    }

    // If FOR ANY REASON we need to refer to the player while in map
    // mode, then this will fetch the actual player character.
    getPracticalPlayer() {
        if (gCatMode) return cat;
        return prey;
    }

    reportPathToPlayer() {
        local goalRoom = getRoomFromGoalObject(
            getPracticalPlayer()
        );
        local goalMapModeRoom = goalRoom.mapModeVersion;
        local path = getFullPathToMapModeRoom(goalMapModeRoom);

        if (path == nil) {
            "Skashek has no way to <<goalRoom.roomTitle>>. ";
            return;
        }

        "Skashek's path would be the following...";
        for (local i = 1; i <= path.length; i++) {
            if (i == 1) {
                "\n\tStarting in <<path[i].actualRoom.roomTitle>>";
            }
            else {
                "\n\t\^<<path[i].getSkashekDir()>>";
            }
        }
    }
}

#include "introState.t"
#include "catModeState.t"
#include "lurkState.t"
#include "ambushState.t"
#include "chaseState.t"
#include "reacquireState.t"
