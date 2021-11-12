#!/usr/bin/env bash

# This is install script of ZOOM!NG
# Made by Akshat Chauhan

function check_zooming_folder(){
    if [[ -d "$HOME/.ZOOM!NG" ]]; then
        echo
        echo "'$HOME/.ZOOM!NG exists', do you want to delete all data and make new settings.json and meetings.csv [yes/no]" 
        read -r answer
        if [[ $answer == "yes"  ]]; then
            echo "Downloading meetings.csv"
            echo $csv_data >> "meetings.csv"
            echo
            echo "Downloading zoom_data.json"
            echo $zoom_data >> "zoom_data.json"
            echo
        elif [[ $answer == "no" ]];then
            echo "OK!"
        else
            check_zooming_folder
        fi
    else
        echo "creating .ZOOM!NG folder"
        mkdir "$HOME/.ZOOM!NG"
        echo "Downloading meetings.csv"
        echo $csv_data >> "meetings.csv"
        echo
        echo "Downloading zoom_data.json"
        echo $zoom_data >> "zoom_data.json"
        echo
    fi
}
csv_data="Topic,Time Zone,Start Time,Password,Agenda,Duration"
zoom_data='
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
'
zoom_script_url="https://raw.githubusercontent.com/AkshatChauhan18/Zooming/main/dist/zooming0-0-1.py"

echo "
  ____  ____  ____  __  ______  _______
 /_  / / __ \/ __ \/  |/  / / |/ / ___/
  / /_/ /_/ / /_/ / /|_/ /_/    / (_ /
 /___/\____/\____/_/  /_(_)_/|_/\___/ "

echo ""
echo "You can read the license here: https://raw.githubusercontent.com/AkshatChauhan18/Zooming/main/LICENSE"
echo "Downloading Zooming script"
mkdir -p "$HOME/.zooming-src/"
sudo curl -o "$HOME/.zooming-src/zooming.py" $zoom_script_url
echo
echo "Adding zooming script to path in .profile"
echo "alias zooming='python3 $HOME/.zooming-src/zooming.py'">>"$HOME/.profile"
check_zooming_folder
echo "Successfully installed ZOOM!NG v0.0.1"
