#Orphanarium v0.0.1 by Shawn Cook (8/9/2019)
#Read Symantec DLP Filereader logs to locate Orphaned Files and remove them from the system.

$logdir = $null
#set $logdir variable to null as we ask the user for this information

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

$Orphan = (Select-String -Path $logdir\FileReader*.log -Pattern '\b(\w*\w*)\b\.([1-9][0-9]{0,2})\.([1-9][0-9]{0,2})\.rdx$|\b(\w*\w*)\b\.([1-9][0-9]{0,2})\.([1-9][0-9]{0,2})\.rdx\.([1-9][0-9]{0,2})').Matches.Value
$Orphans = $Orphan.Count
#Run regex against FileReader*.log in $logdir and print matches to screen
Write-host "------------------------------------------------------------"
Write-Host "Our workers have identified ${Orphans} Orphans on the loose."
Write-host "------------------------------------------------------------"

$Title    = ""
$Question = "Would you like to remove these Orphans?"
$Choices  = '&Yes', '&No'

$decision = $Host.UI.PromptForChoice($Title, $Question, $Choices, 1)
if ($decision -eq 0) {
    Write-Host "Let's get those Orphans cleaned up..."
} else {
    Write-Host "Leaving those Orphans alone..."
    Exit 0
}

<#
NEED TO BE DONE
Matches dumped to file, or temporary storage for remove action
Directory path for orphaned files needs to be determined (user input)
Actions to delete orphaned files listed in logs

NOTES
After matches, print "Found (x) orphans, delete? Y/N"
Error handling?

FUTURE
Automatically find debug log path?
Automatically find orphaned files path?
Check that we are running as Administrator?
#>
