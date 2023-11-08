#!/bin/bash
#: Title       : task_maker
#: Version     : 1.0
#: Description : create a task
#: Options
# Users can create a task -c
# Users can create a task with a due date -d

#######################################
# Print a Usage message.
# Arguments:
#   None
# Outputs:
#   Write a help message
#######################################

usage() {
    echo "usage:${0} [-c]"
    echo ' -c Create a task.'
    exit 1
}


# Generate a unique random ID
unique_id=$(($(date +%s%N) + $RANDOM))


# setting default values
task_name='false'

#file storage location
storage_file_path='task_storage'


while getopts :c OPTION; do
case ${OPTION} in
    c)
      task_name='true'
      ;;
    ?)
      usage
      ;;
esac
done


#add flag to check if there are any non-option arguments
# shift $(($OPTIND -1))

if [[ "$task_name" == 'false' && "$due_date" == 'false' ]]; then
    usage
    exit 1
fi


##############################################
# Create a task!
# Arguments:
#       None
# Outputs:
#       Ask user for a task name
#       Ask user for the task description
#       Ask user for a due date
#       Prints msg it has been saved
##############################################

createTask() {
    read -p 'What task do you want to create: ' TASK
    read -p 'What is the description of the task: ' DESCRIPTION
    read -p 'Do you want to add a due date (y/n): ' DECISION

    if [[ "${DECISION}" == 'y' ]]; then

        while true; do
            read -p 'What is the due date (YYYY-MM-DD): ' DUE_DATE
            # keep asking the user for a valid due_date
            if [[ ! $DUE_DATE =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
                echo "Please use YYYY-MM-DD format and enter only valid numbers."
            else
                break
            fi
        done       


        echo "TaskID: ${unique_id}, Task Name: ${TASK}, Task Description: ${DESCRIPTION}, Due: ${DUE_DATE}" >> $storage_file_path
        echo "Task has been saved!"
    else
        echo "TaskID: ${unique_id}, Task Name:  ${TASK} Task Description: ${DESCRIPTION}" >> task_storage
        echo "Task has been saved!"
fi
}

if [[ "${task_name}" = 'true' ]]; then
    createTask
fi

exit 1