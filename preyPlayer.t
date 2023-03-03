prey: Actor { 'The Prey'
    "<<getClothingDescription()>> "
    person = (gCatMode ? 3 : 2)
    #if __DEBUG
    location = deliveryRoom
    #else
    location = deliveryRoom
    #endif

    scaredByOwnReflection = nil
    hasPonderedShatteredMirror = nil
    hasSeenSelfBefore = nil
    hasSeenCloneIndividualism = nil

    seeReflection(mirror) {
        mirror.confirmSmashed();
        local seenSkashek = gPlayerChar.hasSeen(skashek);
        if (seenSkashek && !scaredByOwnReflection) {
            scaredByOwnReflection = true;
            return 'Your heart lurches. You think you spot <i><b>him</b></i>
                in your visual field. Once your reflexes give way to your conscious
                mind, you remember that you\'re both clones. You decide if
                you want to take another look... ';
        }
        if (mirror.isSmashed) {
            return 'Attempts to look into it reveal rather whimsical
                patterns of reflection, but all you can see of yourself
                is that you have pale skin and white hair.<<ponderVanity()>>';
        }
        local seenSelfIntro = '';
        if (!hasSeenSelfBefore) {
            hasSeenSelfBefore = true;
            seenSelfIntro = 'You realize that this is the first time you are
                clearly seeing your own reflection; you wonder if you should
                savor this moment...<.p>';
        }

        local commentOnIndiduality = hasSeenCloneIndividualism ?
            'a bold expression of your individuality.'
            :
            'perhaps your first method of establishing your individuality.';

        local appearanceIntro = seenSkashek ?
            'You have an <i>uncanny</i> resemblance to
            <<gSkashekName>>: White hair, deathly-pale skin, and two rows of
            sharp teeth. Your faces are indistinguishable; more than simple
            twin siblings could <i>ever</i> be.
            However, there <i>are</i> important differences.
            For one, you have a unique hairstyle; <<commentOnIndiduality>>
            You stare into the reddish eyeshine of your pupils, and see only
            yourself in there.'
            : //TODO: Keep some of these observations when looking at skashek
            'Your skin is as pale as death herself, and your lips conceal two
            rows of sharp teeth. Your deadpan face is framed by you white hair;
            <<commentOnIndiduality>> Your nose is thin by the bridge, and
            upturned slightly. Your jawline is somewhere between round and
            angular, while your chin is long and thin enough to weaponize.
            You stare into your own eyes&mdash;pupils red with the shine of
            nightvision&mdash;and ponder the designs of human engineering
            within your form. ';

        return '<<seenSelfIntro>><<appearanceIntro>>
            <.p><<getClothingDescription()>>
            <<ponderVanity()>>';
    }

    hasPonderedVanity = nil

    ponderVanity() {
        if (hasPonderedVanity) return '';
        hasPonderedVanity = true;
        return '<.p>You weigh the idea in your mind. Do you value your appearance?
            Does looking <q>presentable</q> give you a tactical advantage
            during a chase?
            Are you neutral to it, while humans are often concerned?
            Is any vestige of vanity merely a programmed facet of your mind, so you
            would make yourself look nice during auction? ';
    }

    shatteredVanityMsg =
        '<.p>Judging by the damage to the mirror,
        someone in the facility does <i>not</i> enjoy pondering their appearance...<.p>';

    seeShatteredVanity() {
        if (hasPonderedShatteredMirror) return '';
        if (!hasPonderedVanity) return '';
        hasPonderedShatteredMirror = true;
        return shatteredVanityMsg;
    }

    getClothingDescription() {
        return 'TODO: Describe clothing';
    }

    hasLeftTheNet = nil
    hasCriedLikeABaby = nil

    actorAction() {
        if (gActionIs(Yell)) {
            if (hasLeftTheNet) {
                "You find that making any kind of loud vocalization is a
                deeply-uncomfortable action to take. ";
            }
            else if (hasCriedLikeABaby) {
                "Okay, the first time was cathartic, but now it feels like
                a mouse calling out for a cat to find it. ";
            }
            else {
                "Actually, it turns out that newborn clones <i>do</i> cry after
                entering the world!\b
                You nod to yourself, satisfied, and happy to cross that off
                of your metaphorical list. ";
                //TODO: Check to see if Skashek's arrival was announced
                //      yet, and handle that if not.
                if (skashek.canSee(self)) { // Skashek walks in to check on you
                    "<<gSkashekName>> blinks and stares at you.
                    <q>Did...did you just <i>cry like a newborn?</i>
                    Ugh... I <i>knew</i> something about this cycle
                    seemed wrong. I gotta save the log files, and make
                    sure I don't get another brain-death next time...</q> ";
                    finishGameMsg(ftFailure, [
                        finishOptionCredits
                    ]);
                }
            }
            exit;
        }
    }

    // Everything below this is one unit

    physicalStateDescDaemon = nil

    startTheDay() {
        inherited();

        #if __DEBUG
        soak();
        #else
        soak();
        #endif
        
        physicalStateDescDaemon = new Daemon(self, &describePhysicalState, 0);
        physicalStateDescDaemon.eventOrder = 210;
    }

    wetnessPosScale = static new ConditionScale(nil)
    wetnessNegScale = static new ConditionScale(true)

    exhaustionPosScale = static new ConditionScale(nil)
    exhaustionNegScale = static new ConditionScale(true)

    chillFactorPosScale = static new ConditionScale(nil)
    chillFactorNegScale = static new ConditionScale(true)

    preinitThing() {
        wetnessPosScale.addReport(1 * physicalFactorScale,
            'Regions under your eyes and nose both feel a growing
            layer of humidity, before you realize its
            on your neck and under your arms, too. ',
            'Regions under your eyes and nose both feel a growing
            layer of sweat, before you realize its
            on your neck and under your arms, too. '
        );
        wetnessPosScale.addReport(3 * physicalFactorScale,
            'Beads of humidity form on your forehead, and run
            down your temples and chest. ',
            'Beads of sweat form on your forehead, and run
            down your temples and chest. '
        );
        wetnessPosScale.addReport(5 * physicalFactorScale,
            'You are as soaked as you would be in the rain. '
        );

        wetnessNegScale.addReport(0 * physicalFactorScale,
            'You are dry, at last. '
        );
        wetnessNegScale.addReport(3 * physicalFactorScale,
            'You have reached a state of all-around damp,
            but it no longer drips from you. '
        );
        wetnessNegScale.addReport((5 * physicalFactorScale) - 1,
            'Your are absolutely dripping-wet. '
        );

        exhaustionPosScale.addReport(2 * physicalFactorScale,
            'You start panting from exertion. '
        );
        exhaustionPosScale.addReport(4 * physicalFactorScale,
            'You can feel your heart pounding under the skin
                of your neck, now coated in perspiration. '
        );

        exhaustionNegScale.addReport(0 * physicalFactorScale,
            'You finally feel like you\'ve caught your breath. '
        );
        exhaustionNegScale.addReport(2 * physicalFactorScale,
            'Your breathing is still ragged, but you\'re calming down. '
        );

        chillFactorPosScale.addReport(2 * physicalFactorScale,
            'Your nose feels the bite of the surrounding chill. '
        );
        chillFactorPosScale.addReport(3 * physicalFactorScale,
            'Your face begins to feel numb in the cold. '
        );
        chillFactorPosScale.addReport(5 * physicalFactorScale,
            'Your violent shivering and chaotic breathing makes
                it much more difficult to control your own limbs. ',
            'You can feel frost building up on your damp skin. '
        );

        chillFactorNegScale.addReport(2 * physicalFactorScale,
            'You feel your blood returning to your limbs. '
        );
        chillFactorNegScale.addReport(3 * physicalFactorScale,
            'You notice how dry your eyes had become in the cold,
                and blink moisture back into them. '
        );
        chillFactorNegScale.addReport((5 * physicalFactorScale) - 1,
            'You could kiss the sun, if it would help express
                your gratitude for warmth. ',
            'You can feel yourself slowly defrosting. '
        );
    }

    sweatIsNovel = true

    describePhysicalState() {
        if (gPlayerChar != self) return;
        local om = getOutermostRoom();

        "<.p>";

        // Freeze
        local chillClamp = (d_chillFactor == 0 ? 0 : 1) + chillFactor;
        local hasFrost = (wetness > 0) && (chillClamp > 0);
        local expressedCold = nil;
        local itsSweat = exhaustion >= 2;

        // Chill and frost
        if (chillFactor > 0 || d_chillFactor < 0) {
            if (d_chillFactor > 0) {
                local nextReport = chillFactorPosScale.getReport(
                    chillFactor, hasFrost, chillFactorNegScale
                );
                if (nextReport != nil) {
                    say(nextReport);
                    expressedCold = true;
                }
            }
            if (d_chillFactor < 0) {
                local nextReport = chillFactorNegScale.getReport(
                    chillFactor, hasFrost, chillFactorPosScale
                );
                if (nextReport != nil) {
                    say(nextReport);
                    expressedCold = true;
                }
            }
        }
        if (exhaustion > 0 || d_exhaustion < 0) {
            if (d_exhaustion > 0) {
                local nextReport = exhaustionPosScale.getReport(
                    exhaustion, nil, exhaustionNegScale
                );
                if (nextReport != nil) {
                    say(nextReport);
                }
            }
            if (d_exhaustion < 0) {
                local nextReport = exhaustionNegScale.getReport(
                    exhaustion, nil, exhaustionPosScale
                );
                if (nextReport != nil) {
                    say(nextReport);
                }
            }

            // This is done separately
            if (exhaustion >= (4 * physicalFactorScale) && om.isFreezing) {
                if (sweatIsNovel) {
                    if (chillFactor >= 1 * physicalFactorScale &&
                        chillFactor <= 2 * physicalFactorScale) {
                        "The chilled air feels like a beautiful breeze
                        against your sweating skin. ";
                    }
                    sweatIsNovel = nil;
                }
            }
            else sweatIsNovel = true;
        }
        if (wetness > 0 || d_wetness < 0) {
            if (d_wetness > 0) {
                local nextReport = wetnessPosScale.getReport(
                    wetness, itsSweat, wetnessNegScale
                );
                if (nextReport != nil) {
                    if (!expressedCold) say(nextReport);
                }
            }
            if (d_wetness < 0) {
                local nextReport = wetnessNegScale.getReport(
                    wetness, itsSweat, wetnessPosScale
                );
                if (nextReport != nil) {
                    if (!expressedCold) say(nextReport);
                }
            }
        }

        "<.p>";
    }
}

class ConditionScale: object {
    conditionReports = perInstance(new Vector(maxPhysicalFactor))
    lastIndex = 0
    isNegative = nil

    construct(isNegative_) {
        isNegative = isNegative_;
    }

    addReport(index_, primaryMsg_, secondaryMsg_?) {
        local newReport = new ConditionReport(index_, primaryMsg_, secondaryMsg_);
        conditionReports.append(newReport);
    }

    getReport(index, isSecondary, otherScale) {
        if (conditionReports.length == 0) return nil;

        local dir = isNegative ? -1 : 1;

        if (isNegative) {
            if (index >= lastIndex + dir) return nil;
        }
        else {
            if (index <= lastIndex + dir) return nil;
        }

        local start = lastIndex + dir;
        local end = index;

        local lastDetected = nil;
        
        for (local i = start; compareSearch(i, end); i += dir) {
            for (local j = 1; j <= conditionReports.length; j++) {
                local possibleReport = conditionReports[j];
                if (possibleReport.index == i) {
                    lastDetected = possibleReport.attemptGet();
                }
            }
        }

        if (lastDetected != nil) {
            lastDetected.confirmGet();
            lastIndex = lastDetected.index;
            otherScale.lastIndex = lastIndex;
        }
        else {
            return nil;
        }

        return isSecondary ?
            lastDetected.secondaryMsg : lastDetected.primaryMsg;
    }

    compareSearch(i, end) {
        if (isNegative) {
            return i >= end;
        }
        return i <= end;
    }
}

class ConditionReport: object {
    primaryMsg = 'Something changes. '
    secondaryMsg = (primaryMsg)

    lastTurnOfReport = -10
    index = 0

    construct(index_, primaryMsg_, secondaryMsg_?) {
        primaryMsg = primaryMsg_;
        if (secondaryMsg_ != nil) {
            secondaryMsg = secondaryMsg_;
        }
        index = index_;
    }

    attemptGet() {
        if (gTurns - lastTurnOfReport >= conditionReportDelay) {
            return self;
        }
        return nil;
    }

    confirmGet() {
        lastTurnOfReport = gTurns;
    }
}