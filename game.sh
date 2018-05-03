#!/usr/bin/env bash
#

#We use http://ipecho.net/ for descovering the external ip of your server
#requirement
#curl
#wget

#setup


# Font colors
RED="$(printf '\033[1;31m')"
GREEN="$(printf '\033[1;32m')"
NORMAL="$(printf '\033[0m')"


# @description Multiline description goes here and
# there
#
# @example
#   some:other:func a b c
#   echo 123
#
#
# @noargs
setup() {
    FOLDER_MISSIONS="missions"
    MISSIONS_FILENAME_TASKS="tasks.ini"
    MISSIONS_FILENAME_META="meta.ini"

    PROGRAM_FILENAME="$(echo ${0##*/})"
    PROGRAM_PATH_FULL="$(readlink -f "$PROGRAM_FILENAME")"
    PROGRAM_PATH_WORKDIR="$(echo ${0%/*})"
    #echo $PROGRAM_PATH_WORKDIR
    PROGRAM_PATH_MISSIONS="$PROGRAM_PATH_WORKDIR/$FOLDER_MISSIONS"
    PLAYER_FILE="$PROGRAM_PATH_WORKDIR/player/player.ini"
}

# @description
#
# @example
#
#
#
# @arg $1
#
# @noargs
#
#
# @stdout Path to something.
get_missions() {
    #gets all missions
    for FOLDER in $(ls "$PROGRAM_PATH_MISSIONS" ); do

      MISSION_FOLDER=$FOLDER
      #echo $MISSION_FOLDER
      #Get mission meta
      #"$(crudini --get "$MISSION_PATH/$MISSIONS_FILENAME_META" "mission" "title")"
        MISSION_PATH="$PROGRAM_PATH_MISSIONS/$MISSION_FOLDER"
        MISSION_type="$(echo $MISSION_FOLDER | cut -d '_' -f1)"
        MISSION_name="$(echo $MISSION_FOLDER | cut -d '_' -f2)"
        MISSION_keyword="$(echo $MISSION_FOLDER | cut -d '_' -f3)"
        #echo "---"
        #echo $MISSION_FOLDER
        #echo $MISSION_PATH
        #echo $MISSION_name
        #echo $MISSION_type
        #echo $MISSION_keyword
    done
}

# @description
#
# @example
#
#
#
# @arg $1
#
# @noargs
#
#
# @stdout Path to something.
get_mission_path() {

    local MISSION_NAME=$1

    for FOLDER in $(ls $PROGRAM_PATH_MISSIONS ); do

        MISSION_FOLDER="$FOLDER"
        MISSION_PATH="$PROGRAM_PATH_MISSIONS/$MISSION_FOLDER"

        mission_title="$(crudini --get "$MISSION_PATH/$MISSIONS_FILENAME_META" "mission" "title")"

        if [[ "$mission_title" == "$MISSION_NAME" ]];then
            MISSION_PATH="$PROGRAM_PATH_MISSIONS/$MISSION_FOLDER"
        return 0
        #echo -e "MISSION: $mission_title"
        fi
     done
return 1
}

# @description
#
# @example
#
#
#
# @arg $1
#
# @noargs
#
#
# @stdout Path to something.
list_all_missions() {
    local counter=1

    echo ""
    echo "Missions:"
    echo ""
    for FOLDER in $(ls $PROGRAM_PATH_MISSIONS ); do

        MISSION_FOLDER="$FOLDER"
        MISSION_PATH="$PROGRAM_PATH_MISSIONS/$MISSION_FOLDER"

        mission_title="$(crudini --get "$MISSION_PATH/$MISSIONS_FILENAME_META" "mission" "title")"
        echo -e "\t$counter $mission_title"

        let "counter++"
     done
}

# @description Outputs full info for the current mission.
# Currently outputs last mission. not current mission
#
# @example
#   show_tasks mission_current
#
# @arg $1 string mission
#
# @noargs
#
# @stdout Full mission info. Title + Tasks
#
show_tasks() {
    # Get a fresh array of all tasks in $TASK_LIST_OF_TASK

    MISSION_FOLDER="$1"

    get_all_tasks "$MISSION_FOLDER"


    mission_title="$(crudini --get "$MISSION_PATH/$MISSIONS_FILENAME_META" "mission" "title")"
    echo ""
    echo "Mission: $mission_title"
    echo ""
    echo "Your Tasks:"
    echo ""
    #Show for each task
    for task in "${TASK_LIST_OF_TASK[@]}"
    do

        task_title="$(crudini --get "$MISSION_PATH/$MISSIONS_FILENAME_TASKS" "$task" "title")"
        task_desc="$(crudini --get "$MISSION_PATH/$MISSIONS_FILENAME_TASKS" "$task" "desc")"

        echo "-----------"
        echo -e "$task_title"

        if [ -n "$task_desc" ]; then
            echo -e "\tDescription: $task_desc"
        fi

        why="$(crudini --get "$MISSION_PATH/$MISSIONS_FILENAME_TASKS" "$task" "why")"
        if [ -n "$why" ]; then
            echo -e "\tWhy: $why"
        fi


    done

    echo ""
    echo ""
}


mission_reset() {
    # Get a fresh array of all tasks in $TASK_LIST_OF_TASK
    get_all_tasks "$(get_current_mission)"

    #Check each task
    for task in "${TASK_LIST_OF_TASK[@]}"
    do
        task_solved="$(crudini --set "$MISSION_PATH/$MISSIONS_FILENAME_TASKS" "$task" "solved" "false")"
    done

}




# @description
#
# @example
#
#
#
# @arg $1
#
# @noargs
#
#
# @stdout Path to something.
check_success() {
    check_task="$1"
    cmd="$(crudini --get "$MISSION_PATH/$MISSIONS_FILENAME_TASKS" "$check_task" "cmd")"
    task_title="$(crudini --get "$MISSION_PATH/$MISSIONS_FILENAME_TASKS" "$check_task" "title")"
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


mark_task_solved() {
    task="$1"

    get_mission_path $(get_current_mission)

    crudini --set "$MISSION_PATH/$MISSIONS_FILENAME_TASKS" "$task" "solved" "true"

}

# @description Returns current mission from player.ini. Returns MISSION_CURRENT
#
# @example
#   get_all_tasks $(get_current_mission)
#
# @noargs
get_current_mission() {
    MISSION_CURRENT="$(crudini --get "$PLAYER_FILE" "player" "mission_current")"
    echo "$MISSION_CURRENT"
}

# @description Writes current mission to player.ini. Writes foldername of mission.
#
# @example
#   set_current_mission 1
#
# @arg $1 int Mission number. Output of `ls` stating at 1
set_current_mission() {

    local MISSION_NUMBER="$1"
    local counter=1

    for FOLDER in $(ls "$PROGRAM_PATH_MISSIONS" ); do

        if [[ "$MISSION_NUMBER" == "$counter"  ]];then
                crudini --set "$PLAYER_FILE" "player" "mission_current" "$FOLDER"
         return 0
        fi

        let "counter++"
     done
return 1
}

# @description Receives mission number from terminal input. Returns Mission number
#
# @example
#   input_mission_number
#   "Please select a mission [Input number]"
#   n
#   "Numbers only"
#   1
#
# @noargs
input_mission_number() {

    echo -e "Please select a mission [Input number]: "

    read MISSION_CURRENT_NUMBER
        while [[ "$MISSION_CURRENT_NUMBE" -lt 0 || "$MISSION_CURRENT_NUMBER" -gt 9999 ]]; do
            echo "Numbers only"
            read MISSION_CURRENT_NUMBER
        done
    return "$MISSION_CURRENT_NUMBER"
}

# @description Fills array TASK_LIST_OF_TASK with names of all tasks of current mission.
#
# @example
#   get_all_tasks 1
#
# @ int Mission number. Output of `ls` stating at 1
#
get_all_tasks() {

    MISSION_FOLDER=$1

    MISSION_PATH=$PROGRAM_PATH_MISSIONS/$MISSION_FOLDER

    tasks="$(eval crudini --get "$MISSION_PATH/$MISSIONS_FILENAME_TASKS" | tr '\n' ' ')"

    IFS=' ' read -r -a TASK_LIST_OF_TASK <<< "$tasks"

    return 0
}

# @description Outputs full Result with status, points and hints
#
# @example
#
#
#
# @arg $1
#
# @noargs
#
#
# @stdout Path to something.
check_result() {

    #get_current_mission

    # Get a fresh array of all tasks in $TASK_LIST_OF_TASK
    get_all_tasks "$(get_current_mission)"


    mission_title="$(crudini --get "$MISSION_PATH/$MISSIONS_FILENAME_META" "mission" "title")"
    echo ""
    echo "Mission: $mission_title"
    echo ""
    echo "Your Result:"

    result_points_total=""
    result_points_got=""

    #Check each task
    for task in "${TASK_LIST_OF_TASK[@]}"
    do

        #Get points for task
        task_points="$(crudini --get "$MISSION_PATH/$MISSIONS_FILENAME_TASKS" "$task" "points")"
        result_points_total=$(( $result_points_total + $task_points ))
        task_title="$(crudini --get "$MISSION_PATH/$MISSIONS_FILENAME_TASKS" "$task" "title")"
        check_success "$task"
        STATUS=$?
        #echo ""
        if [ "$STATUS" == 0 ]; then

            echo -e "$task_title\t${GREEN}solved ${NORMAL}"



            result_points_got=$(( $result_points_got + $task_points ))


        else
            echo -e "$task_title\t${RED}failed ${NORMAL}"

            hint="$(crudini --get "$MISSION_PATH/$MISSIONS_FILENAME_TASKS" "$task" "hint")"
            if [ -n "$hint" ]; then
                echo -e "Hint: \t $hint"
            fi


            #echo -e ""
        fi
        #echo ""
        echo -e "Points: \t\t\t     $task_points"
        echo "-------------------------"

    done

    echo ""
    echo -e "Total Points:\t\t\t    $result_points_total"
    echo -e "Your Points :\t\t\t    $result_points_got"
    echo ""




}




setup






if [ "$1" == "check" ]; then
    check_result
    exit 0
fi

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

    exit $?
fi

if [ "$1" == "show" ]; then
    MISSION_FOLDER="$(crudini --get "$PLAYER_FILE" "player" "mission_current")"
    show_tasks "$MISSION_FOLDER"
    exit 0
fi

if [ "$1" == "list" ]; then
    list_all_missions
    exit 0
fi

if [ "$1" == "reset" ]; then
    mission_reset
    exit 0
fi