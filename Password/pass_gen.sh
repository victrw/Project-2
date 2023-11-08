#!/bin/bash
#: Title       : pass_gen
#: Version     : 1.0
#: Description : generate a random password
#: Options
# Users can set a password length -l
# Users can add a special character -s


#######################################
# Print a Usage message.
# Arguments:
#   None
# Outputs:
#   Write a help message
#######################################


usage() {
echo " usage:${0} [-l LENGTH] [-s]" >&2
echo ' -l LENGTH specify the password length'
echo ' -s Add a special character to the password.'

exit 1
}


# set a default password length
LENGTH=48


# setting special char
USE_SPECIAL_CHARACTER='false'


while getopts l:s OPTION; do
case ${OPTION} in
    l)
      LENGTH="${OPTARG}"
      ;;
    s)
      USE_SPECIAL_CHARACTER='true'
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


# display password
echo "${PASSWORD}"
exit 0