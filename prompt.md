i'm getting this from my docker container:

Missing GOOGLE_CLIENT_ID or GOOGLE_CLIENT_SECRET environment variables!
/rails/config/initializers/omniauth.rb:13:in '<main>'
/rails/config/environment.rb:7:in '<main>'
Tasks: TOP => db:prepare => db:load_config => environment
(See full trace by running task with --trace)

how do i set those values in the container securely via "kamal deploy"?

add GOOGLE_CLIENT_ID and GOOGLE_CLIENT_SECRET to .kamal/secrets and have them set by reading (echo?) from my local environment.
i think you also need to add them to deploy.yml

---

# Test Guidelines
- write test coverage for any logic changes
- write test coverage for any functionality changes
- never create/build/update in a test unless those functions are explicitly being tested; use fixtures instead
- name fixtures descriptive of their test purpose, for example: "user_with_vulgar_nickname"
- make sure all tests pass before telling me you are finished