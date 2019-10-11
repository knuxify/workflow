# workflow - a small bash application that prevents you from procrastinating

## HOW IT WORKS

workflow runs in the background, waits for a certain hour (or until it's called manually) and, once activated, loads "modules" - small bash scripts with two functions: start and end.
The start function is called when workflow mode starts and the end function is called when workflow mode ends.

Modules are defined in a configuration file: $HOME/.config/workflow/modules. This location is also reccomended for storing modules. In order to create a module, add it to the module file like so:

```
modulename "/full/path/to/module"
```

Then, to enable it, add it on a new line to the $HOME/.config/workflow/modules.enabled file.
In order to start workflow automatically at a certain hour, add the following to the config
file located at $HOME/.config/workflow/startup-time:

```
HH:MM W
```

Where HH is the hour in a 24-hour format (NOTE: If an hour is single-digit, prepend 0 to it, for example 2:10 becomes 02:10), MM is the minute and W is a number corresponding to the day of the week (where 1 is Monday and 7 is Sunday).

In order to run workflow on multiple days of the week, set W to BEGGININGDAY-ENDDAY, for example 1-5 is going to run from Mondays to Fridays. You can also set W to 0 to run workflow every day.

In order to run workflow between certain hours, separate the two hours with a dash, like so:

```
HH:MM-HH:MM W
```

You can also store multiple startup hours. Simply put them on new lines in the startup-time
file.

## INSTALLING

Copy the workflow, wfexit and workflow-timer files to /usr/bin, then run on workflow-timer on startup (reffer to your environment's documentation)

Alternatively, you can just call the workflow command from a cron job.
