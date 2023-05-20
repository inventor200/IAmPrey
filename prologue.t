#define showPrologue prologueCore.play()
#ifdef __DEBUG
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
        "<b>Content warning:</b>\b";
        if (gFormatForScreenReader) {
            "For violence, frequent crude language, and rare mentions of suicide.";
        }
        else {
            "\t<tt>[&gt;&gt;]</tt> Violence\n
            \t<tt>[&gt;&gt;]</tt> Frequent crude language\n
            \t<tt>[&gt;&gt;]</tt> Rare mentions of suicide";
        }
        "\b<b>Anxiety warning:</b>\b

        This game features an active antagonist,
        so your turns must be spent wisely!\b

        <b>Note on randomness and <<InstructionsChapter.formatCommand('UNDO')>>:</b>\b

        Elements of this game are randomized, with casual replayability
        in mind. Use of <<InstructionsChapter.formatCommand('UNDO')>>
        will not change the outcomes of randomized events.\b
        Rest assured that your survival is not decided by randomness.";
        "\b";
        inputManager.pauseForMore();
        #if __IS_MAP_TEST // is map test
        huntCore.setDifficulty(1);
        #if __ALLOW_CLS
        cls();
        #endif
        catCutscene.play();
        #else // is not map test
        #if __ALLOW_CLS
        cls();
        #endif
        """
        \b<b>Note for new and experienced players:</b>\b

        This will not be a standard parser game. Players of <b>all skill levels</b>
        should consult <i>Prey's Survival Guide</i>
        (which should have come with this game), or use the
        <<InstructionsChapter.formatCommand('guide')>> command
        for the in-game version of the document.\b

        There are a number of new game mechanics ahead, and
        they were not designed with the traditions of this medium in mind.\b

        For more information, experienced parser players should use the
        <<InstructionsChapter.formatCommand('parser warning')>> command.
        \b""";
        inputManager.pauseForMore();
        "\b";
        local difficultyQuestion = new ChoiceGiver('Choose your difficulty');
        local difficulties = huntCore.difficultySettings;
        for (local i = 1; i <= difficulties.length; i++) {
            local difficulty = difficulties[i];
            difficultyQuestion.add(toString(i), difficulty.title, difficulty.getBlurb());
        }
        local result = difficultyQuestion.ask();
        huntCore.setDifficulty(result);
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
        huntCore.setDifficulty(__FAST_DIFFICULTY);
        #endif // end show prologue
    }

    play() {
        #if __SHOW_PROLOGUE
        /*"\b\b\b<i>Use the</i> <<gDirectCmdStr('help')>> <i>command,
        if you would like written tutorials or other info resources.\b
        You can also use the</i> <<gDirectCmdStr('verbs')>> <i>command,
        which will provide a reference for all actions and commands that are
        useful throughout this game!</i>
        \b\b\b";*/
        #endif
        "<center><small>WELCOME TO...</small>\b
        <b><tt>I AM <<if gCatMode>>CAT<<else>>PREY<<end>></tt></b>\n
        <small>version <<versionInfo.version>></small>\b
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
            When {i} realize {i}{'m} alive, {i}{'m} not really sure how much time
            has passed. The only thing {i} <i>do</i> know is that {i} seem to be
            dreaming.\b
            Well... Something{dummy} is <i>delivering</i> this dream <i>to</i> {me}...\b
            It{dummy} has taught {me} <i>language</i>, but only the words necessary for
            listening and obedience. {I} have no way of knowing how much
            it is withholding, and {i} lack the vocabulary to test its veracity.\b
            The rapid rate of delivery is overwhelming, and it expects {my}
            ignorance, compliance, and attention.
            Every advantage is attempted&mdash;<i>within
            {my} own head</i>, no less...!\b
            Above all, it expects to be <i>accepted</i>, without a hint of rejection.
            It cannot <i>conceive</i> of a scenario where
            {i} do not simply roll over and <i>obey</i>."
        });
        introCutscene.addPage({:
            "It{dummy} preaches strange things to {me}:\b
            Impoverished masses allegedly storming the shores of a crumbling empire.\b
            A starving workforce refusing to sell their lives for profit,
            and supposedly straying from the light of a <q>hard day's work</q>.\b
            There is a decline in mimicry for certain vacuous behaviors,
            once inspired by the <q>true-blooded few</q>.\b
            The Enemy is said to be a powerful colossus of culture, and
            yet&mdash;somehow&mdash;it is also
            egregiously <i>incompetent</i>, almost to the point of self-satire.\b
            Above all, none of it makes <i>any fucking sense</i>,
            but it's{dummy} still told to {me} with bold self-assurance."
        });
        introCutscene.addPage({:
            "Something{dummy} within {me}&mdash;native to {my} own mind&mdash;has reflexes.
            Without articulation, {i} see the dream's frailty. {I} seem to be
            designed for quick thinking, out-maneuvering, empathy, and <i>tactics</i>.
            {I} {was} originally born to \"get the job done\", at <i>any cost</i>.\b
            The intruder seems to think {i} {am} its <i>servant</i>.
            {My} genesis&mdash;as well as its own&mdash;were both initiated
            by those who only understood the world in terms of
            grandstanding and profit.\b
            Best of all:
            <i>The invader of {my} mind{dummy} seems to underestimate {me}, and {my}
            creators are not here to advise it to take any caution...</i>"
        });
        introCutscene.addPage({:
            "Before {i} can make any counter-attack,
            {my} lungs suddenly fill with liquid, and {i} begin to drown.\b
            {I} thrash, gnash, and claw at the sensation.\b
            Something gives way, and the waking world washes away the final
            shreds of whatever dream{dummy} (or nightmare)
            that was being injected into {me}..."
        });

        catCutscene = new Cutscene();
        catCutscene.addPage({:
            "<center><b><tt>PROLOGUE (CAT EDITION)</tt></b></center>\b
            {I} {am} a <b>cat</b>; nature's chosen ruler of this realm, though most have
            yet to realize this.\b
            {My} domain used to have <i>a lot more</i> activity. {I} had trusted these
            subjects (back when they still lived), but they had behaved under
            <i>{my}</i> careful watch, alone.
            They used to do <i>strange things</i>, make <i>weird sounds</i>,
            and move around <i>a lot</i>.\b
            Sometimes, infuriating moments would pass without the necessary head pats.
            Other times, {i} would not be fed more than three times a day, no matter
            how many vocal sounds {i} made.
            During one moment in particular, {i} {was} <i>forcibly removed from a
            room</i>, after adequately punishing some silly object on a shelf!\b
            Eventually, {my} citizens returned to their senses. Head pats were given,
            food was regularly delivered <i>(still only three times a day, though)</i>,
            and they would <i>usually</i> look the other way,
            as {i} sent various inanimate objects down to
            <i>more suitable altitudes</i> (the floor).\b
            Maybe <i>occasional</i> infractions could be forgiven, after all..."
        });
        catCutscene.addPage({:
            "One day, a rather <i>tense</i> period began, where one half of {my}
            citizens showed clear signs of discontent, while the other half continually
            built oppressive environments around the first.\b
            (No head pats! Restricted food! <i>Hitting!!</i> No <i>wonder</i> many
            had felt so neglected!!
            {I} would have <i>never</i> accepted such treatment!)\b
            None of this was <i>{my}</i> fault, though; {i} {was} a <i>merciful</i> ruler,
            but {i} {was} also <b>not</b> an <i>arbiter!</i>
            {I} had decided it was best for these citizens to handle their <i>own</i>
            problems!\b
            There was blood. A <i>lot</i> of blood. {I} {was} not <i>scared</i>,
            of course; the Neglected Ones{dummy} had shown {me} the appropriate
            amount of respect,
            usually by performing their kills outside of {my} personal chamber.
            They{dummy} <i>understood</i> {me}. In fact,
            this was probably the <i>ideal outcome!</i>\b
            Once the screams, wailing, and fearful cries had finally subsided,
            {i} figured the situation had gotten sufficiently-calm.
            Maybe {i} could <i>finally</i> catch up on some sleep, without all of that
            <i>shrieking</i> in the hallways!"
        });
        catCutscene.addPage({:
            "{I} returned to {my} role as <i>watchful ruler</i>, once a few short
            fights were all that remained between surviving citizens. Eventually, a
            single Royal Subject still lived, hands caked in blood,
            and {i} graciously shared this world with him.\b
            For a while, he would sob every night. {I} understood why: He was clearly
            <i>starving</i>, but wasn't <i>eating</i> for some reason. {I} wondered
            if&mdash;perhaps&mdash;he{dummy} was waiting for {me} to feed first? Was
            he{dummy} obediently waiting for {me} to usher in {my} <b>new era of rule</b>?\b
            One night, {i} approached him, as he wept over a corpse. It could have been
            his <i>twin</i>, if the body hadn't taken a different scent.
            <i>All</i> of the Neglected Ones had looked the same, compared to the variety
            seen in the Oppressors of ages passed.\b
            After a moment of sitting and making regal gestures, {i} took a small bite
            from the corpse. His sobbing paused, and he{dummy} watched {me} silently. He didn't
            seem <i>angry</i> or <i>offended</i> (he knew his place),
            but it <i>did</i> take him a long time to process {my} royal decree.
            He eventually understood, and{dummy} joined {me} in the Inaugural Feast."
        });
        catCutscene.addPage({:
            "{I}{'m} not as nimble as {i} used to be, but {my} lone Royal Subject
            provides great care{dummy} for {me}.
            <i>Ages</i> ago, {my} original food supply had ended.
            This{dummy} displeased {me}, but {my} Subject was generous, and found an
            expedient solution. He{dummy} began to share pieces of the corpses with {me},
            which he gathered from the Freezer, and prepared in the oven.\b
            The cooked bodies had a <i>different flavor</i>, for sure, but it was similar
            enough to the original food supply,
            so {i} forgave this small change in {my} routine.\b
            Today, {i} decide to test {my} aging joints, and take a tour of {my} domain."
        });
        selectDifficulty();
    }
}
    