# <# HELLO! YOU DOUBLECLICKED THIS FILE. SHAME ON YOU. BUT IT'S FINE: YOU CAN SEE HOW THIS SCRIPT WORKS, I GUESS.
# WHEN YOU'RE DONE HERE, PLEASE CLOSE THIS FILE. TO RUN IT, RIGHT-CLICK IT (WHEREVER YOU PLACED IT) AND PRESS 'Run with Powershell'. I CAN'T DO THAT FOR YOU. OK LOVE YOU BYE.#>
$version = "v0.9"

$items = [ordered]@{
    "LUA PRINCIPLES - (Agility Drift) Play the Organ" = "MoonIntAgility/OrokinMoonTreasureRoomUnlockSeq"
    "LUA PRINCIPLES - (Stealth Drift) Avoid the Lasers" = "MoonIntStealth/OrokinMoonTreasureRoomUnlockSeq"
    "LUA PRINCIPLES - (Endurance Drift) Get shot at a bunch" = "MoonIntEndurance/OrokinMoonTreasureRoomUnlockSeq"
    "LUA PRINCIPLES - (Power Drift) Charge the Four Orbs" = "MoonIntPower/OrokinMoonFloorMoveLoopSeq"
    "LUA PRINCIPLES - (Speed Drift) Beat the Course" = "MoonIntSpeed/OrokinMoonTreasureRoomUnlockSeq"
    "LUA PRINCIPLES - (Coaction Drift) Cooperate with others" = "MoonIntCoop/OrokinMoonTreasureRoomUnlockSeq"
    "LUA PRINCIPLES - (Cunning Drift) Outwit the SecurEye" = "MoonIntCunning/OrokinMoonTreasureRoomUnlockSeq"
    "LUA MISCELLANEOUS - (Captura Scene) Charge the Arboriform" = "MoonIntCloister/OrokinMoonPuzzleSuccessSeq"
    "LUA MISCELLANEOUS - (Octavia Chassis, random Rare Crate) Game of Simon" = "MoonIntOperaHouse/OrokinMoonOperaHouseMusicSeq"
    "LUA MISCELLANEOUS - Jade Light Execution Chamber" = "MoonIntHallsOfJudgement/OrokinMoonBolderCrackSeq"
    "MURMURS (These were for Operation: Gargoyle's Cry, but might still be useful. They might also be broken, since EE.log seems to no longer divulge .level mapgen.) - Zelator - Curse of Hearing" = "IntOctopedeHourglass.level"
    "MURMURS (These were for Operation: Gargoyle's Cry, but might still be useful. They might also be broken, since EE.log seems to no longer divulge .level mapgen.) - Anchorite - Curse of Seeing" = "IntOctopedeArena06.level"
    "MURMURS (These were for Operation: Gargoyle's Cry, but might still be useful. They might also be broken, since EE.log seems to no longer divulge .level mapgen.) - Suzerain - Curse of Knowing" = "IntOctopedeArena.level"
    "GOLDEN INSTINCTS - Ayatan Sculptures" = "/Lotus/Types/Items/FusionTreasures/FusionTreasure"
    
}

$categories = [ordered]@{
    "LUA PRINCIPLES" = @("(Agility Drift) Play the Organ", "(Stealth Drift) Avoid the Lasers", "(Endurance Drift) Get shot at a bunch", "(Power Drift) Charge the Four Orbs", "(Speed Drift) Beat the Course", "(Coaction Drift) Cooperate with others", "(Cunning Drift) Outwit the SecurEye")
    "LUA MISCELLANEOUS" = @("(Captura Scene) Charge the Arboriform", "(Octavia Chassis, random Rare Crate) Game of Simon", "Jade Light Execution Chamber")
    "MURMURS (These were for Operation: Gargoyle's Cry, but might still be useful. They might also be broken, since EE.log seems to no longer divulge .level mapgen.)" = @("Zelator - Curse of Hearing", "Anchorite - Curse of Seeing", "Suzerain - Curse of Knowing")
    "GOLDEN INSTINCTS" = @("Ayatan Sculptures")
}

while ($true) {
    Write-Host "Noxie's Lua Scrobbler ($version)`nAfter this screen, to test if I am working, type 'Wake up!' in the Squad chat and then open the Nav Console.`nI'll let you know if I find anything by beeping. If I don't beep by the time the loading screen fades out, I have not found what we're looking for, and you should abandon the mission.`n`nIf at any point you want to stop the script, press the X at the top-right, or press CTRL+C with this window as the focus.`n`nPlease select one or more options by entering the corresponding numbers (comma-separated), or type 'quit' to exit:"
    
    $keys = @()
    $index = 1
    
    foreach ($category in $categories.Keys) {
        Write-Host "`n$category"
        foreach ($option in $categories[$category]) {
            Write-Host ("{0}: {1}" -f $index, $option)
            $keys += "$category - $option"
            $index++
        }
    }
    
    Write-Host "`nANYTHING ELSE`nQ: Quit"

    $selection = Read-Host "Enter your selection"
    if ($selection -match "^q$|^quit$") {
        Write-Host "Exiting script."
        exit
    }
    
    $selectedIndexes = $selection -split ',' | ForEach-Object { $_.Trim() } | Where-Object { $_ -match "^\d+$" } | ForEach-Object { $_ -as [int] }
    
    $validIndexes = $selectedIndexes | Where-Object { $_ -ge 1 -and $_ -le $keys.Count }
    if ($validIndexes.Count -eq 0) {
        Write-Host "Invalid selection. Please enter valid numbers from the list."
        continue
    }
    
    $choice = $validIndexes | ForEach-Object { $items[$keys[[math]::Max(0, $_-1)]] }
    $filter = $($choice -join '|')
    break
}
$host.ui.RawUI.WindowTitle = "Noxie's Lua Scrobbler (Neo $version)"
$DEBUG = "Wake up!"
$doneloading = "OnStateStarted, mission"
$EOM = "All players extracting"
$quit = "Abort: host/no session"
$changeofplans = "HudRedux.lua: Queued a transmission from Hud: /Lotus/Sounds/Lotus/DualMissionDialog/DualMissionObjective"
$Global:badstreak = 0
$Global:totalattempts = 0
$Global:laststreak = 0
$Global:positiveresults = 0
$Global:negativeresults = 0
$Global:ratio = 0
$Global:stats = "Nothing."
set-PSBreakpoint -variable ratio -mode read -action {$Global:ratio=try {$positiveresults / $negativeresults} catch {"I haven't found anything yet!"};$ratio}
set-PSBreakpoint -variable stats -mode read -action {$Global:ratio=try {$positiveresults / $negativeresults} catch {"I haven't found anything yet!"};$Global:stats="`nTotal number of mission starts: $totalattempts. `nAttempts since last good result: $badstreak. `nPrevious streak: $laststreak. `nHappy times: $positiveresults. Sad times: $negativeresults. Ratio: $ratio";$stats}
$stats
$ratio
clear-host

<#========================================================================
I SHOULD REFACTOR THIS AT SOME POINT, BUT I'M TIRED.
==========================================================================#>
function Scrobble{
clear-host;Write-Host "Search Parameters: $($filter -join '|')`nReady to begin.";[console]::beep(2000,100);sleep(0.5);[console]::beep(3000,100);sleep(0.5);[console]::beep(4000,100);sleep(0.5);[console]::beep(5000,300)
[console]::WindowWidth=115; [console]::WindowHeight=7; [console]::BufferWidth=[console]::WindowWidth
Get-Content -path $env:LOCALAPPDATA\Warframe\EE.log -Tail 1 -wait | ForEach-Object {
$testfor = $_
if ($testfor -match $doneloading){$totalattempts++;$badstreak++;clear-host;write-host "$(get-date -Format "HH:mm:ss") - Done loading. If I haven't found something by now, you should leave.$stats"}
if ($testfor -match $DEBUG){[console]::beep(2000,100);sleep(0.5);[console]::beep(3000,500);write-host "$(get-date -Format "HH:mm:ss") - I'm awake!"}
if ($testfor -match $filter){$positiveresults++;$laststreak=$badstreak ; $badstreak=0;clear-host;[console]::beep(2000,500);write-host "Search Parameters: $filter`n$(get-date -Format "HH:mm:ss") - I found something.$stats"}
if ($testfor -match $EOM){clear-host;write-host "Search Parameters: $($filter -join '|')`n$(get-date -Format "HH:mm:ss") - We finished the mission.$stats";[console]::beep(2000,100);sleep(0.5);[console]::beep(3000,100);sleep(0.5);[console]::beep(4000,100);sleep(0.5);[console]::beep(5000,300)}
if ($testfor -match $quit){$negativeresults++;clear-host;write-host "$(get-date -Format "HH:mm:ss") - We abandoned the previous mission. Better luck next one.$stats"}
if ($testfor -match $changeofplans){write-host "Space-mom is the worst. How badly do you want this stuff?";[console]::beep(4000,300);sleep(0.5);[console]::beep(4000,300);sleep(0.5);[console]::beep(4000,300);sleep(0.5);[console]::beep(3000,700);sleep(1.5);[console]::beep(3500,300);sleep(0.5);[console]::beep(3500,300);sleep(0.5);[console]::beep(3500,300);sleep(0.5);[console]::beep(3000,700)}
}}

<# NOW LET'S FIND SOME BULLSHIT. #>
clear-host
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
clear-host

Scrobble
