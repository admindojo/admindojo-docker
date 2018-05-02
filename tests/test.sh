#!/usr/bin/env bash
#

# Test each mission
# Test only tasks that contain "test" commands
test_missions() {
# marker for failed tests
testing_error=0

    for FOLDER in $(ls $PROGRAM_PATH_MISSIONS ); do

        MISSION_FOLDER=$(echo $FOLDER )
        MISSION_PATH=$PROGRAM_PATH_MISSIONS/$MISSION_FOLDER


        mission_title="$(crudini --get "$MISSION_PATH/$MISSIONS_FILENAME_META" "mission" "title")"
        echo -e "TEST MISSION: $mission_title"

        get_all_tasks


            for task in "${TASK_LIST_OF_TASK[@]}"
            do
                # Only test auto-testable tasks
                task_testing_cmd="$(crudini --get "$MISSION_PATH/$MISSIONS_FILENAME_TASKS" "$task" "test")"
                    if [ -n "$task_testing_cmd" ]; then

                    task_title="$(crudini --get "$MISSION_PATH/$MISSIONS_FILENAME_TASKS" "$task" "title")"

                    echo -e "\tTask: $task_title"


                    # Run cmd to solve task
                    eval "$task_testing_cmd 1>/dev/null"

                    task_status=$(check_success "$task"; echo $?)

                    if [[ "$task_status" == "ok" ]] || [[ "$task_status" = *"OK"* ]] || [[ "$task_status" == "0" ]]; then
                        task_testing_status="${GREEN}ok${NORMAL}"
                        #return 0
                    else
                        task_testing_status="${RED}failed${NORMAL}"
                        #return 1
                        testing_error=1
                    fi

                    echo -e "\t\tTask solvable: $task_testing_status"


                fi

            done
         if [[ "$testing_error" == "1" ]]; then
            echo -e "${RED}Error in Module: $MISSION_PATH${NORMAL}"
         fi

        echo ""
    done
return $testing_error
}


test_missions