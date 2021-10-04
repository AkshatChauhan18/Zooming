#!/usr/bin/env bash
function check_zooming_folder(){
    if [[ -d "$HOME/.ZOOM!NG" ]]; then
        echo
        echo "'$HOME/.ZOOM!NG exists', do you want to delete all data and make new settings.json and meetings.csv [yes/no]" 
        read -r answer
        if [[ $answer == "yes"  ]]; then
            echo "Downloading meetings.csv"
            sudo curl -o "$HOME/.ZOOM!NG/meetings.csv" $csv_url
            echo
            echo "Downloading zoom_data.json"
            sudo curl -o "$HOME/.ZOOM!NG/meetings.csv" $zoom_data_url
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
        sudo curl -o "$HOME/.ZOOM!NG/meetings.csv" $csv_url
        echo "Downloading zoom_data.json"
        sudo curl -o "$HOME/.ZOOM!NG/meetings.csv" $zoom_data_url
    fi
}
csv_url="https://raw.githubusercontent.com/AkshatChauhan18/Zooming/main/fnc/meetings.csv"
zoom_data_url="https://raw.githubusercontent.com/AkshatChauhan18/Zooming/main/fnc/zoom_data.json"
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
