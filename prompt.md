add discord SSO.
copy the code strategy from twitter and google for consistency.
the env variables are already set up as DISCORD_CLIENT_ID and DISCORD_CLIENT_SECRET.

i think you neglected these files:
- .kamal/secrets
- config/deploy.yml
- Dockerfile

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