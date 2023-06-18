#define expandableSearch 'search'|'srch'|'src'|'sr'

modify Action {
    remappingSearchCheckProp = nil

    skipSearch() {
        if (gDobj == nil) return true;
        if (remappingSearchCheckProp == nil) return nil;
        return gDobj.(remappingSearchCheckProp);
    }
}

modify VerbRule(Search)
    [badness 20] (expandableSearch) singleDobj :
    allowAll = nil
;

modify Search {
    remappingSearchCheckProp = &remappingSearch
}

modify VerbRule(LookIn)
    ('look'|'l'|expandableSearch) ('in'|'inside' ('of'|)|'in' 'to'|'into') singleDobj :
    allowAll = nil
;

modify LookIn {
    remappingSearchCheckProp = &remappingLookIn
}

modify VerbRule(LookUnder)
    ('look'|'l'|expandableSearch) 'under' singleDobj :
    allowAll = nil
;

modify LookUnder {
    remappingSearchCheckProp = &remappingLookUnder
}

modify VerbRule(LookBehind)
    ('look'|'l'|expandableSearch) 'behind' singleDobj :
    allowAll = nil
;

modify LookBehind {
    remappingSearchCheckProp = &remappingLookBehind
}

VerbRule(SearchDistant)
    [badness 30] (expandableSearch) singleDobj
    : VerbProduction
    action = SearchDistant
    verbPhrase = 'search/searching (what)'
    missingQ = 'what do you want to search'
    allowAll = nil
;

DefineTAction(SearchDistant)
    remappingSearchCheckProp = &remappingSearchDistant
;

VerbRule(SearchClose)
    [badness 50] (expandableSearch) ('on'|('on'|'the'|) 'top' 'of'|'atop') singleDobj
    : VerbProduction
    action = SearchClose
    verbPhrase = 'search/searching (what)'
    missingQ = 'what do you want to search'
    allowAll = nil
;

DefineTAction(SearchClose)
    remappingSearchCheckProp = &remappingSearchClose
;

#define Searchify(originalAction) \
    modify originalAction { \
        execCycle(cmd) { \
            if (allowDebug) extraReport('\bNew cycle!\b'); \
            if (!skipSearch()) { \
                if (isImplicit) searchCore.clearHistory(); \
                searchCore.startSearch(nil); \
            } \
            inherited(cmd); \
            if (!skipSearch()) searchCore.concludeSearch(gDobj, nil, nil, nil); \
        } \
        execAction(cmd) { \
            local isFastAction = searchCore.forceFastSearch(); \
            if (!skipSearch()) { \
                if (isImplicit) searchCore.clearHistory(); \
                searchCore.startSearch(isFastAction); \
            } \
            inherited(cmd); \
            if (!skipSearch()) searchCore.concludeSearch(gDobj, nil, nil, isFastAction); \
        } \
    }

Searchify(Search)
Searchify(SearchClose)
Searchify(SearchDistant)
Searchify(LookIn)
Searchify(LookUnder)
Searchify(LookBehind)