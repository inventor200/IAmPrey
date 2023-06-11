var currentURL = new URL(window.location.href);
currentURL.searchParams.set(
    'story',
    'https://unbox.ifarchive.org/1363p9wc5y/I-Am-Prey-Beta-Patch-6.t3'
)

window.history.pushState(null, null,
    currentURL.toString()
);