#!/bin/bash

. /etc/init.d/functions

LOG="gracefulShutdown.log"
STARTTIME=`date +"%y-%m-%d_%H-%M-%s"` 

SHUTDOWNTIMER=360
echo '--------------------------------------------------------------------------------------' >> $LOG
echo $STARTTIME >> $LOG
echo `hostname` >> $LOG
echo '--------------------------------------------------------------------------------------' >> $LOG

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


logger "User has intiated a Graceful Shutdown of XMS via gracefulShutdown.sh"

step "Saving any system infomration for debug"
#todo put information gathing inforamtion here such as xmsinfo.sh or gencores.sh
#./xmsinfo.sh
echo -e "No Debug Collection Enabled" >> $LOG
setpass;
next

step "Configuring graceful shutdown timer to $SHUTDOWNTIMER seconds"
RES="$(curl -s -i -H "Accept: application/json" -H "Content-Type: application/json" -H "UserName: superadmin" -X PUT -d "{\"graceful_shutdown_timeout\":\"240\"}" http://localhost:10080/services)"
echo -e $RES >> $LOG
setpass;
next

step "Initiating graceful shutdown"
RES="$(curl -s -i -H "Accept: application/json" -H "Content-Type: application/json" -H "UserName: superadmin" -X PUT -d "{\"state\":\"OUTOFSERVICE\"}" http://localhost:10080/services)"
echo -e $RES >> $LOG
setpass;
next

step "Waiting for graceful shutdown to complete"

LOOPTIMEOUT=$(($SHUTDOWNTIMER+120 ));
LOOPTIMEOUT=$(($LOOPTIMEOUT/10));
#echo -e "Looptimeout=${LOOPTIMEOUT}\n"  ;
while [ $LOOPTIMEOUT -gt 0 ]  ;
do
   SIPCOUNT=$(cat /var/lib/xms/meters/currentValue.txt | grep xmsResources.xmsSignalingSessions | awk -F' ' '{print $3}')
   if [[ -z "$SIPCOUNT" ]];
   then 
       SIPCOUNT="N/A" 
    fi 
    
    MEDIACOUNT=$(cat /var/lib/xms/meters/currentValue.txt | grep xmsResources.xmsMediaTransactions | awk -F' ' '{print $3}')   
    if [[ -z "$MEDIACOUNT" ]]; 
    then 
        MEDIACOUNT="N/A" 
    fi
 
STATE="$(curl -s http://127.0.0.1:10080/services | grep -P -o 'state=".*?"'|awk -F '"' '{print $2}')"
	echo -e "State=$STATE, SIPCOUNT=$SIPCOUNT, MediaTransaction=$MEDIACOUNT" >> $LOG
   if [[ $STATE == "STOPPED" ]];
   then
	   LOOPTIMEOUT=0
   elif [[ $STATE == "FAILED" ]];
   then
       LOOPTIMEOUT=0
   else
    (( LOOPTIMEOUT-- ))
	echo -n "."
	sleep 10
   fi
done
setpass;
next


#Step 3-Stop the Nodecontroller (TODO- Update this to graceful shutdown)
#step "Stoping nodecontroller service" 
echo "STEP - Stopping nodecontroller">>$LOG
service nodecontroller stop | tee -a $LOG

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

echo -e "Log saved to $LOG \n"
echo -e "Process complete, services have been stopped.  You may now 'shutdown' or restart services via 'service nodecontroller start\n"
