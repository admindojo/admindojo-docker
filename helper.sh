#!/usr/bin/env bash
#set -e


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
    get_all_tasks "$(get_current_lesson)"


    lesson_title="$(crudini --get "$LESSON_PATH/$LESSONS_FILENAME_META" "lesson" "title")"
    #echo "Lesson: $lesson_title"

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

        task_solved="$(crudini --get "$LESSON_PATH/$LESSONS_FILENAME_TASKS" "$task" "solved")"
        if [ "$task_solved" == "false" ] || [ "$task_solved" == "" ];then




            if [ "$STATUS" == 0 ]; then
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
                echo -e "${GREEN}\t\t$task_title! \t+ $task_points Points${NORMAL}"
                let "tasks_done++"
                task_done_in_run=1
                task_hintnext="$(crudini --get "$LESSON_PATH/$LESSONS_FILENAME_TASKS" "$task" "hintnext")"

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
        echo "Lesson complete"
        sleep 2
        check_result "tutor"

        #mark lesson as solved
        echo ""
        crudini --set "$LESSON_PATH/$LESSONS_FILENAME_META" "lesson" "solved" "true"
        echo "Lesson marked as solved"
        echo ""
        echo "Hit [enter]"
        echo ""
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

    #echo "Tasks total: $tasks_total"
    #echo "Tasks done: $tasks_done"
    #echo "Tasks undone: $tasks_undone"
}




#TEST BACKGRUND HELPER
# Runs background when lesson is started. Should check the task-status periodically. Notifies user when a task is completed.
#
background_helper(){
    while [ true ]
    do
        #check every minute
        sleep 60
        check_live

    #    if [[ -d /home/marvin/check ]];then
    #        echo "da"
    #        exit 0
    #    else
    #        echo "nicht da"
    #    fi
    done
}







#Thanks:
#https://unix.stackexchange.com/questions/163793/start-a-background-process-from-a-script-and-manage-it-when-the-script-ends