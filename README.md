# workflow - a small bash application that prevents you from procrastinating

## Installing

Copy the workflow and workflow-timer files to /usr/bin, then run on workflow-timer on startup (reffer to your environment's documentation)

Alternatively, you can just call the workflow command from a cron job.

## How it works

workflow-timer runs in the background, waits for a certain hour (or until it's called manually) and, once activated, loads "modules" - small bash scripts with two functions: start and end.
The start function is called when workflow mode starts and the end function is called when workflow mode ends.

## Configuration

### Workflow timer

The workflow-timer is a script that runs in the background. It automatically starts workflow with certain modules (see section titled Modules below).

In order to start workflow automatically at a certain hour, add the following to the config file located at $HOME/.config/workflow/startup-time:

```
HH:MM W
```

Where HH is the hour in a 24-hour format (NOTE: If an hour is single-digit, prepend 0 to it, for example 2:10 becomes 02:10), MM is the minute and W is a number corresponding to the day of the week (where 1 is Monday and 7 is Sunday).

In order to run workflow on multiple days of the week, set W to BEGGININGDAY-ENDDAY, for example 1-5 is going to run from Mondays to Fridays. You can also set W to 0 to run workflow every day.

In order to run workflow between certain hours, separate the two hours with a dash, like so:

```
HH:MM-HH:MM W
```

In order to run certain modules at certain hour, you can provide them:

```
HH:MM W module1 module2 module3 ...
```

You can also store multiple startup hours. Simply put them on new lines in the startup-time file.

### Modules

Modules are shorthands for scripts that can be called by workflow.

Modules are defined in a configuration file: $HOME/.config/workflow/modules. This config location is also reccomended for storing modules. In order to create a module, add it to the module file like so:

```
modulename "/full/path/to/module"
```

In order to use a module, run workflow with the modules as arguments, separated by spaces. You can also place them in the $HOME/.config/workflow/modules.enabled file (although keep in mind that the arguments will take priority over this file).
