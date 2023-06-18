modify TravelConnector {
    // Let it be known that on March 22nd of 2023,
    // Nightshademaker found a bug in the parkour code which
    // required me to modify the travel code of TravelConnectors,
    // which is one giant function.
    //
    // This is largely taken from travel.t of Adv3Lite, but I only
    // needed to make a few modifications.
    execTravel(actor, traveler, conn) {
        local oldLoc = traveler.getOutermostRoom();
        local dest = getDestination(oldLoc);
        local oldTravelInfo = nil;
        
        conn.beforeTravelNotifications(traveler);
        
        if (actor != gPlayerChar) {
            oldTravelInfo = actor.lastTravelInfo;
        }
        
        if (actor == gPlayerChar) {
            libGlobal.lastLoc = oldLoc;                               
        }
        else if (Q.canSee(gPlayerChar, actor)) {
            actor.lastTravelInfo = [oldLoc, conn];
        }
        
        if (gPlayerChar.isOrIsIn(traveler)) {
            local localPlat = getLocalPlatform();
            if (localPlat != nil) doBeforeTravelDiscovery(gPlayerChar.location);
        }
        
        conn.noteTraversal(actor); 
        oldLoc.notifyDeparture(actor, dest);
        
        doTravelMoveInto(traveler, dest);
        
        if (gPlayerChar.isOrIsIn(traveler)) {
            local notifyList = dest.allContents.subset({o: o.ofKind(Actor)});
            
            notifyList.forEach({a: a.pcArrivalTurn = gTurns });
            
            if (dest.lookOnEnter(actor)) {
                dest.lookAroundWithin();
            }

            local oppoPlat = getOppositePlatform();
            if (oppoPlat != nil) doAfterTravelDiscovery(oppoPlat);
        }
        
        if (dest != oldLoc) {               
            conn.afterTravelNotifications(traveler);
        }
        
        if (actor != gPlayerChar && actor.getOutermostRoom == oldLoc) {
            actor.lastTravelInfo = oldTravelInfo;
        }
    }

    doTravelMoveInto(traveler, dest) {
        traveler.actionMoveInto(dest);
    }

    doBeforeTravelDiscovery(oldPlat) {
        //
    }

    doAfterTravelDiscovery(newPlat) {
        //
    }

    getLocalPlatform() {
        return nil;
    }

    getOppositePlatform() {
        return nil;
    }
}