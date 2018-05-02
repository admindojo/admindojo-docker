#!/usr/bin/env bash

source ./tutor.sh

#TEST USER INPUT
list_all_missions

input_mission_number
mission_number="$?"
set_current_mission $mission_number



#TEST USER END



#TEST BACKGRUND HELPER
# Runs background when mission is started. Should check the task-status periodically. Notifies user when a task is completed.
#
helper_function(){



while [ true ]
do
    sleep 2
    if [[ -d /home/marvin/check ]];then
        echo "da"
        exit 0
    else
        echo "nicht da"
    fi
done
}


##helper_function &
## Storing the background process' PID.
#bg_pid=$!
#
## Trapping SIGKILLs so we can send them back to $bg_pid.
#trap "kill -15 $bg_pid" 2 15
#
#
#echo "PID: $bg_pid"











#Thanks:
#https://unix.stackexchange.com/questions/163793/start-a-background-process-from-a-script-and-manage-it-when-the-script-ends