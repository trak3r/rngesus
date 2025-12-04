update my kamal deploy config.
username: ubuntu
host 34.205.65.173
new environment secrets:
    TWITTER_CLIENT_ID
    TWITTER_CLIENT_SECRET
    FACEBOOK_APP_ID
    FACEBOOK_APP_SECRET


Setting up local registry port forwarding to 34.205.65.173...
 ERROR Error setting up port forwarding to 34.205.65.173: Net::SSH::ConnectionTimeout: Net::SSH::ConnectionTimeout
 ERROR /Users/ted/.rvm/gems/ruby-3.4.1/gems/net-ssh-7.3.0/lib/net/ssh/transport/session.rb:91:in 'Net::SSH::Transport::Session#initialize'
/Users/ted/.rvm/gems/ruby-3.4.1/gems/net-ssh-7.3.0/lib/net/ssh.rb:258:in 'Class#new'
/Users/ted/.rvm/gems/ruby-3.4.1/gems/net-ssh-7.3.0/lib/net/ssh.rb:258:in 'Net::SSH.start'
/Users/ted/.rvm/gems/ruby-3.4.1/gems/kamal-2.9.0/lib/kamal/cli/build/port_forwarding.rb:33:in 'block (2 levels) in Kamal::Cli::Build::PortForwarding#forward_ports'
  Finished all in 46.1 seconds
  ERROR (Net::SSH::ConnectionTimeout): Net::SSH::ConnectionTimeout

i'm guessing this needs to be loading ~/.ssh/rngesus-2025-12-04a.pem ?

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