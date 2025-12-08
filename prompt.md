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
- we want to remove all references to randomizers from the codebase (routes, controllers, models, views, fixtures, javascript, etc.) HOWEVER do not yet drop the table from the database - we'll wait until we're 1000% sure the project is completed before deleting any data!

---

# Test Guidelines
- write test coverage for any logic changes
- write test coverage for any functionality changes
- never create/build/update models and relations in a test unless those functions are explicitly being tested; use fixtures instead
- name fixtures descriptive of their test purpose, for example: "user_with_vulgar_nickname"
- make sure all tests pass before telling me you are finished

# Style Guidelines
- always consider dark mode and light mode
- always consider mobile and desktop

# Internationalization & Localization Guidelines
- any verbiage presented to a user should come from the en.yml file

# Deployment Guidelines
- remember any changes related to environment variables should be reflected in:
    - .kamal/secrets
    - config/deploy.yml
    - Dockerfile