VerbRule(ToggleMapMode)
    ('toggle'|'switch'|) 'map' ('mode'|)
    : VerbProduction
    action = ToggleMapMode
    verbPhrase = 'toggle/toggling map mode'
;

DefineIAction(ToggleMapMode)
    execAction(cmd) {
        if (mapModeDatabase.inMapMode) {
            mapModeDatabase.mapModeOff();
        }
        else {
            mapModeDatabase.mapModeOn();
        }
    }
    turnsTaken = 0
;

VerbRule(SetMapModeOn)
    ('set'|'turn'|) 'map' ('mode'|) 'on' |
    ('open'|'enter') 'map' ('mode'|)
    : VerbProduction
    action = SetMapModeOn
    verbPhrase = 'set/setting map mode on'
;

DefineIAction(SetMapModeOn)
    execAction(cmd) {
        if (mapModeDatabase.inMapMode) {
            "You are already in map mode. ";
            exit;
        }
        else {
            mapModeDatabase.mapModeOn();
        }
    }
    turnsTaken = 0
;

VerbRule(SetMapModeOff)
    ('set'|'turn'|) 'map' ('mode'|) 'off' |
    ('close'|'exit'|'leave'|'get' 'out' 'of') 'map' ('mode'|)
    : VerbProduction
    action = SetMapModeOff
    verbPhrase = 'set/setting map mode off'
;

DefineIAction(SetMapModeOff)
    execAction(cmd) {
        if (mapModeDatabase.inMapMode) {
            mapModeDatabase.mapModeOff();
        }
        else {
            "You are not in map mode. ";
            exit;
        }
    }
    turnsTaken = 0
;

VerbRule(RecenterMap)
    'home' |
    ('center'|'recenter') 'map'
    : VerbProduction
    action = RecenterMap
    verbPhrase = 'recenter/recentering map'
;

DefineIAction(RecenterMap)
    execAction(cmd) {
        if (mapModeDatabase.inMapMode) {
            mapModePlayer.moveInto(mapModeStart);
            mapModeStart.lookAroundWithin();
        }
        else {
            "You are not in map mode. ";
            exit;
        }
    }
    turnsTaken = 0
;

VerbRule(MapModeCompass)
    ('check'|) ('compass'|'directions') |
    'where' 'to' ('next'|) |
    'next' ('direction'|'way')
    : VerbProduction
    action = MapModeCompass
    verbPhrase = 'check/checking compass'
;

DefineIAction(MapModeCompass)
    execAction(cmd) {
        mapModeDatabase.checkCompass();
    }
    turnsTaken = 0
;

modify GoTo {
    turnsTaken = 0

    execAction(cmd) {
        if (gDobj == nil) {
            say(mapModeDatabase.notOnMapMsg);
            exit;
        }
        else {
            mapModeDatabase.setGoto(gDobj);
        }
    }
}

modify Continue {
    turnsTaken = 0
    
    exec(cmd) {
        MapModeCompass.exec(cmd);
    }
}

#ifdef __DEBUG
VerbRule(DumpRouteTable)
    'dump' 'route' 'table'
    : VerbProduction
    action = DumpRouteTable
    verbPhrase = 'dump/dumping route table'
;

DefineIAction(DumpRouteTable)
    execAction(cmd) {
        mapModeDatabase.getMapLocation().dumpRouteTable();
    }
    turnsTaken = 0
;
#endif

modify Room {
    mapModeVersion = nil
    actualRoom = nil
    isMapModeRoom = nil
    mapModeDirections = nil

    initMapModeVersion() {
        mapModeVersion = MapModeRoom.createInstance(self);
        mapModeVersion.preinitThing();
        mapModeDatabase.allRooms.append(mapModeVersion);
    }
}

mapModeDatabase: object {
    inMapMode = nil
    firstTimeMapMode = nil
    actualPlayerChar = nil
    mapModeStart = nil
    compassTarget = nil

    allRooms = static new Vector()

    notOnMapMsg = 'You cannot see that on your map. '

    setGoto(target) {
        local room = target;
        if (!target.ofKind(Room)) {
            room = target.getOutermostRoom();
        }
        if (room.isMapModeRoom) {
            room = room.actualRoom;
        }
        
        if (room.mapModeVersion == nil) {
            say(notOnMapMsg);
            exit;
        }

        if (getMapLocation().findBestDirectionTo(room.mapModeVersion) == nil) {
            "You cannot see a way there on your map. ";
        }

        compassTarget = room;

        "Compass set to: <<compassTarget.roomTitle>> ";
    }

    checkCompass() {
        if (compassTarget == nil) {
            "You have not set your compass yet.\n
            Use the GO TO command.\n
            \tExample: GO TO HANGAR";
            exit;
        }

        getMapLocation().findBestDirectionTo(compassTarget.mapModeVersion);
    }

    getMapLocation() {
        checkMapEntry();
        local currentMapModeRoom = gPlayerChar.getOutermostRoom();
        if (!inMapMode) {
            currentMapModeRoom = currentMapModeRoom.mapModeVersion;
        }
        return currentMapModeRoom;
    }

    checkMapEntry() {
        if (inMapMode) return;
        if (gPlayerChar.getOutermostRoom().mapModeVersion == nil) {
            "Your current location is not visible on the map. ";
            exit;
        }
    }

    mapModeOn() {
        checkMapEntry();
        inMapMode = true;
        "<.p><tt>MAP MODE IS NOW ON.</tt><.p>";
        if (!firstTimeMapMode) {
            firstTimeMapMode = true;
            "In map mode, you explore a simplified version of the world.
            Your available actions will be limited, but you will also not
            spend turns.<.p>";
        }
        actualPlayerChar = gPlayerChar;
        mapModeStart = actualPlayerChar.getOutermostRoom().mapModeVersion;
        mapModePlayer.moveInto(mapModeStart);
        setPlayer(mapModePlayer);
        mapModeStart.lookAroundWithin();
    }

    mapModeOff() {
        inMapMode = nil;
        "<.p><tt>MAP MODE IS NOW OFF.</tt><.p>";
        setPlayer(actualPlayerChar);
        actualPlayerChar.getOutermostRoom().lookAroundWithin();
    }

    resetPathCalculation() {
        for (local i = 1; i <= allRooms.length; i++) {
            allRooms[i].pathCalculationScore = allRooms.length + 2;
        }
    }

    calculatePathBetween(startMapRoom, endMapRoom) {
        startMapRoom.populateRouteTable();
        resetPathCalculation();
        startMapRoom.calculateRouteTo(endMapRoom, 0);
    }
}

mapModePlayer: Actor { 'avatar;;me self myself'
    "You are as you appear in your own imagination. "
}

//TODO: Implement (secret) connectors
//TODO: Implement skashek route table
class MapModeDirection: object {
    construct(_dirProp, _dest, _conn) {
        dirProp = _dirProp;
        destination = _dest;
        connector = _conn;
    }
    dirProp = nil
    destination = nil
    connector = nil

    getDirOrder() {
        if (dirProp == &north) return 1;
        if (dirProp == &northeast) return 2;
        if (dirProp == &east) return 3;
        if (dirProp == &southeast) return 4;
        if (dirProp == &south) return 5;
        if (dirProp == &southwest) return 6;
        if (dirProp == &west) return 7;
        if (dirProp == &northwest) return 8;
        if (dirProp == &up) return 9;
        if (dirProp == &down) return 10;
        if (dirProp == &in) return 11;
        return 12;
    }

    getHyperDir() {
        if (dirProp == &north) return 'to the ' + hyperDir('north');
        if (dirProp == &northeast) return 'to the ' + hyperDir('northeast');
        if (dirProp == &east) return 'to the ' + hyperDir('east');
        if (dirProp == &southeast) return 'to the ' + hyperDir('southeast');
        if (dirProp == &south) return 'to the ' + hyperDir('south');
        if (dirProp == &southwest) return 'to the ' + hyperDir('southwest');
        if (dirProp == &west) return 'to the ' + hyperDir('west');
        if (dirProp == &northwest) return 'to the ' + hyperDir('northwest');
        if (dirProp == &up) return 'by going ' + hyperDir('up');
        if (dirProp == &down) return 'by going ' + hyperDir('down');
        if (dirProp == &in) return 'by going ' + hyperDir('in');
        return 'by going ' + hyperDir('out');
    }

    sayDir(prefix, screenReaderPrefix) {
        if (gFormatForScreenReader) {
            "<<screenReaderPrefix>>go to <<destination.actualRoom.roomTitle>>
            <<getHyperDir()>>.";
        }
        else {
            "<<prefix>><<destination.actualRoom.roomTitle
            >>\n\t(<<getHyperDir()>>)";
        }
    }
}

class MapModeRoom: Room {
    construct(_actual) {
        actualRoom = _actual;
        vocab = _actual.vocab;
        roomTitle = _actual.roomTitle + ' (IN MAP MODE)';
        inherited Room.construct();
        knownDirections = new Vector();
        mapRoomIndex = mapModeDatabase.allRooms.length + 1;
    }

    knownDirections = nil;
    isMapModeRoom = true
    familiar = true
    mapRoomIndex = -1

    pathCalculationScore = 10000
    routeTable = nil

    populateRouteTable() {
        if (routeTable != nil) return;
        routeTable = new Vector();
        for (local i = 1; i <= mapModeDatabase.allRooms.length; i++) {
            routeTable.append(nil);
        }
    }

    desc() {
        if (knownDirections == nil || knownDirections.length == 0) {
            "The map does not show any way out of here. ";
            return;
        }
        "The map shows the following exits:";
        for (local i = 1; i <= knownDirections.length; i++) {
            knownDirections[i].sayDir('\n', '\nYou can ');
        }
    }

    createLinks() {
        local directionList = actualRoom.mapModeDirections;
        for (local i = 1; i <= directionList.length; i++) {
            local dirProp = directionList[i];
            local actualDestination = actualRoom.(dirProp);
            if (!actualDestination.ofKind(Room)) {
                actualDestination = actualDestination.destination.getOutermostRoom();
            }
            if (actualDestination.mapModeVersion == nil) continue;
            knownDirections.append(new MapModeDirection(
                dirProp,
                actualDestination.mapModeVersion,
                actualDestination.mapModeVersion
            ));
            self.(dirProp) = actualDestination.mapModeVersion;
        }

        knownDirections.sort(nil, { a, b: a.getDirOrder() - b.getDirOrder() });
    }

    roomBeforeAction() {
        if (gActionIs(Wait)) {
            "Time does not pass in map mode. ";
            exit;
        }

        local isClear = nil;
        if (gActionIs(SystemAction)) {
            isClear = true;
        }
        else if (gActionIs(TravelAction)) {
            isClear = true;
        }
        else if (gActionIs(ToggleMapMode)) {
            isClear = true;
        }
        else if (gActionIs(SetMapModeOn)) {
            isClear = true;
        }
        else if (gActionIs(SetMapModeOff)) {
            isClear = true;
        }
        else if (gActionIs(Look)) {
            isClear = true;
        }
        else if (gActionIs(Examine)) {
            isClear = true;
        }
        else if (gActionIs(ExamineOrGoTo)) {
            isClear = true;
        }
        else if (gActionIs(GoTo)) {
            isClear = true;
        }
        else if (gActionIs(Continue)) {
            isClear = true;
        }
        else if (gActionIs(MapModeCompass)) {
            isClear = true;
        }
        else if (gActionIs(RecenterMap)) {
            isClear = true;
        }
        #ifdef __DEBUG
        else if (gActionIs(DumpRouteTable)) {
            isClear = true;
        }
        #endif

        if (!isClear) {
            "You cannot do that in map mode.\n
            You can only travel, go to, continue, examine, or look around. ";
            exit;
        }
    }

    calculateRouteTo(mapModeRoom, currentSteps) {
        if (mapModeRoom == self) return currentSteps;
        if (currentSteps >= pathCalculationScore) return -1;
        pathCalculationScore = currentSteps;

        local startLowest = 10000;
        local lowest = startLowest;
        local lowestDirection = nil;

        for (local i = 1; i <= knownDirections.length; i++) {
            local attemptDir = knownDirections[i];
            local attempt = attemptDir.destination;
            local stepCount = attempt.calculateRouteTo(mapModeRoom, currentSteps + 1);
            if (stepCount < 0) continue;
            if (stepCount < lowest) {
                lowest = stepCount;
                lowestDirection = attemptDir;
            }
        }

        local res = (lowest == startLowest) ? -1 : lowest;

        if (currentSteps == 0) {
            /*if (actualRoom == deliveryRoom && mapModeRoom.actualRoom == hangar) {
                "\bRoute to: <<(lowestDirection == nil) ? 'nil' : 'found'>>\b";
            }*/
            routeTable[mapModeRoom.mapRoomIndex] = lowestDirection;
        }

        return res;
    }

    findBestDirectionTo(mapModeRoom) {
        local knownDir = routeTable[mapModeRoom.mapRoomIndex];
        if (knownDir == nil) {
            "You cannot see a way there on your compass. ";
            exit;
        }

        knownDir.sayDir(
            'NEXT STEP: ',
            'To reach <<mapModeDatabase.compassTarget.roomTitle>>,
            you must '
        );
    }

    dumpRouteTable() {
        "\bRoute table length: <<routeTable.length>>";
        for (local i = 1; i <= routeTable.length; i++) {
            "\n<<mapModeDatabase.allRooms[i].actualRoom.roomTitle>>:
            <<(routeTable[i] == nil) ? 'no route' : 'has route'>>";
        }
    }
}

mapModePreinit: PreinitObject {
    executeBeforeMe = [thingPreinit]

    execute() {
        local startingRooms = new Vector(32);
        for (local cur = firstObj(Room);
            cur != nil ; cur = nextObj(cur, Room)) {
            startingRooms.append(cur);
        }

        for (local i = 1; i <= startingRooms.length; i++) {
            local startingRoom = startingRooms[i];
            if (startingRoom.mapModeDirections == nil) continue;
            startingRoom.initMapModeVersion();
        }

        for (local i = 1; i <= mapModeDatabase.allRooms.length; i++) {
            local mapModeRoom = mapModeDatabase.allRooms[i];
            mapModeRoom.createLinks();
        }

        // Cache paths
        for (local i = 1; i <= mapModeDatabase.allRooms.length; i++) {
            for (local j = 1; j <= mapModeDatabase.allRooms.length; j++) {
                if (i == j) continue;
                mapModeDatabase.calculatePathBetween(
                    mapModeDatabase.allRooms[i],
                    mapModeDatabase.allRooms[j]
                );
            }
        }
    }
}
