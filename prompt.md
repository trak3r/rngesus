http://localhost:3000/rolls?tab=newest
- add pagination to the roll index
- 6 cards per page (remember the fake image card counts as a card)
- if it makes sense to use a gem for this, do so
- use the "show more" pattern

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
