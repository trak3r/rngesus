http://localhost:3000/rolls/8oSMY
- add a "show all results" button to the roll show page
- add the roll tags to the roll show page
- the roll name and like button don't line up vertically; fix that
- make the card tallers so it doesn't sputter when the results are long
- move the resulting value to the top left corner of the card overlapping it like a ping pong ball pulled for a lottery, and rotate it a bit
- the 3D dice aren't showing on the deployed site; are there some files we have locally that aren't in the repository?

http://localhost:3000/rolls/8oSMY
- move the tags on the same line as the roll name and like button
- the value bubble is being cropped by the corner of the card; fix that
- don't make the show all results scrollable; just expand the page
- the dice value should show as a range from "value" to "next value - 1"; for example, if the dice value is 6 and the next result is 12, it should show "6 - 11"
- center justify the dice value column
- you didn't follow the directive to put all verbiage into the en.yml file

http://localhost:3000/rolls/8oSMY
- the dice value range column should not wrap
- we don't need headers on the table of all results
- left justify the resultes name column
- the bubble crop was fixed but then the re-roll ribbon broke; the latter should not be extending outside of the card

---

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
