/*
 * This game has a lot of custom mechanics, a narrow scope of play, and
 * requires less overall discovery for the player. Therefore, it would be
 * best for the player to have access to custom instructions, specifically
 * made for everything covered in this game.
 */

VerbRule(ShowVerbs)
    ('show'|'list'|'remind' 'me' 'of'|'refresh' ('me'|) ('on'|'about')|'review'|'see') (('all'|) 'verbs' | 'verb' 'list') |
    ('verb'|'verbs') ('all'|'list') |
    ('all'|) 'verbs'
    : VerbProduction
    action = ShowVerbs
    verbPhrase = 'show/showing verbs'        
;

DefineSystemAction(ShowVerbs)
    execAction(cmd) {
        instructionsCore.showVerbs();
    }
;

VerbRule(ShowExperiencedWarning)
    ('show'|'read'|'x'|) ('experienced'|'expert'|) 'parser' ('player'|) 'warning'
    : VerbProduction
    action = ShowExperiencedWarning
    verbPhrase = 'show/showing the warning for experienced parser players'        
;

DefineSystemAction(ShowExperiencedWarning)
    execAction(cmd) {
        experiencedWarningChapter.play();
    }
;

#define expandedSuit 'suit'|'envirosuit'|('environment'|'enviro') 'suit'
VerbRule(ShowSuitProgress)
    ('show'|'get'|'x'|'track'|'review'|'update'|'what' 'is' ('my'|)) (expandedSuit|) ('progress'|'count') |
    ('review'|'update') (expandedSuit) ('pieces'|'parts') |
    'how' 'many' (expandedSuit) ('pieces'|'parts') ('remain'|(('do' 'i'|'does' 'prey') 'have'|'are') 'left' ('to' 'get'|)|('do' 'i'|'does' 'prey') 'have') |
    ('show'|'get'|'x'|) (expandedSuit) ('update'|'progress') |
    ('show'|'get'|'x'|'how' 'many') (expandedSuit|) ('pieces'|'parts') (('that'|) 'are' ('still'|)|'still'|) ('left'|'remaining'|'hidden'|'missing'|'out' 'there') |
    'progress'
    : VerbProduction
    action = ShowSuitProgress
    verbPhrase = 'show/showing the warning for experienced parser players'        
;

DefineSystemAction(ShowSuitProgress)
    execAction(cmd) {
        if (gCatMode) {
            "The only thing <i>this</i> king searches for is
            <<gSkashekName>>!";
        }
        else {
            "<<suitTracker.getProgressLists()>>";
        }
    }
;

modify VerbRule(instructions) 
    'instructions' |
    ('show'|'read'|'x'|'open'|'review'|'look' 'at'|) (('prey'|'preys'|'prey\'s'|) 'survival'|) 'guide' 
    :
;

modify Instructions {
    showInstructions() {
        instructionsCore.openTableOfContents();
    }
}

modify helpMessage {
    showHowToWinAndProgress() {
        if (gCatMode) return;
        "<b>Find all seven pieces of the environment suit, and escape through the
        emergency airlock to win!</b>\b
        <<suitTracker.getProgressLists()>>";
    }

    fromHelpCommand = nil

    showHeader() {
        "<.p>
        <<gDirectCmdStr('about')>> for a general summary.\n
        <<gDirectCmdStr('credits')>> for author and tester credits.";
        if (!fromHelpCommand) {
            "\n<<gDirectCmdStr('help')>> for tutorials and assistance.";
        }
        if (sneakyCore.allowSneak) {
            "\b\t<b>AUTO-SNEAK is ENABLED!</b>\n
            Use the <b>SNEAK</b> (or <q><b>SN</b></q>) command to automatically
            sneak around the map! For example:\n
            \t<b>SNEAK NORTH</b>\n
            \t<b>SN THRU DOOR</b>\b
            <b>REMEMBER:</b> This is a <i>learning tool!</i> The <b>SNEAK</b>
            command <i>will be disabled outside of tutorial modes,</i>
            meaning you will need to remember to <b>LISTEN</b>, <b>PEEK</b>,
            and <b>CLOSE DOOR</b> on your own!\b
            If you'd rather practice without auto-sneak, simply enter in
            <<gDirectCmdStr('sneak off')>>.\b
            <b>REMEMBER:</b> You are always free to
            <<gDirectCmdStr('turn sneak back on')>> in a tutorial mode!";
        }
        fromHelpCommand = nil;
    }

    printMsg() {
        showHowToWinAndProgress();

        "\bTo read the in-game copy of
        Prey's Survival Guide (which explains how to play this game), type in the
        <<gDirectCmdStr('guide')>> command at the prompt.
        This could be necessary, if you are new to
        interactive fiction (<q><tt>IF</tt></q>), text games, parser games,
        text adventures, etc.\b
        For a reference list of verbs and commands, type in
        <<gDirectCmdStr('verbs')>>.\b
        Remember, you can always explore a simplified version of the
        world&mdash;<i>without spending turns</i>&mdash;as long as you are
        in <i>map mode!</i>\n
        Use the <<gDirectCmdStr('map')>> command to enter or leave map mode!";

        fromHelpCommand = true;
        
        showHeader();
    }

    briefIntro() {
        Instructions.showInstructions();
    }
}