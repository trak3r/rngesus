- let's add soft deletion to all models
- if there's a gem that handles this, let's use it
- make sure this doesn't screw up the Avo admin interface

Models: Update all 5 models to include Discard::Model.
Avo: Avo has built-in support for discard. I will verify that "Discard" and "Restore" actions appear automatically or configure them if needed.
Verification: I will write a test to confirm that records can be discarded and restored, and manually verify the behavior in the Avo admin panel.

- is it possible to see deleted items in Avo?

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