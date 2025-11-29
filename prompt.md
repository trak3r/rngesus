- let's add soft deletion to all models
- if there's a gem that handles this, let's use it
- make sure this doesn't screw up the Avo admin interface

Models: Update all 5 models to include Discard::Model.
Avo: Avo has built-in support for discard. I will verify that "Discard" and "Restore" actions appear automatically or configure them if needed.
Verification: I will write a test to confirm that records can be discarded and restored, and manually verify the behavior in the Avo admin panel.

- is it possible to see deleted items in Avo?

- i deleted a randomizer from the web interface and don't see it as discarded in the admin. i'm worried it was full deleted. please audit the randomizer controller (and others) so see if they are getting full deleted. if so, fix it. include test coverage.

- i deleted a randomizer in Avo and it seems to have been full deleted rather than discarded. the purpose of soft delete is that data can't be full deleted ANYWHERE in the site. please audit and fix. thanks!

- test the outcomes page doesn't use discarded rolls, and rolls don't use discarded results

- is "dependents: :destroy" in relations an issue for the discarded gem logic?

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