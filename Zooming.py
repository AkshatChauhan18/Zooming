import jwt 
import requests
import json
import argparse
import sys
import os
import csv
from colorama import Fore
from time import time 

zooming_folder = f"{os.path.expanduser('~')}/.Zooming"
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

def scheduleMeeting(meetingsettings):
        headers = {'authorization': f'Bearer {generateToken()}',
                'content-type': 'application/json'}
        try:       
            r = requests.post(
                f'https://api.zoom.us/v2/users/me/meetings', 
            headers=headers, data=json.dumps(meetingsettings))    
            res = r.json()
            print(res)
            print()
        except Exception as e:
            print(e) 
            print()   

def generateToken():
        token = jwt.encode(
            {'iss': KEY, 'exp': time() + 5000},
            SECRET,
            algorithm='HS256'
        )
        return token

def from_csv():
    csv_file = open(f"{zooming_folder}/meetings.csv")
    csv_reader = csv.DictReader(csv_file)
    print(Fore.CYAN+"Scheduling all of your meetings."+Fore.WHITE)  
    for data in csv_reader:
        topic = data["Topic"]
        starttime = data["Start Time"]
        duration = 40 if data["Duration"] == "" else int(data["Duration"])
        agenda = data["Agenda"]
        timezone = data["Time Zone"]
        password = None if data["Password"] == "" else data["Password"]
        settings =  settings_json if args.jsonsettings else default_settings
        if starttime == "":
            print(Fore.RED+"Your CSV does not have start time."+Fore.WHITE)
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
        print(Fore.GREEN+f"Scheduling meeting of topic: {topic}"+Fore.WHITE)                          
        scheduleMeeting(meeting_settings)            

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
        print(Fore.RED+'Please specify start time'+Fore.WHITE) 
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
    
    
    print(Fore.GREEN+f"Scheduling meeting of topic: {topic}"+Fore.WHITE)
    scheduleMeeting(meeting_settings)

def main(args):
    if args.fromcsv:
        from_csv()
    else:
        from_term(args)
        
    
if __name__ == "__main__":
    parse = argparse.ArgumentParser(description="Schedule zoom meetings using Zooming")
    parse.add_argument('-csv','--fromcsv',help="Read csv file and schedule all meetings specified",action='store_true')
    parse.add_argument('-st',"--starttime",help="Set start time for meeting")
    parse.add_argument('-d','--duration',help="Set duration for meeting ,default is 40 mins",type=int)
    parse.add_argument('-t','--topic',help='Set topic for meeting')
    parse.add_argument('-a','--agenda',help='Set agenda for meeting')
    parse.add_argument('-p','--password',help='Set password for meeting , should not have white space')
    parse.add_argument('-tz','--timezone',help='Set time zone for meeting')
    parse.add_argument('-jse','--jsonsettings',help=("""Set settings for meeting (json), else use default settings.The default settings are :,
                                "host_video: true",
                                "participant_video: true",
                                "join_before_host: false",
                                "mute_upon_entry: false",
                                "audio: voip",
                                "auto_recording: false",
                                "waiting_room: true"""),action='store_true')

    args = parse.parse_args()
    main(args)
    
