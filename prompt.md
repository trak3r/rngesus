now i'm getting this error on the server:

[52e1b045-e7a4-4a90-a66e-d36d9d7230d0] Completed 500 Internal Server Error in 6985ms (ActiveRecord: 0.2ms (1 query, 0 cached) | GC: 6.4ms)
[52e1b045-e7a4-4a90-a66e-d36d9d7230d0]
[52e1b045-e7a4-4a90-a66e-d36d9d7230d0] Errno::ENOENT (No such file or directory - tesseract):
[52e1b045-e7a4-4a90-a66e-d36d9d7230d0]
[52e1b045-e7a4-4a90-a66e-d36d9d7230d0] app/services/results_img_processor.rb:33:in 'block in ResultsImgProcessor#to_s'
[52e1b045-e7a4-4a90-a66e-d36d9d7230d0] app/services/results_img_processor.rb:23:in 'ResultsImgProcessor#to_s'
[52e1b045-e7a4-4a90-a66e-d36d9d7230d0] app/services/results_img_processor.rb:39:in 'ResultsImgProcessor#to_a'
[52e1b045-e7a4-4a90-a66e-d36d9d7230d0] app/services/results_img_processor.rb:53:in 'ResultsImgProcessor#parsed_list'
[52e1b045-e7a4-4a90-a66e-d36d9d7230d0] app/services/results_img_processor.rb:95:in 'ResultsImgProcessor#call'
[52e1b045-e7a4-4a90-a66e-d36d9d7230d0] app/controllers/results_imgs_controller.rb:22:in 'block in ResultsImgsController#create'
[52e1b045-e7a4-4a90-a66e-d36d9d7230d0] app/controllers/results_imgs_controller.rb:21:in 'Array#each'
[52e1b045-e7a4-4a90-a66e-d36d9d7230d0] app/controllers/results_imgs_controller.rb:21:in 'ResultsImgsController#create'


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