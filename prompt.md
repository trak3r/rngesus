# rubocop

Offenses:

test/system/randomizers_index_test.rb:13:121: C: Layout/LineLength: Line is too long. [158/120]
    long_name = 'This is a very long randomizer name that should definitely be truncated because it is way too long to fit on a single line or even two lines'
                                                                                                                        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
# tests

Failure:
RandomizersSearchTest#test_shows_no_results_message_when_no_matches_found [test/integration/randomizers_search_test.rb:51]:
--- expected
+++ actual
@@ -1 +1 @@
-/No randomizers found matching "nonexistent"/
+"RNGesus Log In Newest Most Liked Your Likes Your Randomizers All Tags TagOne TagTwo New Randomizer Create your own! No randomizers found... matching \"nonexistent\" © 2025 · Thomas E. Davis"
.
Expected 0 to be >= 1.

bin/rails test test/integration/randomizers_search_test.rb:47

---

# Test Guidelines
- write test coverage for any logic changes
- write test coverage for any functionality changes
- never create/build/update in a test unless those functions are explicitly being tested; use fixtures instead
- name fixtures descriptive of their test purpose, for example: "user_with_vulgar_nickname"
- make sure all tests pass before telling me you are finished