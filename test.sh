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


show_tasks(){
    # Get a fresh array of all tasks in $TASK_LIST_OF_TASK
    get_all_tasks


    mission_title="$(crudini --get mission.ini "mission" "title")"
    echo ""
    echo "Mission: $mission_title"
    echo ""
    echo "Your Tasks:"
    #Show for each task
    for task in "${TASK_LIST_OF_TASK[@]}"
    do

        task_title="$(crudini --get task.ini "$task" "title")"
        task_desc="$(crudini --get task.ini "$task" "desc")"

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
cmd="$(crudini --get task.ini "$check_task" "cmd")"
task_title="$(crudini --get task.ini "$check_task" "title")"
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
    tasks="$(eval crudini --get task.ini | tr '\n' ' ')"

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


    mission_title="$(crudini --get mission.ini "mission" "title")"
    echo ""
    echo "Mission: $mission_title"
    echo ""
    echo "Your Result:"
    #Check each task
    for task in "${TASK_LIST_OF_TASK[@]}"
    do

        #Get points for task
        task_points="$(crudini --get task.ini "$task" "points")"
        result_points_total=$(( $result_points_total + $task_points ))
        task_title="$(crudini --get task.ini "$task" "title")"
        check_success "$task"
        STATUS=$?
        #echo ""
        if [ "$STATUS" == 0 ]; then

            echo -e "$task_title\t${GREEN}solved ${NORMAL}"



            result_points_got=$(( $result_points_got + $task_points ))


        else
            echo -e "$task_title\t${RED}failed ${NORMAL}"

            hint="$(crudini --get task.ini "$task" "hint")"
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


if [ "$1" == "show" ]; then
    show_tasks
    exit 0
fi
