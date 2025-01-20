#!/usr/bin/env osascript

property internalDisplayActive : missing value
property iceBarStatus : missing value

set internalDisplayActive to do shell script "system_profiler SPDisplaysDataType | grep Built-in | wc -l | xargs"

set iceBarStatus to do shell script "defaults read com.jordanbaird.Ice UseIceBar"

log "Internal Display Active: " & (internalDisplayActive as string) & ", Ice Bar Enabled: " & (iceBarStatus as string)

if iceBarStatus is not equal to internalDisplayActive then -- If internal display: on, If external display: off
	set desiredBool to "false"
	if internalDisplayActive is equal to "1" then
		set desiredBool to "true"
	end if

	log "Setting Ice Bar to: " & desiredBool

	set shellScript to "defaults write com.jordanbaird.Ice UseIceBar -bool '" & desiredBool & "'"
	do shell script shellScript

	tell application "Ice"
		quit
	end tell

	delay 0.1

	tell application "Ice"
		activate
	end tell
else
	log "Ice bar is as desired"
end if


log "Done"
