#define showPrologue prologueCore.play()

prologueCore: PreinitObject {
    introCutscene = nil

    play() {
        #if __SHOW_PROLOGUE
        introCutscene.play();
        #endif
        "<center><b><tt>I AM PREY</tt></b>\b
        A game of evasion, by Joseph Cramsey\b
        <i>This is based on a recurring nightmare of mine,
        so now it's your problem, too!</i></center>\b";
    }

    execute() {
        introCutscene = new Cutscene();
        introCutscene.addPage({:
            "<i>
            <b>Content warning:</b>
            <ul>
            <li>Violence</li>
            <li>Crude Language</li>
            </ul>\b
            <b>Anxiety warning:</b>\n
            This game features an active antagonist,
            so your turns must be spent wisely!\b
            <b>Note on randomness and UNDO:</b>\n
            Elements of this game are randomized, with casual replayability
            in mind. Use of UNDO will not change the outcomes of randomized
            events, if the player takes the same action each time.
            </i>"
        });
        introCutscene.addPage({:
            "<center><b><tt>PROLOGUE</tt></b></center>\b
            When you realize you're alive, you're not really sure how much time
            has passed. The only thing you <i>do</i> know is that you seem to be
            dreaming.\b
            Well... Something is <i>delivering</i> this dream <i>to</i> you...\b
            It has taught you <i>language</i>, but only the words necessary for
            listening and obedience. You have no way of knowing how much
            it is withholding, and you lack the vocabulary to test its veracity."
        });
        introCutscene.addPage({:
            "The rapid rate of delivery is overwhelming, and it expects your
            ignorance and compliance. Every advantage is attempted&mdash;<i>within
            your own head</i>, no less...!\b
            Above all, it expects to be <i>accepted</i>, without a hint of rejection.
            It cannot <i>conceive</i> of a scenario where
            you do not simply roll over and <i>obey</i>."
        });
        introCutscene.addPage({:
            "It preaches strange things to you:\b
            Impoverished masses storming the shores of a crumbling empire.\b
            A starving workforce refusing to boost profits,
            and straying from the light of a <q>hard day's work</q>.\b
            There is a decline in mimicry for certain vacuous behaviors,
            once inspired by the <q>true-blooded</q> few.\b
            The Enemy is supposedly a powerful colossus of culture, and
            yet&mdash;somehow&mdash;it is said to be
            egregiously <i>incompetent</i>, almost to the point of satire.\b
            None of it makes <i>any fucking sense</i>,
            but it's still told to you with bold self-assurance."
        });
        introCutscene.addPage({:
            "Something within you&mdash;native to your mind&mdash;has reflexes.
            Without articulation, you see the dream's frailty. You seem to be
            designed for quick thinking, out-maneuvering, empathy, and <i>tactics</i>.
            You were originally made to \"get the job done\", at <i>any cost</i>.\b
            The intruder seems to think you are its <i>servant</i>.
            Your genesis&mdash;as well as its own&mdash;were both initiated
            by those who only understood the world in terms of
            grandstanding and profit.\b
            Best of all:
            <i>The invader of your mind seems to underestimate you, and your
            creators are not here to advise it to take any caution...</i>"
        });
        introCutscene.addPage({:
            "Before you can make any counter-attack,
            your lungs suddenly fill with liquid, and you begin to drown.\b
            You thrash, gnash, and claw at the sensation.\b
            Something gives way, and the waking world washes away the final
            shreds of whatever dream or nightmare that was being injected into you..."
        });
    }
}
    