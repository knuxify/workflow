#!/usr/bin/env bash
#
# workflow - a small bash application that prevents you from procrastinating
#
###############
# HOW IT WORKS
# moved to README.md
###############

# Initial checks for required startup items.
[[ ! -e "$HOME/.config/workflow" ]] && mkdir -p "$HOME/.config/workflow"
touch "$HOME/.config/workflow/modules"
#touch "$HOME/.config/workflow/modules.enabled"
if [[ -z "$(cat $HOME/.config/workflow/modules)" ]]; then
	echo "No modules have been added. Nothing to do."
	exit 1
fi

if [[ "$*" ]]; then
	for mod in $*; do
		if [[ "$mod" == "exit" ]]; then
			read -p "Are you sure you want to exit workflow mode? [y/N] " -re exitoption
			if [[ "$exitoption" == "y" ]] || [[ "$exitoption" == "Y" ]]; then
			while read -re toload; do
				path="$(grep $toload $HOME/.config/workflow/modules | sed 's/[^ ]* *//')"
				if [[ -z "$path" ]]; then
					echo "WARNING: Module $toload was supposed to be loaded, but it is not specified in the modules file."
					continue
				fi
			    if [[ ! -e "$path" ]]; then
			        echo "WARNING: File $path (required by module $toload) does not exist."
			        continue
			    fi
				source "$path"
				end
				unset -f start end
			done < "$HOME/.config/workflow/modules.loaded"
			rm "$HOME/.config/workflow/modules.loaded"
			touch "$HOME/.config/workflow/.lock"
			break
		elif [[ "$mod" != "autoend" ]]; then
			path="$(grep $toload $HOME/.config/workflow/modules | sed 's/[^ ]* *//')"
			if [[ -z "$path" ]]; then
				echo "WARNING: Module $toload was supposed to be loaded, but it is not specified in the modules file."
				continue
			fi
			if [[ ! -e "$path" ]]; then
				echo "WARNING: File $path (required by module $toload) does not exist."
				continue
			fi
			source "$path"
			start
			echo "$toload" | awk '{print $1;}' >> "$HOME/.config/workflow/modules.loaded"
			unset -f start end
		fi
	done
elif [[ -e "$HOME/.config/workflow/modules.enabled" ]]; then
	while read -re toload; do
		path="$(grep $toload $HOME/.config/workflow/modules | sed 's/[^ ]* *//')"
		if [[ -z "$path" ]]; then
			echo "WARNING: Module $toload was supposed to be loaded, but it is not specified in the modules file."
			continue
		fi
		if [[ ! -e "$path" ]]; then
			echo "WARNING: File $path (required by module $toload) does not exist."
			continue
		fi
		source "$path"
		start
		echo "$toload" | awk '{print $1;}' >> "$HOME/.config/workflow/modules.loaded"
		unset -f start end
	done < "$HOME/.config/workflow/modules.enabled"
else
	echo "No modules have been provided. Nothing to do."
fi
