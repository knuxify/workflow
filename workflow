#!/usr/bin/env bash
#
# workflow - a small bash application that prevents you from procrastinating
#
###############
# HOW IT WORKS
# workflow runs in the background, waits for a certain hour (or until it's called manually)
# and, once activated, loads "modules" - small bash scripts with two functions: start and end.
# The start function is called when workflow mode starts and the end function is called when
# workflow mode ends.
# Modules are defined in a configuration file: $HOME/.config/workflow/modules. This location
# is also reccomended for storing modules. In order to create a module, add it to the module
# file like so:
#
#  modulename "/full/path/to/module"
#
# Then, to enable it, add it on a new line to the $HOME/.config/workflow/modules.enabled file.
# In order to start workflow automatically at a certain hour, add the following to the config
# file located at $HOME/.config/workflow/startup-time:
#
#  HH:MM W
#
# Where HH is the hour in a 24-hour format (NOTE: If an hour is single-digit, prepend 0 to it,
# for example 2:10 becomes 02:10), MM is the minute and W is a number corresponding to the day
# of the week (where 1 is Monday and 7 is Sunday).
# In order to run workflow on multiple days of the week, set W to BEGGININGDAY-ENDDAY,
# for example 1-5 is going to run from Mondays to Fridays. You can also set W to 0 to run
# workflow every day.
# In order to run workflow between certain hours, separate the two hours with a dash, like so:
#
#  HH:MM-HH:MM W
#
# If you want workflow to close automatically at a certain hour, separate the two hours with
# an underscore, like so:
#
#  HH:MM_HH:MM
#
# You can also store multiple startup hours. Simply put them on new lines in the startup-time
# file.
###############
# INSTALLING
# Run the installer (./installer) as superuser.
# Manual installation instructions will follow:
# Copy the workflow and workflow-timer files to /usr/bin, then copy the workflow-timer.service
# file to the /etc/systemd/system directory, then (as root) run
#
#  systemd enable workflow-timer.service && systemd start workflow-timer.service
#
# to start up the timer. Alternatively, you can just call the workflow command from a cron job.
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
