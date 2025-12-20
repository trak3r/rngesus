- move tabs into header
- roll results page: remove the "Manage Results" it's redundant of the edit icon (and the en.yml entry)
- roll results page: move the tags to the top center of the card like they are for rolls
- roll results page: make the roll result value number larger
- roll results page: deemphasize the roll name, center it

- it seems you made the text on the roll results card larger; i just wanted the number to be larger
- the tags on top of the results card are not aligned to the top border; this might be corrected by revertig the font size change
- the tab names in the header are pretty small; make them larger
- there was a donation button in the header it seems you removed; you could put it in the footer if it can't be fit into the header
- i think i want the search field in the headers too but it's not going to make sense on the pages that aren't roll cards; should be it be disabled for those pages? do what you think is best

- the tags on the roll results card still aren't the same style and position as the roll cards - they are smaller and not aligned to the top border; fix that 
- the clear "X" on the search field isn't clickable
- the "you rolls" tab always has the background when other tabs are selected
- sometimes typing in the search field changes the tab to "your rolls"; fix that
- on the roll results page align the like button to the right 

---

IMPORTANT: do not edit TODO.md and prompt.md files!

# Test Guidelines
- write test coverage for any logic changes
- write test coverage for any functionality changes
- if you're fixing a bug, write a test first that replicates the bug, then fix the bug and leave the test in place
- never create/build/update models and relations in a test unless those functions are explicitly being tested; use fixtures instead
- name fixtures descriptive of their test purpose, for example: "user_with_vulgar_nickname"
- make sure all tests pass before telling me you are finished

# Style Guidelines
- always consider dark mode and light mode
- always consider mobile screens (touch not click, swipe, hover doesn't work, more focus on vertical vs. horizontal layout)

# Internationalization & Localization Guidelines
- any verbiage presented to a user should come from the en.yml file

# Deployment Guidelines
- remember any changes related to environment variables should be reflected in:
    - .kamal/secrets
    - config/deploy.yml
    - Dockerfile
