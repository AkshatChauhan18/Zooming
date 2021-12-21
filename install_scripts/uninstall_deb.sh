#!/usr/bin/env bash

# This is install script of ZOOM!NG for debian based distros
# Created by Akshat Chauhan

function check_zooming_folder(){
    if [[ -d "$HOME/.ZOOM!NG" ]]; then
        echo
        echo "Do you want to remove .ZOOM!NG folder[y/n]" && read -r answer
        if [[ $answer == "y"  ]]; then
            echo 'Removing .ZOOM!NG folder'
            rm "$HOME/.ZOOM!NG/meetings.csv"
            rm "$HOME/.ZOOM!NG/zoom_data.json"
            rmdir "$HOME/.ZOOM!NG"
        elif [[ $answer == "n" ]];then
            echo "OK!"
        else
            check_zooming_folder
        fi
    else
        echo ".ZOOM!NG folder not found."    
    fi    
}

if [[ -f "/usr/bin/zooming" ]]; then
    echo "removing ZOOM!NG"
    sudo rm "/usr/bin/zooming"
else
    echo '.zooming-src not found'    
fi
check_zooming_folder
echo
echo 'Successfully removed ZOOM!NG'
