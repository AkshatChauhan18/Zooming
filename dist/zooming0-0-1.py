#!/usr/bin/env python3

"""
ZOOM!NG is used for scheduling zoom meetings from terminal >_ .
Copyright (C) 2021  Akshat Chauhan

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.
"""

import jwt
import requests
import json
import argparse
import sys
import os
import csv
from time import time ,sleep 
from rich.console import Console
from rich.markdown import Markdown

console = Console()
ver = "0.0.1"
zooming_folder = f"{os.path.expanduser('~')}/.ZOOM!NG"
zoom_json = open(f"{zooming_folder}/zoom_data.json").read()
zoom_data = json.loads(zoom_json)
KEY = zoom_data["KEY"]
SECRET= zoom_data["SECRET"]
settings_json = zoom_data["settings"]
default_settings = {"host_video": "true",
                "participant_video": "true",
                "join_before_host": "false",
                "mute_upon_entry": "false",
                "audio": "voip",
                "auto_recording": "false",
                "waiting_room": "true"
                }

def schedule_meeting(meetingsettings):
        headers = {'authorization': f'Bearer {generate_web_token()}',
                'content-type': 'application/json'}
        try:       
            r = requests.post(
                f'https://api.zoom.us/v2/users/me/meetings', 
            headers=headers, data=json.dumps(meetingsettings))    
            res = r.json()
            final_data = (
            "# Its a zoom meet !\n"
            "\n"
            f"## The topic is {res['topic']}\n"
            "\n"
            f"### Link: {res['join_url']}\n"
            "\n"
            f"### **Meeting ID** : ```{res['id']}```\n"
            "\n"
            f"### **Meeting Password** : ```{res['password']}```")
            markdown = Markdown(final_data)
            console.print(markdown)
            print()

        except Exception as e:
            print(res)
            print(e) 
            print()   

def generate_web_token():
        token = jwt.encode(
            {'iss': KEY, 'exp': time() + 5000},
            SECRET,
            algorithm='HS256'
        )
        return token

def from_csv():
    csv_file = open(f"{zooming_folder}/meetings.csv")
    csv_reader = csv.DictReader(csv_file)
    console.print("[cyan]Scheduling all of your meetings.[/cyan][white]")  
    for data in csv_reader:
        topic = data["Topic"]
        starttime = data["Start Time"]
        duration = 40 if data["Duration"] == "" else int(data["Duration"])
        agenda = data["Agenda"]
        timezone = data["Time Zone"]
        password = None if data["Password"] == "" else data["Password"]
        settings =  settings_json if args.jsonsettings else default_settings
        if starttime == "":
            console.print("[red]Your CSV does not have start time.[/red][white]")
            sys.exit()
        meeting_settings =  {"topic": topic,
                    "type": 2,
                    "start_time": starttime,
                    "duration": duration,
                    "timezone": timezone ,
                    "agenda": agenda,
                    "password":password,
                    "settings": settings
                    }  
        console.print(f"[green]Scheduling meeting of topic: {topic} [/green][white]")                          
        schedule_meeting(meeting_settings)            

def from_term(args):
    if args.topic:topic = args.topic
    if not args.topic:topic = None
    if args.password:password = args.password
    if not args.password:password = None
    if args.agenda:agenda = args.agenda
    if not  args.agenda:agenda = None
    if args.duration:duration = args.duration
    if not args.duration:duration = 40
    if args.starttime:starttime = args.starttime
    if not  args.starttime:
        console.print('[red]Please specify start time[/red][white]') 
        sys.exit()
    if args.timezone:timezone = args.timezone
    if not args.timezone:timezone = ''
    settings =  settings_json if args.jsonsettings else default_settings
    

    meeting_settings = {"topic": topic,
                    "type": 2,
                    "start_time": starttime,
                    "duration": duration,
                    "timezone": timezone ,
                    "agenda": agenda,
                    "password":password,
                    "settings": settings
                    }
    
    
    console.print(f"[green]Scheduling meeting of topic: {topic} [/green][white]")
    schedule_meeting(meeting_settings)

def main(args):
    print("""
    
  ____  ____  ____  __  ______  _______
 /_  / / __ \/ __ \/  |/  / / |/ / ___/
  / /_/ /_/ / /_/ / /|_/ /_/    / (_ / 
 /___/\____/\____/_/  /_(_)_/|_/\___/ 

""")
    console.print(f"Version [yellow]{ver}[/yellow][white]")
    sleep(1)
    print()
    if args.fromcsv:
        from_csv()
    else:
        from_term(args)
        
    
if __name__ == "__main__":
    parse = argparse.ArgumentParser(description="Schedule zoom meetings using ZOOM!NG")
    parse.add_argument('-csv','--fromcsv',help="Read csv file and schedule all meetings specified",action='store_true')
    parse.add_argument('-st',"--starttime",help="Set start time for meeting")
    parse.add_argument('-d','--duration',help="Set duration for meeting ,default is 40 mins",type=int)
    parse.add_argument('-t','--topic',help='Set topic for meeting')
    parse.add_argument('-a','--agenda',help='Set agenda for meeting')
    parse.add_argument('-p','--password',help='Set password for meeting , should not have white space')
    parse.add_argument('-tz','--timezone',help='Set time zone for meeting')
    parse.add_argument('-jse','--jsonsettings',help=("""Set settings for meeting using zoom_data.json, else use default settings.The default settings are :,
                                "host_video: true",
                                "participant_video: true",
                                "join_before_host: false",
                                "mute_upon_entry: false",
                                "audio: voip",
                                "auto_recording: false",
                                "waiting_room: true"""),action='store_true')

    args = parse.parse_args()
    main(args)