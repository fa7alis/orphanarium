#Orphanarium v0.0.2 by Shawn Cook (1/13/2020)
#Read Symantec DLP Filereader logs to locate Orphaned Files and remove them from the system.

$logdir = $null
$indexdir = $null
$orphan = $null
$orphans = $null
#set variables to null as we ask the user for this information/populate ourselves

while ($null -eq $logdir){
$logdir = read-host "Please enter the Symantec DLP DEBUG log folder path"
if (-not(test-path $logdir)){
    Write-host ""
    Write-host -ForegroundColor red "*** Invalid directory path, please try again. ***"
    Write-host ""
    $logdir = $null
    }
elseif (-not (get-item $logdir).psiscontainer){
    Write-host ""
    Write-host -ForegroundColor red "*** Path must be a directory, please try again. ***"
    Write-host ""
    $logdir = $null
    }
}
#Query user on log directory and set it as $logdir variable
#Error if path is not valid or is not a folder

while ($null -eq $indexdir){
    $indexdir = read-host "Please enter the Symantec DLP ServerPlatformCommon index folder path"
    if (-not(test-path $indexdir)){
        Write-host ""
        Write-host -ForegroundColor Red "*** Invalid directory path, please try again. ***"
        Write-host ""
        $indexdir = $null
        }
    elseif (-not (get-item $logdir).psiscontainer){
        Write-host ""
        Write-host -ForegroundColor Red "*** Path must be a directory, please try again. ***"
        Write-host ""
        $indexdir = $null
        }
    }
#Query user on index directory and set it as $indexdir variable
#Error if path is not valid or is not a folder

$orphan = (Select-String -Path $logdir\FileReader*.log -Pattern '\b(\w*\w*)\b\.([1-9][0-9]{0,2})\.([1-9][0-9]{0,2})\.rdx$|\b(\w*\w*)\b\.([1-9][0-9]{0,2})\.([1-9][0-9]{0,2})\.rdx\.([1-9][0-9]{0,2})').Matches.Value
$orphans = $orphan.Count
#Run regex against FileReader*.log in $logdir and print matches to screen
Write-host "------------------------------------------------------------"
Write-Host "Our workers have identified ${Orphans} Orphans on the loose."
Write-host "------------------------------------------------------------"

$title    = ""
$question = "Would you like to remove these Orphans?"
$choices  = '&Yes', '&No'

$decision = $Host.UI.PromptForChoice($title, $question, $choices, 1)
if ($decision -eq 0) {
    Write-Host -ForegroundColor Green ">Let's get those Orphans cleaned up..."
    Set-Location -Path $indexdir
    #Set our location to the index directory
    $orphan | ForEach-Object {Remove-Item $_ -WhatIf}
    #For each match found, remove the object from our current location
    #Remove -WhatIf for Production
} else {
    Write-Host -ForegroundColor Blue "Leaving those Orphans alone..."
    Exit 0
}
#Prompt user if they want to remove the found Orphans or not. If Y then remove Orphans, if N then exit the script.
