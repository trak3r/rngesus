- on a phone screen, the "new randomizer" card appears at the top of every list and becomes a huge waste of real estate. let's make "New Randomizer" a tab-style link on the row with the other tabs
- let's ensure the artwork card is never the first (top) card in a list
- let's not show art cards on phone screens; we don't need to spend precious real estate on eye candy for small screens
- i'm realizing now (shame on me) that "hovers" don't work on touch screens. 
    - change the "click to re-roll" from a hover tool tip to an always-visible message, perhaps in the lower right corner of the card, perhaps a diagonal ribbon like 
- do not make any fuctional or logic changes - this is an entirely cosmetic review for now

- i'm STILL not seeing the "click to re-roll" message/ribbon on the outcomes page cards
- the tabs are not wrapping on a phone screen and instead disappearing off the side of the screen; try some other best practices UI without making the font any smaller
- the filter pills are not wrapping on a phone screen and instead disappearing off the side of the screen; try some other best practices UI without making the font any smaller

- tabs on desktop are now appearing vertically stacked instead of horizontally
- i'm STILL not seeing the "click to re-roll" message/ribbon on the outcomes page cards on any screen size

- i can finally see the "click to re-roll" message/ribbon on the outcomes page cards but the text is being cropped a bit
- let's bring back the "new randomizer" card but only show it on the "your randomizers" tab
    - and remove the "new randomizer" tab

---

# Test Guidelines
- write test coverage for any logic changes
- write test coverage for any functionality changes
- never create/build/update in a test unless those functions are explicitly being tested; use fixtures instead
- name fixtures descriptive of their test purpose, for example: "user_with_vulgar_nickname"
- make sure all tests pass before telling me you are finished