# DinoGun
Modernized version of Google's classic Dinosaur Game with new features, some 8-bit tunes, and a blunderbuss.

# Instructions

Install latest version of Java SE Development Kit. Extract DinoGun ZIP file and run the executable. Appreciate my magnum opus.

# Controls

W or Up Arrow     -  Jump
A or Left Arrow   -  Strafe Left
D or Right Arrow  -  Strafe Right
Space             -  Fire Blunderbuss

# Features

- Multiple GUI systems
    - Menu screen
    - High score screen
    - In-game HUD with framerate and score
    - Game Over screen with options to restart or return to menu
- Score continuously increases the longer you survive
    - Collecting coins and shooting birds increases score by 10,000
    - High scores are kept in a text file, updated every time you Game Over
- Satisfying custom-made sound effects and endearing music (see: Credits)
    - Gameplay timing coincides with the music if you listen closely
- Tasteful sprites recreated by hand based on reference images (see: Credits)
    - Upscaled with Nearest-Neighbor scaling to maintain clarity
- The game should run the same at any framerate & resolution (theoretically)
- A framerate counter is displayed in the top left corner

# Technical Details

The Player class handles the dino's movement data and various states like jumping and invincibility. If the player tries to jump
while in the air within a certain proximity to the ground, it will queue a jump buffer and then jump immediately once the player
touches ground. Obstacles are generated based on a random timer and constantly move to the left based on the current speed 
multiplier, which increases every 15.36 seconds in time with the background music. Obstacles can either be on the ground or flying.
If they are on the ground, they will appear as 1 of 3 cactus sprites and have the chance of spawning a coin a random height above
them. If they are flying, they will appear as a bird that can be shot with the blunderbuss. The blunderbuss is a Weapon object with
a reloading animation that triggers after it is fired (two level animation hierarchy). It fires objects of the Projectile class that
cause bird Obstacles to explode upon collision, which uses code from my previous Firework simulator (the Particle class). A similar
animation occurs after the player collects a coin. The clouds and the grass are both members of the Object class, which respawn to
the right of the screen as soon as they are off screen to the left. If it is a cloud, its position will be randomized, whereas 
grass textures will be moved directly to the right of the previous grass texture. Finally, buttons are created from the Button
class and change colors when hovered over.

The main challenge I faced was getting the game to work the same regardless of resolution, which I noticed after moving from my
ultrawide monitor to my laptop. I solved this by defining/updating practically every variable based on the display window's width
and height. I also made movement and other logic factor in a deltaTime variable that enables the game to run the same at different
framerates. The only issue I've been unable to solve is making the particle's size and respawn time consistent across resolutions
and framerates. I tried multiple changes but nothing seemed to work quite right. Countless other issues arose during this game's 
creation (there are 920 lines of code -- stuff was bound to go wrong) but this report is getting lengthy so I will spare you the 
headache. Better planning and organization would have solved 95% of such issues.

# Credits

Chrome UX Team - Dinosaur Sprite
Natalia Kosheleva - Cactus Sprites
Dong Nguyen - Flappy Bird Sprite
Pixilart - Background, Blunderbuss, Coin, & Cloud Sprites
Mojang Studios - Minecraft Grass Texture
Eric Fredricksen - Jsfxr Sound Maker 
Daft Punk - Digital Love (8-Bit Universe Remix)
Playboi Carti - King Vamp (SuperNeonIceLogan Remix)
