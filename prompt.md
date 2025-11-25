- allow multiple tags per randomizer, limit to 3
- update the randomizer form to allow multiple tags selection, error message if more than 3 tags are selected, use the same style as the tag pills on the index page
- update the randomizer index cards to show multiple tags per randomizer, same style across the top of the card
- add new "Monster" tag

http://localhost:3000/randomizers/0dyit
- the header is only showing 1 tag
http://localhost:3000/randomizers/0dyit/edit
- the form field for selecting multiple tags isn't intuitive; make it more clear how to select multiple tags

tags should always apper in alphabetical order
- index page filter pills
- index page card tags
- randomizer show page tags
- randomizer form tags

---

# Test Guidelines
- write test coverage for any logic changes
- write test coverage for any functionality changes
- never create/build/update in a test unless those functions are explicitly being tested; use fixtures instead
- name fixtures descriptive of their test purpose, for example: "user_with_vulgar_nickname"
- make sure all tests pass before telling me you are finished