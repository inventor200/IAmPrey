# I Am Prey
## A text-based, horror-lite, science fiction game of evasion!
### by Joseph Cramsey
Recommended to play with the [QTADS interpreter](https://github.com/realnc/qtads), or the [HTML TADS interpreter](https://www.ifwiki.org/HTML_TADS_(Interpreter)).

More information is available on the
[IFDB page](https://ifdb.org/viewgame?id=1vaafzgrqf4m8yvr)!

***

## About the Game

Inspired by the casual and round-based designs of visual indie games—such as *Slender: The Eight Pages* and *Duskers*—*I Am Prey* aims to bring tense, methodical, and replayable stealth challenges to screen reader users and text game enthusiasts alike.

The player follows the titular protagonist, Prey, and guides the character through a cloning facility under siege. By using parkour navigation and evasion tactics, Prey must avoid The Predator, and locate seven randomly-scattered pieces of an environment suit to escape.

The player must be careful, though, because The Predator is always looking for clues of Prey's presence and location.

*I Am Prey* also offers a free-roam "Cat Mode", where the player guides The Predator's pet cat, who can safely discover the secret parkour passages of the facility.

***

## Version Notes

The final version submitted to the Spring Thing 2023 competition was ["0.9.4 BETA", or "Patch 4"](https://www.springthing.net/2023/play.html#IAmPrey).

On June 3rd *(21 days after the competition had closed)*, a major bugfix was applied, resulting in version "0.9.6 BETA", or "Patch 6".

Patch 6 fixed a soft-lock bug in map mode, revamped *Prey's Survival Guide*, and also made the guide available from within the game's help menu.

***

## Compiling

This game is compiled under [Adv3Lite 1.6](https://github.com/EricEve/adv3lite), using `ReleaseMakefile.t3mo` for release builds, and `Makefile.t3m` for debug builds.

**However, this is only necessary if you are making custom versions of the game!**

All TADS 3 games are cross-platform, as they run through [various interpreter VMs](https://www.ifwiki.org/TADS_interpreters), according to the preferences of the user.