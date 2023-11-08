#!/bin/bash
#: Title       : pass_gen
#: Version     : 1.0
#: Description : generate a random password
#: Options
# Users can set a password length -l
# Users can add a special character -s
# Users can save a password -S
# Users can see their list of stored password -i


#######################################
# Print a Usage message.
# Arguments:
#   None
# Outputs:
#   Write a help message
#######################################


usage() {
echo " usage:${0} [-l LENGTH] [-sS] [-i 'all' or your prefered service] " >&2
echo ' -l LENGTH specify the password length'
echo ' -s Add a special character to the password.'
echo ' -S Store the password.'
echo ' -i Prints certain services or all stored passwords if found'
exit 1
}


############################################################################
# Stores a password.
# Arguments:
#       None
# Outputs:
#       Ask user for what the password is associated with
#       Ask user what email/username the password is associated with
#       Stores passwords and info regarding password in 'pass_storage'
#       Prints msg it has been saved
############################################################################


store_password() {
        read -p "Service the password is associated with: " SERVICE
        read -p "Email address or Username associated with the service: " EMAIL
        echo "Password: ${PASSWORD}, Service: ${SERVICE}, Email/Username: ${EMAIL}, ID: ${unique_id}" >> pass_storage
        echo "Password has been successfully saved."
}


# echo contents of the storage file
ls_password() {
        cat "$storage_file_path"
}


# set a default password length
LENGTH=48



# Generate a unique random ID
unique_id=$(($(date +%s%N) + $RANDOM))


# setting special char, store password, and list passwords to false
USE_SPECIAL_CHARACTER='false'
STORE_PASSWORD='false'
LIST_PASSWORD='false'


while getopts l:sSi: OPTION; do
case ${OPTION} in
    l)
      LENGTH="${OPTARG}"
      ;;
    S)
      STORE_PASSWORD='true'
      ;;
    s)
      USE_SPECIAL_CHARACTER='true'
      ;;
    i)
      LIST_PASSWORD='true'
      FILTER_PASS="${OPTARG}" 
      ;;
    ?)
      usage
      ;;
esac
done


# fixes the problem where if I call ${0} + rand arg, it keeps returning a password
# go to next flag if it's one of the options
shift $(($OPTIND -1))

if [[ "${#}" -gt 0 ]]; then
        echo " Please refer to down below for assistance."
        usage
fi


# Create a random password
PASSWORD=$(date +%s%N${RANDOM}${RANDOM} | sha256sum | head -c${LENGTH})


# Append a special character
if [[ "${USE_SPECIAL_CHARACTER}" = 'true' ]]; then
SPECIAL_CHARACTER=$(echo '!@#$%^&*()-=+' | fold -w1 | shuf | head -c1)
PASSWORD="${PASSWORD}${SPECIAL_CHARACTER}"
#shuffle password after adding special char
PASSWORD=$(echo "${PASSWORD}" | fold -w1 | shuf | tr -d "\n")
fi


# Store password in a file
if [[ "${STORE_PASSWORD}" = 'true' ]]; then
        #call function store_password
        store_password
fi


# file path for password_storage
storage_file_path='pass_storage'


# if file exists, then call ls_password which will print the contents of the file
# if there are no args after -i, then print all the contents, else find the search word

if [[ "${LIST_PASSWORD}" = 'true' ]]; then
    if [ -e "$storage_file_path" ]; then
        if [[ "$FILTER_PASS" = 'all' ]]; then
            ls_password
        else
            result=$(grep -i "Service: $FILTER_PASS" "$storage_file_path")
            if [ -z "$result" ]; then
                echo "Cannot find any passwords for service: $FILTER_PASS"
                exit 1
            else
                echo "$result"
            fi
        fi
        exit 0
    else
        echo "Cannot find any stored passwords."
        exit 1
    fi
fi


# display password
echo "${PASSWORD}"
exit 0