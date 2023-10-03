/*
 * This game has a lot of custom mechanics, a narrow scope of play, and
 * requires less overall discovery for the player. Therefore, it would be
 * best for the player to have access to custom instructions, specifically
 * made for everything covered in this game.
 */

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
