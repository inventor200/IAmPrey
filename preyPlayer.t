prey: PlayerActor { 'The Prey;;me self myself'
    "<<getClothingDescription()>> "
    person = (gCatMode ? 3 : gDefaultPOV)

    location = dreamWorldPrey
    alwaysHideFromAll = true

    onlySeenShatteredReflectionBefore = nil
    scaredByOwnReflection = nil
    hasPonderedShatteredMirror = nil
    hasSeenSelfBefore = nil
    hasSeenCloneIndividualism = nil

    seeReflection(mirror) {
        mirror.confirmSmashed();
        local seenSkashek = gPlayerChar.hasSeen(skashek);
        if (seenSkashek && !scaredByOwnReflection) {
            scaredByOwnReflection = true;
            return '{My} heart lurches. {I} think {i} see <i><b>him</b></i>
                in {my} visual field. Once {my} reflexes give way to {my} conscious
                mind, {i} remember that he and {i} are <i>both</i> clones.
                {I} decide to take another look... ';
        }
        if (mirror.isSmashed) {
            onlySeenShatteredReflectionBefore = true;
            return 'Attempts to look into it reveal whimsical
                patterns of reflection, and the only features {i} can see
                are {my} pale skin and white hair.<<ponderVanity()>>';
        }
        local seenSelfIntro = '';
        if (!hasSeenSelfBefore) {
            hasSeenSelfBefore = true;
            seenSelfIntro = onlySeenShatteredReflectionBefore ?
                '{I} realize that this is the first time {i} {am}
                clearly seeing {my} own reflection.<<
                if seenSkashek>> <i>{My}</i> reflection.<<end>>
                {I} wonder if {i} should savor this moment...<.p>'
                :
                'This is the first time {i} {am} seeing {my} own face.<<
                if seenSkashek>> <i>{My}</i> face.<<end>>
                {I} wonder if {i} should savor this moment...<.p>';
        }

        local commentOnIndiduality = hasSeenCloneIndividualism ?
            'a bold expression of {my} individuality.'
            :
            'perhaps {my} first method of establishing {my} individuality.';

        local appearanceIntro = seenSkashek ?
            '{I} have an <i>uncanny</i> resemblance to
            <<gSkashekName>>: White hair, deathly-pale skin, and two rows of
            sharp teeth. His face is indistinguishable from {mine};
            more than simple twin siblings could <i>ever</i> be.
            However, there <i>are</i> important differences.
            For one, {i} have a unique hairstyle, <<commentOnIndiduality>>
            {I} stare into the reddish eyeshine of {my} pupils, and see only
            {myself} inside.'
            :
            '{My} skin is as pale as death herself, and {my} lips conceal two
            rows of sharp teeth. {My} deadpan face is framed by {my} white hair,
            <<commentOnIndiduality>>
            {My} nose is upturned slightly, with a thin bridge, and
            {my} jawline is angular, with an extended chin.
            {I} stare into {my} own eyes&mdash;pupils red with the shine of
            night vision&mdash;and ponder the designs of human engineering
            within {my} form. ';

        return '<<seenSelfIntro>><<appearanceIntro>>
            <.p><<getClothingDescription()>>
            <<ponderVanity()>>';
    }

    hasPonderedVanity = nil

    ponderVanity() {
        if (hasPonderedVanity) return '';
        hasPonderedVanity = true;
        return '<.p>{I} weigh the idea in {my} mind. Do {i} value {my} appearance?
            Does looking{dummy} <q>presentable</q> give {me} a tactical advantage?
            {Am} {i} neutral to it, while humans are often concerned?
            Is any vestige of vanity merely a programmed facet of {my} mind, so {i}
            would make {myself} look nice during auction? ';
    }

    shatteredVanityMsg =
        '<.p>Judging by the damage to the mirror,
        someone in the facility does <i>not</i> enjoy
        pondering their appearance...<.p>';

    seeShatteredVanity() {
        if (hasPonderedShatteredMirror) return '';
        if (!hasPonderedVanity) return '';
        hasPonderedShatteredMirror = true;
        return shatteredVanityMsg;
    }

    getClothingDescription() {
        if (outfit == nil) {
            "{I} {am} currently stark-naked. ";
        }
        else {
            outfit.wornDesc();
        }
    }

    hasLeftTheNet = nil
    hasCriedLikeABaby = nil

    actorAction() {
        inherited();
        if (gActionIs(Yell) || gActionIs(SayMeow)) {
            if (hasLeftTheNet) {
                "{I} find that making any kind of loud vocalization is a
                deeply-uncomfortable action to take. ";
            }
            else if (gActionIs(SayMeow)) {
                meowPrompt;
                "\b<i>(Hm. Maybe {i} {was} a cat in a past life!)</i> ";
            }
            else if (gActionIs(Sing)) {
                "{My} voice is rough, but {i} make pitched vocalizations.
                There is no way to determine if {i} {am} any good at it, though. ";
            }
            else if (gActionIs(Purr)) {
                "{I} make a quiet, purring sound in the back of {my} throat.
                {I}{'m} not sure why, but it feels natural. Maybe it's something
                clones normally do? ";
            }
            else if (hasCriedLikeABaby) {
                "Okay, the first time was cathartic, but now it feels like
                a mouse calling out for a cat to find it. ";
            }
            else {
                hasCriedLikeABaby = true;
                "Actually, it turns out that newborn clones <i>do</i> cry after
                entering the world!\b
                {I} nod to {myself}, satisfied, and content to cross that off
                of {my} metaphorical to-do list. ";
                if (skashek.canSee(self)) { // Skashek walks in to check on you
                    "<.p><<gSkashekName>> blinks{dummy} and stares at {me}.
                    <q>Ugh... I <i>knew</i> something about this grow cycle
                    seemed wrong. I gotta save the log files, and make
                    sure I don't get another brain-death next time...</q> ";
                    gameTurnBroker.makeNegative();
                    finishGameMsgSong(ftFailure, gEndingOptionsLoss);
                }
            }
            exit;
        }
        if (gActionIs(SayMeow)) {
            "<i><<one of>>Meow<<or>>Mraow<<or>>Maow<<at random>>.</i> ";
            exit;
        }
        if (gActionIs(Sleep)) {
            "<i>Ha!</i>\bAs if {i} could sleep at a time like <i>this!</i> ";
            exit;
        }

        if (gActionIs(GiveTo) || gActionIs(GiveToImplicit)) {
            "{I} think {i} will keep what {i} can, until {i}
            get out of here. ";
            exit;
        }
        else if (gActionIs(ShowTo) || gActionIs(ShowToImplicit)) {
            "It's neither advisable tactics nor optimal game theory
            to reveal any of {my} findings in such a hostile environment. ";
            exit;
        }
        else if (
            gActionIs(SayAction) ||
            gActionIs(SayTo) ||
            gActionIs(AskAbout) ||
            gActionIs(AskFor) ||
            gActionIs(TellAbout) ||
            gActionIs(TellTo) ||
            gActionIs(TalkAbout) ||
            gActionIs(TalkTo) ||
            gActionIs(ImplicitConversationAction) ||
            gActionIs(QueryAbout) ||
            gActionIs(MiscConvAction) ||
            gActionIs(Hello) ||
            gActionIs(Goodbye)
        ) {
            "{I} cannot seem to find {my} voice right now. ";
            exit;
        }
        else if (gActionIs(Follow)) {
            "{I} follow <i>nobody</i>,
            ever since {my} creators{dummy} attacked {me}, and {my} only
            sibling{dummy} decided to hunt {me} for food. ";
            exit;
        }
        else if ((
            gActionIs(ParkourJumpUpTo) ||
            gActionIs(ParkourJumpOverTo) ||
            gActionIs(ParkourJumpDownTo) ||
            gActionIs(ParkourJumpUpInto) ||
            gActionIs(ParkourJumpOverInto) ||
            gActionIs(ParkourJumpDownInto)) &&
            !warnedAboutJumpNoise
        ) {
            warnedAboutJumpNoise = true;
            "<.p><i>{I} should be more careful about how often {i} jump
            around...\b
            It{dummy} might give {me} faster routes, but it makes <b>a lot
            of noise</b>. If <b>he</b> is nearby,
            then <b>he</b>{dummy} will hear {me} a lot
            more easily than if {i} were simply climbing...</i><.p>";
        }
    }

    warnedAboutJumpNoise = nil

    springInteriorTrap() {
        "<q>Where do you think <i>you're</i> going??</q> he growls, slashing{dummy}
        {me} as {i} try to run past.\b
        My blood sprays <<getOutermostRoom().floorObj.theName>>, and
        {i} collapse. He must have torn a section of {my} leg, but {i} don't get
        a moment to inspect, as he's already on top{dummy} of {me}.";
        springTrapDeath();
    }

    springExteriorTrap() {
        "{I} do not get very far, until I run right into <<gSkashekName>>.<.p>";
        springInteriorTrap();
    }

    springTrapDeath() {
        "<.p>
        {I} try to reach for his eyes, but he swats {my} arm, and clamps it to
        <<getOutermostRoom().floorObj.theName>> with his boot.
        {My} other arm is already pinned under one of his hands, and his claws
        dig into {my} flesh. I try to kick, but that damned arm is in the way,
        and {my} other leg is pinned under his weight.\b
        {I} try to headbutt him, and fail.\b
        <q><b>Prey, I <i>always</i> control the last exit I pass through!</q>
        he sneers. <q>You should have found another way out!</b></q>\b
        {I}{'m} moments from spitting in his face, until he rips something
        out of {my} arm, and claws out {my} throat. {My} arm is free, but
        cannot seem to move.\b
        He stands, and {i} try to follow suit, refusing to die like this.
        However, the floor is coated by the streams of crimson pouring from
        {my} neck.\b
        <b><q>Only the Hanger and Storage Bay are big enough for a stunt
        like that. Too much area to control,</q></b>
        he mutters, waiting{dummy} for {me} to bleed out.
        <q>Ah well...maybe the <i>next</i> Prey will figure that out...</q>\b
        Dizziness soon takes hold, and {i} collapse.";
        gameTurnBroker.makeNegative();
        finishGameMsgSong(ftDeath, gEndingOptionsLoss);
    }

    dieToShortStreak() {
        "<.p>
        {I}{'m} not sure if it was a lack of options, slow reaction time,
        or an unexpected consequence, but ";
        restOfStreakDeath();
    }

    dieToLongStreak() {
        "<.p>
        Over time, <<skashek.getPeekHe()>> had been slowly gaining{dummy}
        on {me}. It seems {i} have found my limit, then.
        <b>{I} can evade him through <<skashekAIControls.maxLongStreak>>
        rooms, maximum</b>. It's a shame that this lesson is lethal.\b
        {I} feel a deep urge to refuse death, so {i} attempt to face {my}
        attacker. Instead, {i} sail off of my feet, as ";
        restOfStreakDeath();
    }

    restOfStreakDeath() {
        "the full force of
        <<skashek.getPeekHis()>> body mass{dummy} slams into {me}.
        {I} feel his claws dig into {my} neck, fleeting moments before {my}
        skull impacts <<getOutermostRoom().floorObj.theName>>.\b
        {I} {am} horribly dazed and stunned, and {i} think {i} feel something
        being ripped free from {my} body; something which should have remained
        attached. Cold rushes into the void, and {i} sink into searing pain.\b
        {My} head is too dizzy to pinpoint exactly <i>when</i>, but {my} life
        comes to an end. ";
        gameTurnBroker.makeNegative();
        finishGameMsgSong(ftDeath, gEndingOptionsLoss);
    }

    // Everything below this is one unit

    physicalStateDescDaemon = nil

    batchIDNumber = '6845'
    possibleIDs = [
        '1193',
        '7469',
        '8211',
        '9032'
    ]

    startTheDay() {
        inherited();
        
        batchIDNumber = possibleIDs[
            skashek.getRandomResult(possibleIDs.length)
        ];

        #ifdef __DEBUG
        local startWet = nil;
        local startOutsideNet = true;
        
        hasLeftTheNet = startOutsideNet;
        if (startWet) {
            soak();
            wombFluidTraces.moveInto(deliveryRoom);
        }
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
            'Regions under {my} eyes and nose both feel a growing
            layer of humidity, before {i} realize its
            on {my} neck and under {my} arms, too. ',
            'Regions under {my} eyes and nose both feel a growing
            layer of sweat, before {i} realize its
            on {my} neck and under {my} arms, too. '
        );
        wetnessPosScale.addReport(3 * physicalFactorScale,
            'Beads of humidity form on {my} forehead, and run
            down {my} temples and chest. ',
            'Beads of sweat form on {my} forehead, and run
            down {my} temples and chest. '
        );
        wetnessPosScale.addReport(5 * physicalFactorScale,
            '{I} {am} as soaked as {i} would be in the rain. '
        );

        wetnessNegScale.addReport(0 * physicalFactorScale,
            '{I} {am} dry, at last. '
        );
        wetnessNegScale.addReport(3 * physicalFactorScale,
            '{I} have reached a state of all-around damp,
            but it{dummy} no longer drips from {me}. '
        );
        wetnessNegScale.addReport((5 * physicalFactorScale) - 1,
            '{I} {am} absolutely dripping-wet. '
        );

        exhaustionPosScale.addReport(2 * physicalFactorScale,
            '{I} start panting from exertion. '
        );
        exhaustionPosScale.addReport(4 * physicalFactorScale,
            '{I} can feel {my} heart pounding under the skin
                of {my} neck, now coated in perspiration. '
        );

        exhaustionNegScale.addReport(0 * physicalFactorScale,
            '{I} finally feel like {i}\'ve caught {my} breath. '
        );
        exhaustionNegScale.addReport(2 * physicalFactorScale,
            '{My} breathing is still ragged, but {i}{\'m} calming down. '
        );

        chillFactorPosScale.addReport(2 * physicalFactorScale,
            '{My} nose feels the bite of the surrounding chill. '
        );
        chillFactorPosScale.addReport(3 * physicalFactorScale,
            '{My} face begins to feel numb in the cold. '
        );
        chillFactorPosScale.addReport(5 * physicalFactorScale,
            '{My} violent shivering and chaotic breathing makes
                it much more difficult to control {my} own limbs. ',
            '{I} can feel frost building up on {my} damp skin. '
        );

        chillFactorNegScale.addReport(2 * physicalFactorScale,
            '{I} feel {my} blood returning to {my} limbs. '
        );
        chillFactorNegScale.addReport(3 * physicalFactorScale,
            '{I} notice how dry {my} eyes had become in the cold,
                and blink moisture back into them. '
        );
        chillFactorNegScale.addReport((5 * physicalFactorScale) - 1,
            '{I} could kiss the sun, if it would help express
                {my} gratitude for warmth. ',
            '{I} can feel {myself} slowly defrosting. '
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
                        against {my} sweating skin. ";
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

+CarryMap;
+CarryCompass;

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