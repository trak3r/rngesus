- the URL isn't changing when tabs are clicked in the header

- "your rolls" tab is always showing as selected (gray background) when on other tabs

- active tab gray background is still not working. it seems the first tab visited is always showing as active. switching to a non-index page (like results or form) clears it, but when a tab is selected again it sticks.

- still not working. i don't think your test is valid since you are makingn fresh GET requests to the index page while the browser is redrawing HTML on the page.

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
