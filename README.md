# What is it?
- A tool for creating tabletop role-playing game (TTRPG) random dice roll tables and rolling on them to get results
- With some added cool features like **uploading a photo or screenshot from a book** and automatically building everything 
- When a result contains an embedded roll, like "2d6 goblins", it will roll that and insert the result into the text
- The results spin like a slot machine while rolling
- On a re-roll, 3D dice will roll across the page
- Tentatively live at https://rngesus.rudiment.net/

# Why am I building it?
- Free-time project to play with some technologies I don't get to use at my day job
- SQLite (I've been using PostgreSQL for over a decade, MS-SQL before that)
- Hotwire: Turbo / Stimulus (I use React and React Native now, Backbone.js before that)
- Tailwind CSS & DaisyUI (I use Bootstrap at work)
- Avo for admin (I have experience with Rails Admin)
- Omniauth without Devise and exclusively third-party authentication
- Experiment with optical character recognition (OCR) 
- Rails new Kamal & Docker deploy strategy (used Capistrano forever)
- Test the potential of AI and vibe coding

# Screenshots

![Landing page showing the list of random tables](screenshots/randomizers.png)

![Outcomes page showing roll results](screenshots/outcomes.png)

See [TODO > Done](TODO.md#done) for more details on features and lessons learned.

# License

This project is licensed under the [PolyForm Noncommercial License 1.0.0](LICENSE).

- Free to use for personal, educational, or noncommercial projects.
- Commercial use requires a separate license. Please contact [YOUR CONTACT INFO] for inquiries.
