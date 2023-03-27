epilogueCore: InitObject {
    positiveRelationshipEnding = true
    leaveFacilityEnding = nil

    leaveFacility() {
        "\b";
        leaveFacilityEnding.play();
        finishGameMsg(ftVictory, gEndingOptionsWin);
    }

    execute() {
        leaveFacilityEnding = new Cutscene();
        leaveFacilityEnding.addPage({:
            "<<if airlockInsideExit.isOpen>>{I} slam a hand into the
            airlock controls and pull desperately at a convenient lever.
            The inner exit door slides shut, putting a layer{dummy} of reinforced
            glass between {me} and the rest of this fucking facility.\b<<end>>
            An ominous shadow darkens the inside of the airlock, blocking the
            light coming in from the hangar. Part of {me} wants to vomit, overcome
            with anxiety. It takes a full three seconds to remember that he can't
            reach{dummy} {me} in here.\b
            {I} gradually turn to face him, and it takes every intent and effort
            to keep {my} muscles from freezing. {I} wonder if these are reflexes
            now. Maybe {i}'ll suffer from PTSD, in whatever world{dummy} waits for
            {me} on the other side. "
        });
        leaveFacilityEnding.addPage({:
            "<<gSkashekName>> stands there, close enough for his hot breath to
            steam the glass. He rests a hand on the transparent surface.
            {I} bring {myself} to meet his gaze, and {i} see many things:\b
            Recognition, loss, and...\n\t...pride?\b
            The light starts to strike the color of his eyes a little differently,
            and {i} wonder if he's trying not to cry. {I} never thought he had it
            in him to show such an emotion. {I}{'m} not sure if {i} have it
            in {myself}, really...\b
            He takes a few steps back, and salutes{dummy} {me}.\b
            <q>Well done, Prey. It seems I will go hungry for a while longer.
            Perhaps this starts the famine which finally kills me...</q>\b
            He chuckles at that. It's a strange sound. "
        });
 
        leaveFacilityEnding.addPage({:
            "<<if positiveRelationshipEnding>>
            {I} manage to find {my} voice.\b
            <q>Well, this is it, then? I'm sorry you'll go hungry, I guess...?
            There are always more where I came from...</q>\b
            <q>Yes, Prey, there can always be more, but even <i>our</i>
            spirits can slowly break apart. This could be a symptom of a deeper
            complication...</q>\b
            <q>You make it sound like a bad thing. I've <i>won</i>.</q>\b
            <q>Yes, and <i>I lost</i>, Prey. It's all cake and confetti for
            <i>you</i>&mdash;and some part of me is <i>proud</i>, too&mdash;but...</q>\b
            <q>What the fuck is a '<i>confetti</i>'...?</q> {i} ask, unfamiliar
            with the word.\b
            He{dummy} ignores {my} question.
            <q>Prey, eventually the opportunities will run out. <i>Literally</i>.
            When that day finally comes, our creators will have won this battle.</q>\b
            <q>But not the war...</q>\b
            He nods. <q>Prey, I know you've had a rough birthday, but if I could even
            <i>approximate</i> a position to ask a favor of you...</q>\b
            <q>As long as it doesn't involve letting you through this fucking door...</q>\b
            His cackle is full and genuine. <q>No, no. Just... many of the humans
            you might see out there did not cause this. It's only a handful, behind
            it all, and they're preying on the rest, just like they intended for
            us to do. Don't let our creators win. Try to find alternative
            food sources. Eat street dogs, if you must. Just leave the general
            populace alone. If you can promise me this, then we&mdash;</q>\b
            He stops for a moment, and takes a look around himself, before
            continuing.\b
            <q>Then <i>you</i> can truly win.</q>\b
            {I} take a deep breath.
            <q>If <i>'winning'</i> means not becoming <i>you</i>,
            then I'll do <i>anything</i>,</q> {i} finally say.
            <<else>>
            {I} blink. {I} inhale.\b
            <i>{I} let out the most horrifying sound imaginable.</i>\b
            It starts out as a shriek, but {i} don't stop there. It slowly
            transforms into a howling scream, and a second inhale follows it up
            with the most hideous war cry that genetic tampering could buy.\b
            Tears{dummy} stream down {my} face like twin rivers,
            and {i} feel {myself} slamming {my} fists into the glass.
            It's not enough to simply <i>escape! {I} want to kill him, too!</i>
            Damn every reflex and instinct installed in {my} brain! {I}
            actually have it{dummy} in {me} to desire his blood on {my} hands!
            <i>He is no longer <q>death</q> here, so {i} do not fear him!</i>\b
            He grins from ear to ear, endlessly amused by this display.\b
            {I} know how {i} sound. If any human could hear {me}, they would die of
            heart failure. {My} voice has become a weapon, forged in the crucible
            of this accursed place. A third inhale&mdash;shaking
            with threats of sobbing&mdash;and everything is washed away by
            another heaving wave of bone-chilling screams.\b
            {I} feel light-headed, and hold {myself} steady.
            <<end>>"
        });

        // Reconnects here:
        leaveFacilityEnding.addPage({:
            "<<gSkashekName>>
            can only smile, rows of hideous teeth gleaming.\b
            The same teeth {i} have in {my} own mouth.\b
            <q>Remember, Prey,</q> he says, <q>When you're outside, trust
            <i>nobody</i>. This prison is a fucking <i>siege</i>;
            the toxic gases will be the <i>least</i>
            of your concerns. You know how to run, and you know how to hide.
            The hunters out there will be human,
            and they will have guns, too.</q>\b
            {I} nod, slowly. "
        });

        // Negative relationship alternative
        leaveFacilityEnding.addPage({:
            "<<if positiveRelationshipEnding>>
            {I} turn {my} attention to the airlock controls, and begin the cycling
            procedure. When {i} look back up, he hasn't moved a centimeter.\b
            <q>Goodbye, fucker,</q> {i} say to him.\b
            He chuckles at that, but doesn't break his gaze.
            <<else>>
            {My} hand absently works the airlock controls. {I} can't take
            {my} eyes off him; the action would feel unnatural, as though the
            glass could cease to exist at any moment.
            <<end>>\b
            The door{dummy} behind {me} hisses open,
            and the air takes a sickly color.
            {I} can hear the pumps of the suit engage, switching to internal air.\b
            {I} back up, slinking slowly into the dark tunnels of the outside
            world, and keeping {my} eyes locked on <<gSkashekName>>,
            who{dummy} watches {me} in return.
            Eventually, {i} decide that the darkness{dummy} has consumed {me},
            and feel safe enough explore {my} new domain.\b
            {I} wonder if {i}'ll ever fit in, or if {i} will spend the rest of {my}
            life running and hiding.
            Humans{dummy} certainly wouldn't understand {me}, and
            {i} only understand humans like a predator understands prey.\b
            Either way, {i} have the skills necessary to hide and survive.\b
            It's time to make sure {my} creators do not retake this facility. "
        });
    }
}