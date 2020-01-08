#!/bin/bash
#echo Script name: $0
#echo $# arguments

# Setup loggining
export TIMESTAMP=$(date +"%Y-%m-%d-%T")
export LOGDIR=$HOME/logs
export LOGFILE="${LOGDIR}/test_${TIMESTAMP}.log"
touch $LOGFILE
echo $TIMESTAMP
echo $LOGDIR
echo $LOGFILE

echo "Start of log"

date > $LOGFILE

if [ "$#" -ne 3 ];
    then
        echo "This script requires 3 parameters"
        echo "1. is the RFC number i.e RFC-1234"
        echo "2. is URL for git repo - this ends in .git"
        echo "3. git reference - either tag or SHA1"

    exit
fi

# Lets check that the RFC number is inthe correct format
# It should start with RFC- and then 4 digits
if [[ $1 =~ ^[R][F][C][-][0-9][0-9][0-9][0-9] ]]
then
        echo "RFC looks good"
else
        echo "RFC reference is not correctly formatted"
        exit
fi

# Checking the URL for the git repo
# At the most basic level it must end in .get
if [[ $2 =~ .git$ ]]
then
        echo "URL looks good"
else
        echo "URL is not good"
        exit
fi

# Checking that the TAG or SHA1 exists in the repo
# If it does not exist then the ticket must be rejected
git ls-remote --heads --tags $2 | grep -E $3 > /dev/null
if [[ "$?" -eq "0" ]];
then
        echo "GIT reference looks good"
else
        echo "GIT reference not found"
        exit
fi
