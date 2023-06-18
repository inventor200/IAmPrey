modify Door {
    emitSoundFromBothSides(profile, fromPlayer) {
        if (!doSoundPropagation) return;
        
        local sndSrc = getSoundSource();
        soundBleedCore.createSound(
            profile, sndSrc,
            getOutermostRoom(),
            fromPlayer
        );
        if (otherSide != nil) {
            soundBleedCore.createSound(
                profile, sndSrc,
                otherSide.getOutermostRoom(),
                fromPlayer
            );
        }
    }

    emitNormalClosingSound() {
        if (canPlayerSense()) {
            if (primedPlayerAudio == normalClosingSound) {
                local obj = getSoundSource();
                gMessageParams(obj);
                "<.p><<normalClosingMsg>>";
                reportSenseAction(
                    doorShutSnd,
                    doorShutCloseSnd,
                    '<.p><<normalClosingMsg>>',
                    doorShutMuffledSnd
                );
            }
            else if (primedPlayerAudio == slamClosingSound) {
                say(slamClosingMsg);
                addSFX(doorSlamShutSnd);
            }
        }
        else {
            emitSoundFromBothSides(doorSlamCloseNoiseProfile, nil);
        }
    }

    makeOpen(stat) {
        inherited(stat);

        if (airlockDoor) {
            if (canPlayerSense()) {
                setForBothSides(&playerExpectsAirlockOpen, stat);
            }
            if (canEitherBeSeenBy(skashek)) {
                setForBothSides(&skashekExpectsAirlockOpen, stat);
            }
        }
        else {
            if (stat) {
                startFuse();
                reportSenseAction(
                    doorOpenSnd,
                    doorOpenSnd,
                    '<.p>I can hear <<getTheVisibleName()>> opening... ',
                    doorOpenSnd
                );
            }
            else {
                witnessClosing();
            }
        }

        if (!stat && lockability == lockableWithKey) {
            // Doors re-lock when closing
            makeLocked(true);
        }
    }

    autoClose() {
        primedPlayerAudio = normalClosingSound;
        checkClosingExpectations();
        makeOpen(nil);
        primedPlayerAudio = nil;
    }

    slam() {
        primedPlayerAudio = slamClosingSound;
        if (airlockDoor) {
            // Only the player slams airlock doors
            setForBothSides(&wasPlayerExpectingAClose, true);
            setForBothSides(&wasSkashekExpectingAClose, nil);
        }
        checkClosingExpectations();
        makeOpen(nil);
        primedPlayerAudio = nil;
    }

    getTrappedStatus() {
        return nil; // Implemented in trapsAndTracks.t
    }

    qualifiesForCloseTrick() {
        if (!gActorIsPrey) return nil;
        if (!getTrappedStatus()) return nil;
        local skashekOnOtherSide =
            (otherSide.getOutermostRoom() == skashek.getOutermostRoom());
        if (!skashekOnOtherSide) return nil;
        return true;
    }

    spendCloseTrick() {
        "<.p>";
        local poll = huntCore.spendTrick(&closeDoorCount);
        setPlayerTrap(nil);
        skashek.receiveDoorSlam();
        local shoutVerb =
            '<<one of>>bellows<<or>>yells<<or>>screams<<or>>shouts<<at random>>
            from behind the door';
        switch (poll) {
            default:
                "<q>Ach! <<one of>>Fuck you<<or>>Smooth<<or>>Clever<<at random>>, Prey!!</q>
                <<gSkashekName>> <<shoutVerb>>. ";
                return;
            case oneTrickRemaining:
                "<q><<one of>>Fuck<<or>>Ach!<<at random>>!
                I'm getting tired of your
                <<one of>>shit<<or>>antics<<or>>tactics<<at random>>,
                Prey!!</q>
                <<gSkashekName>> <<shoutVerb>>. ";
                return;
            case noTricksRemaining:
                "<q>That's <i>it!</i>
                That's the <i>last</i> time that will work, Prey!!</q>
                <<gSkashekName>> <<shoutVerb>>. ";
                return;
        }
    }
}