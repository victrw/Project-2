#!/bin/bash
#: Title       : list_pass
#: Version     : 1.0
#: Description : Shows a list of all passwords stored in a file.
#: Options
# Users can see their list of stored password -s


#######################################
# Print a Usage message.
# Arguments:
#   None
# Outputs:
#   Write a help message
#######################################


usage() {
echo " usage:${0} [-s 'all' or preferred 'service'] " >&2
echo ' -s Prints all stored passwords or certain services if found'
exit 1
}

# file path for password_storage
storage_file_path='top_secret'


# echo contents of the storage file
ls_password() {
        cat "$storage_file_path"
}


# Setting list_password to false
LIST_PASSWORD='false'



while getopts s: OPTION; do
case ${OPTION} in
    s)
      LIST_PASSWORD='true'
      FILTER_PASS="${OPTARG}" 
      ;;
    ?)
      usage
      ;;
esac
done


if [[ "$LIST_PASSWORD" == 'false' ]]; then
    usage
    exit 1
fi
# if file exists, then call ls_password which will print the contents of the file
# if there are no args after -i, then print all the contents, else find the search word

if [[ "${LIST_PASSWORD}" = 'true' ]]; then
    if [ -e "$storage_file_path" ]; then
        if [[ "$FILTER_PASS" = 'all' ]]; then
            ls_password
        else
            #filters the file for certain services the user specified
            result=$(grep -i "Service: $FILTER_PASS" "$storage_file_path")
            #checks if string is null
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

exit 0