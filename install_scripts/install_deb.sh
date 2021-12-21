#!/usr/bin/env bash

# This is install script of ZOOM!NG for debian based distros
# Created by Akshat Chauhan
function install_python_packages(){
    echo "Do you want to install imp python packages using sudo, packages are (pyjwt,requests,argparse.rich) [y/n]" && read -r answer
    if [[ $answer == "y" ]]; then
        sudo pip3 install rich
        sudo apt install python3-requests
        sudo pip3 install pyjwt
        sudo pip3 install argparse
    elif [[ $answer == "n" ]]; then
        echo "OK!"
    else 
        install_python_packages 
    fi       
}

function check_zooming_folder(){
    if [[ -d "$HOME/.ZOOM!NG" ]]; then
        echo
        echo "'$HOME/.ZOOM!NG exists', do you want to delete all data and make new settings.json and meetings.csv [y/n]" && read -r answer
        if [[ $answer == "y"  ]]; then
            echo "Creating meetings.csv"
            rm "$HOME/.ZOOM!NG/meetings.csv"
            touch "$HOME/.ZOOM!NG/meetings.csv"
            echo $csv_data >> "$HOME/.ZOOM!NG/meetings.csv"
            echo
            echo "Creating zoom_data.json"
            rm "$HOME/.ZOOM!NG/zoom_data.json"
            touch "$HOME/.ZOOM!NG/zoom_data.json"
            echo $zoom_data >> "$HOME/.ZOOM!NG/zoom_data.json"
            echo
        elif [[ $answer == "n" ]];then
            echo "OK!"
        else
            check_zooming_folder
        fi
    else
        echo "creating .ZOOM!NG folder"
        mkdir "$HOME/.ZOOM!NG"
        echo "Creating meetings.csv"
        touch "$HOME/.ZOOM!NG/meetings.csv"
        echo $csv_data >> "$HOME/.ZOOM!NG/meetings.csv"
        echo
        echo "Creating zoom_data.json"
        touch "$HOME/.ZOOM!NG/zoom_data.json"
        echo $zoom_data >> "$HOME/.ZOOM!NG/zoom_data.json"
        echo
    fi
}
csv_data="Topic,Time Zone,Start Time,Password,Agenda,Duration"
zoom_data='
{
    "KEY": "your key",
    "SECRET": "your secret",
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
sudo touch "/usr/bin/zooming"
sudo curl -o "/usr/bin/zooming" $zoom_script_url
sudo chmod +x "/usr/bin/zooming"
check_zooming_folder
install_python_packages
echo "Successfully installed ZOOM!NG v0.0.1"