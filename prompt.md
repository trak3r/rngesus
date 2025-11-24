- the cards on the randomizer index page have inconsitent heights when the name spans multiple lines or there are many rolls
- can we truncate the name to 2 lines and add an ellipsis if it goes beyond that?
- can we show just the first 3 rolls then add a "...and more" note if there are more than 3 rolls?
- and adjust the height of the cards to be consistent

---

# Test Guidelines
- write test coverage for any logic changes
- write test coverage for any functionality changes
- never create/build/update in a test unless those functions are explicitly being tested; use fixtures instead
- name fixtures descriptive of their test purpose, for example: "user_with_vulgar_nickname"
- make sure all tests pass before telling me you are finished