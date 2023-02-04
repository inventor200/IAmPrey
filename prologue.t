#define showPrologue prologueCore.play()

prologueCore: PreinitObject {
    introCutscene = nil

    play() {
        cls();
        #if __SHOW_PROLOGUE
        "<b>Content warning:</b>";
        if (gFormatForScreenReader) {
            " For violence and crude language.";
        }
        else {
            "<ul>
                <li>Violence</li>
                <li>Crude Language</li>
            </ul>";
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
        cls();
        local difficultyQuestion = new ChoiceGiver('Choose your difficulty');
        difficultyQuestion.add('1', 'Full Tutorial',
            'You are new to interactive fiction, and are not versed in
            the usual controls or mechanics of parser-based text games.\b
            <i>(The predator will offer you a second chance,
            allow you a single pop-out escape,
            and can be stalled by doors up to five times.)</i>'
        );
        difficultyQuestion.add('2', 'Partial Tutorial',
            'You are new to <i>I Am Prey</i>, and have not used the parkour,
            stealth, or chase mechanics before.\b
            <i>(The predator will be just as lenient as in
            the Full Tutorial choice.)</i>'
        );
        difficultyQuestion.add('3', 'Easy Mode',
            'The predator has had a string of victories, and will go
            easy on you, mostly for his own entertainment.\b
            <i>(The predator will only
            allow you a single pop-out escape,
            and will be stalled by doors up to five times.)</i>'
        );
        difficultyQuestion.add('4', 'Medium Mode',
            'The predator revels in his apparent sense of superiority over you.
            This hunt will have the typical amount of sadism.\b
            <i>(The predator will only
            be stalled by doors up to five times.)</i>'
        );
        difficultyQuestion.add('5', 'Hard Mode',
            'The predator must be furious, and is taking all of his
            rage out on you, during this hunt.\b
            <i>(The predator will only
            be stalled by doors up to three times,
            and the prologue will be skipped.)</i>'
        );
        difficultyQuestion.add('6', 'Nightmare Mode',
            'What the <i>fuck?!</i> Something has really gotten into the predator
            today! His cruelty is <i>insatiable!</i>\b
            <i>(The predator will maximize his capabilities for the entire hunt,
            and the prologue will be skipped.)</i>'
        );
        local result = difficultyQuestion.ask();
        switch (result) {
            case 1:
                gameMain.gameDifficulty = superTutorial;
                break;
            case 2:
                gameMain.gameDifficulty = tutorial;
                break;
            case 3:
                gameMain.gameDifficulty = easyMode;
                break;
            case 4:
                gameMain.gameDifficulty = mediumMode;
                break;
            case 5:
                gameMain.gameDifficulty = hardMode;
                break;
            case 6:
                gameMain.gameDifficulty = nightmareMode;
                break;
        }
        cls();
        if (result < 5) {
            introCutscene.play();
        }
        "\b";
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
        <b><tt>I AM PREY</tt></b>\b
        A game of evasion, by Joey Cramsey\b
        <i><q>This is based on a recurring nightmare of mine,
        so now it's your problem, too!</q></i></center>\b
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
    }
}
    