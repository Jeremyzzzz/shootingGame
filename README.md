# shootingGame

### Description
It's a simplified shooting game with a shooter and monsters. Each user is equipped by a gun positioned at centre of the screen. The gun can rotate itself to four directions which are north, south, east and west controlling by keyboard W, S, A, D. Monsters come out from the four directions with different speed and time intervals. The goal is to protect us from attacking by monsters. Each turn contains three lives. Whenever monster touches your gun, you lose one live. The bullet will come out from the gun whenever O is pressed. Each time you shoot a monster, you get two scores for the shooting. There will be a winning screen if you achieve 99 scores without losing 3 lives. Have fun playing the game!

High-level Schematic:
![alt text](https://raw.githubusercontent.com/Jeremyzzzz/shootingGame/master/architecture.png)

### Project Success
1.	We managed to pull off using keyboard as game controls which takes a lot of time to figure out but finally pays off and works like a charm.
2.	After a long time of recompiling and testing, we are able to find the best settings of the game like the size of the objects, monster spawn interval, movement speed to keep the game balanced and challenging at the same time. 
3.	We are able to add an airstrike button that clears the whole screen to help the player survives, which makes the game a whole lot fun and tactical.
4.	Apply what we learnt in labs, like seven segment decoder, FSM design, data path of VGA controller and rate divider.
5.	Apply hierarchy structure properly and build a systematic code construction for game control so that it is readable for everyone and easy to debug.

