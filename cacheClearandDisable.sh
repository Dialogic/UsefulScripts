#!/bin/bash
. /etc/init.d/functions

LOG="cacheClearandDisable.log"
STARTTIME=`date +"%y-%m-%d_%H-%m-%s"` 
echo $STARTTIME > $LOG
echo `hostname` >> $LOG
# Use step(), try(), and next() to perform a series of commands and print
# [  OK  ] or [FAILED] at the end. The step as a whole fails if any individual
# command fails.
#
step() {
    echo -n -e "$@"

    
    echo -e "\n\nSTEP -  $@">> $LOG
    STEP_OK=0
    [[ -w /tmp ]] && echo $STEP_OK > /tmp/step.$$
}

try() {
    # Check for `-b' argument to run command in the background.
    local BG=

    [[ $1 == -b ]] && { BG=1; shift; }
    [[ $1 == -- ]] && {       shift; }

    # Run the command.
    echo -e "$@" >> $LOG

    if [[ -z $BG ]]; then
        "$@" | tee -a $LOG
    else
        "$@" &
    fi

    # Check if command failed and update $STEP_OK if so.
    local EXIT_CODE=$?

    if [[ $EXIT_CODE -ne 0 ]]; then
        STEP_OK=$EXIT_CODE
        [[ -w /tmp ]] && echo $STEP_OK > /tmp/step.$$

        if [[ -n $LOG_STEPS ]]; then
            local FILE=$(readlink -m "${BASH_SOURCE[1]}")
            local LINE=${BASH_LINENO[0]}

            echo "$FILE: line $LINE: Command \'$*\' failed with exit code $EXIT_CODE." >> "$LOG_STEPS"
        fi
    fi

    return $EXIT_CODE
}

next() {
    [[ -f /tmp/step.$$ ]] && { STEP_OK=$(< /tmp/step.$$); rm -f /tmp/step.$$; }
    [[ $STEP_OK -eq 0 ]]  && echo_success || echo_failure
    echo

    return $STEP_OK
}

setpass() {
    echo -n "$@"

    STEP_OK=0
    [[ -w /tmp ]] && echo $STEP_OK > /tmp/step.$$
}
setfail() {
    echo -n "$@"

    STEP_OK=1
    [[ -w /tmp ]] && echo $STEP_OK > /tmp/step.$$
}

#Step 1-display current settings
step "Checking current httpclient cache"
VALUE="$(curl -s http://127.0.0.1:10080/httpclient | grep cache)"
#TODO Check to see if it is currently on and only reset if it is
setpass;
next
echo -e "\n   Current Value = {$VALUE}\n" | tee -a $LOG

#Step 2-disable cache either via this or the WebUI
step "Turning off Cache setting\n" 
RES="$(curl -s -H 'Content-Type: application/json' -X PUT  -d '{"cache":"no"}' 127.0.0.1:10080/httpclient)"
#TODO Check response code to ensure it is set
setpass;
next
echo -e "Response\n {$RES} \n\n" | tee -a $LOG

#Step 3-Stop the Nodecontroller (TODO- Update this to graceful shutdown)
#step "Stoping nodecontroller service"
echo "STEP - Stopping nodecontroller">>$LOG
if [[ -x "./gracefulShutdown.sh" ]]
then
    echo "File '$file' is executable" >> $LOG
    ./gracefulShutdown.sh | tee -a $LOG
else
    echo "File '$file' is not executable or found" >> $LOG
    service nodecontroller stop | tee -a $LOG
fi


#Step 4-check the number of files in the cache
step "Checking the number of files in cache\n"
FILECOUNT="$(echo `ls -l /var/cache/xms/http/xmserver/ |wc -l`)"
#TODO check to make sure there are a large number of files
setpass;
next
echo -e "    $FILECOUNT files found in the xms http cache \n" | tee -a $LOG

#Step 5- Note the permisions and owner of the xmserver
#TODO should ceck to see if we have ability to make write a new folder
step "Checking File permissions on current cache directory" 
try ls -al /var/cache/xms/http | grep xmserver >> $LOG
next
#Step 6- Move the Current folder to a new name
step "Renaming current directory" 
try mv /var/cache/xms/http/xmserver /var/cache/xms/http/xmserver_del 
next

#Step 7- Make a new directory (TODO- Need to check the file permisions
step "Making new cache directory" 
try mkdir /var/cache/xms/http/xmserver 
next

#Step 7a - Resetting file permisions
step "Setting chown on new cache folder"
try chown --reference=/var/cache/xms/http/xmserver_del /var/cache/xms/http/xmserver
next

#Step 7b - Resetting file permisions
step "Setting chmod on new cache folder"
try chmod --reference=/var/cache/xms/http/xmserver_del /var/cache/xms/http/xmserver
next
#Step 7c - Cehcking permissions and owner of new dir
step "Checking File permissions on current cache directory"
try ls -al /var/cache/xms/http | grep xmserver >> $LOG
next
#TODO should check to make sure that it is set correctly

#NOTE: If this is taking too long, likely you can comment this line out and uncomment one after restart
#Step - Delete the old del dir
step "\nDeleting files (This may take some time)"
start=$(date +%s.%N); 
try find /var/cache/xms/http/xmserver_del -type f -delete 
try rm -rf /var/cache/xms/http/xmserver_del
dur=$(echo "$(date +%s.%N) - $start" | bc)
next
printf "  Complete Execution time: %.3f seconds\n" $dur | tee -a $LOG

#Step 9- Restart the Nodecontroller
#step "Restarting XMS" 
#TODO Should check to see if this should be done before or after the delet happens
echo "STEP - Starting nodecontroller">>$LOG
service nodecontroller start | tee -a $LOG 

#Step 10- Check the cache
step "Re-Checking current httpclient cache"
VALUE="$(curl -s http://127.0.0.1:10080/httpclient | grep cache)"
#TODO check if it is set correct
setpass;
next
echo -e "\n   Current Value = {$VALUE}" |tee -a $LOG

#Step 11- Delete the old del dir
#step "\nDeleting files (This may take some time)" 
#try find /var/cache/xms/http/xmserver_del -type f -delete 
#try rm -rf /var/cache/xms/http/xmserver_del
#next

echo -e "\n\nProcessing Complete, see $LOG for details\n\n"
