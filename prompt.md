i need a small subset of tags for ttrpg random roll tables.
some examples are: monster, forest, carousing, magic, treasure, effects.
there could be several dozen great tags but i need a list of only 9 that will cover most common cases.
keep in mind generic tags would be applied to too many roll tables and thus become meaningless.
build me that list please.

consumable
downtime
dungeon
effect
encounter
event
location
loot
magic
monster
npc
plot
treasure
urban
weather
wilderness

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
