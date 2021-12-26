# This is install script of ZOOM!NG 
# Made by Akshat Chauhan

#Requires -RunAsAdministrator

$exe_file_path = "$env:USERPROFILE/AppData/Local/Programs/zooming"
$zooming_folder = "$env:USERPROFILE/.ZOOM!NG"
$zoom_script_url = "https://raw.githubusercontent.com/AkshatChauhan18/Zooming/main/dist/zooming0-0-1.exe"
$zoom_data_json_text = @'
{
    "KEY": "your key",
    "SECRET": "your secrete",
    "settings": {
      "host_video": "true",
      "participant_video": "true",
      "join_before_host": "false",
      "mute_upon_entry": "false",
      "audio": "voip",
      "auto_recording": "false",
      "waiting_room": "true"
    }
}
'@
function create_files {
    Write-Host "Creating meetings.csv"
    New-Item "$zooming_folder/meetings.csv"
    "Topic,Time Zone,Start Time,Password,Agenda,Duration" | Out-File "$zooming_folder/meetings.csv"
    Write-Host "Creating zoom_data.json"
    New-Item "$zooming_folder/zoom_data.json"
    $zoom_data_json_text | Out-File "$zooming_folder/zoom_data.json"
}
function main {
    Write-Host "
 ____  ____  ____  __  ______  _______
/_  / / __ \/ __ \/  |/  / / |/ / ___/
 / /_/ /_/ / /_/ / /|_/ /_/    / (_ /
/___/\____/\____/_/  /_(_)_/|_/\___/ "

    Write-Host
    Write-Host "You can read the license here: https://raw.githubusercontent.com/AkshatChauhan18/Zooming/main/LICENSE"
    if (-not(Test-Path -Path $exe_file_path )) {
        try {
            New-Item -Path $exe_file_path -ItemType Directory
        }
        catch {
            throw $_.Exception.Message
        }
        
    }
    else {
        Remove-Item "$exe_file_path/*"
    }
    Write-Host "Downloading zooming.exe"
    Start-BitsTransfer -Source $zoom_script_url -Destination "$env:USERPROFILE/AppData/Local/Programs/zooming/zooming.exe"
    Write-Host "Adding to path."
    [Environment]::SetEnvironmentVariable("Path", $env:Path + ";$env:USERPROFILE/AppData/Local/Programs/zooming/", "Machine")
}
function check_zooming_folder {
    if (Test-Path -Path $zooming_folder) {
        $answer = Read-Host "$zooming_folder exists, do you want to delete all data and make new settings.json and meetings.csv [y/n]"
        if ($answer -eq "y") {
            Write-Host "Removing all files from .ZOOM!NG folder"
            Remove-Item  "$zooming_folder/*"
            Write-Host
            create_files
        }
        elseif ($answer -eq "n") {
            Write-Host "OK!"
        }
        else {
            check_zooming_folder
        }

    }
    else {
        Write-Host "Creating .ZOOM!NG directory"
        New-Item -Path "$env:USERPROFILE" -Name ".ZOOM!NG" -ItemType "directory" 
        create_files
    }
}

main
check_zooming_folder
Write-Host "Successfully installed ZOOM!NG 0.0.1"