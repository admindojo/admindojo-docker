#!/usr/bin/env bash
#set -e


# @description Checks tasks and outputs "task-done"message + hint for next task + final end result.
# Should be updated since show final result is already done in main file.
#
#
# @noargs
#
#
# @stdout
check_live() {
    # Get a fresh array of all tasks in $TASK_LIST_OF_TASK
    get_all_tasks "$(get_current_lesson)"

    lesson_title="$(crudini --get "$LESSON_PATH/$LESSONS_FILENAME_META" "lesson" "title")"

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
        task_points="$(crudini --get "$LESSON_PATH/$LESSONS_FILENAME_TASKS" "$task" "points")"
        if [[ $task_points != 0 ]];then
            check_success "$task"
            STATUS=$?
        else
            STATUS=0
        fi

        let "task_counter++"

        task_solved="$(crudini --get "$LESSON_PATH/$LESSONS_FILENAME_TASKS" "$task" "solved")"
        if [ "$task_solved" == "false" ] || [ "$task_solved" == "" ];then

            if [ "$STATUS" == 0 ] && [[ $task_points != 0 ]]; then
                if [[ "$task_done_in_run" == "0" ]];then
                    echo ""
                    echo -e "${GREEN}You just solved:${NORMAL}"
                fi

                #mark task as solved in lesson-file
                #mark_task_solved "$task"
                crudini --set "$LESSON_PATH/$LESSONS_FILENAME_TASKS" "$task" "solved" "true"

                #Get points for task
                task_points="$(crudini --get "$LESSON_PATH/$LESSONS_FILENAME_TASKS" "$task" "points")"
                result_points_total=$(( $result_points_total + $task_points ))

                task_title="$(crudini --get "$LESSON_PATH/$LESSONS_FILENAME_TASKS" "$task" "title")"

                result_points_got=$(( $result_points_got + $task_points ))

                if [[ $task_points != 0 ]];then
                    echo -e "${GREEN}\t\t$task_title! \t+ $task_points Points${NORMAL}"
                fi

                let "tasks_done++"
                task_done_in_run=1
                task_hintnext="$(crudini --get "$LESSON_PATH/$LESSONS_FILENAME_TASKS" "$task" "hintnext")"

            fi
         else
            let "tasks_done++"
         fi
    let "tasks_total++"
    done

    #Output final result if all tasks are done
    if [[ "$tasks_done" == "$tasks_total" ]];then
        echo ""
        echo "You solved all tasks!"
        echo ""
        echo "Lesson complete"
        sleep 2
        # check result + "tutor" displays a hint for next task
        check_result "tutor"

        #mark lesson as solved
        echo ""
        crudini --set "$LESSON_PATH/$LESSONS_FILENAME_META" "lesson" "solved" "true"
        crudini --set "$PLAYER_FILE" "player" "lesson_current" ""
        crudini --set "$PLAYER_FILE" "local" "helper_pid" ""
        echo "Lesson marked as solved"
        echo ""
        echo "Hit [enter]"
        echo ""

        #exit the game when lesson is finished
        exit 0
    else
        if [[ "$task_done_in_run" == "1" ]];then
            echo "Tasks done: $tasks_done/$tasks_total"
            echo ""

             if [ ! "$task_hintnext" == "" ]; then
                echo ""
                echo "Next: $task_hintnext"
                echo ""
             fi

            echo "Hit [enter]"
            echo ""
        fi
    fi
}


# @description Runs background when lesson is started. Should check the task-status periodically. Notifies user when a task is completed.
#
#
# @noargs
#
#
# @stdout P
background_helper(){
    while [ true ]
    do
        #check every minute
        sleep 60
        check_live
    done
}







#Thanks:
#https://unix.stackexchange.com/questions/163793/start-a-background-process-from-a-script-and-manage-it-when-the-script-ends