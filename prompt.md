configure the kamal deploy for ssh certificate management.
the domain will be rngesus.rudiment.net
remember the latest version of kamal uses the basecame kamal proxy, NOT traefix.
i think it supports let's encrypt for the certificate management - use whatever is standard practice.
https should be required and non-https should be redirected to https.

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