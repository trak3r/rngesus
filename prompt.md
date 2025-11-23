OK i loved the black and white notebook style design but it started to wear on me. it's a little too much. Too cliche. Too much black ink; lacking contrast and color. 
Let's take another bold big swing approach and try to clean things up.
First of all, for inspiration let's think of the old D&D books from the 80s, specifically their font and layout and black ink imagery.
Think of their clean table design for all the dice rolls and results.
Also consider use of whitespace to avoid busy cluttered screens and make things easy for the user to read and scan.
Use color sparingly and only for important elements to draw the user's eye to the most important parts of the page.

looking good so far.
not a fan of the font; maybe a sans-serif font would be better.
don't need so much padding in the randomizer cards; maybe half as much.
go ahead and contine to the depper pages and make sure to clean up the design.


http://localhost:3000/randomizers/0dyit/outcomes
something broke big here. looks like you're showing the results value rather than the text. there was a lot of desired functionality here so you might want to roll back to the previous version and try again.
http://localhost:3000/rolls/18
i'm not seeing any new design elements applied to the list of results on the rolls show page.

http://localhost:3000/randomizers/0dyit/outcomes
you broke lots of hover functionality on the results cards. they used to be able to be clicked to reroll, and now they can't. also they used to show the raw name and now they don't.
http://localhost:3000/rolls/18
the results in the list are still showing the old design of purple gradient wells and colored icons.

http://localhost:3000/randomizers/0dyit/outcomes
- too many borders on this page. make the result border more subtle. add spacing between the results cards.
- the results used to have a tooltip on hover to reroll. add that back.
http://localhost:3000/rolls/18
- right justify the value column
- add spacing between the edit and delete icons; they are hard targets for a misclick
- the edit and delete iconts aren't aligned vertically

http://localhost:3000/randomizers/0dyit
- i'm no longer seeing any of the rolls on this edit randomizer page
http://localhost:3000/randomizers/0dyit/outcomes
- this page used to have a click to reroll hover notice; add that back

i'm dismayed by how much functionality has been broken by this visual styling change. audit a git diff of this branch and see what functionalty was changed and lost lost and restore it.

http://localhost:3000/randomizers/0dyit/outcomes
- add a little space between results
- make the "click to reroll" more subtle

http://localhost:3000/randomizers/0dyit/outcomes
- add some spacing betwen the results cards
- reenable the slot machine spinner