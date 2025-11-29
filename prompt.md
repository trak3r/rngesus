- let's add some admin tools
- if rails_admin is still the best option, let's do that
- if not, let's look at something else
- set up the ability to browse and manage all the models and relationships

- the GUIDs in URLs for models seems to be an issue with Avo. can you make it so it uses the raw IDs instead?

- how is admin access being determined?
- only the trak3r@gmail.com account should have admin access
    - from provider google_oauth2
    - UID 105389714176102520548
    - this record is not guarenteed to have the same ID in each environment so don't rely on it

---

# Test Guidelines
- write test coverage for any logic changes
- write test coverage for any functionality changes
- never create/build/update in a test unless those functions are explicitly being tested; use fixtures instead
- name fixtures descriptive of their test purpose, for example: "user_with_vulgar_nickname"
- make sure all tests pass before telling me you are finished

# Style Guidelines
- always consider dark mode and light mode
- always consider mobile and desktop

# Internationalization & Localization Guidelines
- any verbiage presented to a user should come from the en.yml file