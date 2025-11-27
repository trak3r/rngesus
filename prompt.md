let's setup ssl with the kamal deploy.
we want to generate a free ssl certificate.
this is for local testing so we don't care about the security of the certificate.
we want to enforce https.
we're deploying to an ubuntu virtual machine that is not internet accessible.
we will be accessing it via https://localhost:4443
the virtual machine is running on a macbook if that matters for anything.

---

# Test Guidelines
- write test coverage for any logic changes
- write test coverage for any functionality changes
- never create/build/update in a test unless those functions are explicitly being tested; use fixtures instead
- name fixtures descriptive of their test purpose, for example: "user_with_vulgar_nickname"
- make sure all tests pass before telling me you are finished