## Todo:
* Change colours mid-line to emphasise certain words.  
* Make a "find everything" version? Ask the user after the "stay on top" question and make an entire new program?  
* Consider making a version that says things instead of beeping. But the Windows TTS is so boring.  
* Consider changing the script extension - see if there's one that defaults the double-click invoke action to execute the script, rather than open it in an editor.  
* Consider asking the user if we want to keep the console tidy, or if we want to let the messages survive when they become obsolete.  
* Consider a function to reload the script if the user changes the search parameters.  

## Changelog:
### 0.1  
  Implemented a terrible way of watching the log.  
### 0.2  
  Made it better. Now the console can report something on a positive result other than the result itself.  
### 0.21  
  Added debug command.  
  Added environment variables.  
### 0.22  
  The script now knows when the mission has loaded up, when the user abandons the mission, or when they complete the mission. Added TODO.  
### 0.25  
  Changed the above parameters to be more unique.  
### 0.3  
  Added beeps so that the user doesn't have to keep staring at the script.  
  Added an extra case for when Space-Mom changes her stupid mind.  
### 0.31  
  The script won't shut up about Space-Mom changing her dumb mind. Fixed it.  
  Also added an option for the user to keep the script window in the fore.  
### 0.32  
  The question about keeping the window in fore was broken. Fixed it.  
### 0.33  
  Added window parameters so the window isn't ever larger than it needs to be. It's not locked, and the user can still manipulate it to their liking.  
### 0.34  
  Strongly considering changing the "Space-Mom is an idiot who can't make up her stupid dumb mind" jingle from 'Beethoven's 5th' to 'MeGaLoVaNiA'.  
  No actual change.  
### 0.4  
  Added CHANGELOG.  
### 0.42  
  Changed script output to put the message's timestamp at the start of the message. Feels less organic, but it's easier to read.  
### 0.5  
  Added a bad-streak counter and a total attempts counter to know just much of your life you've wasted!  
### 0.51  
  More numbers!  
### 0.52  
  Removed bloat pertaining to stats "times something was found" etc.  
### 0.53  
  Search parameters are now displayed persistently!  
  Changed introduction as it's not a given that the player is using default settings.  
### 0.54  
  Reverted v0.52. Turns out variables don't update when called as part of other variables ('";Get-Stats' would not change when its parts incremented, so all statistics stayed at zero.)  
### 0.55  
  Fixed that?  
### 0.60  
  Actually fixed that. This is a milestone! Slow and clogged and barely holding itself together inside, but looks alright outside. Just like me frfr.  
### 0.70  
  Swapped out Read-Host (ask the user for input) to Switch (ask the user to make a choice) re:Stay-On-Top.  
  Also added a couple of presets for the user to choose! Untested, prone to explode.  
### 0.71  
  Added default option to $luamode.  
### 0.72  
  Added support for Ayatan Sculptures.  
    It pings three times. Need to figure that out.  
