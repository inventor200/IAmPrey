epilogueCore: InitObject {
    positiveRelationshipEnding = true
    leaveFacilityEnding = nil

    leaveFacility() {
        "\b";
        leaveFacilityEnding.play();
        finishGameMsg(ftVictory, [
            finishOptionCredits
        ]);
    }

    execute() {
        leaveFacilityEnding = new Cutscene();
        leaveFacilityEnding.addPage({:
            "<<if airlockInsideExit.isOpen>>You slam a hand into the
            airlock controls and pull desperately at a convenient lever.
            The inner exit door slides shut, putting a layer of reinforced
            glass between you and the rest of this fucking facility.\b<<end>>
            An ominous shadow darkens the inside of the airlock, blocking the
            light coming in from the hangar. Part of you wants to vomit, overcome
            with anxiety. It takes a full three seconds to remember that he can't
            reach you in here.\b
            You gradually turn to face him, and it takes every intent and effort
            to keep your muscles from freezing. You wonder if these are reflexes
            now. Maybe you'll suffer from PTSD, in whatever world waits for you
            on the other side. "
        });
        leaveFacilityEnding.addPage({:
            "<<gSkashekName>> stands there, close enough for his hot breath to
            steam the glass. He rests a hand on the transparent surface.
            You bring yourself to meet his gaze, and you see many things:\b
            Recognition, loss, and...\n\t...pride?\b
            The light starts to strike the color of his eyes a little differently,
            and you wonder if he's trying not to cry. You never thought he had it
            in him to show such an emotion.\b
            He takes a few steps back, and salutes you.\b
            <q>Well done, Prey. It seems I will go hungry for a while longer.
            Perhaps this starts the famine which finally kills me...</q>\b
            He chuckles at that. It's a strange sound. "
        });
 
        leaveFacilityEnding.addPage({:
            "<<if positiveRelationshipEnding>>
            You manage to find your voice.\b
            <q>Well, this is it, then? I'm sorry you'll go hungry, I guess...
            There are always more where I came from...</q>\b
            <q>Yes, Prey, there can always be more, but even <i>our</i>
            spirits can slowly break apart. This could be a symptom of a deeper
            complication...</q>\b
            <q>You make it sound like a bad thing. I've <i>won</i>.</q>\b
            <q>Yes, and <i>I lost</i>, Prey. It's all cake and confetti for
            <i>you</i>&mdash;and a silly part of me is <i>proud</i>, too&mdash;but...</q>\b
            <q>What the fuck is a '<i>confetti</i>'...?</q> you ask, unfamiliar
            with the word.\b
            He ignores your question.
            <q>Prey, eventually the opportunities will run out. <i>Literally</i>.
            When that day finally comes, our creators will have won this battle.</q>\b
            <q>But not the war...</q>\b
            He nods. <q>Prey, I know you've had a rough birthday, but if I could even
            <i>approximate</i> a position to ask a favor of you...</q>\b
            <q>As long as it doesn't involve letting you through this fucking door...</q>\b
            His cackle is full and genuine. <q>No, no. Just... many of the humans
            you might see out there did not cause this. It's only a handful behind
            it all, and they're preying on the rest, just like they intended
            for you to. Don't let our creators win the war. Try to find alternative
            food sources. Eat street dogs, if you must. Just leave the general
            populace alone. If you can promise me this, then we <i>both</i> can win.</q>\b
            You take a deep breath.
            <q>If it means not becoming <i>you</i>, then I'll do <i>anything</i>,</q> you
            finally say.
            <<else>>
            You blink. You inhale.\b
            <i>You let out the most horrifying sound imaginable.</i>\b
            It started out as a shriek, but you didn't stop there. It slowly
            transforms into a howling scream, and a second inhale follows it up
            with the most hideous war cry that genetic tampering could buy.\b
            Tears stream down your face like twin rivers, and you feel yourself slamming
            your fists into the glass. It's not enough to simply <i>escape! You want
            to kill him, too!</i>\b
            He grins from ear to ear, endlessly amused by this display.\b
            You know how you sound. If any human could hear you, they would die of
            heart failure. Your voice has become a weapon, forged in the crucible
            of this accursed place. A third inhale&mdash;shaking
            with threats of sobbing&mdash;and everything is washed away by
            another heaving wave of bone-chilling screams.\b
            You feel light-headed, and hold yourself steady.
            <<end>>"
        });

        // Reconnects here:
        leaveFacilityEnding.addPage({:
            "<<gSkashekName>>
            can only smile, rows of hideous teeth gleaming.\b
            The same teeth you have in your own mouth.\b
            <q>Remember, Prey,</q> he says, <q>When you're outside, trust
            <i>nobody</i>. This prison is a fucking <i>siege</i>;
            the toxic gases will be the least
            of your concerns. You know how to run, and you know how to hide.
            The hunters out there will be human, but they will have guns, too.</q>\b
            You nod, slowly. "
        });

        // Negative relationship alternative
        leaveFacilityEnding.addPage({:
            "<<if positiveRelationshipEnding>>
            You turn your attention to the airlock controls, and begin the cycling
            procedure. When you look back up, he hasn't moved a centimeter.\b
            <q>Goodbye, fucker,</q> you say to him.\b
            He chuckles at that, but doesn't break his gaze.
            <<else>>
            Your hand absently works the airlock controls. You can't take
            your eyes off him; the action would feel unnatural, as though the
            glass could cease to exist at any moment.
            <<end>>\b
            The door behind you hisses open, and the air takes a sickly color.
            You can hear the pumps of the suit engage, switching to internal air.\b
            You back up, slinking slowly into the dark tunnels of the outside
            world, and keeping your eyes locked on <<gSkashekName>>, who watches you
            in return. Eventually, you decide that the darkness has consumed you,
            and feel safe enough explore your new domain.\b
            You wonder if you'll ever fit in, or if you will spend the rest of your
            life running and hiding. Humans certainly wouldn't understand you, and
            you only understand humans like a mechanic understands a machine.\b
            Either way, you have the skills necessary to survive."
        });
    }
}