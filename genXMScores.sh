#!/bin/bash

starttime=`date +"%Y-%m-%d_%H-%M-%S"`
coredir="xmscores-$starttime"

. /etc/init.d/functions
LOG="genXMScores.log"
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
        "$@" &>> $LOG
    else
        "$@" & &>> $LOG
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

genBT(){

    echo Generated via btdumpscript.sh > $coredir/corebtinfo.log
    echo Core List in dir - >> $coredir/corebtinfo.log 
echo `ls -al ./$coredir/*_core.*` >> $coredir/corebtinfo.log
echo ------------------------------- >> $coredir/corebtinfo.log
for corefile in ./$coredir/*_core.*
do

	echo ============================= NEXT {$corefile}  ========================================== &>> $coredir/corebtinfo.log
	exe= `file ${corefile}  | grep -oE "'.*?'" | grep -oE "/.*?'" | rev | cut -c2- | rev` &>> $coredir/corebtinfo.log
	echo ---------------------------------------------------------------------------- &>> $coredir/corebtinfo.log
	echo `ls -al $corefile` &>> $coredir/corebtinfo.log
	echo `file $corefile` &>> $coredir/corebtinfo.log
	echo ---------------------------------------------------------------------------- &>> $coredir/corebtinfo.log
	echo BT only &>> $coredir/corebtinfo.log
	echo ---------------------------------------------------------------------------- &>> $coredir/corebtinfo.log
	gdb --batch --quiet -ex "bt " -ex "quit" -core ${corefile} ${exe} &>>  $coredir/corebtinfo.log
	echo ---------------------------------------------------------------------------- &>> $coredir/corebtinfo.log
	echo FULL trace on all threads  &>> $coredir/corebtinfo.log
	echo ---------------------------------------------------------------------------- &>> $coredir/corebtinfo.log
	gdb --batch --quiet -ex "thread apply all bt full" -ex "quit" -core ${corefile} ${exe} &>>  $coredir/corebtinfo.log
done

	echo ============================= DONE  ========================================== &>> $coredir/corebtinfo.log


}
logger "User has intiated generation of XMS process cores via genXMScores.sh"

step "Creating core output directory"
try mkdir $coredir
next


if [[ -x "./xmsinfo.sh" ]]
then
    step "Obtaining XMSInfo"
    try ./xmsinfo.sh $coredir/xmsinfo-$starttime.tgz &>/dev/null 
    next
fi

step "Generating Cores for XMS process"
#XMS Core processes
try gcore -o ./$coredir/xmserver_core_core `pidof xmserver`
try gcore -o ./$coredir/appmanager_core `pidof appmanager`
try gcore -o ./$coredir/broker_core `pidof broker`
try gcore -o ./$coredir/eventmanager_core `pidof eventmanager`
try gcore -o ./$coredir/nodecontroller_core `pidof nodecontroller`
next

#WebRTC process
step "Generating Cores for Webrtc process"
try gcore -o ./$coredir/rtcweb_core `pidof rtcweb`
next

#HMP Core process
step "Generating Cores for Media Cores (HMP) process"
try gcore -o ./$coredir/ssp_x86Linux_boot_core `pidof ssp_x86Linux_boot`
next

#XMS interface processes
step "Generating Cores for XMS Control Interface process"
try gcore -o ./$coredir/vxmlinterpreter_core `pidof vxmlinterpreter`
try gcore -o ./$coredir/xmsrest_core `pidof xmsrest`
try gcore -o ./$coredir/msml_main_core `pidof msmlserver`
try gcore -o ./$coredir/netann_core `pidof netann`
next

step "Gathering executable binaries"
#copy of the binaries
try tar cvzf ./$coredir/binaries.tgz /usr/dialogic/bin/ssp_x86Linux_boot /usr/bin/xmserver /usr/bin/appmanager /usr/bin/broker /usr/bin/eventmanager /usr/bin/nodecontroller /usr/bin/rtcweb /usr/bin/vxmlinterpreter /usr/bin/xmsrest /usr/bin/msmlserver /usr/bin/netann  &> /dev/null
next

step "Generating Backtraces from cores"
genBT
setpass
next

echo "----------------------------------------------------------------" | tee -a $LOG
echo  Cores available in $coredir | tee -a $LOG
echo "----------------------------------------------------------------" | tee -a $LOG

#TODO, put detect in for abrt logs or cores already available
