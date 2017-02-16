*************** Disclaimer ***************

In the second version I handed in with the 
extra time I added the following:

1. README.txt
2. Comments to my code
3. Health bars for enemies
4. Level 5

************ Menu Navigation *************

You start off on the home menu. Pressing 
the help button will show you all the 
controls you have for your charater. The 
credits button will show who created what
(basically just me except for Myles who 
I asked to make me the logo). Pressing 
play will bring you to a level select 
allowing you to choose any level and play.

*************** Controls *****************

Shoot ------- Z
Move -------- LEFT ARROW and RIGHT ARROW
Jump -------- UP ARROW
Slide ------- DOWN ARROW and one of the 
	      movement keys

*************** Gameplay *****************

Each level has unique challenges forcing 
you to change how you play. Different 
difficulties will change the sprite,
health, damage and movement speed of the
enemy. There are aspects of platforming
implented in the game using moving blocks 
and blocks that change the players speed.
Melee enemies hurt the player on collision 
and range enemies hurt the player with 
there bullets. Levels combine these
different components to make each on feel 
unique. After taking damage the player
becomes invincible for a short period of
time. All enemies in the level must be
killed in order to beat the level.

****** Streamlining level creation *******

Using arrays during level creation and 
loops while level is running I was able to
quickly change how different aspects of 
the game work.

For Blocks:

   Change players speed on blocks
   Move the block horrizantaly
   Move the block verticaly
   Change block move direction

For Enemies:

Everything about the enemy is changed 
once the difficulty changes.

   Change enemy health
   Change enemy sprite
   Change enemies damage
   Change enemy fire rate
   Change enemy speed
   Keep enemy stationary

For Levels:                              

Before I begin stating what I added I
am going to talk about what I optimization
I added into my class and file in order
to make the creation of levels as simple 
as possible. With the combination of loops
and if statements creation is extremely 
simple. This means all the creator has to
do is drag and drop the building blocks
onto the screen. Once that is complete the
creator has to enter the following.

   Which frame of level is the level on
   Which scene the want for background
   How many screens they want to pass
   before the level ends.
   Number of A and B blocks
   Number of melee and range enemies
   States of blocks
   States of enemies
   Enemy Position

These few lines of code is all it now
takes to make a jurassic change in the
game.




