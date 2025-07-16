# Warframe-Mapgen-Scrobbler  
Look for a specific tile or object on mapgen. Ping when it happens. The code is cobbled together with spit and tape, ~~and I can't even blame ChatGPT for making it. This was between me and the shadows of StackExchange.~~ ChatGPT handled the selection UI.
  
Throughout its entire execution, Warframe is constantly adding to a debug log known as *[EE.log.](https://warframe.fandom.com/wiki/EE.log)*. It's information that *generally* shouldn't be in the hands of players or any entities external to Digital Extremes. But as long as it's here, we might as well eat it. And smarter people than me have been sifting through it for years. For instance, [Semlar's Death Log Parser](https://semlar.com/deathlog) is for figuring out how someone died, by looking through your log. You can replicate this functionality, too, by just opening the log, searching for "was killed by", and pressing 'Previous'.  
But this trio of raccoons masquerading as a Powershell Script is interested in mapgen, and a few other things.  

## Background  
Whenever Warframe loads a level, it writes to its log certain generated aspects of the level. This used to include rooms, but now only includes special objects (such as Rare Crates and Logic Entities). It cannot tell you WHERE such things exist, only THAT they exist.  

## Use case  
I initially used this as a means of finding Rare Crates on Copernicus (Lua Capture), by way of the [(still defective) Octavia Music Puzzle](https://warframe.fandom.com/wiki/Orokin_Moon#Lua_Music_Puzzle_Room_Solution(s)). By finding the Music Puzzle, I could bash the solution out and get a Rare Crate. If it contained Forma, we gucci. If not, bummer, quit back to Orbiter. And if the level didn't contain the puzzle, then I quit before even departing the Lander.  
Over time, the script ~~evolved~~ mutated into being able to find anything that would appear in *EE.log*. This included the notoriously (at the time) rare Lua Speed Principle room, and even to Ayatan Sculptures. (The latter has been obsoleted by TheKengineer's method of giving a Lavos a max-range Golden Instinct.)  

## How to use  
For starters, don't use this in public. Not because it's clandestine, but because the optimal use of this script involves a lot of abandoning mission and reloading, which is rude to people already in mission.    
Right-click the script file and select **Run with Powershell**.   

The script will introduce itself (version number, a quick rundown on usage). It will ask you what you want to look for, and you select them by entering a comma-seperated list of numbers.

The script will say it's waiting, but if you want to make sure it's working, then type the phrase "**Wake up!**" in a chat (Squad Chat works fine, even if you're alone). *EE.log* doesn't update *very* promptly, but tends to do so when you examine the System Map. To begin, load up a mission that you think contains the thing you're looking for. The game will have finished generating a map before the loading screen is even done. At that point, the script will either beep that it has found something, or say that it has finished looking. If it gets a hit (it beeps), proceed through the mission as normal, get what it is you came for, and then leave.  
If the script says that it has finished, but it hasn't found anything, then you quit back to Orbiter, and press "Repeat Last Mission" on the "Mission Failed" screen. Repeat.  

## Bonuses  
* The script can stay in the foreground if you want it to.  
* The script will display how many hits you have versus how many misses, their streaks, and calculate it over how many times you've loaded a mission. In theory. I think there was always a stupid off-by-one error I kept getting, and the functionality isn't critical enough to focus on.  
* Turns out, Lotus does a lot of "ignore your original objective" bullshittery when you're going through motions. What could be an easy Lua Capture (knock a dude out, then go and find your booty) can very quickly turn into a sloggy Exterminate mission. While this doesn't seem to be decided until the completion or approachment of the objective (as far as I can tell), it will provide on average 0.5 seconds of warning before the Lotus opens her dumb mouth. Go you.  
* The script can find Ayatan Sculptures as well. While there are easily more optimal ways to get them (such as [TheKengineer's method](https://www.youtube.com/watch?v=LiQWHsgTRB8), which I recommend in general), it's a good incidental bonus.  

## Again for those of you in the back:  
**This will not tell you WHERE a thing is.** It will not say how many rooms away it is. It will not put a waypoint down for you. And it won't navigate you to it. This is entirely to tell you if the mission you embarked on two seconds ago has what you're looking for. This is a max-range Golden Instinct, but without the near-useless mote that dies before it can point in anything vaguely resembling the right direction.  

Also, don't @ me. This code is bad and I know it. It was formerly for private use.  
