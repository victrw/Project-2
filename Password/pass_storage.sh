#!/bin/bash
#: Title       : pass_storage
#: Version     : 1.0
#: Description : store a given password
#: Options
# Users can store the GENERATED password -S
# Users can store their OWN password -p 


#######################################
# Print a Usage message.
# Arguments:
#   None
# Outputs:
#   Write a help message
#######################################


usage() {
    echo "usage:${0} [-S] [-p 'your password']"
    echo ' -S Store a generated password.'
    echo ' -p Store your own password.'
    exit 1
}


# Generate a unique random ID
unique_id=$(($(date +%s%N) + $RANDOM))


# file path for password_storage
storage_file_path='top_secret'


# Setting store_password to false
STORE_GEN_PASSWORD='false'
STORE_OWN_PASSWORD='false'


while getopts :Sp OPTION; do
case ${OPTION} in
    S)
      STORE_GEN_PASSWORD='true'
      ;;
    p)
      STORE_OWN_PASSWORD='true'
      ;;
    ?)
      usage
      ;;
esac
done


#add flag to check if there are any non-option arguments
shift $(($OPTIND -1))

if [[ "$STORE_GEN_PASSWORD" == 'false' && "$STORE_OWN_PASSWORD" == 'false' ]]; then
    usage
    exit 1
fi

############################################################################
# Stores a password.
# Arguments:
#       None
# Outputs:
#       Ask user for what the password is associated with
#       Ask user what email/username the password is associated with
#       Stores passwords and info regarding password in 'top_secret'
#       Prints msg it has been saved
############################################################################

store_password() {
    read -p "Service the password is associated with: " SERVICE
    read -p "Email address or Username associated with the service: " EMAIL
    echo "Password: ${PASSWORD}, Service: ${SERVICE}, Email/Username: ${EMAIL}, ID: ${unique_id}" >> $storage_file_path
    echo "Password has been successfully saved."
}


# randomly generates a password for the user and ask if they want to add 
# a certain length or add a special character
store_gen_password(){
    while true; do 
        read -p "Length of the password (if nothing is entered, default = 48): " LENGTH
        # if empty, continue
        if [[ -z "$LENGTH" ]]; then
            break
            #if a number, continue
        elif [[ "$LENGTH" =~ ^[0-9]+$ ]]; then
            break
            #if not empty or not a number, ask again.
        else
            echo "Please enter a valid number."
    fi
    done

    read -p "Add a special character to the password? (y/n): " USE_SPECIAL_CHARACTER
    # generate default password if no option chosen
    PASSWORD_OPTIONS=()

    # Add -l option if LENGTH is specified and not null
    if [ -n "${LENGTH}" ]; then
        PASSWORD_OPTIONS+=("-l ${LENGTH}")
    fi


    # Add -s option if USE_SPECIAL_CHARACTER is 'y'
    if [[ "${USE_SPECIAL_CHARACTER}" = 'y' ]]; then
        PASSWORD_OPTIONS+=("-s")
    fi


    # Call pass_gen options chosen 
    PASSWORD=$(./pass_gen "${PASSWORD_OPTIONS[@]}")
    store_password
}


# user enters their own password
store_own_password() {
    read -p "Please enter your own password: " PASSWORD
    store_password
}


# Store a user's password to a file
if [[ "${STORE_OWN_PASSWORD}" == 'true' ]]; then
    store_own_password
fi


# Store a randomly generated password to a file
if [[ "${STORE_GEN_PASSWORD}" == 'true' ]]; then
    store_gen_password
fi

exit 1