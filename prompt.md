i'm getting this error on the server:

[87a8acf9-5534-48a5-b8e0-6b3351a72aec] Completed 500 Internal Server Error in 22ms (ActiveRecord: 0.1ms (1 query, 0 cached) | GC: 0.7ms)
[87a8acf9-5534-48a5-b8e0-6b3351a72aec]
[87a8acf9-5534-48a5-b8e0-6b3351a72aec] MiniMagick::Error (`mogrify -colorspace Gray /tmp/mini_magick20251204-14-tyfnym.png` failed with status: 127 and error:
executable not found: "mogrify"):
[87a8acf9-5534-48a5-b8e0-6b3351a72aec]
[87a8acf9-5534-48a5-b8e0-6b3351a72aec] app/services/results_img_processor.rb:14:in 'ResultsImgProcessor#to_s'
[87a8acf9-5534-48a5-b8e0-6b3351a72aec] app/services/results_img_processor.rb:39:in 'ResultsImgProcessor#to_a'
[87a8acf9-5534-48a5-b8e0-6b3351a72aec] app/services/results_img_processor.rb:53:in 'ResultsImgProcessor#parsed_list'
[87a8acf9-5534-48a5-b8e0-6b3351a72aec] app/services/results_img_processor.rb:95:in 'ResultsImgProcessor#call'
[87a8acf9-5534-48a5-b8e0-6b3351a72aec] app/controllers/results_imgs_controller.rb:22:in 'block in ResultsImgsController#create'
[87a8acf9-5534-48a5-b8e0-6b3351a72aec] app/controllers/results_imgs_controller.rb:21:in 'Array#each'
[87a8acf9-5534-48a5-b8e0-6b3351a72aec] app/controllers/results_imgs_controller.rb:21:in 'ResultsImgsController#create'


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