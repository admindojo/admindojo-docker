
* [setup()](#setup)
* [get_missions()](#get_missions)
* [get_mission_path()](#get_mission_path)
* [list_all_missions()](#list_all_missions)
* [show_tasks()](#show_tasks)
* [check_success()](#check_success)
* [get_current_mission()](#get_current_mission)
* [set_current_mission()](#set_current_mission)
* [input_mission_number()](#input_mission_number)
* [get_all_tasks()](#get_all_tasks)
* [check_result()](#check_result)


## setup()

Multiline description goes here and
there

#### Example

```bash
some:other:func a b c
echo 123
```

_Function has no arguments._

## get_missions()

@description

#### Example

```bash
```

### Arguments

* $1

_Function has no arguments._

### Output on stdout

* Path to something.

## get_mission_path()

@description

#### Example

```bash
```

### Arguments

* $1

_Function has no arguments._

### Output on stdout

* Path to something.

## list_all_missions()

@description

#### Example

```bash
```

### Arguments

* $1

_Function has no arguments._

### Output on stdout

* Path to something.

## show_tasks()

Outputs full info for the current mission.
Currently outputs last mission. not current mission

#### Example

```bash
show_tasks mission_current
```

### Arguments

* **$1** (string): mission

_Function has no arguments._

### Output on stdout

* Full mission info. Title + Tasks

## check_success()

@description

#### Example

```bash
```

### Arguments

* $1

_Function has no arguments._

### Output on stdout

* Path to something.

## get_current_mission()

Returns current mission from player.ini. Returns MISSION_CURRENT

#### Example

```bash
get_all_tasks $(get_current_mission)
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

Fills array TASK_LIST_OF_TASK with names of all tasks of current mission.

#### Example

```bash
get_all_tasks 1
```

## check_result()

Checks

#### Example

```bash
```

### Arguments

* $1

_Function has no arguments._

### Output on stdout

* Path to something.

