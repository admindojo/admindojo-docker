#!/usr/bin/env bash
#set -e

# Set font colors
RED="$(printf '\033[1;31m')"
GREEN="$(printf '\033[1;32m')"
NORMAL="$(printf '\033[0m')"

#---------------------------- FUNCTIONS START ------------------------------------------------------------------------------------

# @description Setup. Sets up common variables with paths and filenames
# there
#
# @example setup
#
#
# @noargs
setup() {
    #Filenames
    FOLDER_LESSONS="lessons"
    LESSONS_FILENAME_TASKS="tasks.ini"
    LESSONS_FILENAME_META="meta.ini"

    #Paths
    PROGRAM_FILENAME="$(echo ${0##*/})"
    PROGRAM_PATH_FULL="$(readlink -f "$PROGRAM_FILENAME")"
    PROGRAM_PATH_WORKDIR="$(echo ${0%/*})"
    PROGRAM_PATH_LESSONS="$PROGRAM_PATH_WORKDIR/$FOLDER_LESSONS"
    PLAYER_FILE="$PROGRAM_PATH_WORKDIR/player/player.ini"
}

# @description Gets meta info for each lesson. UNUSED
#
# @example
#

#
# @noargs
get_lessons() {
    #gets all lessons
    for FOLDER in $(ls "$PROGRAM_PATH_LESSONS" ); do

      LESSON_FOLDER=$FOLDER
      #echo $LESSON_FOLDER
      #Get lesson meta
      #"$(crudini --get "$LESSON_PATH/$LESSONS_FILENAME_META" "lesson" "title")"
        LESSON_PATH="$PROGRAM_PATH_LESSONS/$LESSON_FOLDER"
        LESSON_type="$(echo "$LESSON_FOLDER" | cut -d '_' -f1)"
        LESSON_name="$(echo "$LESSON_FOLDER" | cut -d '_' -f2)"
        LESSON_keyword="$(echo "$LESSON_FOLDER" | cut -d '_' -f3)"
        #echo "---"
        #echo $LESSON_FOLDER
        #echo $LESSON_PATH
        #echo $LESSON_name
        #echo $LESSON_type
        #echo $LESSON_keyword
    done
}

# @description Fills $LESSON_PATH with full path to lesson name UNUSED
#
# @example
#
#
#
# @arg $1 string lesson-name
#
get_lesson_path() {

    local LESSON_NAME=$1

    for FOLDER in $(ls "$PROGRAM_PATH_LESSONS" ); do

        LESSON_FOLDER="$FOLDER"
        LESSON_PATH="$PROGRAM_PATH_LESSONS/$LESSON_FOLDER"

        lesson_title="$(crudini --get "$LESSON_PATH/$LESSONS_FILENAME_META" "lesson" "title")"

        if [[ "$lesson_title" == "$LESSON_NAME" ]];then
            LESSON_PATH="$PROGRAM_PATH_LESSONS/$LESSON_FOLDER"
        return 0
        #echo -e "LESSON: $lesson_title"
        fi
     done
return 1
}

# @description Outputs all lessons with counter(lesson number)
#
# @example
#
#
# @noargs
#
#
# @stdout 1 Install and run apache webserver
list_all_lessons() {
    local counter=1

    echo ""
    echo "Available lessons:"
    echo ""
    for FOLDER in $(ls "$PROGRAM_PATH_LESSONS" ); do

        LESSON_FOLDER="$FOLDER"
        LESSON_PATH="$PROGRAM_PATH_LESSONS/$LESSON_FOLDER"

        lesson_title="$(crudini --get "$LESSON_PATH/$LESSONS_FILENAME_META" "lesson" "title")"
        echo -e "\t$counter $lesson_title"

        let "counter++"
     done
}

# @description Outputs full info of given lesson
#
# @example
#   show_tasks lesson_current
#
# @arg $1 string lesson
#
# @noargs
#
# @stdout Full lesson info. Title + Tasks
#
show_tasks() {

    LESSON_FOLDER="$1"
    # Get a fresh array of all tasks in $TASK_LIST_OF_TASK
    get_all_tasks "$LESSON_FOLDER"

    lesson_title="$(crudini --get "$LESSON_PATH/$LESSONS_FILENAME_META" "lesson" "title")"
    lesson_author="$(crudini --get "$LESSON_PATH/$LESSONS_FILENAME_META" "lesson" "author")"
    lesson_website="$(crudini --get "$LESSON_PATH/$LESSONS_FILENAME_META" "lesson" "website")"

    echo ""
    echo "######################################################"
    echo "      Lesson: $lesson_title"
    echo ""
    echo -e "\nby: "$lesson_author""

    if [ -n "$lesson_website" ]; then
        echo -e "\nwebsite: "$lesson_website""
    fi

    #echo -e
    echo "######################################################"
    echo ""
    echo "Your Tasks:"
    echo ""
    #Show for each task
    for task in "${TASK_LIST_OF_TASK[@]}"
    do

        task_title="$(crudini --get "$LESSON_PATH/$LESSONS_FILENAME_TASKS" "$task" "title")"
        task_desc="$(crudini --get "$LESSON_PATH/$LESSONS_FILENAME_TASKS" "$task" "desc")"

        #task - title
        echo ""
        echo -e "⏵ $task_title"

        #task - description
        if [ -n "$task_desc" ]; then
            echo -e "\tDescription: $task_desc"
        fi

        #task - why
        task_why="$(crudini --get "$LESSON_PATH/$LESSONS_FILENAME_TASKS" "$task" "why")"
        if [ -n "$task_why" ]; then
            echo -e "\tWhy: $task_why"
        fi
    done

    echo ""

    lesson_note="$(crudini --get "$LESSON_PATH/$LESSONS_FILENAME_META" "lesson" "note")"
    if [ -n "$lesson_note" ]; then
        echo "Note: $lesson_note"
        echo ""
    fi
    echo ""
}

# @description Resets solved-status of current lesson+all tasks of lesson.
#
# @example lesson_reset
#

# @noargs
#
lesson_reset() {
    # Get a fresh array of all tasks in $TASK_LIST_OF_TASK
    get_all_tasks "$(get_current_lesson)"

    #reset tasks
    for task in "${TASK_LIST_OF_TASK[@]}"
    do
        crudini --set "$LESSON_PATH/$LESSONS_FILENAME_TASKS" "$task" "solved" "false"
    done
    # reset meta
    crudini --set "$LESSON_PATH/$LESSONS_FILENAME_META" "lesson" "solved" "false"
}




# @description Checks task status with help of "cmd" command in task.ini.
#
# @example check_success task1
#
# @exitcode 0 Task solved
# @exitcode 1 Task unsolved

# @arg $1 task
#
check_success() {
    check_task="$1"
    cmd="$(crudini --get "$LESSON_PATH/$LESSONS_FILENAME_TASKS" "$check_task" "cmd")"

    #run the cmd and save exit code
    task_status=$(eval "$cmd")

    # "ok" for if-checks
    # "OK" for http status
    # 0 for exit code
    if [[ "$task_status" == "ok" ]] || [[ "$task_status" = *"OK"* ]] || [[ "$task_status" == "0" ]]; then
            #echo "ok"
            return 0
        else
            #echo "fail"
            return 1
        fi
}

# @description Returns current lesson from player.ini. Returns $LESSON_CURRENT (String)
#
# @example get_all_tasks $(get_current_lesson)
#
# @noargs
get_current_lesson() {
    LESSON_CURRENT="$(crudini --get "$PLAYER_FILE" "player" "lesson_current")"
    echo "$LESSON_CURRENT"
}

# @description Writes current lesson(string) to player.ini. string=foldername of lesson
#
# @example
#   set_current_lesson 1
#
# @arg $1 int Lesson number. Output of `ls` stating at 1
set_current_lesson() {

    local LESSON_NUMBER="$1"
    local counter=1

    for FOLDER in $(ls "$PROGRAM_PATH_LESSONS" ); do
        if [[ "$LESSON_NUMBER" == "$counter"  ]];then
                crudini --set "$PLAYER_FILE" "player" "lesson_current" "$FOLDER"
         return 0
        fi

        let "counter++"
     done
return 1
}

# @description Receives lesson number from terminal input. Returns Lesson number. Doesn't list all lesons.
#
# @example
#   input_lesson_number
#   "Please select a lesson [Input number]"
#   n
#   "Numbers only"
#   1
#
# @noargs
input_lesson_number() {

    echo -e "Please select a lesson [Input number]: "

    read LESSON_CURRENT_NUMBER
        while [[ "$LESSON_CURRENT_NUMBER" -lt 0 || "$LESSON_CURRENT_NUMBER" -gt 9999 ]]; do
            echo "Please input numbers only"
            read LESSON_CURRENT_NUMBER
        done
    return "$LESSON_CURRENT_NUMBER"
}

# @description Fills array $TASK_LIST_OF_TASK with names of all tasks of current lesson.
#
# @example
#   get_all_tasks 1
#
# @ int lesson number. Output of `ls` stating at 1
#
get_all_tasks() {

    LESSON_FOLDER=$1
    LESSON_PATH=$PROGRAM_PATH_LESSONS/$LESSON_FOLDER

    tasks="$(eval crudini --get "$LESSON_PATH/$LESSONS_FILENAME_TASKS" | tr '\n' ' ')"

    IFS=' ' read -r -a TASK_LIST_OF_TASK <<< "$tasks"

    return 0
}

# @description Asks player to choose a lesson. Lists lessons, waits for input, saves input as current lesson
#
# @example input
#
# @noargs
#
#
# @stdout lists lessons
input() {
    list_all_lessons

    input_lesson_number
    lesson_number="$?"

    set_current_lesson "$lesson_number"
}

# @description Outputs full result with status, points and hints
#
# @example
#
#
# @arg optional: gamemode (tutor)
#
#
# @stdout Full lesson status
check_result() {

    #optional. for tutor mode only
    gamemode="$1"

    # Get a fresh array of all tasks in $TASK_LIST_OF_TASK
    get_all_tasks "$(get_current_lesson)"

    lesson_title="$(crudini --get "$LESSON_PATH/$LESSONS_FILENAME_META" "lesson" "title")"
    echo ""
    echo "Lesson: $lesson_title"
    echo ""
    echo "Your result:"
    echo ""

    #reset score
    result_points_total=""
    result_points_got=""

    #Check each task
    for task in "${TASK_LIST_OF_TASK[@]}"
    do
        #Get points for task
        task_points="$(crudini --get "$LESSON_PATH/$LESSONS_FILENAME_TASKS" "$task" "points")"
        result_points_total=$(( $result_points_total + $task_points ))
        task_title="$(crudini --get "$LESSON_PATH/$LESSONS_FILENAME_TASKS" "$task" "title")"

        #check with if task is done
        check_success "$task"
        STATUS=$?

        if [ "$STATUS" == 0 ]; then
            echo -e "⏵ $task_title\t${GREEN}   solved ✔${NORMAL}"

            result_points_got=$(( $result_points_got + $task_points ))

            task_hintnext="$(crudini --get "$LESSON_PATH/$LESSONS_FILENAME_TASKS" "$task" "hintnext")"
        else
            echo -e "⏵ $task_title\t${RED} unsolved ✘${NORMAL}"

            if [[ "$gamemode" != "tutor" ]]; then
                hint="$(crudini --get "$LESSON_PATH/$LESSONS_FILENAME_TASKS" "$task" "hint")"
                if [ -n "$hint" ]; then
                    echo -e "🔎Hint: \t $hint"
                fi
            fi
            echo -e ""
        fi
        echo -e "  Points:\t\t\t\t  "$task_points""
        echo "-------------------------"
    done

    echo ""
    echo -e "  Total Points:\t\t\t          $result_points_total"
    echo -e "  Your Points :\t\t\t          $result_points_got"
    echo ""

    if [ ! "$gamemode" == "tutor" ] && [[ "$result_points_got" == "$result_points_total" ]];then
            #if all solved and gamode != tutor
            echo ""
            echo "You solved all tasks!"
            echo ""
            echo "Lesson complete"
            sleep 2

            #mark lesson as solved
            echo ""
            crudini --set "$LESSON_PATH/$LESSONS_FILENAME_META" "lesson" "solved" "true"
            echo "Lesson marked as solved"
            echo ""
            echo ""
            exit 0
    else
         if [ "$gamemode" == "tutor" ] && [ ! "$task_hintnext" == "" ]; then
            #Show tutor hint if existing
            echo ""
            echo "🔎 $task_hintnext"
            echo ""
         fi
    fi
    echo ""
}

#---------------------------- FUNCTIONS END ------------------------------------------------------------------------------------



# refresh filesnames and paths in any case
setup


# Show help
if [ "$1" == "help" ] || [ "$1" == "-?" ] || [ "$1" == "--help" ] || [ "$1" == "" ]; then
echo ""
echo " admindojo"
echo ""
echo " Start the Training"
echo "    admindojo list   (list available lesson)"
echo "    admindojo start   (list, select and start lesson)"
echo ""
echo " In-game control"
echo "    admindojo tasks   (show tasks)"
echo "    admindojo end     (end game, show result)"
echo ""
echo " Tutor mode:"
echo " Guides you through your lesson. Checks every minute if you solved a task and shows hints."
echo "    admindojo tutor   (start tutor)"
echo ""
echo ""
    exit 0
fi



# List all available lessons
if [ "$1" == "lessons" ]; then
    list_all_lessons
    exit 0
fi

# List all current tasks
if [ "$1" == "tasks" ]; then
    LESSON_FOLDER="$(crudini --get "$PLAYER_FILE" "player" "lesson_current")"
    show_tasks "$LESSON_FOLDER"
    exit 0
fi


if [ "$1" == "start" ]; then
    input
    show_tasks "$(get_current_lesson)"
    exit $?
fi

if [ "$1" == "end" ]; then
    check_result
    exit 0
fi


if [ "$1" == "tutor" ]; then
    echo "Starting tutor"
    echo "The tutor checks every minute for solved tasks and provides hints."
    echo ""
    source ./helper.sh
    #Thanks:
    #https://unix.stackexchange.com/questions/163793/start-a-background-process-from-a-script-and-manage-it-when-the-script-ends
    background_helper &
    # Storing the background process' PID.
    bg_pid=$!

    # To kill helper manually use PID from player.ini and "kill -15 PID"
    # Trapping SIGKILLs so we can send them back to $bg_pid.
    trap "kill -15 $bg_pid" 2 15

    crudini --set "$PLAYER_FILE" "local" "helper_pid" "$bg_pid"
    #echo "PID: $bg_pid"

    show_tasks $(get_current_lesson)
fi




# ------ advanced/not for user

# reset status of current lesson
if [ "$1" == "reset" ]; then
    lesson_reset
    exit 0
fi



# To invoke testing only! NOT FOR GAMEPLAY
if [ "$1" == "testing" ]; then
    set -e # Exit with nonzero exit code if anything fails

    echo ""
    echo "------------------   TEST START   ------------------"
    echo ""
    echo "------------------   SETUP START  ------------------"
    setup
    echo "------------------   SETUP DONE   ------------------"
    source $PROGRAM_PATH_WORKDIR/tests/requirements.sh
    source $PROGRAM_PATH_WORKDIR/tests/test.sh
    echo ""
    echo "------------------   TEST END    ------------------"
    echo ""
fi