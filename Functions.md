
* [setup()](#setup)
* [get_missions()](#get_missions)
* [get_mission_path()](#get_mission_path)
* [list_all_missions()](#list_all_missions)
* [show_tasks()](#show_tasks)
* [mission_reset()](#mission_reset)
* [check_success()](#check_success)
* [get_current_mission()](#get_current_mission)
* [set_current_mission()](#set_current_mission)
* [input_mission_number()](#input_mission_number)
* [get_all_tasks()](#get_all_tasks)
* [input()](#input)
* [check_result()](#check_result)


## setup()

Setup. Sets up common variables with paths and filenames
there

#### Example

```bash
```

_Function has no arguments._

## get_missions()

Gets meta info for each mission. UNUSED

#### Example

```bash
```

_Function has no arguments._

## get_mission_path()

Fills $MISSION_PATH with full path to mission name UNUSED

#### Example

```bash
```

### Arguments

* **$1** (string): mission-name

## list_all_missions()

Outputs all missions with counter(mission number)

#### Example

```bash
```

_Function has no arguments._

### Output on stdout

* 1 Install and run apache webserver

## show_tasks()

Outputs full info of mission

#### Example

```bash
show_tasks mission_current
```

### Arguments

* **$1** (string): mission

_Function has no arguments._

### Output on stdout

* Full mission info. Title + Tasks

## mission_reset()

Resets solved-status of current mission+all tasks of mission.

#### Example

```bash
```

_Function has no arguments._

## check_success()

Checks task status with help of "cmd" command in task.ini.

#### Example

```bash
```

### Exit codes

* **0**: Task solved
* **1**: Task unsolved

### Arguments

* **$1** (task):

## get_current_mission()

Returns current mission from player.ini. Returns $MISSION_CURRENT

#### Example

```bash
```

_Function has no arguments._

## set_current_mission()

Writes current mission to player.ini. Writes foldername of mission.

#### Example

```bash
set_current_mission 1
```

### Arguments

* **$1** (int): Mission number. Output of `ls` stating at 1

## input_mission_number()

Receives mission number from terminal input. Returns Mission number

#### Example

```bash
input_mission_number
"Please select a mission [Input number]"
n
"Numbers only"
1
```

_Function has no arguments._

## get_all_tasks()

Fills array $TASK_LIST_OF_TASK with names of all tasks of current mission.

#### Example

```bash
get_all_tasks 1
```

## input()

Asks player to choose a mission. Lists missions and waits for input.

#### Example

```bash
```

_Function has no arguments._

### Output on stdout

* lists missions

## check_result()

Outputs full Result with status, points and hints

#### Example

```bash
```

_Function has no arguments._

### Output on stdout

* Full mission status

