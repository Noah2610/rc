#!/bin/bash

help_text=$(cat <<-END
  chvol
  Change volume script
  Usage:
    # Increment/Decrement volume by 5%:
      $ chvol incr[ement] 5
      $ chvol decr[ement] 5
    # Set volume to 50%:
      $ chvol set 50
    # Mute/Unmute/Toggle mute:
      $ chvol mute
      $ chvol unmute
      $ chvol togglemute
    # Print this help message, then exit:
      $ chvol help

  Options:
    # Print this help message, then exit:
      -h --help
    # Quiet, don't print feedback message to stdout:
      -q --quiet
    # No feedback sound:
      -Q --nosound
END
)

sound_file="/home/noah/.custom_sounds/volume_change.mp3"

opts=()
opts_ext=()
cmd=
val=

for arg in $@; do
	if [[ $arg =~ ^-[[:alnum:]]+ ]]; then
		for (( i=1; i < ${#arg}; i++ )); do
			opts+=("${arg:$i:1}")
		done
	elif [[ "$arg" == "--"* && "${#arg}" > "2" ]]; then
		opts_ext+=("${arg:2}")
	elif [ -z "$cmd" ]; then
		cmd="$arg"
	elif [ -z "$val" ]; then
		val="$arg"
	fi
done

if [[ " ${opts[@]} " =~ " h " || " ${opts_ext[@]} " =~ " help " ]]; then
	echo "$help_text"
	exit
fi

feedback=
case "$cmd" in
	"help")
		echo "$help_text"
		exit
		;;
	"incr"*)
		amixer sset Master ${val}%+ &> /dev/null
		feedback="Incremented volume by ${val}%."
		;;
	"decr"*)
		amixer sset Master ${val}%- &> /dev/null
		feedback="Decremented volume by ${val}%."
		;;
	"set")
		amixer sset Master ${val}% &> /dev/null
		feedback="Set volume to ${val}%."
		;;
	"mute")
		amixer sser Master mute &> /dev/null
		feedback="Muted volume."
		;;
	"unmute")
		amixer sser Master unmute &> /dev/null
		feedback="Unmuted volume."
		;;
	"togglemute")
		amixer sser Master toggle &> /dev/null
		feedback="Toggled mute."
		;;
	*)
		echo "'$cmd': Command not recognized."
		exit
		;;
esac

if [[ ! " ${opts[@]} " =~ " q " && ! " ${opts_ext[@]} " =~ " quiet " ]]; then
	echo "$feedback"
fi
if [[ ! " ${opts[@]} " =~ " Q " && ! " ${opts_ext[@]} " =~ " nosound " ]]; then
	VLC_VERBOSE=0; cvlc --quiet --play-and-exit $sound_file  &> /dev/null
fi

