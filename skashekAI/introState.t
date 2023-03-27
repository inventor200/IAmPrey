// Skashek chilling before he begins the hunt
skashekIntroState: SkashekAIState {
    stateName = 'Intro State'

    countdownBeforeStart = 0
    peeksAllowed = 2
    startWithChase = nil
    
    doPerception() {
        //TODO: Handle Skashek sound perception
    }

    doPlayerPeek() {
        //
    }

    doPlayerCaughtLooking() {
        //
    }

    describePeekedAction() {
        local peekCount = peeksAllowed;
        peeksAllowed--;
        #if __DEBUG_SKASHEK_ACTIONS
        /*"<.p>
        peekCount: <<peekCount>>\n
        peeksAllowed: <<peeksAllowed>>\n
        countdownBeforeStart: <<countdownBeforeStart>>
        <.p>";*/
        #endif

        //TODO: Make it possible to catch him monologing

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
                <q>Fucking <i>run</i>, Prey!</q> he commands.
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
        countdownBeforeStart =
            huntCore.difficultySettingObj.turnsBeforeSkashekDeploys;
    }

    doTurn() {
        //TODO: If the player walks in on Skashek, death occurs
        // We can check this with skashek.playerWasSeenEntering()
        //TODO: If the player slams the door, Skashek is pissed
        // and starts chasing
        countdownBeforeStart--;

        #if __DEBUG_SKASHEK_ACTIONS
        /*"<.p>
        Doing turn...\n
        countdownBeforeStart: <<countdownBeforeStart>>
        <.p>";*/
        #endif

        if (countdownBeforeStart > 0) return;

        if (skashek.hasSeenPreyOutsideOfDeliveryRoom) {
            if (startWithChase) {
                // Skashek says "Boo!"
                skashekChaseState.activate();
            }
            else {
                // Skashek knows the player is active
                skashekLurkState.activate();
            }
        }
        else {
            // Make the reacquire state check the Delivery Room first
            skashekReacquireState.needsGameStartSetup = true;
            skashekReacquireState.activate();
        }
    }
}