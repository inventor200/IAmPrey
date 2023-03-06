/*
 * This game has a lot of custom mechanics, a narrow scope of play, and
 * requires less overall discovery for the player. Therefore, it would be
 * best for the player to have access to custom instructions, specifically
 * made for everything covered in this game.
 */

instructionsCore: InitObject {
    instructionsCutscene = nil

    execute() {
        //TODO: Add how to win, and make this a flowing, choice-based menu
        instructionsCutscene = new Cutscene();
        instructionsCutscene.addPage({:
            "<center><b><tt>TABLE OF CONTENTS</tt></b></center>\b
            <b>Page 1:</b> Table of Contents\n
            <b>Page 2:</b> Quick Intro to Parser Games\n
            <b>Page 3:</b> Common Shorthand and Abbreviations\n
            <b>Page 4:</b> Travel\n
            <b>Page 5:</b> Item Interaction and Inventory\n
            <b>Page 6:</b> Taking Turns and Undo\n
            <b>Page 7:</b> Parkour Crash Course\n
            <b>Page 8:</b> Stealth and Caution\n
            <b>Page 9:</b> Other Utility Commands"
        });
        instructionsCutscene.addPage({:
            "<center><b><tt>QUICK INTRO TO PARSER GAMES</tt></b></center>\b
            A <q>parser game</q> is a kind of turn-based text game where you
            (the player) interacts with a game world by typing in commands.\b
            Now, it is <b>crucial</b> to understand that parsers are generally
            not complex enough to fluently understand English. <b>However</b>,
            most authors still try to foster a comfortable amount of flexibility.\b
            Commands are usually notated in <b>ALL-CAPS</b>, but
            you are not expected to use upper-case letters <i>at all</i>, even
            when typing in a proper noun.\n
            <b>For example...</b>\b
            \tCommands, when listed within the game:\n
            \t\t<q>Try to <b>OPEN THE DOOR</b>!</q>\n
            \t\t<q>This lets you <b>JUMP OVER THE GAP</b>!</q>\n
            \t\t<q>You can <b>PUT THE CUP ON THE TABLE</b>!</q>\b
            \tCommands, when entered by the player:\n
            \t\t<b>&gt;open door</b>\n
            \t\t<b>&gt;jump over gap</b>\n
            \t\t<b>&gt;put cup on table</b>\b
            Also, while there <i>is</i> flexibility, there is <i>also</i> a sort of
            expectation that the game will reuse specific verbs, or otherwise
            hint at what words can be used.
            That way, the player will not be stuck typing in
            unrecognized words and commands all day. Ideally, the parser input
            should have a foundation of habit, expectation, and ease.\b
            Of course,
            the game might not be able to handle your desired action, but
            games tend to be played within a set of rules and constraints, anyway.
            When playing a racing game, you would not attempt to play it like a
            city-building simulator. In a first-person shooter, you would not be
            able to walk <i>everywhere</i>; you would eventually fall off of the
            game's map.\b
            However, you can quickly attain familiarity with parsers, and find
            a comfortable, immersive groove within the game's world."
        });
        instructionsCutscene.addPage({:
            "<center><b><tt>COMMON SHORTHAND AND ABBREVIATIONS</tt></b></center>\b
            There are a few common commands which have abbreviations for you to
            use, instead of typing in the whole word:\n
            \t<tt><b>L</b> =</tt> <b>LOOK AROUND</b>\n
            \t<tt><b>I</b> =</tt> <b>INVENTORY</b>\n
            \t<tt><b>N</b> =</tt> <b>GO NORTH</b>\n
            \t\tSimilarly, <tt><b>E</b> =</tt> <b>GO EAST</b>\n
            \t\tAlso, <tt><b>S</b></tt>, <tt><b>W</b></tt>\n
            \t\tetc...\n
            \t<tt><b>X</b> =</tt> <b>EXAMINE / LOOK AT</b>\n
            \t<tt><b>Z</b> =</tt> <b>WAIT</b>\n
            \t<tt><b>G</b> =</tt> <b>AGAIN</b>\n
            \t<tt><b>CL</b> =</tt> <b>CLIMB</b>\n
            \t<tt><b>JM</b> =</tt> <b>JUMP</b>\n
            \t<tt><b>P</b> =</tt> <b>PEEK</b>\n
            \t<tt><b>PK</b> =</tt> <b>SHOW PARKOUR ROUTES</b>\n
            \t<tt><b>LOCAL</b> =</tt> <b>SHOW LOCAL SURFACES</b> (for parkour)\n
            \t<tt><b>PK FULL</b> =</tt> shows parkour routes and local surfaces\b
            Additionally, you only need to be as specific as the situation requires.
            If there is only one box in the room, then <b>TAKE BOX</b> would suffice.
            If there is a red and blue box in the room, then you would need to
            specify <b>TAKE RED BOX</b>. Otherwise, the parser will ask you which
            of the two boxes you meant to take.\b
            This also means that if you have a door called
            <q>the south-end life support door</q>, and it's the only door in the
            room, then you can simply refer to it with <b>DOOR</b>."
        });
        instructionsCutscene.addPage({:
            "<center><b><tt>TRAVEL</tt></b></center>\b
            This game understands directions according to a compass.
            Valid directions for travel are:\n
            \t<b>NORTH</b> (<tt><b>N</b></tt>)\n
            \t<b>NORTHEAST</b> (<tt><b>NE</b></tt>)\n
            \t<b>EAST</b> (<tt><b>E</b></tt>)\n
            \t<b>SOUTHEAST</b> (<tt><b>SE</b></tt>)\n
            \t<b>SOUTH</b> (<tt><b>S</b></tt>)\n
            \t<b>SOUTHWEST</b> (<tt><b>SW</b></tt>)\n
            \t<b>WEST</b> (<tt><b>W</b></tt>)\n
            \t<b>NORTHWEST</b> (<tt><b>NW</b></tt>)\n
            \t<b>UP</b> (<tt><b>U</b></tt>)\n
            \t<b>DOWN</b> (<tt><b>D</b></tt>)\b
            Additionally, there are sometimes features of a room
            can be traveled through:\n
            \t<b>GO THROUGH WINDOW</b>\n
            \t<b>GO THROUGH DOOR</b>\n
            \t<b>GO THRU PASSAGE</b>\n
            \t<b>GO THRU VENT GRATE</b>"
        });
        instructionsCutscene.addPage({:
            "<center><b><tt>ITEM INTERACTION AND INVENTORY</tt></b></center>\b
            Given a cup, table, note, and cabinet, you can study the following example
            commands to learn how to interact with your environment:\n
            \t<b>TAKE CUP</b>\n
            \t<b>DROP CUP</b>\n
            \t<b>PUT CUP ON TABLE</b>\n
            \t<b>LOOK AT TABLE</b>\n
            \t<b>READ NOTE</b>\n
            \t<b>OPEN CABINET</b>\n
            \t<b>LOOK IN CABINET</b>\n
            \t<b>PUT NOTE IN CABINET</b>\n
            \t<b>CLOSE CABINET</b>\b
            You can carry objects with you in your <i>inventory</i>, which also has
            a limited capacity. To check your inventory, use the <b>INVENTORY</b>
            command.\b
            You can also use <b>IT</b> and <b>THEM</b> to refer to items from a
            previous command:\n
            \t<b>OPEN CABINET</b>\n
            \t<b>TAKE CUP AND NOTE IN IT</b>\n
            \t<b>LOOK AT THEM</b>\n
            \t<b>CLOSE CABINET</b>"
        });
        instructionsCutscene.addPage({:
            "<center><b><tt>TAKING TURNS AND UNDO</tt></b></center>\b
            Some actions cost turns, while others are <q>free actions</q>.
            Sometimes, the results and consequences of a free action will make
            it cost you a turn instead.\b
            Free actions include <b>INVENTORY</b>, <b>LOOK AT</b>, <b>LOOK THROUGH</b>,
            <b>LOOK AROUND</b>, <b>PEEK</b>, <b>PEEK THROUGH</b>, <b>SLAM</b>, 
            and <b>READ</b> (but only when re-reading!).\b
            After you take a turn, the antagonist will also take one. A free action
            means that the antagonist will not be able to take his turn.\b
            All <i>utility commands</i> (such as <b>SAVE</b>, <b>UNDO</b>,
            <b>RESTART</b>, <b>SHOW PARKOUR ROUTES</b>, and <b>LOCALS</b>)
            will <i>always</i> be free actions, as they are done <q>out-of-world</q>.\b
            The <b>UNDO</b> command (like in most parser games) is there for players
            who want to use it. With this, you are able to reverse your last
            command. <b>While this game does have randomized elements, the UNDO command
            will not change the outcome of most encounters. The consequences of your
            actions are entirely deterministic.</b>\b
            Also, <b>while this game <i>does</i>
            allow the use of UNDO, it is not <i>required</i> to play this game!</b>\b
            It is left to <i>you</i> to decide if you want to make use of
            <b>UNDO</b>, or limit your use of it in some way. It is assumed that you
            will know what suits your desired challenge and play style."
        });
        instructionsCutscene.addPage({: //TODO: SEARCH will be used instead of EXAMINE
            "<center><b><tt>PARKOUR CRASH COURSE</tt></b></center>\b
            This game makes use of a parkour system, which challenges you to find
            hidden routes between rooms.\b
            If you are <i>specific</i> about your actions, then you can discover new
            routes through experimentation:\n
            \t<b>CLIMB ATOP CABINET</b>\n
            \t<b>JUMP DOWN TO TABLE</b>\n
            \t<b>JUMP OVER GAP</b>\n
            \t<b>SWING ON BAR</b>\n
            \t<b>CRAWL UNDER CABLES</b>\n
            \t<b>CLIMB BETWEEN PIPES</b>\b
            However, the following shorthand commands require <i>prior discovery</i> of
            routes, because the approach is too ambiguous:\n
            \t<b>CLIMB DESK</b>\n
            \t<b>JUMP SHELF</b>\b
            To discover a route, you must <b>LOOK AT</b> a possible surface (from
            another surface). If there is a viable route, it will be confirmed to you,
            and you will be able to use shorthand commands to traverse it.\b
            The abbreviations <b><tt>CL</tt></b> and <b><tt>JM</tt></b> can be
            used for <b>CLIMB</b> and <b>JUMP</b> respectively.\b
            <i>Jumping</i> differs from <i>climbing</i> in a few ways. For one, you
            must jump to surfaces that are out of normal reach, but it also causes more
            noise (which is generally not ideal for stealth). Some jumps are
            <i>dangerous</i> as well, which will award an extra turn to your predator.\b
            The <b>ROUTES</b> command (<b>PK</b> for short) lists the currently-known
            routes from your present location. Obvious routes (like climbing a desk
            from the floor) will not be listed.\n
            The <b>LOCALS</b> command lists accessible surfaces from your present
            location, which could be things like a desk from the floor, or a crate
            resting on some elevated platform, which you also stand on.\n
            The <b>ROUTES FULL</b> command combines the previous two commands into a
            single shorthand command."
        });
        instructionsCutscene.addPage({: //TODO: SEARCH will be used instead of EXAMINE
            "<center><b><tt>STEALTH AND CAUTION</tt></b></center>\b
            <i>Unfortunately, you are being hunted!</i>\b
            Your predator has certain expectations for how the environment should
            behave, and your actions will leave traces, as a result! Normally, these
            are in the form of doors that audibly close when they shouldn't, doors
            being open when he did not open them for himself, and the sounds of your
            noisier parkour actions.\b
            For best practice, close any doors that you open for yourself, keep your
            jumping to a minimum, listen for his clicking sounds, peek into rooms
            before traveling into them, and look at objects that he might be
            hiding in (you will see his eyes in the darkness!).\b
            <b>REMEMBER:</b> The doors in the facility close automatically after
            three turns!\b
            It may be best to plan your movements ahead of time! To freely explore
            a simplified version of the world, use the <b>MAP</b> command. <i>Moving
            through this simplified model does not cost any turns for you!</i> This way,
            you can see how rooms are connected, before using turns during actual
            travel.\b
            <i>It should be noted that travel in the map does not result in travel for
            your character! The map is for route planning only!</i>"
        });
        instructionsCutscene.addPage({:
            "<center><b><tt>OTHER UTILITY COMMANDS</tt></b></center>\b
            There are a few other <q>out-of-world</q> commands that are available
            to you:\n
            \t<b>AGAIN</b> repeats the previous command.\n
            \t<b>EXITS</b> shows a list of obvious exits from the room.\n
            \t<b>OOPS</b> allows you to correct a misspelling in the previous
            command, such as <b>OOPS DOOR</b> if the previous command was
            something like <b>OPEN DOPR</b>.\n
            \t<b>SAVE</b> saves your game to a file.\n
            \t<b>RESTORE</b> loads a saved game.\n
            \t<b>RESTART</b> restarts the game from the beginning.\n
            \t<b>EXTRAS ON/OFF</b> enables/disables tutorial hints during gameplay.\n
            \t<b>VERBOSE</b> shows the room description each time you enter the
            same room.\n
            \t<b>BRIEF</b> shows the room description only when entering the
            room for the first time.\n
            \t<b>SAVE DEFAULTS</b> saves your preferences (for things like
            <b>BRIEF</b> and <b>VERBOSE</b>).\n
            \t<b>SCRIPT</b> starts recording gameplay to a transcript text file.\n
            \t<b>SCRIPT OFF</b> stops the transcript recording.\n
            \t<b>QUIT</b> ends the game.\n"
        });
    }
}

modify Instructions {
    showInstructions() {
        "\b";
        instructionsCore.instructionsCutscene.play();
        "\b\b\b";
        gPlayerChar.getOutermostRoom().lookAroundWithin();
    }
}

modify helpMessage {
    showHowToWinAndProgress() {
        //TODO: Show progress
        "<b>Find all seven pieces of the environment suit, and escape through the
        emergency airlock to win!</b>";
    }

    showHeader() {
        "<.p>
        <<gDirectCmdStr('about')>> for a general summary.\n
        <<gDirectCmdStr('credits')>> for author and tester credits.";
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
    }

    printMsg() {
        showHowToWinAndProgress();

        "\bFor a categorized guide on how to play this game, type in the
        <<gDirectCmdStr('instructions')>> command at the prompt.
        This could be necessary, if you are new to
        interactive fiction (<q><tt>IF</tt></q>), text games, parser games,
        text adventures, etc.\b
        For a reference list of verbs and commands, type in
        <<gDirectCmdStr('verbs')>>.\b
        Remember, you can always explore a simplified version of the
        world&mdash;<i>without spending turns</i>&mdash;as long as you are
        in <i>map mode!</i>\n
        Use the <<gDirectCmdStr('map')>> command to enter or leave map mode!";
        
        /*if(defined(extraHintManager))
           extraHintManager.explainExtraHints();*/
        
        showHeader();
    }

    briefIntro() {
        Instructions.showInstructions();
    }
}