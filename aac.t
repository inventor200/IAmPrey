/*
 * The actorActionContinuer primes the next verb in a sentence to
 * agree with {i}, allowing multiple verbs per sentence.
 * This is used with the token {aac}.
 *
 * For example:
 * "{I} {let} go of the ledge, and{aac} drop{s/?ed} to the floor below. ";
 *
 * Results:
 * You let go of the ledge, and drop to the floor below.
 * She lets go of the ledge, and drops to the floor below.
 * He let go of the ledge, and dropped to the floor below.
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