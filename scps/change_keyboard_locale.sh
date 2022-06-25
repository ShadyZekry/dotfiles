# !bin/bash

current_layout=$(~/scps/current_keyboard_layout.sh)
new_lang="us"

if [[ "$current_layout" == "us" ]]; then
	new_lang="ar"
elif [[ "$current_layout" == "ar" ]]; then
	new_lang="us"
else
	new_lang="us"
fi

setxkbmap -layout $new_lang
notify-send "Changing keyboard layout to $new_lang"