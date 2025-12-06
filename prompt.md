we need to make the creation of randomizers more user friendly. 
let's consider a wizard-style step-by-step walk-through (or recommend a better flow).
if there's a good modern active gem that does this, let's use it.
the steps would be as follows (or recommend a better flow):
step 1
1. ask the user if they want to upload screenshots of a table or create a randomizer manually
    - two big side-by-side buttons: "Upload Screenshots" and "Create By Hand"
2. if they choose to upload screenshots, ask them to upload them
step 2
3. show a form in three sections: 
    1. randomizer 
        - name
        - tags
    2. roll
        - name
        - dice
    3. results
        - imported from screenshots
        - or 3 dummy placeholders
4. if everything saved without errors, show a success message and load the outcomes page for that randomizer


where there's a validation error on the wizard page two - for example i selected 4 tags - i am taken to the edit page for the randomizer, but i should be taken back to the wizard page two.

changing the roll name and dice on the wizard page two does not update the roll in the database.

we've got an alternate flow issue.
when i come from a roll show to import from screenshot, i should be taken back to the roll show, not the wizard. but if i come from the wizard, i should be taken to the wizard page two.

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