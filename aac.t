/*
 * The actorActionContinuer primes the next verb in a sentence to
 * agree with {i}, allowing multiple verbs per sentence.
 * This is used with the token {aac}.
 */

actorActionContinuer_: dummy_ {
    dummyName = ''
    name = ''
    person = (gActor == nil ? 3 : gActor.person)
    plural = (gActor == nil ? nil : gActor.plural)
}

// A modified englishMessageParams will have our new token.
modify englishMessageParams {
    construct() {
        // Add the simplified message token
        params = params.append(['aac', { ctx, params:
            cmdInfo(ctx, actorActionContinuer_, &dummyName, vSubject)
        }]);

        inherited();
    }
}