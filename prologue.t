#define showPrologue prologueCore.play()
#if __DEBUG
#define __ALLOW_CLS true
#else
#define __ALLOW_CLS true
#endif

prologueCore: InitObject {
    introCutscene = nil
    catCutscene = nil

    execBeforeMe = [screenReaderInit]

    selectDifficulty() {
        #if __ALLOW_CLS
        cls();
        #endif
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
        #if __IS_MAP_TEST // is map test
        huntCore.setDifficult(1);
        #if __ALLOW_CLS
        cls();
        #endif
        catCutscene.play();
        #else // is not map test
        #if __ALLOW_CLS
        cls();
        #endif
        "\b<b>Definition of AUTO-SNEAKING:</b>\n
        Players must remember to perform <i>all</i> precautions
        for <i>stealth</i> and <i>safety</i>, as a core part of this game!\b
        However, there are a few to
        remember&mdash;<i>especially while under pressure</i>&mdash;so
        both tutorial modes offer <b>AUTO-SNEAKING</b>, which will perform these
        precautions <i>automatically</i>, giving new players a chance to explore
        and get used to other mechanics first.\b
        Once the player feels comfortable enough to remember these
        precautions for themselves, the non-tutorial modes will prevent use
        of the <b>SNEAK</b> action <i>entirely</i>.\b";
        inputManager.pauseForMore();
        "\b";
        local difficultyQuestion = new ChoiceGiver('Choose your difficulty');
        local difficulties = huntCore.difficultySettings;
        for (local i = 1; i <= difficulties.length; i++) {
            local difficulty = difficulties[i];
            difficultyQuestion.add(toString(i), difficulty.title, difficulty.getBlurb());
        }
        local result = difficultyQuestion.ask();
        huntCore.setDifficult(result);
        #if __ALLOW_CLS
        cls();
        #endif
        if (!huntCore.difficultySettingObj.skipPrologue) {
            if (result == 1) {
                catCutscene.play();
            }
            else {
                introCutscene.play();
            }
        }
        #endif // end is map test
        "\b";
        #else // do not show prologue
        huntCore.setDifficult(__FAST_DIFFICULTY);
        #endif // end show prologue
    }

    play() {
        #if __SHOW_PROLOGUE
        "\b\b\b<i>Use the</i> <<gDirectCmdStr('help')>> <i>command,
        if you would like written tutorials or other info resources.\b
        You can also use the</i> <<gDirectCmdStr('verbs')>> <i>command,
        which will provide a reference for all actions and commands that are
        useful throughout this game!</i>
        \b\b\b";
        #endif
        "<center><small>WELCOME TO...</small>\b
        <b><tt>I AM <<if gCatMode>>CAT<<else>>PREY<<end>></tt></b>\b
        A game of evasion, by Joey Cramsey<<if gPreyMode>>\b
        <i><q>This is based on a recurring nightmare of mine,
        so now it's your problem, too!</q></i><<end>>";
        #if __IS_MAP_TEST
        "\b<i><q>The limited edition for testers!</q></i>\n(The full game will <b>not</b> be a cat game, lol)";
        #endif
        "</center>";
        helpMessage.showHeader();
        "\b<<if gCatMode>>
        <b>REMEMBER:</b> In Cat Mode, you are free to explore! There is no pressure to
        <q>win</q> or <q>solve a puzzle</q> here! Once you are satisfied with your
        free-form exploration, use the <<gDirectCmdStr('restart')>> command to choose
        another difficulty, and begin a new game!
        <<end>>\b";
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
    