#!/usr/bin/env bash
#set -e

source game.sh
setup




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
input() {
    list_all_missions

    input_mission_number
    mission_number="$?"

    #mission_status=$(crudini --get "$MISSION_PATH/$MISSIONS_FILENAME_META" "mission" "solved")
    #echo "$mission_status"

    set_current_mission "$mission_number"

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
check_live() {
    # Get a fresh array of all tasks in $TASK_LIST_OF_TASK
    get_all_tasks "$(get_current_mission)"


    mission_title="$(crudini --get "$MISSION_PATH/$MISSIONS_FILENAME_META" "mission" "title")"
    #echo "Mission: $mission_title"

    result_points_total=""
    result_points_got=""

    tasks_total=0
    tasks_done=0
    tasks_undone=0
    task_done_in_run=0

    local task_counter=0

    #Check each task
    for task in "${TASK_LIST_OF_TASK[@]}"
    do


        check_success "$task"
        STATUS=$?
        #echo ""

        let "task_counter++"

        task_solved="$(crudini --get "$MISSION_PATH/$MISSIONS_FILENAME_TASKS" "$task" "solved")"
        if [ "$task_solved" == "false" ] || [ "$task_solved" == "" ];then




            if [ "$STATUS" == 0 ]; then
                if [[ "$task_done_in_run" == "0" ]];then
                    echo ""
                    echo -e "${GREEN}You just solved:${NORMAL}"
                fi
                echo "test"
                #mark task as solved in mission-file
                #mark_task_solved "$task"
                crudini --set "$MISSION_PATH/$MISSIONS_FILENAME_TASKS" "$task" "solved" "true"

                #Get points for task
                task_points="$(crudini --get "$MISSION_PATH/$MISSIONS_FILENAME_TASKS" "$task" "points")"
                result_points_total=$(( $result_points_total + $task_points ))

                task_title="$(crudini --get "$MISSION_PATH/$MISSIONS_FILENAME_TASKS" "$task" "title")"

                result_points_got=$(( $result_points_got + $task_points ))
                echo -e "${GREEN}\t\t$task_title! + $task_points Points${NORMAL}"
                let "tasks_done++"
                task_done_in_run=1


            fi


         else
            let "tasks_done++"
         fi
    let "tasks_total++"


    done

    #
    if [[ "$tasks_done" == "$tasks_total" ]];then
        echo ""
        echo "You solved all tasks!"
        echo ""
        echo "Mission complete"
        sleep 2
        check_result

        #mark mission as solved
        echo ""
        crudini --set "$MISSION_PATH/$MISSIONS_FILENAME_META" "mission" "solved" "true"
        echo "Mission marked as solved"
        echo ""
        echo "Hit [enter]"
        echo ""
        exit 0
    else
        if [[ "$task_done_in_run" == "1" ]];then
            echo "Tasks done: $tasks_done/$tasks_total"
            echo ""
        fi
    fi

    #echo "Tasks total: $tasks_total"
    #echo "Tasks done: $tasks_done"
    #echo "Tasks undone: $tasks_undone"
}




#TEST BACKGRUND HELPER
# Runs background when mission is started. Should check the task-status periodically. Notifies user when a task is completed.
#
background_helper(){
    while [ true ]
    do
        #check every minute
        sleep 10
        check_live

    #    if [[ -d /home/marvin/check ]];then
    #        echo "da"
    #        exit 0
    #    else
    #        echo "nicht da"
    #    fi
    done
}








if [ "$1" == "live" ]; then
    check_live
    exit 0
fi

if [ "$1" == "input" ]; then
    input
    exit $?
fi

if [ "$1" == "start" ]; then
    echo "Starting background helper"
    echo "Helper checkes every minute for solved tasks"
    echo ""
    background_helper &
    # Storing the background process' PID.
    bg_pid=$!

    # Trapping SIGKILLs so we can send them back to $bg_pid.
    trap "kill -15 $bg_pid" 2 15

    crudini --set "$PLAYER_FILE" "local" "helper_pid" "$bg_pid"
    #echo "PID: $bg_pid"

    #echo ""
    show_tasks $(get_current_mission)

fi


#Thanks:
#https://unix.stackexchange.com/questions/163793/start-a-background-process-from-a-script-and-manage-it-when-the-script-ends