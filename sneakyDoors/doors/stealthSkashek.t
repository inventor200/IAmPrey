modify Door {
    endSkashekExpectation() {
        if (getEndExpectationSuspicion(&wasSkashekExpectingAClose, &skashekCloseExpectationFuse)) {
            makeSkashekSuspicious();
        }
    }

    makeSkashekSuspicious() {
        if (primedPlayerAudio == normalClosingSound || primedPlayerAudio == slamClosingSound) {
            // Noisy door close
            emitSoundFromBothSides(doorSlamCloseNoiseProfile, true);
        }
        else {
            // Silent door close
            if (silentDoorRealizationFuse != nil) return;
            silentDoorRealizationFuse = new Fuse(
                self,
                &causeSilenceSuspicionForSkashek,
                skashek.getRandomResult(3)
            );
        }
    }

    causeSilenceSuspicionForSkashek() {
        silentDoorRealizationFuse = nil;
        emitSoundFromBothSides(doorSuspiciousSilenceProfile, true);
    }
}