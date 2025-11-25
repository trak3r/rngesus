- selecting an already-selected filter pill should deselect it
- allow for selcting multiple filter pills, acting as AND logic
- the url should refelct the state of the filters so it can be bookmarked or shared

---

# Test Guidelines
- write test coverage for any logic changes
- write test coverage for any functionality changes
- never create/build/update in a test unless those functions are explicitly being tested; use fixtures instead
- name fixtures descriptive of their test purpose, for example: "user_with_vulgar_nickname"
- make sure all tests pass before telling me you are finished