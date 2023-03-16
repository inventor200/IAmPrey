// A fix provided by Eric Eve, which should allow the player to
// disambiguate between an east and west object without causing a
// travel action.

/*StringPreParser {
    doParsing(str, which) {
        if (which == rmcDisambig) {
            if (str.toLower() is in ('n' ,'north')) {
                str = 'northx';
            }
            if (str.toLower() is in ('ne' ,'northeast')) {
                str = 'northeastx';
            }
            if (str.toLower() is in ('e' ,'east')) {
                str = 'eastx';
            }
            if (str.toLower() is in ('se' ,'southeast')) {
                str = 'southeastx';
            }
            if (str.toLower() is in ('s' ,'south')) {
                str = 'southx';
            }
            if (str.toLower() is in ('sw' ,'southwest')) {
                str = 'southwestx';
            }
            if (str.toLower() is in ('w' ,'west')) {
                str = 'westx';
            }
            if (str.toLower() is in ('nw' ,'northwest')) {
                str = 'northwestx';
            }
        }   
        
        // return the original string unchanged
        return str;
    }    
}*/

// Simpler solution, from both Eric Eve and John Ziegler
modify ParseErrorQuestion {
    priority = true
}