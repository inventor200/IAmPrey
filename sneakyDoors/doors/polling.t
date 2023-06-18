modify Door {
    canPlayerSense() {
        return canEitherBeSeenBy(gPlayerChar) || canPlayerHearNearby();
    }

    canPlayerHearNearby() {
        if (canEitherBeSeenBy(gPlayerChar)) return nil;
        local plom = gPlayerChar.getOutermostRoom();
        local inProximity = plom == getOutermostRoom();
        if (otherSide != nil) {
            if (plom == otherSide.getOutermostRoom()) {
                inProximity = true;
            }
        }
        return canEitherBeHeardBy(gPlayerChar) && inProximity;
    }

    sharesRoomWith(witness) {
        local rm = witness.getOutermostRoom();

        if (getOutermostRoom() == rm) return true;
        else if (otherSide != nil) {
            if (otherSide.getOutermostRoom() == rm) return true;
        }

        return nil;
    }

    canEitherBeSeenBy(witness) {
        return witness.canSee(self) || witness.canSee(otherSide);
    }

    canEitherBeHeardBy(listener) {
        return listener.canHear(self) || listener.canHear(otherSide);
    }
}