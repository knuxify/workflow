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
touch "$HOME/.config/workflow/modules.enabled"
if [[ -z "$(cat $HOME/.config/workflow/modules)" ]]; then
	echo "No modules have been added. Nothing to do."
	exit 1
fi

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
	unset -f start end
done < "$HOME/.config/workflow/modules.enabled"
