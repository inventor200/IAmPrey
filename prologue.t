#define showPrologue prologueCore.play()

prologueCore: InitObject {
    introCutscene = nil
    catCutscene = nil

    execBeforeMe = [screenReaderInit]

    selectDifficulty() {
        cls();
        #if __SHOW_PROLOGUE
        "<b>Content warning:</b>\n";
        if (gFormatForScreenReader) {
            "For violence and crude language.";
        }
        else {
            "\t<tt>[&gt;&gt;]</tt> Violence\n
            \t<tt>[&gt;&gt;]</tt> Crude Language";
        }
        "\b<b>Anxiety warning:</b>\n
        This game features an active antagonist,
        so your turns must be spent wisely!\b
        <b>Note on randomness and UNDO:</b>\n
        Elements of this game are randomized, with casual replayability
        in mind. Use of UNDO will not change the outcomes of randomized
        events.\b
        Rest assured that your survival is not decided by randomness.";
        "\b";
        inputManager.pauseForMore();
        #if __IS_CAT_GAME
        cls();
        catCutscene.play();
        #else
        cls();
        local difficultyQuestion = new ChoiceGiver('Choose your difficulty');
        difficultyQuestion.add('1', 'Basic Tutorial',
            'You are new to interactive fiction (<q><tt>IF</tt></q>), and are not
            versed in the usual controls or mechanics of parser-based text games.\n
            <b>This tutorial will also introduce you to the game\'s parkour
            movement mechanics!</b>\b
            <i>(You play as the Predator\'s pet cat, attempting to avoid bath time.)</i>'
        );
        difficultyQuestion.add('2', 'Prey Tutorial',
            'You are new to <i>I Am Prey</i>, and have not used the parkour,
            stealth, or chase mechanics before.\b
            <i>(The Predator will offer you a second chance,
            allow you a single pop-out escape,
            and can be stalled by doors up to five times.)</i>'
        );
        difficultyQuestion.add('3', 'Easy Mode',
            'The Predator has had a string of victories, and will go
            easy on you, mostly for his own entertainment.\b
            <i>(The Predator will only
            allow you a single pop-out escape,
            and will be stalled by doors up to five times.)</i>'
        );
        difficultyQuestion.add('4', 'Medium Mode',
            'The Predator revels in his apparent sense of superiority over you.
            This hunt will have the typical amount of sadism.\b
            <i>(The Predator will only
            be stalled by doors up to five times.)</i>'
        );
        difficultyQuestion.add('5', 'Hard Mode',
            'The Predator must be furious, and is taking all of his
            rage out on you, during this hunt.\b
            <i>(The Predator will only
            be stalled by doors up to three times,
            and the prologue will be skipped.)</i>'
        );
        difficultyQuestion.add('6', 'Nightmare Mode',
            'What the <i>fuck?!</i> Something has really gotten into the Predator
            today! His cruelty is <i>insatiable!</i>\b
            <i>(The Predator will maximize his capabilities for the entire hunt,
            and the prologue will be skipped.)</i>'
        );
        local result = difficultyQuestion.ask();
        switch (result) {
            case 1:
                huntCore.difficulty = basicTutorial;
                break;
            case 2:
                huntCore.difficulty = preyTutorial;
                break;
            case 3:
                huntCore.difficulty = easyMode;
                break;
            case 4:
                huntCore.difficulty = mediumMode;
                break;
            case 5:
                huntCore.difficulty = hardMode;
                break;
            case 6:
                huntCore.difficulty = nightmareMode;
                break;
        }
        cls();
        if (result == 1) {
            catCutscene.play();
        }
        else if (result < 5) {
            introCutscene.play();
        }
        #endif
        "\b";
        #endif
    }

    play() {
        #if __SHOW_PROLOGUE
        /*"<center><b><tt>IF HELP IS NEEDED</tt></b></center>\b
        For those new to interactive fiction and text games, use the HELP
        command to get a crash-course, specifically written with this game
        in mind.\b
        For those new to <i>this game in particular</i>, use the EXTRAS ON
        command to get occasional messages in the form of an on-the-go tutorial.
        You can disable these later with EXTRAS OFF.
        <b>EXTRAS do not contain puzzle solutions, hints, or spoilers!</b>\b
        If you ever forget how to do something, the VERBS command provides
        a reference for all the other commands, verbs, and actions available
        to you.";*/
        "\b\b\b<i>Remeber to use the</i> <b>VERBS</b> <i>command, which will provide
        a reference for all actions and commands that are useful throughout
        this game!</i>
        \b\b\b";
        #endif
        "<center><small>WELCOME TO...</small>\b
        <b><tt>I AM <<if gCatMode>>CAT<<else>>PREY<<end>></tt></b>\b
        A game of evasion, by Joey Cramsey<<if !gCatMode>>\b
        <i><q>This is based on a recurring nightmare of mine,
        so now it's your problem, too!</q></i><<end>>";
        #if __IS_CAT_GAME
        "\b<i><q>The limited edition for testers!</q></i>\n(The full game will <b>not</b> be a cat game, lol)";
        #endif
        "</center>\b
        <<gDirectCmdStr('about')>> for a general summary.\n
        <<gDirectCmdStr('credits')>> for author and tester credits.";
        "\b";
    }

    execute() {
        introCutscene = new Cutscene();
        introCutscene.addPage({:
            "<center><b><tt>PROLOGUE</tt></b></center>\b
            When you realize you're alive, you're not really sure how much time
            has passed. The only thing you <i>do</i> know is that you seem to be
            dreaming.\b
            Well... Something is <i>delivering</i> this dream <i>to</i> you...\b
            It has taught you <i>language</i>, but only the words necessary for
            listening and obedience. You have no way of knowing how much
            it is withholding, and you lack the vocabulary to test its veracity.\b
            The rapid rate of delivery is overwhelming, and it expects your
            ignorance and compliance. Every advantage is attempted&mdash;<i>within
            your own head</i>, no less...!\b
            Above all, it expects to be <i>accepted</i>, without a hint of rejection.
            It cannot <i>conceive</i> of a scenario where
            you do not simply roll over and <i>obey</i>."
        });
        introCutscene.addPage({:
            "It preaches strange things to you:\b
            Impoverished masses allegedly storming the shores of a crumbling empire.\b
            A starving workforce refusing to sell their lives for profit,
            and supposedly straying from the light of a <q>hard day's work</q>.\b
            There is a decline in mimicry for certain vacuous behaviors,
            once inspired by the <q>true-blooded few</q>.\b
            The Enemy is said to be a powerful colossus of culture, and
            yet&mdash;somehow&mdash;it is also
            egregiously <i>incompetent</i>, almost to the point of self-satire.\b
            Above all, none of it makes <i>any fucking sense</i>,
            but it's still told to you with bold self-assurance."
        });
        introCutscene.addPage({:
            "Something within you&mdash;native to your mind&mdash;has reflexes.
            Without articulation, you see the dream's frailty. You seem to be
            designed for quick thinking, out-maneuvering, empathy, and <i>tactics</i>.
            You were originally made to \"get the job done\", at <i>any cost</i>.\b
            The intruder seems to think you are its <i>servant</i>.
            Your genesis&mdash;as well as its own&mdash;were both initiated
            by those who only understood the world in terms of
            grandstanding and profit.\b
            Best of all:
            <i>The invader of your mind seems to underestimate you, and your
            creators are not here to advise it to take any caution...</i>"
        });
        introCutscene.addPage({:
            "Before you can make any counter-attack,
            your lungs suddenly fill with liquid, and you begin to drown.\b
            You thrash, gnash, and claw at the sensation.\b
            Something gives way, and the waking world washes away the final
            shreds of whatever dream or nightmare that was being injected into you..."
        });

        catCutscene = new Cutscene();
        catCutscene.addPage({:
            "<center><b><tt>PROLOGUE (CAT EDITION)</tt></b></center>\b
            You are a <b>cat</b>; nature's chosen ruler of this realm, though most have
            yet to realize this.\b
            Your domain used to have <i>a lot more</i> activity. You had trusted these
            subjects (back when they still lived), but they had behaved under
            <i>your</i> careful watch, alone.
            They used to do <i>strange things</i>, make <i>weird sounds</i>,
            and move around <i>a lot</i>.\b
            Sometimes, infuriating moments would pass without the necessary head pats.
            Other times, you would not be fed more than three times a day, no matter
            how many vocal sounds you made.
            During one moment in particular, you were <i>forcibly removed from a
            room</i>, after adequately punishing some silly object on a shelf!\b
            Eventually, your citizens returned to their senses. Head pats were given,
            food was regularly delivered <i>(still only three times a day, though)</i>,
            and they would <i>usually</i> look the other way,
            as you sent various inanimate objects down to
            <i>more suitable altitudes</i> (the floor).\b
            Maybe <i>occasional</i> infractions could be forgiven, after all..."
        });
        catCutscene.addPage({:
            "One day, a rather <i>tense</i> period began, where one half of your
            citizens showed clear signs of discontent, while the other half continually
            built oppressive environments around the first half.\b
            (No head pats! Restricted food! <i>Hitting!!</i> No <i>wonder</i> certain
            citizens had felt so neglected!!
            You would have <i>never</i> accepted such treatment!)\b
            None of this was <i>your</i> fault, though; you were a <i>merciful</i> ruler,
            but you were also <b>not</b> an <i>arbiter!</i>
            You had decided it was best for these citizens to handle their <i>own</i>
            problems!\b
            There was blood. A <i>lot</i> of blood. You weren't <i>scared</i>,
            of course; the Neglected Ones had shown you appropriate amounts of respect,
            usually by keeping their killings outside your personal chamber.
            They <i>understood</i> you. In fact,
            this was probably the <i>ideal outcome!</i>\b
            Once the screams, wailing, and fearful cries had finally subsided,
            you figured the situation had gotten sufficiently-calm.
            Maybe you could <i>finally</i> catch up on some sleep, without all of that
            <i>shrieking</i> in the hallways!"
        });
        catCutscene.addPage({:
            "You returned to your role as <i>watchful ruler</i>, once a few short
            fights were all that remained between surviving citizens. Eventually, a
            single Royal Subject still lived, hands caked in blood,
            and he graciously shared this world with you.\b
            For a while, he would sob every night. You understood why: He was clearly
            <i>starving</i>, but wasn't <i>eating</i> for some reason. You wondered
            if&mdash;perhaps&mdash;he was waiting for you to feed first? Was
            he obediently waiting for you to usher in your <b>new era of rule</b>?\b
            One night, you approached him, as he wept over a corpse. It could have been
            his <i>twin</i>, if the body hadn't taken a different scent.
            <i>All</i> of the Neglected Ones had looked the same, compared to the variety
            seen in the Oppressors of ages passed.\b
            After a moment of sitting and making regal gestures, you took a small bite
            from the corpse. His sobbing paused, and he watched you silently. He didn't
            seem <i>angry</i> or <i>offended</i> (he knew his place),
            but it <i>did</i> take him a long time to process your royal decree.
            He eventually understood, and joined you in the inaugural feast."
        });
        catCutscene.addPage({:
            "You're not as nimble as you used to be, but your lone Royal Subject
            provides great care for you. <i>Ages</i> ago, your original food supply had
            ended. This displeased you, but your Subject was generous, and found an
            expedient solution. He began to share pieces of the corpses with you,
            which he gathered from the Frozen Realm, and prepared in the Warm Box.\b
            The cooked bodies had a <i>different flavor</i>, for sure, but it was similar
            enough to the original food supply,
            so you forgave this small change in your routine.\b
            Today, you decide to test your aging joints, and take a tour of your domain."
        });
        selectDifficulty();
    }
}
    