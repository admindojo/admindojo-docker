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
                    #eval "$task_testing_cmd 1>/dev/null"
                    testing_command_error=$(eval "$task_testing_cmd 1>/dev/null"; echo $?)

                    task_status=$(check_success "$task"; echo $?)

                    if [[ "$task_status" == "ok" ]] || [[ "$task_status" = *"OK"* ]] || [[ "$task_status" == "0" ]]; then
                        task_testing_status="${GREEN}ok${NORMAL}"
                        #return 0
                    else
                        task_testing_status="${RED}failed${NORMAL}"
                        #return 1
                        testing_error=1
                    fi

                    if [[ "$testing_command_error" == "0" ]]; then
                        task_testingcmd_status="${GREEN}ok${NORMAL}"
                    else
                        task_testingcmd_status="${RED}failed${NORMAL}"
                        testing_error=1
                    fi

                    echo -e "\t\tTest command: $task_testingcmd_status"
                    echo -e "\t\tTask solved : $task_testing_status"


                fi

            done
         if [[ "$testing_error" == "1" ]]; then
            echo -e "${RED}Solved Check failed: $MISSION_PATH${NORMAL}"
         fi
         if [[ "$testing_command_error" != "0" ]]; then
            echo -e "${RED}Testing command failed: $MISSION_PATH${NORMAL}"
         fi


        echo ""
    done
return $testing_error
}

echo "------------------   TEST START   ----------------"
test_missions
return $testing_error