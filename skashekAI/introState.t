// Skashek chilling before he begins the hunt
skashekIntroState: SkashekAIState {
    stateName = 'Intro State'

    #ifdef __DEBUG
    setupForTesting() {
        inherited();
        // Set starting variables for testing
    }
    #endif

    countdownBeforeStart = 0
    peeksAllowed = 2
    startWithChase = nil
    
    doPerception(impact) {
        // Hearing the player is proof of activity
        skashek.hasSeenPreyOutsideOfDeliveryRoom = true;
        if ((impact.sourceOrigin == breakroomEntryDoor ||
            impact.sourceOrigin == breakroomExitDoor) &&
            impact.soundProfile == doorSlamCloseNoiseProfile) {
            countdownBeforeStart = 0;
            startWithChase = true;
            skashek.doAction(Open, breakroomExitDoor);
            prepareSpeech();
            if (!breakroomExitDoor.canEitherBeSeenBy(gPlayerChar)) {
                "\b{I} hear the Breakroom door being
                forcefully thrown back open. ";
            }
            "\b<q>I'm gonna <i>rip you in half</i>, Prey!!</q>
            he declares.\b
            <i>Maybe slamming the door on him was a tactical misstep...</i>";
        }
    }

    doPlayerPeek() { }

    doPlayerCaughtLooking() { }

    describePeekedAction() {
        local peekCount = peeksAllowed;
        peeksAllowed--;
        #if __DEBUG_SKASHEK_ACTIONS
        "<.p>
        peekCount: <<peekCount>>\n
        peeksAllowed: <<peeksAllowed>>\n
        countdownBeforeStart: <<countdownBeforeStart>>
        <.p>";
        #endif

        if (countdownBeforeStart == 1 || peekCount <= 0) {
            if (!skashek.hasSeenPreyOutsideOfDeliveryRoom) {
                "<<gSkashekName>> has stood up,
                and is brushing off his uniform.
                He cracks his knuckles, and shakes
                out any remaining nerves.\b
                There is no joy or excitement on his face,
                and he stares at some imaginary horizon,
                deep in thought. ";
            }
            else {
                "<<gSkashekName>> is...gone?\b
                <i>Then, his face is centimeters
                away from {my} own.</i>\b
                <q><<one of>>Fucking <<or>>You should <<or>>\^<<at random>><i>run</i>,
                Prey!</q> he barks.
                He's close enough to smell the kelp on his breath.\b
                {My} head-start has ended, and the chase has begun. ";
                startWithChase = true;
                countdownBeforeStart = 0;
            }
            return;
        }
        
        if (countdownBeforeStart > 1) {
            if (!skashek.hasSeenPreyOutsideOfDeliveryRoom) {
                skashek.hasSeenPreyOutsideOfDeliveryRoom = true;
                "<<gSkashekName>> is sitting at the breakroom table,
                munching on strange, ghostly-white kelp.\b
                He's probably getting ready to hunt{dummy} {me}...\b
                He{dummy} doesn't notice {me} at first, and looks deep in thought.
                Then, his eyes locked onto {my} own, and the reddish glow
                of his night vision look like activation lights.
                He swallows his mouthful of kelp,
                visibly <i>hating</i> the taste.\b";
            }
            else {
                "<<gSkashekName>> was ready{dummy} for {me} to peek again,
                eyes{dummy} already trained on {me}.\b";
            }
        }

        if (peekCount >= 2) {
            if (countdownBeforeStart == 2) {
                "<q>Prey,</q> he says, with amusement in his serrated smile,
                <q>I'm almost done with my kelp snack. You should
                <i>really</i> start running away from me...</q>";
                return;
            }
            "<q>Prey,</q> he says, eyes locked on {mine},
            <q>I am giving you a golden opportunity here.
            I suggest you take full advantage of it, if you know
            what's good for you.</q>";
            return;
        }
        if (peekCount == 1) {
            "<q>Prey,</q> he says, with an edge creeping into his voice,
            <q>If you insist on <i>taunting me</i>, then I might
            have to start early...</q>";
        }
    }

    playerWillGetCaughtPeeking() {
        // This is the only time he's not watching the door
        return !(
            !skashek.hasSeenPreyOutsideOfDeliveryRoom && 
            countdownBeforeStart == 1
        );
    }

    startGameFrom() {
        if (!huntCore.difficultySettingObj.skipPrologue) {
            skashek.reciteAnnouncement(introMessage1);
            skashek.reciteAnnouncement(introMessage2);
            skashek.reciteAnnouncement(introMessage3);
        }
        countdownBeforeStart =
            huntCore.difficultySettingObj.turnsBeforeSkashekDeploys;
    }

    doTurn() {
        local hitZeroLegit = countdownBeforeStart == 1;
        countdownBeforeStart--;

        #if __DEBUG_SKASHEK_ACTIONS
        "<.p>
        Doing turn...\n
        countdownBeforeStart: <<countdownBeforeStart>>
        <.p>";
        #endif

        local playerSeenEntering = skashek.playerWasSeenEntering();

        if (playerSeenEntering) {
            hitZeroLegit = nil;
            if (countdownBeforeStart <= 1) {
                "<<gSkashekName>> is standing by the table, adjusting
                his uniform. He{dummy} slowly turns to look at {me}.\b";
            }
            else {
                "<<gSkashekName>> pauses, a piece of pale kelp moments
                from his mouth. His eyes are locked on {mine}, and he
                slowly stands up.\b";
            }
            "<q>Prey,</q> he growls, <q>you are being quite <i>bold</i>.
            I suggest you start running. <i>Now.</i></q> ";
            countdownBeforeStart = 0;
            startWithChase = true;
        }

        if (countdownBeforeStart > 0) return;

        if (hitZeroLegit) {
            // Prey has not disturbed Skashek so far.
            skashek.reciteAnnouncement(readyOrNotMessage);
            skashek.performNextAnnouncement();
        }

        if (skashek.hasSeenPreyOutsideOfDeliveryRoom) {
            if (startWithChase) {
                // Skashek says "Boo!"
                skashekChaseState.activate();
            }
            else {
                // Skashek knows the player is active
                skashekLurkState.startRandom = true;
                skashekLurkState.activate();
            }
        }
        else {
            // Make the lurk state check the Delivery Room first
            skashekLurkState.startRandom = nil;
            skashekLurkState.activate();
        }
    }
}