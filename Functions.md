
* [setup()](#setup)
* [get_lessons()](#get_lessons)
* [get_lesson_path()](#get_lesson_path)
* [list_all_lessons()](#list_all_lessons)
* [show_tasks()](#show_tasks)
* [lesson_reset()](#lesson_reset)
* [check_success()](#check_success)
* [get_current_lesson()](#get_current_lesson)
* [set_current_lesson()](#set_current_lesson)
* [input_lesson_number()](#input_lesson_number)
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

## get_lessons()

Gets meta info for each lesson. UNUSED

#### Example

```bash
```

_Function has no arguments._

## get_lesson_path()

Fills $LESSON_PATH with full path to lesson name UNUSED

#### Example

```bash
```

### Arguments

* **$1** (string): lesson-name

## list_all_lessons()

Outputs all lessons with counter(lesson number)

#### Example

```bash
```

_Function has no arguments._

### Output on stdout

* 1 Install and run apache webserver

## show_tasks()

Outputs full info of given lesson

#### Example

```bash
show_tasks lesson_current
```

### Arguments

* **$1** (string): lesson

_Function has no arguments._

### Output on stdout

* Full lesson info. Title + Tasks

## lesson_reset()

Resets solved-status of current lesson+all tasks of lesson.

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

## get_current_lesson()

Returns current lesson from player.ini. Returns $LESSON_CURRENT (String)

#### Example

```bash
```

_Function has no arguments._

## set_current_lesson()

Writes current lesson(string) to player.ini. string=foldername of lesson

#### Example

```bash
set_current_lesson 1
```

### Arguments

* **$1** (int): Lesson number. Output of `ls` stating at 1

## input_lesson_number()

Receives lesson number from terminal input. Returns Lesson number. Doesn't list all lesons.

#### Example

```bash
input_lesson_number
"Please select a lesson [Input number]"
n
"Numbers only"
1
```

_Function has no arguments._

## get_all_tasks()

Fills array $TASK_LIST_OF_TASK with names of all tasks of current lesson.

#### Example

```bash
get_all_tasks 1
```

## input()

Asks player to choose a lesson. Lists lessons, waits for input, saves input as current lesson

#### Example

```bash
```

_Function has no arguments._

### Output on stdout

* lists lessons

## check_result()

Outputs full result with status, points and hints

#### Example

```bash
```

### Arguments

* optional: gamemode (tutor)

### Output on stdout

* Full lesson status

