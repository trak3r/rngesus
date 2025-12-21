http://localhost:3000/rolls?tab=your_likes
http://localhost:3000/rolls/NcbJX
find all instances of the "like" button and DRY them into a shared view.
add a toggle to make it read-only and set that toggle from the rolls index view.

http://localhost:3000/rolls/wkauh
clicking the like button causes it to shift locations on the page


http://localhost:3000/rolls/Y6Icy
when the roll name is really long, the edit and like button overlap each other
http://localhost:3000/rolls?tab=your_likes
don't show the buttom row of buttons on the card unless on the "your rolls" tab

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
