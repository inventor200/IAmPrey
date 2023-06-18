modify Door {
    endPlayerExpectation() {
        if (getEndExpectationSuspicion(&wasPlayerExpectingAClose, &playerCloseExpectationFuse)) {
            makePlayerSuspicious();
        }
    }

    makePlayerSuspicious() {
        if (canEitherBeHeardBy(gPlayerChar)) {
            if (primedPlayerAudio == normalClosingSound) {
                local obj = getSoundSource();
                gMessageParams(obj);
                "<.p><<normalClosingMsg>> <<suspicionMsg>> ";
            }
            else if (primedPlayerAudio == slamClosingSound) {
                "<.p><<slamClosingMsg>> <<suspicionMsg>> ";
            }
            else {
                local obj = getSoundSource();
                gMessageParams(obj);
                "<.p><<suspiciousSilenceMsg>> ";
            }
        }
        else {
            if (primedPlayerAudio == normalClosingSound || primedPlayerAudio == slamClosingSound) {
                // Audible suspicion
                emitSoundFromBothSides(doorSuspiciousCloseNoiseProfile, nil);
            }
            else {
                // Inaudible suspicion
                emitSoundFromBothSides(doorSuspiciousSilenceProfile, nil);
            }
        }
    }
}