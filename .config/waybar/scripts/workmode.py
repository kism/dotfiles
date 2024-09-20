#!/usr/bin/env python3

import subprocess
import json


list_of_titles_work = ["Outlook", "Microsoft Teams"]
list_of_titles_discord = ["Discord"]

list_of_titles = [list_of_titles_work, list_of_titles_discord]

def get_window_titles():
    root = subprocess.Popen(["swaymsg", "-r", "-t", "get_tree"], stdout=subprocess.PIPE)
    stdout, stderr = root.communicate()

    tree = json.loads(stdout)
    windows = []

    def recurse_tree(node):
        if isinstance(node, dict):
            if "name" in node and node["type"] == "con":
                windows.append(node["name"])
            for key, value in node.items():
                recurse_tree(value)
        elif isinstance(node, list):
            for item in node:
                recurse_tree(item)

    recurse_tree(tree)
    return windows


window_list = get_window_titles()

found_window_list = []

def check_windows(window_list, list_of_list_of_titles):
    # print(list_of_list_of_titles)
    for list_of_titles in list_of_list_of_titles:
        # print(list_of_titles)
        for window in window_list:
            for title in list_of_titles:
                # print(f"Checking title {title} in {window}")
                if title.lower() in str(window).lower():
                    # print("found!")
                    found_window_list.append(title)

check_windows(window_list, list_of_titles)

if len(found_window_list) == 0:
    output_message = { "text": "No work windows", "tooltip": "No work windows" }
elif len(found_window_list) == 1:
    output_message = { "text": found_window_list[0], "tooltip": found_window_list[0] }
else:
    output_message = { "text": f"{len(found_window_list)} chats", "tooltip": ", ".join(found_window_list) }

print(json.dumps(output_message))
