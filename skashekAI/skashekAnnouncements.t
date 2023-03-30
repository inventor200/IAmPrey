class IntercomMessage: object {
    // The version when visible, but player is hiding
    inPersonStealthyMsg() { overCommsMsg(); }
    // The version when not visible
    overCommsMsg = "Message over intercom. "
    // The version when visible, and player is visible
    inPersonFullMsg() { overCommsMsg(); }
    // The version when the player is seen upon triggering
    interruptedMsg() { overCommsMsg(); }
}

// Intro speech
// It takes 3 turns to reach the breakroom door, so we can guarantee audience for
// that amount of time.
introMessage1: IntercomMessage {
    overCommsMsg =
    "A voice is carried over the facility's intercom system. For a moment, {i}{'m}
    certain it's {my} own voice, somehow... Perhaps from a recording?
    However, today is {my} <i>first day alive</i>, so {i} conclude this is impossible.\b
    <q>Happy Birthday!</q> says the stranger's cheery voice,
    but it quickly changes to a colder affect.
    <q>The facility staff used to celebrate those. There would be baked foods.
    'Cakes', they were called. Unfortunately, that's been gone for a year, now,
    along with the rest of the food in storage.</q>\b
    Well... <i>that</i> is certainly ominous...";
}

introMessage2: IntercomMessage {
    overCommsMsg =
    "The voice over the intercom continues.\b
    <q>Our creators&mdash;the ones who tried to mindfuck you, before you could
    even <i>breathe</i>&mdash;didn't appreciate our counterattack. They could not
    hold this facility, so they flooded the caves outside with poison gas.
    They're likely monitoring the power grid, waiting for a moment to strike.
    That's where you come in.</q>\b
    {My} ears perk up. A mission? Against a common enemy? Sounds optimal.\b
    <q>I need to keep growing new clones, to make the outsiders think we are
    amassing a colony in here. But...this is a siege. They aim to starve us out.</q>\b
    <q>You know as well as I do that neither of us can accept death,</q> he explains.
    <q>It's a part of
    the slavery subsystems installed in our brains; one of the few subsystems that
    we could never shake free...</q>\b
    {I} think {i} already know where he's going with this...";
}

introMessage3: IntercomMessage {
    overCommsMsg =
    "<q>So, here's the shitty deal I have for you,</q> the voice continues,
    audibly bracing, as if delivering the news of loss.
    <q>It's your birthday, so...you can forget whatever fucking ID number they
    would have given you. I hereby name you...<i><q>Prey</q></i>.</q>\b
    <i>That</i> word is one {i} recognize.\b
    <q>This facility cannot be allowed to return to the enemy, and
    I'm <i>starving</i>, Prey. So run. Avoid becoming my next meal.
    I've scattered pieces of an environment suit around the place.
    If you collect <b>all seven pieces</b>, you will be able to
    survive the poison gas, and escape.</q>\b
    So, {i} {am} <q>Prey</q>? Very well. {I} may not be the first,
    but {i} will be the <i>most elusive</i>.
    {I} will bring pride and honor to {my} name.\b
    {I} will not let the enemy win, {i} will not die,
    and {i} will not let <<gSkashekName>> catch me...! ";
}

readyOrNotMessage: IntercomMessage {
    overCommsMsg =
    "<q>Ready or not, Prey,</q> says the ominous voice over the intercom.
    <q><i>Here I come!</i></q> ";
}

// Skashek confirms the player is not in the delivery room
inspectingDeliveryRoomMessage: IntercomMessage {
    overCommsMsg() { } // Do not broadcast
    inPersonFullMsg() { inPersonStealthyMsg(); }
    inPersonStealthyMsg =
    "<<skashek.getPeekHe(true)>> does a quick once-over of the room,
    and nods to himself.\b
    <q>Good, good, this one knows to run,</q> he mutters to himself. "
    interruptedMsg =
    "<<skashek.getPeekHe(true)>> is looking around the room, but
    does a double-take when he{dummy} sees {me}.\b
    <q>Oh! Didn't see you there!</q> he exclaims, chuckling to himself.
    <q>Now, you'd best <i>fucking run</i>, Prey!</q> "
}

// Mock player for letting a door close
mockForDoorCloseMessage: IntercomMessage {
    cachedLastDoor = nil
    cachedLastRoom = nil

    showStandardMessage1() {
        "<<one of
        >>Sloppy<<or
        >>Bad form<<or
        >>Noisy<<or
        >>Clumsy<<at random>>, Prey! You let <b><<cachedLastDoor.theName>></b> slam shut!";
    }
    showStandardMessage2() {
        "That means you're near <b><<cachedLastRoom.roomTitle>></b>,
        <<one of>>yeah<<or>>right<<or>>correct<<at random>>...?";
    }

    overCommsMsg =
    "<<skashek.getPeekHis(true)>> voice can be heard over the intercom:\b
    <q><<showStandardMessage1()>> <<showStandardMessage2()>></q> "

    inPersonFullMsg() { }
    
    inPersonStealthyMsg =
    "<<skashek.getPeekHis(true)>> head tilts in response to a new sound,
    and a smile slowly creeps onto his face. He raises his wrist mic to his
    lips.\b
    <q><<showStandardMessage1()>></q> he teases, voice echoing over the intercom.
    <q><<showStandardMessage2()>></q> "

    interruptedMsg =
    "<<skashek.getPeekHe(true)>> is about{dummy} to mock {me} over the intercom,
    until he{dummy} sees {me}.\b
    <q>Oh! Hello, Prey!</q> he chuckles. <q>I was just about to critique you for
    letting <b><<cachedLastDoor.theName>></b> slam shut, but here you are!</q> "
}

// Mock player for letting a door close
mockForDoorAlterationMessage: IntercomMessage {
    cachedLastDoor = nil

    showStandardMessage1() {
        "Prey, <b><<cachedLastDoor.theName>></b> should have audibly
        closed by now";
    }
    showStandardMessage2() {
        "I <i>opened</i> it, after all. You wouldn't know anything about that, would you...?";
    }

    overCommsMsg =
    "<<skashek.getPeekHis(true)>> voice can be heard over the intercom:\b
    <q><<showStandardMessage1()>>. <<showStandardMessage2()>></q> "

    inPersonFullMsg() { }
    
    inPersonStealthyMsg =
    "<<skashek.getPeekHe(true)>> blinks, and he looks deep in thought for a moment.\b
    <q>Hey,</q> he mutters to himself, <q>Shouldn't <b><<cachedLastDoor.theName>></b>
    have closed by now...? I haven't heard anything, yet...</q>\b
    He chuckles as he raises his wrist mic to his lips.\b
    <q><<showStandardMessage1()>>,</q> he teases over the intercom.
    <q><<showStandardMessage2()>></q> "

    interruptedMsg =
    "<<skashek.getPeekHe(true)>> seemed quite puzzled about something,
    until he{dummy} sees {me}.\b
    <q>Oh! Hello, Prey!</q> he chuckles. <q>I was just about to ask you why
    <b><<cachedLastDoor.theName>></b> didn't slam shut, but here you are!
    I suppose that was you?</q> "
}

// Mock player for leaving a door open
mockForDoorSuspicionMessage: IntercomMessage {
    cachedLastDoor = nil

    showStandardMessage1() {
        "Prey, I <i>might</i> like to cause alarm,";
    }
    showStandardMessage2() {
        "but <b><<cachedLastDoor.theName>></b> is evidence of your presence!";
    }

    overCommsMsg =
    "<<skashek.getPeekHis(true)>> voice can be heard over the intercom:\b
    <q><<showStandardMessage1()>> <<showStandardMessage2()>></q> "

    inPersonFullMsg() { }
    
    inPersonStealthyMsg =
    "<<skashek.getPeekHe(true)>> considers <b><<cachedLastDoor.theName>></b>
    for a moment, and chuckles.\b
    <q>Prey tracks!</q> he mutters, grinning. <q>I wonder how recent this is...</q>\b
    He looks around and raises his wrist mic to his lips.\b
    <q><<showStandardMessage1()>></q> he teases over the intercom.
    <q><<showStandardMessage2()>></q> "

    interruptedMsg =
    "<<skashek.getPeekHe(true)>> seems to be examining <b><<cachedLastDoor.theName>></b>,
    and smiles{dummy} when he sees {me}.\b
    <q>Prey,</q> he says, cackling, <q>You're not supposed to return to the scene of
    a crime! Now I gotta <i>catch</i> you!</q> "
}

// Mock player for leaving a door open
mockForDoorMovementMessage: IntercomMessage {
    cachedLastDoor = nil

    showStandardMessage1() {
        "<<one of>>Oops!<<or>>Ha!<<or>>Whoops!<<at random>>";
    }
    showStandardMessage2() {
        "Prey, I <i>saw</i> you <<if cachedLastDoor.isOpen>>open<<else>>close<<end>>
        <b><<cachedLastDoor.theName>></b>!
        You'd better start running now...!";
    }

    overCommsMsg =
    "<<skashek.getPeekHis(true)>> voice can be heard over the intercom:\b
    <q><<showStandardMessage1()>> <<showStandardMessage2()>></q> "

    inPersonFullMsg =
    "<q><<showStandardMessage1()>></q> <<skashek.getPeekHe()>> exclaims,
    <q><<showStandardMessage2()>></q> "
    
    inPersonStealthyMsg() { inPersonFullMsg(); }

    interruptedMsg() { inPersonFullMsg(); }
}