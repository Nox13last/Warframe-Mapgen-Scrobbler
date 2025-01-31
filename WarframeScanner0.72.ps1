# <# HELLO! YOU DOUBLECLICKED THIS FILE. SHAME ON YOU. BUT IT'S FINE: YOU CAN SEE HOW THIS SCRIPT WORKS, I GUESS. OR MAYBE YOU'RE HERE TO TWEAK THE PROGRAM. THAT'S COOL, TOO. GO TO LINE 59 FOR THAT.
# WHEN YOU'RE DONE HERE, PLEASE CLOSE THIS FILE. TO RUN IT, RIGHT-CLICK IT (WHEREVER YOU PLACED IT) AND PRESS 'Run with Powershell'. I CAN'T DO THAT FOR YOU. OK LOVE YOU BYE.#>
$version = "v0.72"

<#TODO: 
	Change colours mid-line to emphasise certain words.
	Make a "find everything" version? Ask the user after the "stay on top" question and make an entire new program?
	Consider making a version that says things instead of beeping. But the Windows TTS is so boring.
	Consider changing the script extension - see if there's one that defaults the double-click invoke action to execute the script, rather than open it in an editor.
	Consider asking the user if we want to keep the console tidy, or if we want to let the messages survive when they become obsolete.
    Consider a function to reload the script if the user changes the search parameters.

CHANGELOG:
	v0.1 	- 	Implemented a terrible way of watching the log.
	v0.2 	- 	Made it better. Now the console can report something on a positive result other than the result itself.
	v0.21 	- 	Added debug command. Added environment variables.
	v0.22	-	The script now knows when the mission has loaded up, when the user abandons the mission, or when they complete the mission. Added TODO.
	v0.25	-	Changed the above parameters to be more unique.
	v0.3	-	Added beeps so that the user doesn't have to keep staring at the script. Added an extra case for when Space-Mom changes her stupid mind.
	v0.31	-	The script won't shut up about Space-Mom changing her dumb mind. Fixed it. Also added an option for the user to keep the script window in the fore.
	v0.32	-	The question about keeping the window in fore was broken. Fixed it.
	v0.33	-	Added window parameters so the window isn't ever larger than it needs to be. It's not locked, and the user can still manipulate it to their liking.
	v0.34	-	Strongly considering changing the "Space-Mom is an idiot who can't make up her stupid dumb mind" jingle from 'Beethoven's 5th' to 'MeGaLoVaNiA'. No actual change.
	v0.4	-	Added CHANGELOG.
	v0.42	-	Changed script output to put the message's timestamp at the start of the message. Feels less organic, but it's easier to read.
	v0.5	-	Added a bad-streak counter and a total attempts counter to know just much of your life you've wasted!
	v0.51	-	More numbers!
    v0.52   -   Removed bloat pertaining to stats "times something was found" etc.
    v0.53   -   Search parameters are now displayed persistently! Changed introduction as it's not a given that the player is using default settings.
    v0.54   -   Reverted v0.52. Turns out variables don't update when called as part of other variables ('";Get-Stats' would not change when its parts incremented, so all statistics stayed at zero.)
    v0.55   -   Fixed that?
    v0.60   -   Actually fixed that. This is a milestone! Slow and clogged and barely holding itself together inside, but looks alright outside. Just like me frfr.
    v0.70   -   Swapped out Read-Host (ask the user for input) to Switch (ask the user to make a choice) re:Stay-On-Top. Also added a couple of presets for the user to choose! Untested, prone to explode.
    v0.71   -   Added default option to $luamode.
    v0.72   -   Added support for Ayatan Sculptures. It pings three times. Need to figure that out.
#>
<# Replace the $filter arguments with any room you're looking for. To look for multiple rooms, seperate them with a pipe character (|) and no space.
    Some valid interesting (lucrative) Lua tiles are:
        IntAgility.level		=	Play the Organ. (Agility Drift). 
        IntStealth.level		=	Avoid the Lasers. (Stealth Drift)
        IntPower.level			=	Charge the Orbs. (Power Drift)
        IntOperaHouse.level	    =	Game of Simon. (Octavia Chassis, random Rare Crate)
        IntSpeed.level			=	Beat the course. (Speed Drift)
        IntCooperation.level	=	Cooperate with one or more players. (Coaction Drift)
        IntCunning.level		=	Outwit the SecurEye. (Cunning Drift).
        IntCloister.level		=	Charge the Arboriform (does not necessarily award prizes)

    Interesting tiles, Murmur Edition:
        IntOctopedeHourglass.level  =    Zelator - Curse of Hearing
        IntOctopedeArena06.level    =    Anchorite - Curse of Seeing
        IntOctopedeArena.level      =    Suzerain - Curse of Knowing
        
    Interesting Objects (Those found by Orokin Eye and Golden Instinct):
        /Lotus/Types/Items/FusionTreasures/FusionTreasure     =   A subset of 'Ayatan Sculpture' items.         

#        The example below looks for the Simon puzzle, the Speed puzzle, and the Power puzzle.#>

# $filter = "ADDITIONAL FILTERS HERE DEMARKATED BY PIPES|IntOperaHouse.level|IntSpeed.level|IntPower.level"
$filter = "I'm not looking for anything right now."

<#========================================================================
DON'T CHANGE ANYTHING BELOW THIS LINE. ALL YOU NEED TO CHANGE IS $filter.
THE STUFF BELOW IS THE SCRIPT'S DETECTION ALGORITHMS AND TEXT STRINGS.
I HAVE WORKED TOO FUCKING HARD FOR YOU TO SCREW IT ALL UP.
==========================================================================#>
[console]::WindowWidth=128; [console]::WindowHeight=11; [console]::BufferWidth=[console]::WindowWidth
$host.ui.RawUI.WindowTitle = "Noxie's Lua Scrobbler ($version)"
$welcome = "Noxie's Lua Scrobbler ($version)`nAfter this screen, to test to see if I am working, type 'Wake up!' in the Squad chat and then open the Nav Console. `nI'll let you know if I find anything by beeping. If I do not beep by the time the loading screen fades out, I have not found`nwhat we're looking for, and you should abandon the mission. `n`nIf at any point you want to stop the script, press the X at the top-right, or press CTRL+C with this window as the focus.`n`nThese are my Search Parameters: $filter`n"
$DEBUG = "Wake up!"
$doneloading = "OnStateStarted, mission"
$EOM = "All players extracting"
$quit = "Abort: host/no session"
$screwyouspacemom = "HudRedux.lua: Queued a transmission from Hud: /Lotus/Sounds/Lotus/DualMissionDialog/DualMissionObjective"
$Global:badstreak = -1
$Global:totalattempts = 0
$Global:laststreak = 0
$Global:positiveresults = 0
$Global:negativeresults = 0
$Global:ratio = 0
$Global:stats = "Null."
set-PSBreakpoint -variable ratio -mode read -action {$Global:ratio=try {$positiveresults / $negativeresults} catch {"I haven't found anything yet!"};$ratio}
set-PSBreakpoint -variable stats -mode read -action {$Global:ratio=try {$positiveresults / $negativeresults} catch {"I haven't found anything yet!"};$Global:stats="`nTotal number of mission starts: $totalattempts. `nAttempts since last good result: $badstreak. `nPrevious streak: $laststreak. `nHappy times: $positiveresults. Sad times: $negativeresults. Ratio: $ratio";$stats}
$stats
$ratio
Clear-Host

<#========================================================================
THIS IS THE SEARCH ENGINE. OH GOD FUCK ME WITH AN UNLUBED CRUCIFIX, THIS SHIT
IS HORRIFYING. DON'T LOOK AT IT. DON'T ASK ABOUT IT. DON'T THINK ABOUT IT.
==========================================================================#>
function TheWholeLot{
Clear-Host;Write-Host "Search Parameters: $filter`nReady to begin.";[console]::beep(2000,100);sleep(0.5);[console]::beep(3000,100);sleep(0.5);[console]::beep(4000,100);sleep(0.5);[console]::beep(5000,300)
[console]::WindowWidth=115; [console]::WindowHeight=7; [console]::BufferWidth=[console]::WindowWidth
Get-Content -path $env:LOCALAPPDATA\Warframe\EE.log -Tail 1 -wait | ForEach-Object {
$testfor = $_
if ($testfor -match $doneloading){$totalattempts++;$badstreak++;Clear-Host;write-host "$(get-date -Format "HH:mm:ss") - Done loading. If I haven't found something by now, you should leave.$stats"}
if ($testfor -match $DEBUG){[console]::beep(2000,100);sleep(0.5);[console]::beep(3000,500);write-host "$(get-date -Format "HH:mm:ss") - I'm awake!"}
if ($testfor -match $filter){$positiveresults++;$laststreak=$badstreak ; $badstreak=0;Clear-Host;[console]::beep(2000,500);write-host "Search Parameters: $filter`n$(get-date -Format "HH:mm:ss") - I found something.$stats"}
if ($testfor -match $EOM){Clear-Host;write-host "Search Parameters: $filter`n$(get-date -Format "HH:mm:ss") - We finished the mission.$stats";[console]::beep(2000,100);sleep(0.5);[console]::beep(3000,100);sleep(0.5);[console]::beep(4000,100);sleep(0.5);[console]::beep(5000,300)}
if ($testfor -match $quit){$negativeresults++;Clear-Host;write-host "$(get-date -Format "HH:mm:ss") - We abandoned the previous mission. Better luck next one.$stats"}
if ($testfor -match $screwyouspacemom){write-host "Space-mom is the worst. How badly do you want this stuff?";[console]::beep(4000,300);sleep(0.5);[console]::beep(4000,300);sleep(0.5);[console]::beep(4000,300);sleep(0.5);[console]::beep(3000,700);sleep(1.5);[console]::beep(3500,300);sleep(0.5);[console]::beep(3500,300);sleep(0.5);[console]::beep(3500,300);sleep(0.5);[console]::beep(3000,700)}
if ($testfor -match "/Lotus/Types/Items/FusionTreasures/FusionTreasure"){[console]::beep(3400,300);sleep(0.5);[console]::beep(4000,300);write-host "I found an Ayatan Sculpture!";sleep(1)}
}}

<# NOW LET'S FIND SOME BULLSHIT. #>
clear-host
echo $welcome
sleep(3)
$ontop = $host.UI.PromptForChoice('', "Do you want this window to stay on top of everything else?", ('&Yes', '&No', '&Quit'), 0)
switch($ontop)
{
    0 {$code=@"
using System;
using System.Runtime.InteropServices;
public static class GetApi {
    [DllImport("user32.dll")]
    private static extern int SetWindowPos(IntPtr hWnd, int hWndInsertAfter, int x, int y, int Width, int Height, int flags); 
    public static int setTop(IntPtr handle) {return GetApi.SetWindowPos(handle, -1, 0, 0, 0, 0, 1 | 2);}
}
"@
Add-Type -TypeDefinition $code

$note=Get-Process -Id $PID | Select-Object -First 1
$handle=$note.MainWindowHandle
[GetApi]::setTop($handle)
}
    1 {Write-Host "OK"}
    2 {Write-Host "Then why am I here?";sleep(1);exit}}
Clear-Host

$luamode = $host.UI.PromptForChoice('What are you looking for?', "The coded search parameters ($filter), All of the Drift Mods on Lua, Everything on Lua.", ('The current &Filter.', 'All &Drift Mods', '&Everything on Lua','&Quit'), 0)
switch($luamode)
{
0 {TheWholeLot}
1 {$filter = "IntAgility.level|IntStealth.level|IntPower.level|IntSpeed.level|IntCooperation.level|IntCunning.level"
TheWholeLot}
2 {$filter = "IntAgility.level|IntStealth.level|IntPower.level|IntOperaHouse.level|IntSpeed.level|IntCooperation.level|IntCunning.level|IntCloister.level"
TheWholeLot}
3 {write-host "Then why am I here?";sleep(1);exit}}

