#!/usr/bin/env bash
#
test='if [ -e "/usr/sbin/apache2" ]; then
echo "ok" return 0;
else echo "fail" return 1;
fi'
#eval $test


#We use http://ipecho.net/ for descovering the external ip of your server
#requirement
#curl
#wget

#setup
result_points_total=""
result_points_got=""


RED="$(printf '\033[1;31m')"
GREEN="$(printf '\033[1;32m')"
NORMAL="$(printf '\033[0m')"


FOLDER_MISSIONS="missions"

MISSIONS_FILENAME_TASKS="tasks.ini"
MISSIONS_FILENAME_META="meta.ini"




# @description Multiline description goes here and
# there
#
# @example
#   some:other:func a b c
#   echo 123
#
#
# @noargs
setup (){

PROGRAM_FILENAME="$(echo ${0##*/})"
PROGRAM_PATH_FULL="$(readlink -f "$PROGRAM_FILENAME")"
PROGRAM_PATH_WORKDIR="$(echo ${0%/*})"
#echo $PROGRAM_PATH_WORKDIR
PROGRAM_PATH_MISSIONS="$PROGRAM_PATH_WORKDIR/$FOLDER_MISSIONS"
#echo $PROGRAM_PATH_MISSIONS
}

get_missions(){

#gets all missions
for FOLDER in $(ls $PROGRAM_PATH_MISSIONS ); do

  MISSION_FOLDER=$(echo $FOLDER )
  #echo $MISSION_FOLDER
  #Get mission meta
  #"$(crudini --get "$MISSION_PATH/$MISSIONS_FILENAME_META" "mission" "title")"
    MISSION_PATH=$PROGRAM_PATH_MISSIONS/$MISSION_FOLDER
    MISSION_type=$(echo $MISSION_FOLDER | cut -d '_' -f1)
    MISSION_name=$(echo $MISSION_FOLDER | cut -d '_' -f2)
    MISSION_keyword=$(echo $MISSION_FOLDER | cut -d '_' -f3)
    #echo "---"
    #echo $MISSION_FOLDER
    #echo $MISSION_PATH
    #echo $MISSION_name
    #echo $MISSION_type
    #echo $MISSION_keyword


done



}





# @description Outputs full info for the current mission.
# Currently outputs last mission. not current mission
#
# @example
#   show_tasks mission_current
#
# @arg $1 string mission (Not implemented!)
#
# @noargs
#
# @stdout Full mission info. Title + Tasks
#
show_tasks(){
    # Get a fresh array of all tasks in $TASK_LIST_OF_TASK
    get_all_tasks


    mission_title="$(crudini --get "$MISSION_PATH/$MISSIONS_FILENAME_META" "mission" "title")"
    echo ""
    echo "Mission: $mission_title"
    echo ""
    echo "Your Tasks:"
    #Show for each task
    for task in "${TASK_LIST_OF_TASK[@]}"
    do

        task_title="$(crudini --get "$MISSION_PATH/$MISSIONS_FILENAME_TASKS" "$task" "title")"
        task_desc="$(crudini --get "$MISSION_PATH/$MISSIONS_FILENAME_TASKS" "$task" "desc")"

        echo "-----------"
        echo -e "$task_title"

        if [ -n "$task_desc" ]; then
            echo -e "\t$task_desc"
        fi




    done

    echo ""
    echo ""

}


check_success(){
    check_task=$1
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


#get all tasks from ini
get_all_tasks(){
    tasks="$(eval crudini --get "$MISSION_PATH/$MISSIONS_FILENAME_TASKS" | tr '\n' ' ')"

    IFS=' ' read -r -a TASK_LIST_OF_TASK <<< "$tasks"

    #echo "ausgabe list_of_tasks:"

    #for task in "${list_of_tasks[@]}"
    #do
    #    echo "$task"
    #done

    return 0
}


check_result(){
    # Get a fresh array of all tasks in $TASK_LIST_OF_TASK
    get_all_tasks


    mission_title="$(crudini --get "$MISSION_PATH/$MISSIONS_FILENAME_META" "mission" "title")"
    echo ""
    echo "Mission: $mission_title"
    echo ""
    echo "Your Result:"
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


if [ "$1" == "check" ]; then
    check_result
    exit 0
fi

if [ "$1" == "testing" ]; then
    echo ""
    echo "Start testing"
    setup
    echo "workdir: $PROGRAM_PATH_WORKDIR"
    #source $PROGRAM_PATH_WORKDIR/tests/requirements.sh
    source $PROGRAM_PATH_WORKDIR/tests/test.sh
    exit 0
fi

if [ "$1" == "show" ]; then
get_missions
    show_tasks
    exit 0
fi

if [ "$1" == "mission" ]; then
    get_missions
    exit 0
fi