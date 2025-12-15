http://localhost:3000/rolls/8oSMY
- add a "show all results" button to the roll show page
- add the roll tags to the roll show page
- the roll name and like button don't line up vertically; fix that
- make the card tallers so it doesn't sputter when the results are long
- move the resulting value to the top left corner of the card overlapping it like a ping pong ball pulled for a lottery, and rotate it a bit
- the 3D dice aren't showing on the deployed site; are there some files we have locally that aren't in the repository?

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
