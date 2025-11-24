http://localhost:3000/randomizers/EgAnv
- should not have an edit icon for the roll; the roll show page has an edit button

http://localhost:3000/rolls/25
- show the randomizer name in the header before the roll name like a breadcrumb

---

# Test Guidelines
- write test coverage for any logic changes
- write test coverage for any functionality changes
- never create/build/update in a test unless those functions are explicitly being tested; use fixtures instead
- name fixtures descriptive of their test purpose, for example: "user_with_vulgar_nickname"
- make sure all tests pass before telling me you are finished