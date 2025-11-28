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

we've got some issues with dark mode again
- the app name and user name are not visible on the dark theme
- the page header on outcomes is black on black
- the selected active tab is black on black
- the filters label is black on black
- look for more i haven't found

dark mode regressions
- now the like button is black on black
- now the randomizer card text is light on white
- the randomizer card tagsa are black text on black pills

still dark mode issues
- the text on the outcomes cards is black on black
- the borders of the randomizer cards aren't visible on dark mode; perhaps make the card a little lighter than black?

- the like button on the outcomes page is black on black

more dark mode issues
http://localhost:3000/randomizers/8iQ6D
- tags are not visibile
- edit icon is not visible
- list of rolls not visible
http://localhost:3000/rolls/21
- randomer name not visible
- list of results not visible
http://localhost:3000/results/280/edit
- page header not visible
- form field labels not visible
- button labels not visible

still more dark mode issues
http://localhost:3000/randomizers/8iQ6D
- list of rolls not visible
- footer text not visible (all pages)
http://localhost:3000/randomizers/8iQ6D/edit
- page header not visible
- form field labels not visible
- button labels not visible
http://localhost:3000/rolls/20
- list of results not visible
http://localhost:3000/rolls/20/edit
- page header not visible
- form field labels not visible
- button labels not visible

a few more dark mode issues
http://localhost:3000/randomizers/8iQ6D
- the blue and red colors of the buttons are jarring in dark mode; same for all forms
http://localhost:3000/randomizers/8iQ6D/edit
- text on the submit button is not visible (same for all forms)
http://localhost:3000/rolls/20/edit
- dice icons and labels not visible

---

# Style Guidelines
- always consider dark mode and light mode
- always consider mobile and desktop

# Test Guidelines
- write test coverage for any logic changes
- write test coverage for any functionality changes
- never create/build/update in a test unless those functions are explicitly being tested; use fixtures instead
- name fixtures descriptive of their test purpose, for example: "user_with_vulgar_nickname"
- make sure all tests pass before telling me you are finished