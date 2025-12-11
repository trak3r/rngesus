# Plan
- OK this next project is going to be big, complicated, and potentially messy.
- so we need to be meticulous and careful.
- short version: we're going to completely remove Randomizers and promote Rolls to top-level entities.
# Data
- IMPORTANT we need to perserve existing data, so we should probably tackle that first.
- we'll need to change the ownership from randomizers to rolls (new foreign key, new model relation), and copy the user_ids
- we'll need to remap tags from randomizers to rolls (new table, new model relations), and copy them
- we'll need to add slugs to rolls. in the case of a one-to-one relationship between a randomizer and a roll, copy the slug from the randomizer to the roll.
# Interface
- we'll need to change all front-end representations (cards, search, outcomes, filters, etc.) of randomizers to rolls.
# Testing
- when logical, randomizer tests should be refactored to roll tests
# Cleanup
- we want to remove all references to randomizers from the codebase (routes, controllers, models, views, fixtures, javascript, en.yml, etc.) HOWEVER do not yet drop the table from the database - we'll wait until we're 1000% sure the project is completed before deleting any data!


http://localhost:3000/rolls/5jQZ8/edit
this roll edit form has no results and no way to add some
there used to be an "add new result" functionality before the randomizers were dropped (you can check the git diff for this branch if necessary)


- that's great but users will expect to see the "add another result" button at the bottom left of the results list (not above it)
- add some separation between it and the save/back buttons also at the bottom of the page


- on the roll form, the results should be ordered by their "value" values
- when i add a new result on the roll form there's no way to delete it before attempting to save


- as part of the randomizer removal it seems outcomes controller was also removed but seems some of its views are still there
- audit all the view files to ensure they are actually needed

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