class IntercomMessage: object {
    // The version when visible, but player is hiding
    inPersonStealthyMsg() { overCommsMsg(); }
    // The version when not visible
    overCommsMsg = "Message over intercom. "
    // The version when visible, and player is visible
    inPersonFullMsg() { overCommsMsg(); }
    // The version when the player is seen upon triggering
    interruptedMsg() { overCommsMsg(); }
    // The version where the player is in the same room,
    // but can't hear anything
    inPersonAudioMsg() { overCommsMsg(); }
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

class HidingParanoiaMessage: IntercomMessage {
    overCommsMsg() { } // Do not broadcast
    inPersonFullMsg() { inPersonStealthyMsg(); }
    interruptedMsg =
    "<<skashek.getPeekHe(true)>> is looking around the room, but
    does a double-take when he{dummy} sees {me}.\b
    <q>Oh! Didn't see you there!</q> he exclaims, chuckling to himself.
    <q>Now, you'd best <i>fucking run</i>, Prey!</q> "
}

// Skashek confirms the player is not in the delivery room
inspectingDeliveryRoomMessage: HidingParanoiaMessage {
    remark =
    "<q>Good, good, this one knows to run,</q>
    <<skashek.getPeekHe()>> mutters to himself."
    inPersonStealthyMsg =
    "<<skashek.getPeekHe(true)>> does a quick once-over of the room,
    and nods to himself.\b
    <<remark()>> "
    inPersonAudioMsg =
    "<<skashek.getPeekHe(true)>> doesn't make a sound for a moment. Then...\b
    <<remark()>> "
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

    inPersonAudioMsg =
    "<<skashek.getPeekHe(true)>> can be heard in the room:\b
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

    inPersonAudioMsg =
    "<<skashek.getPeekHe(true)>> can be heard in the room:\b
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

    inPersonAudioMsg =
    "<<skashek.getPeekHe(true)>> can be heard in the room:\b
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
    
    inPersonAudioMsg =
    "<<skashek.getPeekHe(true)>> can be heard in the room:\b
    <q><<showStandardMessage1()>> <<showStandardMessage2()>></q> "

    inPersonFullMsg =
    "<q><<showStandardMessage1()>></q> <<skashek.getPeekHe()>> exclaims,
    <q><<showStandardMessage2()>></q> "
    
    inPersonStealthyMsg() { inPersonFullMsg(); }

    interruptedMsg() { inPersonFullMsg(); }
}

// Mock player for running water
mockForRunningWaterMessage: IntercomMessage {
    hasYelledBefore = nil

    showStandardMessage1() {
        "<<one of>>Curses!<<or>>Curses, Prey!<<or>>Nuisance!<<at random>>";
    }
    showStandardMessage2() {
        "Prey, you've left the fucking <i>water</i> running?!<<if hasYelledBefore
        >> <i><b>Again???</b></i><<end>>
        <<one of
        >>Are you a child??<<or
        >>I <i>hate</i> that fucking sound!<<or
        >>What the fuck is <i>wrong</i> with you??<<at random>>";
        hasYelledBefore = true;
    }

    overCommsMsg =
    "<<skashek.getPeekHis(true)>> voice can be heard over the intercom:\b
    <q><<showStandardMessage1()>> <<showStandardMessage2()>></q> "
    
    inPersonAudioMsg =
    "<<skashek.getPeekHe(true)>> can be heard in the room:\b
    <q><<showStandardMessage1()>> <<showStandardMessage2()>></q> "

    inPersonFullMsg =
    "<q><<showStandardMessage1()>></q> <<skashek.getPeekHe()>> exclaims,
    <q><<showStandardMessage2()>></q> "
    
    inPersonStealthyMsg() { inPersonFullMsg(); }

    interruptedMsg() { inPersonFullMsg(); }
}

// Punish player for having a weapon
punishForWeaponMessage: IntercomMessage {
    causeForConcern = nil

    switchToNightmareMode() {
        huntCore.setDifficulty(6, true);
        "<.p>
        \t<b>ALERT:</b>\n
        <i>The game difficulty has been switch to <b>Nightmare Mode</b>!\n
        Best of luck to you!</i>
        <.p>";
    }

    pity1() {
        "Oh, Prey...";
    }

    pity2() {
        "You <i>really</i> shouldn't have. Now I need to <i>destroy</i> you.
        Until the moment of your death, you will be <i>begging</i> to turn back time.";
    }

    overCommsMsg() {
        "From some unseen vantage point, <<skashek.getPeekHe()>> sees that {i}
        carry <<causeForConcern.theName>>.\b";
        "<q><<pity1()>> <<pity2()>></q>";
        switchToNightmareMode();
    }

    inPersonFullMsg() {
        "<<skashek.getPeekHis(true)>> eyes fixate on <<causeForConcern.theName>>
        on {my} person.\b";
        "<q><<pity1()>></q> he says, with ice-cold disappointment. <q><<pity2()>></q>";
        switchToNightmareMode();
    }
    
    inPersonStealthyMsg() { inPersonFullMsg(); }

    interruptedMsg() {
        "<q>Oh,</q> <<skashek.getPeekHe()>> says, turning{dummy} to look at {me}.
        <q><i>There</i> you are, Prey! I was&mdash;</q>\b";
        inPersonFullMsg();
    }
}

hidingParanoiaGroup: object {
    turnsToHide = 3
    messages = [
        [hidingParanoia_1_1_Message, hidingParanoia_1_2_Message, hidingParanoia_1_3_Message],
        [hidingParanoia_2_1_Message, hidingParanoia_2_2_Message, hidingParanoia_2_3_Message],
        [hidingParanoia_3_1_Message, hidingParanoia_3_2_Message, hidingParanoia_3_3_Message],
        [hidingParanoia_4_1_Message, hidingParanoia_4_2_Message, hidingParanoia_4_3_Message]
    ]
}

// First batch of words when hiding from Skashek...
hidingParanoia_1_1_Message: HidingParanoiaMessage {
    remark =
    "If {i} remain unseen, he will leave, eventually...\b
    <q>Are you here, Prey...?</q> he asks quietly.
    <q>Are you hiding away somewhere, or am I talking to an empty room...?</q>"

    inPersonStealthyMsg =
    "<.p>
    <<skashek.getPeekHis(true)>> eyes pan around
    <<skashek.getOutermostRoom().roomTitle>>. <<remark()>>
    <.p>"
    
    inPersonAudioMsg =
    "<.p>
    <<skashek.getPeekHe(true)>> is probably looking around.
    All is quiet for a moment. <<remark()>>
    <.p>"
}

hidingParanoia_1_2_Message: HidingParanoiaMessage {
    remark1 =
    "<q>These walls <i>listen</i>, Prey...</q> he mutters, almost inaudibly.
    <q>They tell stories, when I'm all alone. When I'm
    without <i>you</i>, Prey...</q>"

    remark2 =
    "<q>The nightmares from the early days return, sometimes,</q>
    he says, ominously.
    <q>I still remember the faces of our old masters.</q>"

    inPersonStealthyMsg =
    "<.p>
    For a moment, {i} think <<skashek.getPeekHe()>>{dummy} sees {me},
    but his gaze continues onto something else.\b
    <<remark1()>>\b
    He turns around, expecting{dummy} to catch {me}, but he's actually
    facing his back to me wrong way.\b
    <<remark2()>>
    <.p>"
    
    inPersonAudioMsg =
    "<.p>
    For a moment, {i} think <<skashek.getPeekHe()>>{dummy} sees {me},
    because he gets super silent for a little <i>too</i> long...\b
    <<remark1()>>\b
    There's a sudden rush of movement, as if he turned around really quickly.\b
    <<remark2()>>
    <.p>"
}

hidingParanoia_1_3_Message: HidingParanoiaMessage {
    remark1 =
    "<q>I used to wonder,</q> he whispers,
    <q>how they could be so...<i>loving</i> and <i>affectionate</i>
    with each other, and then display the most hideous brutality to <i>us</i>.
    All in the same day, too...</q>\b
    Eventually, he allows himself to move again.\b
    <q>Maybe I heard the cat...?</q> he wonders to himself,"

    remark2 =
    "<q>I wanted to better,</q> he sighs.
    <q>We <i>all</i> did. But the way was clear. Their
    world rubs off on you like a <i>disease</i>, Prey. I often <i>hope</i>
    you escape, but the <i>shit</i> they forced into my head...it
    won't let you go as easily as I'd prefer.</q>"

    inPersonStealthyMsg =
    "<.p>
    Something elsewhere seems to catch <<skashek.getPeekHis()>>
    attention. He holds himself still as stone, and listens.\b
    <<remark1()>> making one more quick examination of the area.
    <<remark2()>>
    <.p>"

    inPersonAudioMsg =
    "<.p>
    For a uncomfortable pause, <<skashek.getPeekHe()>> is incredibly quiet.\b
    <<remark1()>> sounding genuinely confused.
    <<remark2()>>
    <.p>"
}

// Second batch of words when hiding from Skashek...
hidingParanoia_2_1_Message: HidingParanoiaMessage {
    remark =
    "<q>There's a certain comfort in chaos,</q> he says.
    <q>The world without collapsed probabilities. Maybe you're in the room, or
    maybe you're not. Maybe I'm speaking to a captive audience, or maybe nobody
    sees my <q>scary-monster act</q> slipping up.</q>"

    inPersonStealthyMsg =
    "<.p>
    <<skashek.getPeekHe(true)>> performs an examination of his surroundings.\b
    <<remark()>>
    <.p>"

    inPersonAudioMsg =
    "<.p>
    <<skashek.getPeekHe(true)>> is silent for a while, and then...\b
    <<remark()>>
    <.p>"
}

hidingParanoia_2_2_Message: HidingParanoiaMessage {
    remark =
    "<q>Maybe I don't need to be the killer I was created to be. Maybe you
    will escape this time. Maybe I can get that much closer to starving
    to death. It wouldn't be <i>my</i> fault, then, right? Chaos decides,
    after all.</q>"

    inPersonStealthyMsg =
    "<.p>
    <q>Maybe...</q> <<skashek.getPeekHe()>> begins, and pauses his gaze on something.
    <<remark()>>
    <.p>"

    inPersonAudioMsg =
    "<.p>
    <<skashek.getPeekHe(true)>> continues, but hesitantly:\b
    <<remark()>>
    <.p>"
}

hidingParanoia_2_3_Message: HidingParanoiaMessage {
    remark =
    "<q>I cannot <i>die</i>, Prey,</q> <<skashek.getPeekHis()>> continues.
    <q>And I don't mean
    to say I'm <i>invulnerable</i>. It's whatever they put in our brains.
    I know you feel it, too. Sometimes, you want to do something dangerous
    or...exercise your free will, and... it's like your personality seems
    to fade away for a moment. Like something else decides <i>for you</i>.
    It's the fucking computers they shoved in our brainstems. You remember
    the dream, before you were born? It won't let me die, Prey...</q>\b
    He takes a deep breath, giving{dummy} up on {me}.\b
    <q>Chaos decides,</q> he mutters. <q>So I bet my free will on chaos.</q>"

    inPersonStealthyMsg =
    "<.p>
    <<skashek.getPeekHis(true)>> gaze{dummy} passes <i>right over {me}!</i>\b
    <<remark()>>
    <.p>"

    inPersonAudioMsg =
    "<.p>
    <<remark()>>
    <.p>"
}

// Third batch of words when hiding from Skashek...
hidingParanoia_3_1_Message: HidingParanoiaMessage {
    inPersonStealthyMsg =
    "<.p>
    <<skashek.getPeekHe(true)>> doesn't say anything for a while,
    and simply searches.
    <.p>"

    inPersonAudioMsg() {
        inPersonStealthyMsg();
    }
}

hidingParanoia_3_2_Message: HidingParanoiaMessage {
    remark1 =
    "<q>My name,</q> he finally says, like a confession,
    <q>is <i><<gSkashekName>></i>. <i>Not</i> <q>Clone 3141</q>.
    And you are not <q>Clone <<prey.batchIDNumber>></q>.
    You have a name, too.</q>"

    remark2 =
    "<<if prey.outfit == preyUniform
    >><q>And the uniform you're wearing?<<else
    >>And the uniform I put in the Delivery Room closet? With a tag for<<end
    >> <q>Clone <<preyUniform.getCloneID()>></q>?
    She named herself <q>Marssella</q>. She and I had a wonderful alliance.
    Just the two of us, against the others. We were the only proponents of
    empathy and cooperation. Can you imagine <i>that</i>, Prey?</q>\b
    {I} could imagine <i>plenty</i> of things.
    The immediate realities are more pressing, though."

    inPersonStealthyMsg() {
        skashek.trueNameKnown = true;
        epilogueCore.positiveRelationshipEnding = true;
        "<.p>
        <<remark1()>>\b
        He turns to look <i>right where {i} {am} hiding</i>.\b
        <<remark2()>>
        <.p>";
    }

    inPersonAudioMsg() {
        skashek.trueNameKnown = true;
        epilogueCore.positiveRelationshipEnding = true;
        "<.p>
        <<remark1()>>\b
        I can hear him step a bit closer.\b
        <<remark2()>>
        <.p>";
    }
}

hidingParanoia_3_3_Message: HidingParanoiaMessage {
    remark1 =
    "<q>Sometimes the walls sound like her,</q> <<skashek.getPeekHe()>> mutters"

    remark2 =
    "<q><q>What did I taste like?</q> the walls ask, wearing her voice like a costume.
    <q>I'm just glad I was your first,</q> she says, like it's something I should
    be praised for.
    <q>It means you held on for as long as you could,</q> she points out, conveniently
    paying no mind to the many generations of Prey, who have sustained me since.
    It feels <i>disloyal</i>, among other things.</q>"

    remark3 =
    "<q>I wasn't eager, by the way. She starved herself to death, by giving me
    the <i>actual</i> remaining food supplies, while she ate that fucking
    <i>reservoir kelp</i>. I guess the circuits in her brain stem thought that
    was <q>eating</q>, and not the slow suicide that it was.</q>"

    remark4 =
    "<q>I wish her lapse in mutualism had done the other way. I wish she would
    have fed <i>me</i> the kelp, instead. Maybe I should have angered her in our
    final moments. Maybe she would have cared less about my well-being, then.</q>"

    remark5 =
    "<q>But apparently <i>chaos</i> fucking decides. So maybe I'm confessing to
    and empty room, again. Maybe that would be for the best.</q>"

    inPersonStealthyMsg =
    "<.p>
    <<remark1()>>, looking at some distant horizon.
    <<remark2()>>\b
    He looks up, and takes a deep breathe.\b
    <<remark3()>>\b
    He comes back to his surroundings.\b
    <<remark4()>>\b
    He looks at my hiding spot again.\b
    <<remark5()>>
    <.p>"

    inPersonAudioMsg =
    "<.p>
    <<remark1()>>.
    <<remark2()>>\b
    He can be heard taking a deep breathe.\b
    <<remark3()>>\b
    He pauses.\b
    <<remark4()>>\b
    He pauses again.\b
    <<remark5()>>
    <.p>"
}

// final batch of words when hiding from Skashek...
hidingParanoia_4_1_Message: HidingParanoiaMessage {
    pauseRemark =
    "<<skashek.getPeekHe(true)>> doesn't say anything for a moment."

    inPersonStealthyMsg =
    "<.p>
    <<pauseRemark()>>
    His eyes just scan the area.
    <.p>"

    inPersonAudioMsg =
    "<.p>
    <<pauseRemark()>>
    <.p>"
}

hidingParanoia_4_2_Message: HidingParanoiaMessage {
    inPersonStealthyMsg =
    "<.p>
    <q>Are you here, Prey?</q> <<skashek.getPeekHe()>> asks.
    <q>How many of these little therapy sessions have you attended?</q>
    <.p>"

    inPersonAudioMsg() {
        inPersonStealthyMsg();
    }
}

hidingParanoia_4_3_Message: HidingParanoiaMessage {
    inPersonStealthyMsg =
    "<.p>
    He says nothing else, and simply concludes that {i} {am} not here.
    <.p>"

    inPersonAudioMsg() {
        inPersonStealthyMsg();
    }
}