# Initial vision of admindojo
## Story
### Target group
A user who want's to try a new software by using a tutorial or wants to become familiar with Linux itself.
### Usage
- git clone or download
- run install (prepare system)
- all missions are listed (list missions)
- user selects lesson:
    - select lesson
    - save lesson (save current lesson to file)
- lesson tasks are listed
- end:
    - user invokes end (command lesson end)
    - program checks itself (helper that checks all lesson tasks continuously)
    - lesson gets checked ()
- check: 
    - check each task (check task)
    - get points (calculate points)
    - list result (list result)
    - give hints on unsolved tasks (prepare hints in file)
    - save task result (save result to file)
    - 
- extra:
- reset lesson status (reset all tasks)

# mockup files
## lessons
one lesson per folder: type_name_category

example: `apache_install-apache_webserver`
### folder structure
mandatory:
- tasks.ini
- meta.ini

optional:
- directory `tests` with seperate test-scripts
### tasks.ini
One task per section
Each task should be solvable within 1-2 commands or one file manipulation
The tasks order should be based on the order 
```
[task%NUMBER%]
title = (mandatory) A brief task description
desc= (mandatory) A description on how to solve this task
why = (optional) A description on why this is task is important
cmd = (mandatory) A series of bash commands to check wether this task is solved or not.
       Must returne/echo 0, "ok" or "OK" when solved
       Can be multiline according to the ini-format. Use <tab> to indent multiline commands.
points = (mandatory) ( 1 | 2 | 3 ) Points for this task based on difficulty easy | mid | hard
hint = (optional) run apache2ctl
test = (optional) A series of bash commands to solve this task. This is used to auto-test the lesson.
        A filename for a seperate script in the /tests directory is ok too.
status = (mandatory) ( solved | unsolved ) current task status
```
example:
```
[task4]
title = Install apache webserver
desc= Install apache webserver with apt get
why = 
cmd = (mandatory) A series of bash commands to check wether this task is solved or not.
       Must returne/echo 0, "ok" or "OK" when solved
       Can be multiline according to the ini-format. Use <tab> to indent multiline commands.
points = (mandatory) ( 1 | 2 | 3 ) Points for this task based on difficulty easy | mid | hard
hint = (optional) run apache2ctl
test = (optional) A series of bash commands to solve this task. This is used to auto-test the lesson.
        A filename for a seperate script in the /tests directory is ok too.
status = (mandatory) ( solved | unsolved ) current task status
```
### meta.ini
```
[lesson]
title = (mandatory) Install and run apache webserver
status = (mandatory) ( solved | unsolved ) current lesson status. solved = 100% tasks solved
author = (optional) Initial Author
website = (optional) URL for additional lesson info
note = (optional) Extra notes e.g. required software, 'this lesson requires internet access'
```

## links
- https://google.github.io/styleguide/shell.xml#Function_Names
- https://github.com/reconquest/shdoc
- https://github.com/reconquest/tests.sh


- https://robots.thoughtbot.com/shell-script-suggestions-for-speedy-setups
- https://dev.to/thiht/shell-scripts-matter
- https://github.com/kward/shunit2


## nice to have
- Error output (google syle)
>STDOUT vs STDERR
link ▽ All error messages should go to STDERR.
This makes it easier to separate normal status from actual issues.
A function to print out error messages along with other status information is recommended.
```
err() {
  echo "[$(date +'%Y-%m-%dT%H:%M:%S%z')]: $@" >&2
}

if ! do_something; then
  err "Unable to do_something"
  exit "${E_DID_NOTHING}"
fi
```