# TODO
- add helper tips on screnshot upload for cropping and layout with example image
- easy way to combine randomizer and roll together (e.g. forest encounter monster and reaction tables)
- on the outcomes page of a multi-roll randomizer, allow clicking on any single roll to re-roll just that result
- support for rolls within results like "1d4 treants"
    - recognize patterns like "XdY" and link them to impromptu roller
    - a pop-up modal or just a hover tooltip might be slick (client-side JS)
- would we need to support "advantage" rolls?
- user registration
    - prefer to use third-party exclusively - no password management internally
    - (x) https://guides.rubyonrails.org/security.html#authentication
    - (x) https://github.com/heartcombo/devise
    - https://github.com/omniauth/omniauth
        - https://github.com/omniauth/omniauth/wiki/List-of-Strategies
- ownership of randomizers
- share rollable randomizers via links with guid not raw id
- tagging / categories, searchable and browsable
- likes / favorites
- promotion lists: newest, most liked, most rolled, most shared, etc.
- search, type-ahead quick find
- animate cool 3d dice roll on screen
- animate spin results like a slot machine
- responsive/mobile screens
- hotwire native
- hardening (scan tools?)
- accessibility (scan tools?)
- re-enable github ci workflow
- free hosting?
- donations / patreon
    - https://buymeacoffee.com/signup
- affiliate links to buy real dice
- sponsors
# Done
- rails new
- randomizers
- rolls
- favicon dice icon
    - https://fontawesome.com/icons/dice?f=duotone&s=solid
    - https://game-icons.net/1x1/delapouite/dice-twenty-faces-twenty.html#download
    - https://favicon.io/favicon-converter/
- results
- dice types
- is this the proper way to do edit-in-place?
    - https://nts.strzibny.name/single-attribute-in-place-editing-turbo/
- audit for vestigal scaffold files (and controller actions)
- too many rubocop rules disabled; not cleaning up code
- https://tabler.io/icons
- special dice types (2d6, with-advantage, etc.)
- erb-format app/views/**/*.html.erb --write
- support d100 logic (digit position not sum)
- upload screenshot of printed table automatically built (ocr)
    - add "import results" button to Roll show
    - prompts for drag or upload file (image or csv)
    - submit uploads the file, converts it to result objects, back to Roll show
- better styling with daisyui https://daisyui.com/components/list/
- tests (once there's complicated enough logic to warrant)
- discovered by accident that (a) tailwind supports OS dark mode toggle and (b) it's broken as fugg on my pages


ChatGPT script to convert all basic tailwind styles to daisyui
```
grep -RlZ --include="*.html.erb" 'bg-' app/views/ | xargs -0 sed -i '' \
-e 's/bg-blue-[0-9]\{2,3\}/btn-primary/g' \
-e 's/bg-gray-[0-9]\{2,3\}/btn-secondary/g' \
-e 's/bg-red-[0-9]\{2,3\}/btn-error/g' \
-e 's/bg-green-[0-9]\{2,3\}/btn-success/g' \
-e 's/bg-yellow-[0-9]\{2,3\}/btn-warning/g' \
-e 's/bg-purple-[0-9]\{2,3\}/btn-accent/g' \
-e 's/hover:bg-[a-z]\{3,6\}-[0-9]\{2,3\}//g'
```
