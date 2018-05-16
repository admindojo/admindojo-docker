#!/usr/bin/env bash
#set -e


#requirement
#curl
#wget

#setup


# Font colors
RED="$(printf '\033[1;31m')"
GREEN="$(printf '\033[1;32m')"
NORMAL="$(printf '\033[0m')"


# @description Setup. Sets up common variables with paths and filenames
# there
#
# @example setup
#
#
# @noargs
setup() {
    FOLDER_LESSONS="lessons"
    LESSONS_FILENAME_TASKS="tasks.ini"
    LESSONS_FILENAME_META="meta.ini"

    PROGRAM_FILENAME="$(echo ${0##*/})"
    PROGRAM_PATH_FULL="$(readlink -f "$PROGRAM_FILENAME")"
    PROGRAM_PATH_WORKDIR="$(echo ${0%/*})"
    #echo $PROGRAM_PATH_WORKDIR
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

# @description Outputs full info of lesson
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
    # Get a fresh array of all tasks in $TASK_LIST_OF_TASK

    LESSON_FOLDER="$1"

    get_all_tasks "$LESSON_FOLDER"


    lesson_title="$(crudini --get "$LESSON_PATH/$LESSONS_FILENAME_META" "lesson" "title")"

    lesson_author="$(crudini --get "$LESSON_PATH/$LESSONS_FILENAME_META" "lesson" "author")"
    lesson_website="$(crudini --get "$LESSON_PATH/$LESSONS_FILENAME_META" "lesson" "website")"

    echo ""
    echo "######################################################"
    echo "      Lesson: $lesson_title"
    echo ""
    echo -e "         by: "$lesson_author" url: "$lesson_website""
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

        echo ""
        #echo "-----------"
        echo -e "⏵ $task_title"

        if [ -n "$task_desc" ]; then
            echo -e "\tDescription: $task_desc"
        fi

        why="$(crudini --get "$LESSON_PATH/$LESSONS_FILENAME_TASKS" "$task" "why")"
        if [ -n "$why" ]; then
            echo -e "\tWhy: $why"
        fi


    done

    echo ""
    lesson_note="$(crudini --get "$LESSON_PATH/$LESSONS_FILENAME_META" "lesson" "title")"

    echo "Note: $lesson_note"
    echo ""
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

    #Check each task
    for task in "${TASK_LIST_OF_TASK[@]}"
    do
        crudini --set "$LESSON_PATH/$LESSONS_FILENAME_TASKS" "$task" "solved" "false"
        crudini --set "$LESSON_PATH/$LESSONS_FILENAME_META" "lesson" "solved" "false"
    done

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
    task_title="$(crudini --get "$LESSON_PATH/$LESSONS_FILENAME_TASKS" "$check_task" "title")"
    #echo "$desc:"

    task_status=$(eval "$cmd")
    #echo $cmd
    #echo $task_status


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

# @description Returns current lesson from player.ini. Returns $LESSON_CURRENT
#
# @example get_all_tasks $(get_current_lesson)
#
# @noargs
get_current_lesson() {
    LESSON_CURRENT="$(crudini --get "$PLAYER_FILE" "player" "lesson_current")"
    echo "$LESSON_CURRENT"
}

# @description Writes current lesson to player.ini. Writes foldername of lesson.
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

# @description Receives lesson number from terminal input. Returns Lesson number
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
            echo "Numbers only"
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

# @description Asks player to choose a lesson. Lists lessons and waits for input.
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

    #lesson_status=$(crudini --get "$LESSON_PATH/$LESSONS_FILENAME_META" "lesson" "solved")
    #echo "$lesson_status"

    set_current_lesson "$lesson_number"

}

# @description Outputs full Result with status, points and hints
#
# @example
#
#
# @noargs
#
#
# @stdout Full lesson status
check_result() {

    gamemode="$1"

    #get_current_lesson

    # Get a fresh array of all tasks in $TASK_LIST_OF_TASK
    get_all_tasks "$(get_current_lesson)"


    lesson_title="$(crudini --get "$LESSON_PATH/$LESSONS_FILENAME_META" "lesson" "title")"
    echo ""
    echo "Lesson: $lesson_title"
    echo ""
    echo "Your Result:"

    result_points_total=""
    result_points_got=""

    #Check each task
    for task in "${TASK_LIST_OF_TASK[@]}"
    do

        #Get points for task
        task_points="$(crudini --get "$LESSON_PATH/$LESSONS_FILENAME_TASKS" "$task" "points")"
        result_points_total=$(( $result_points_total + $task_points ))
        task_title="$(crudini --get "$LESSON_PATH/$LESSONS_FILENAME_TASKS" "$task" "title")"
        check_success "$task"
        STATUS=$?
        #echo ""
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
        #echo ""
        echo -e "  Points:\t\t\t\t  "$task_points""
        echo "-------------------------"

    done

    echo ""
    echo -e "  Total Points:\t\t\t          $result_points_total"
    echo -e "  Your Points :\t\t\t          $result_points_got"
    echo ""



    if [ ! "$gamemode" == "tutor" ] && [[ "$result_points_got" == "$result_points_total" ]];then
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
            echo ""
            echo "🔎 $task_hintnext"
            echo ""
         fi

    fi
    echo ""

}




setup








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

if [ "$1" == "tasks" ]; then
    LESSON_FOLDER="$(crudini --get "$PLAYER_FILE" "player" "lesson_current")"
    show_tasks "$LESSON_FOLDER"
    exit 0
fi

if [ "$1" == "lessons" ]; then
    list_all_lessons
    exit 0
fi

if [ "$1" == "help" ] || [ "$1" == "-?" ] || [ "$1" == "--help" ] || [ "$1" == "" ]; then


echo " admindojo"
echo ""
echo " Start the Training"
echo "    start   (list, select and start lesson)"
echo ""
echo " In-game control"
echo "    tasks   (show tasks)"
echo "    end     (end game, show result)"
echo ""
echo " Tutor mode:"
echo " Guides you through your lesson. Checks every minute if you solved a task and shows hints."
echo "    tutor   (start tutor)"
echo ""
echo ""

#    echo -e "\n\n\n"
#    echo ""
#    echo -e "admingame lessons: Lists available lessons.\n"
#    echo -e "admingame start: Lists lessons, let you choose a lesson and starts the game.\n"
#    echo -e "admingame tasks: Lists all tasks.\n"
#    echo -e "admingame end: Checks your work and shows the result.\n"
#    echo -e "admingame tutor: Starts the game in tutor mode. Checks every minute if you solved a task and shows hints.\n"
#    echo ""
#
#    echo ""
#    echo -e "Lists available lessonsadmingame lessons\n"
#    echo -e "Lists lessons, let you choose a lesson and starts the game_ admingame start: \n"
#    echo -e "Lists all tasks: admingame tasks: \n"
#    echo -e "Checks your work and shows the result.: admingame end: \n"
#    echo -e ": admingame tutor: \n"
#    echo ""

    exit 0
fi

if [ "$1" == "reset" ]; then
    lesson_reset
    exit 0
fi

if [ "$1" == "end" ]; then
    check_result
    exit 0
fi

if [ "$1" == "start" ]; then
    input
    show_tasks "$(get_current_lesson)"
    exit $?
fi

if [ "$1" == "tutor" ]; then
    echo "Starting tutor"
    echo "The tutor checks every minute for solved tasks and provides hints."
    echo ""
    source ./helper.sh

    background_helper &
    # Storing the background process' PID.
    bg_pid=$!

    # Trapping SIGKILLs so we can send them back to $bg_pid.
    trap "kill -15 $bg_pid" 2 15

    crudini --set "$PLAYER_FILE" "local" "helper_pid" "$bg_pid"
    #echo "PID: $bg_pid"

    #echo ""
    show_tasks $(get_current_lesson)

fi