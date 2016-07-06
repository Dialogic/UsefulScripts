#!/bin/bash
# This script will gather all the system level information needed to debug
# XMS issues.
# License information and the latest version of this script can be found at
# https://github.com/Dialogic/UsefulScripts
# or run directly by Executing
# curl -s https://raw.githubusercontent.com/Dialogic/UsefulScripts/master/xmsinfo.sh | bash -
. /etc/init.d/functions

starttime=`date +"%Y-%m-%d_%H-%M-%S"`
OUTFILE=xmsinfo-$starttime.tgz
LOG="xmsinfo-$starttime.log"
if [ $# -eq 1 ]; then
	OUTFILE=$1
fi

# Use step(), try(), and next() to perform a series of commands and print
# [  OK  ] or [FAILED] at the end. The step as a whole fails if any individual
# command fails.
step() {
    echo -n -e "$@"
    echo -e "\n\nSTEP -  $@"&>> $LOG
    STEP_OK=0
    [[ -w /tmp ]] && echo $STEP_OK > /tmp/step.$$
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

#logger -t SCRIPT  Executing $0, see $LOG for details
step "Saving directory and file information"
touch /var/log/xms/dirlisting.out
echo "$starttime" > /var/log/xms/dirlisting.out
echo "----------------------------------------------------------------------------" &>> /var/log/xms/dirlisting.out
echo "/usr/dialogic" &>> /var/log/xms/dirlisting.out
echo "----------------------------------------------------------------------------" &>> /var/log/xms/dirlisting.out
ls -atlR /usr/dialogic &>> /var/log/xms/dirlisting.out
echo "----------------------------------------------------------------------------" &>> /var/log/xms/dirlisting.out
echo "/etc/xms" &>> /var/log/xms/dirlisting.out
echo "----------------------------------------------------------------------------" &>> /var/log/xms/dirlisting.out
ls -altR /etc/xms &>> /var/log/xms/dirlisting.out
echo "----------------------------------------------------------------------------" &>> /var/log/xms/dirlisting.out
echo "/var/lib/xms" &>> /var/log/xms/dirlisting.out
echo "----------------------------------------------------------------------------" &>> /var/log/xms/dirlisting.out
ls -altR /var/lib/xms &>> /var/log/xms/dirlisting.out
echo "----------------------------------------------------------------------------" &>> /var/log/xms/dirlisting.out
echo "/usr/bin" &>> /var/log/xms/dirlisting.out
echo "----------------------------------------------------------------------------" &>> /var/log/xms/dirlisting.out
ls -altR /usr/bin &>> /var/log/xms/dirlisting.out
setpass;
next

step "Saving network information"
touch /var/log/xms/additionalinfo.out
echo "$starttime" > /var/log/xms/additionalinfo.out
echo "----------------------------------------------------------------------------" &>> /var/log/xms/additionalinfo.out
echo "hostname" &>> /var/log/xms/additionalinfo.out
echo "----------------------------------------------------------------------------" &>> /var/log/xms/additionalinfo.out
hostname &>> /var/log/xms/additionalinfo.out
echo "----------------------------------------------------------------------------" &>> /var/log/xms/additionalinfo.out
echo "hostnamectl" &>> /var/log/xms/additionalinfo.out
echo "----------------------------------------------------------------------------" &>> /var/log/xms/additionalinfo.out
hostnamectl &>> /var/log/xms/additionalinfo.out
echo "----------------------------------------------------------------------------" &>> /var/log/xms/additionalinfo.out
echo "ping hostname" &>> /var/log/xms/additionalinfo.out
echo "----------------------------------------------------------------------------" &>> /var/log/xms/additionalinfo.out
ping `hostname` -c 1 &>> /var/log/xms/additionalinfo.out
echo "----------------------------------------------------------------------------" &>> /var/log/xms/additionalinfo.out
echo "ping www.dialogic.com" &>> /var/log/xms/additionalinfo.out
echo "----------------------------------------------------------------------------" &>> /var/log/xms/additionalinfo.out
ping www.dialogic.com -c 1 &>> /var/log/xms/additionalinfo.out
echo "----------------------------------------------------------------------------" &>> /var/log/xms/additionalinfo.out
echo "ifconfig" &>> /var/log/xms/additionalinfo.out
echo "----------------------------------------------------------------------------" &>> /var/log/xms/additionalinfo.out
ifconfig &>> /var/log/xms/additionalinfo.out
echo "----------------------------------------------------------------------------" &>> /var/log/xms/additionalinfo.out
echo "ifconfig -a" &>> /var/log/xms/additionalinfo.out
echo "----------------------------------------------------------------------------" &>> /var/log/xms/additionalinfo.out
ifconfig -a &>> /var/log/xms/additionalinfo.out
echo "----------------------------------------------------------------------------" &>> /var/log/xms/additionalinfo.out
echo "ip a" &>> /var/log/xms/additionalinfo.out
echo "----------------------------------------------------------------------------" &>> /var/log/xms/additionalinfo.out
ip a &>> /var/log/xms/additionalinfo.out
echo "----------------------------------------------------------------------------" &>> /var/log/xms/additionalinfo.out
echo "netstat -anope" &>> /var/log/xms/additionalinfo.out
echo "----------------------------------------------------------------------------" &>> /var/log/xms/additionalinfo.out
netstat -anope &>> /var/log/xms/additionalinfo.out
echo "----------------------------------------------------------------------------" &>> /var/log/xms/additionalinfo.out
echo "route" &>> /var/log/xms/additionalinfo.out
echo "----------------------------------------------------------------------------" &>> /var/log/xms/additionalinfo.out
route &>> /var/log/xms/additionalinfo.out
setpass;
next

step "Saving firewall information"
echo "----------------------------------------------------------------------------" &>> /var/log/xms/additionalinfo.out
echo "iptables --list" &>> /var/log/xms/additionalinfo.out
echo "----------------------------------------------------------------------------" &>> /var/log/xms/additionalinfo.out
iptables --list &>> /var/log/xms/additionalinfo.out
echo "----------------------------------------------------------------------------" &>> /var/log/xms/additionalinfo.out
echo "firewall-cmd --list-all-zones" &>> /var/log/xms/additionalinfo.out
echo "----------------------------------------------------------------------------" &>> /var/log/xms/additionalinfo.out
firewall-cmd --list-all-zones &>> /var/log/xms/additionalinfo.out
setpass;
next

step "Collecting process and package information"
echo "----------------------------------------------------------------------------" &>> /var/log/xms/additionalinfo.out
echo "/etc/system-release" &>> /var/log/xms/additionalinfo.out
echo "----------------------------------------------------------------------------" &>> /var/log/xms/additionalinfo.out
cat /etc/system-release &>> /var/log/xms/additionalinfo.out
echo "----------------------------------------------------------------------------" &>> /var/log/xms/additionalinfo.out
echo "/etc/redhat-release" &>> /var/log/xms/additionalinfo.out
echo "----------------------------------------------------------------------------" &>> /var/log/xms/additionalinfo.out
cat /etc/redhat-release &>> /var/log/xms/additionalinfo.out
echo "----------------------------------------------------------------------------" &>> /var/log/xms/additionalinfo.out
echo "ps -fe" &>> /var/log/xms/additionalinfo.out
echo "----------------------------------------------------------------------------" &>> /var/log/xms/additionalinfo.out
ps -fe &>> /var/log/xms/additionalinfo.out
echo "----------------------------------------------------------------------------" &>> /var/log/xms/additionalinfo.out
echo "rpm -qa" &>> /var/log/xms/additionalinfo.out
echo "----------------------------------------------------------------------------" &>> /var/log/xms/additionalinfo.out
rpm -qa &>> /var/log/xms/additionalinfo.out
echo "----------------------------------------------------------------------------" &>> /var/log/xms/additionalinfo.out
echo "cron tasks" &>> /var/log/xms/additionalinfo.out
echo "----------------------------------------------------------------------------" &>> /var/log/xms/additionalinfo.out
crontab -l &>> /var/log/xms/additionalinfo.out
cat /etc/passwd | sed 's/^\([^:]*\):.*$/crontab -u \1 -l 2>\&1/' | grep -v "no crontab for" | sh &>> /var/log/xms/additionalinfo.out
setpass;
next

step "Collecting system usage and performance data"
echo "----------------------------------------------------------------------------" &>> /var/log/xms/additionalinfo.out
echo "df -h" &>> /var/log/xms/additionalinfo.out
echo "----------------------------------------------------------------------------" &>> /var/log/xms/additionalinfo.out
df -h &>> /var/log/xms/additionalinfo.out
echo "----------------------------------------------------------------------------" &>> /var/log/xms/additionalinfo.out
echo "free -ml" &>> /var/log/xms/additionalinfo.out
echo "----------------------------------------------------------------------------" &>> /var/log/xms/additionalinfo.out
free -ml &>> /var/log/xms/additionalinfo.out
echo "----------------------------------------------------------------------------" &>> /var/log/xms/additionalinfo.out
echo "uptime" &>> /var/log/xms/additionalinfo.out
echo "----------------------------------------------------------------------------" &>> /var/log/xms/additionalinfo.out
uptime &>> /var/log/xms/additionalinfo.out
echo "----------------------------------------------------------------------------" &>> /var/log/xms/additionalinfo.out
echo "top -b -n 1" &>> /var/log/xms/additionalinfo.out
echo "----------------------------------------------------------------------------" &>> /var/log/xms/additionalinfo.out
top -b -n 1 &>> /var/log/xms/additionalinfo.out
echo "----------------------------------------------------------------------------" &>> /var/log/xms/additionalinfo.out
echo "sar -A" &>> /var/log/xms/additionalinfo.out
echo "----------------------------------------------------------------------------" &>> /var/log/xms/additionalinfo.out
sar -A &>> /var/log/xms/additionalinfo.out
echo "----------------------------------------------------------------------------" &>> /var/log/xms/additionalinfo.out
echo "proc/meminfo" &>> /var/log/xms/additionalinfo.out
echo "----------------------------------------------------------------------------" &>> /var/log/xms/additionalinfo.out
cat /proc/meminfo &>> /var/log/xms/additionalinfo.out
echo "----------------------------------------------------------------------------" &>> /var/log/xms/additionalinfo.out
echo "proc/cpuinfo" &>> /var/log/xms/additionalinfo.out
echo "----------------------------------------------------------------------------" &>> /var/log/xms/additionalinfo.out
cat /proc/cpuinfo &>> /var/log/xms/additionalinfo.out
echo "----------------------------------------------------------------------------" &>> /var/log/xms/additionalinfo.out
echo "lscpu" &>> /var/log/xms/additionalinfo.out
echo "----------------------------------------------------------------------------" &>> /var/log/xms/additionalinfo.out
lscpu &>> /var/log/xms/additionalinfo.out
echo "----------------------------------------------------------------------------" &>> /var/log/xms/additionalinfo.out
echo "systemctl list-unit-files " &>> /var/log/xms/additionalinfo.out
echo "----------------------------------------------------------------------------" &>> /var/log/xms/additionalinfo.out
systemctl list-unit-files  &>> /var/log/xms/additionalinfo.out
echo "----------------------------------------------------------------------------" &>> /var/log/xms/additionalinfo.out
echo "chkconfig --list " &>> /var/log/xms/additionalinfo.out
echo "----------------------------------------------------------------------------" &>> /var/log/xms/additionalinfo.out
chkconfig --list  &>> /var/log/xms/additionalinfo.out
setpass;
next

step "Collecting other system and configuration data"
echo "----------------------------------------------------------------------------" &>> /var/log/xms/additionalinfo.out
echo "sestatus" &>> /var/log/xms/additionalinfo.out
echo "----------------------------------------------------------------------------" &>> /var/log/xms/additionalinfo.out
sestatus &>> /var/log/xms/additionalinfo.out
echo "----------------------------------------------------------------------------" &>> /var/log/xms/additionalinfo.out
echo "env" &>> /var/log/xms/additionalinfo.out
echo "----------------------------------------------------------------------------" &>> /var/log/xms/additionalinfo.out
env &>> /var/log/xms/additionalinfo.out
echo "----------------------------------------------------------------------------" &>> /var/log/xms/additionalinfo.out
echo "ethtool --show-offload" &>> /var/log/xms/additionalinfo.out
echo "----------------------------------------------------------------------------" &>> /var/log/xms/additionalinfo.out
for nic in `ls /sys/class/net` ; do ethtool --show-offload $nic; done &>> /var/log/xms/additionalinfo.out
echo "----------------------------------------------------------------------------" &>> /var/log/xms/additionalinfo.out
echo "lspci" &>> /var/log/xms/additionalinfo.out
echo "----------------------------------------------------------------------------" &>> /var/log/xms/additionalinfo.out
lspci &>> /var/log/xms/additionalinfo.out
echo "----------------------------------------------------------------------------" &>> /var/log/xms/additionalinfo.out
echo "sysctl -A" &>> /var/log/xms/additionalinfo.out
echo "----------------------------------------------------------------------------" &>> /var/log/xms/additionalinfo.out
sysctl -A &>> /var/log/xms/additionalinfo.out
echo "----------------------------------------------------------------------------" &>> /var/log/xms/additionalinfo.out
echo "dmidecode | egrep -i 'manufacturer|product|vendor'" &>> /var/log/xms/additionalinfo.out
echo "----------------------------------------------------------------------------" &>> /var/log/xms/additionalinfo.out
dmidecode | egrep -i 'manufacturer|product|vendor' &>> /var/log/xms/additionalinfo.out
echo "----------------------------------------------------------------------------" &>> /var/log/xms/additionalinfo.out
echo "dmidecode " &>> /var/log/xms/additionalinfo.out
echo "----------------------------------------------------------------------------" &>> /var/log/xms/additionalinfo.out
dmidecode  &>> /var/log/xms/additionalinfo.out
echo "----------------------------------------------------------------------------" &>> /var/log/xms/additionalinfo.out
echo "dmesg " &>> /var/log/xms/additionalinfo.out
echo "----------------------------------------------------------------------------" &>> /var/log/xms/additionalinfo.out
dmesg  &>> /var/log/xms/additionalinfo.out
echo "----------------------------------------------------------------------------" &>> /var/log/xms/additionalinfo.out
echo "ulimit -a " &>> /var/log/xms/additionalinfo.out
echo "----------------------------------------------------------------------------" &>> /var/log/xms/additionalinfo.out
ulimit -a  &>> /var/log/xms/additionalinfo.out
echo "----------------------------------------------------------------------------" &>> /var/log/xms/additionalinfo.out
echo "uname -a " &>> /var/log/xms/additionalinfo.out
echo "----------------------------------------------------------------------------" &>> /var/log/xms/additionalinfo.out
uname -a  &>> /var/log/xms/additionalinfo.out
setpass;
next

step "Collecting XMS WebUI information"
touch /var/log/xms/webuiinfo.out
echo "" > /var/log/xms/webuiinfo.out
#echo "############################################################################" &>> /var/log/xms/webuiinfo.out
#echo "WebUI" &>> /var/log/xms/webuiinfo.out
#echo "############################################################################" &>> /var/log/xms/webuiinfo.out
#echo "----------------------------------------------------------------------------" &>> /var/log/xms/webuiinfo.out
#curl http://127.0.0.1:10080/system &>> /var/log/xms/webuiinfo.out 2> /dev/null
#echo "----------------------------------------------------------------------------" &>> /var/log/xms/webuiinfo.out
#curl http://127.0.0.1:10080/system/network &>> /var/log/xms/webuiinfo.out 2> /dev/null
#echo "----------------------------------------------------------------------------" &>> /var/log/xms/webuiinfo.out
#curl http://127.0.0.1:10080/system/network/eth0 &>> /var/log/xms/webuiinfo.out 2> /dev/null
#echo "----------------------------------------------------------------------------" &>> /var/log/xms/webuiinfo.out
#curl http://127.0.0.1:10080/license &>> /var/log/xms/webuiinfo.out 2> /dev/null
#echo "----------------------------------------------------------------------------" &>> /var/log/xms/webuiinfo.out
#curl http://127.0.0.1:10080/codecs &>> /var/log/xms/webuiinfo.out 2> /dev/null
#echo "----------------------------------------------------------------------------" &>> /var/log/xms/webuiinfo.out
#curl http://127.0.0.1:10080/services &>> /var/log/xms/webuiinfo.out 2> /dev/null
#echo "----------------------------------------------------------------------------" &>> /var/log/xms/webuiinfo.out
#curl http://127.0.0.1:10080/sip &>> /var/log/xms/webuiinfo.out 2> /dev/null
#echo "----------------------------------------------------------------------------" &>> /var/log/xms/webuiinfo.out
#curl http://127.0.0.1:10080/routing &>> /var/log/xms/webuiinfo.out 2> /dev/null
#echo "----------------------------------------------------------------------------" &>> /var/log/xms/webuiinfo.out
#curl http://127.0.0.1:10080/rtp &>> /var/log/xms/webuiinfo.out 2> /dev/null
#echo "----------------------------------------------------------------------------" &>> /var/log/xms/webuiinfo.out
#curl http://127.0.0.1:10080/msml &>> /var/log/xms/webuiinfo.out 2> /dev/null
#echo "----------------------------------------------------------------------------" &>> /var/log/xms/webuiinfo.out
#curl http://127.0.0.1:10080/mrcpclient &>> /var/log/xms/webuiinfo.out 2> /dev/null
#echo "----------------------------------------------------------------------------" &>> /var/log/xms/webuiinfo.out
#curl http://127.0.0.1:10080/httpclient &>> /var/log/xms/webuiinfo.out 2> /dev/null
#echo "----------------------------------------------------------------------------" &>> /var/log/xms/webuiinfo.out
OAMHOST="127.0.0.1"
OAMPORT="10080"
dumpsubs(){
local CURPATH=$1
local RESPONSE="$(curl -s http://$OAMHOST:$OAMPORT$CURPATH)"
echo -e "\n------------------------------------------------------------------------------"&>> /var/log/xms/webuiinfo.out
echo -e "$CURPATH"&>> /var/log/xms/webuiinfo.out
echo -e "------------------------------------------------------------------------------"&>> /var/log/xms/webuiinfo.out
echo -e "$RESPONSE\n" &>> /var/log/xms/webuiinfo.out
local ITEMS="$(echo -e "$RESPONSE" |grep uri |  grep resource | awk -F'"' '{print $2}')"
#echo $ITEMS
for item in $ITEMS
do
	#omit getting the media and backup for performance sake
	 if [[ ${CURPATH} != *"/media/prompts"* ]] && [[ ${CURPATH} != *"/system/backup"* ]]; then
   		dumpsubs "$CURPATH/$item"
	fi
done
}
echo -e "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" &>> /var/log/xms/webuiinfo.out
echo -e "XMS FULL WebUI Dump" &>> /var/log/xms/webuiinfo.out
echo -e "host:      `hostname`" &>> /var/log/xms/webuiinfo.out
echo -e "OAM:       http://$OAMHOST:$OAMPORT" &>> /var/log/xms/webuiinfo.out
echo -e "starttime: $starttime" &>> /var/log/xms/webuiinfo.out
echo -e "Outfile:   $OUTFILE" &>> /var/log/xms/webuiinfo.out
echo -e "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" &>> /var/log/xms/webuiinfo.out
dumpsubs ""
setpass;
next


step "Collecting XMS media file information"
touch /var/log/xms/mediafileinfo.out
echo "" > /var/log/xms/mediafileinfo.out
echo "----------------------------------------------------------------------------" &>> /var/log/xms/mediafileinfo.out
echo Cache Info &>> /var/log/xms/mediafileinfo.out
echo "----------------------------------------------------------------------------" &>> /var/log/xms/mediafileinfo.out
echo `ls -l /var/cache/xms/http/xmserver/ |wc -l` files found in cache &>> /var/log/xms/mediafileinfo.out
echo Files- &>> /var/log/xms/mediafileinfo.out
ls -la /var/cache/xms/http/xmserver/ &>> /var/log/xms/mediafileinfo.out
echo "----------------------------------------------------------------------------" &>> /var/log/xms/mediafileinfo.out
echo Media Files &>> /var/log/xms/mediafileinfo.out
echo "----------------------------------------------------------------------------" &>> /var/log/xms/mediafileinfo.out
find /var/lib/xms/media -type f -name '*' -exec ls -al {} \; &>> /var/log/xms/mediafileinfo.out

echo "----------------------------------------------------------------------------" &>> /var/log/xms/mediafileinfo.out
echo Small Files &>> /var/log/xms/mediafileinfo.out
echo "----------------------------------------------------------------------------" &>> /var/log/xms/mediafileinfo.out
find / -type f -size -16c -name '*.amr' -printf "%p  - %c - %k KB\n"  &>> /var/log/xms/webuiinfo.out
find / -type f -size -16c -name '*.wav' -printf "%p  - %c - %k KB\n"  &>> /var/log/xms/webuiinfo.out

echo "----------------------------------------------------------------------------" &>> /var/log/xms/mediafileinfo.out
echo All Files &>> /var/log/xms/mediafileinfo.out
echo "----------------------------------------------------------------------------" &>> /var/log/xms/mediafileinfo.out
find / -type f -name '*.amr' -exec ls -al {} \;  &>> /var/log/xms/mediafileinfo.out
setpass;
next

step "Collecting XMS core dump information"
echo "Listing:" &>> /var/log/xms/abrtinfo.out
ls -altr /var/tmp/abrt &>> /var/log/xms/abrtinfo.out
echo "last-ccpp:" &>> /var/log/xms/abrtinfo.out
cat /var/tmp/abrt/last-ccpp &>> /var/log/xms/abrtinfo.out
echo "" &>> /var/log/xms/abrtinfo.out

for filename in /var/tmp/abrt/*; do
if [ -d $filename ]
then
        echo "======================== START ================================" &>> /var/log/xms/abrtinfo.out
        echo "$filename" &>> /var/log/xms/abrtinfo.out
        echo "===============================================================" &>> /var/log/xms/abrtinfo.out
        echo "                     EXECUTABLE                                " &>> /var/log/xms/abrtinfo.out
        echo "---------------------------------------------------------------" &>> /var/log/xms/abrtinfo.out
        cat $filename/executable &>> /var/log/xms/abrtinfo.out
        echo "" &>> /var/log/xms/abrtinfo.out
        echo "---------------------------------------------------------------" &>> /var/log/xms/abrtinfo.out
        echo "                      REASON                                   " &>> /var/log/xms/abrtinfo.out
        echo "---------------------------------------------------------------" &>> /var/log/xms/abrtinfo.out
        cat $filename/reason &>> /var/log/xms/abrtinfo.out
        echo "" &>> /var/log/xms/abrtinfo.out
        echo "---------------------------------------------------------------" &>> /var/log/xms/abrtinfo.out
        echo "                     BACKTRACE                                 " &>> /var/log/xms/abrtinfo.out
        echo "---------------------------------------------------------------" &>> /var/log/xms/abrtinfo.out
        cat $filename/core_backtrace &>> /var/log/xms/abrtinfo.out
        echo "" &>> /var/log/xms/abrtinfo.out
        echo "===============================================================" &>> /var/log/xms/abrtinfo.out
        echo "$filename" &>> /var/log/xms/abrtinfo.out
        echo "=====================i===  END  ===============================" &>> /var/log/xms/abrtinfo.out
fi
done
setpass;
next

step "Compressing system and XMS debug logs"
tar cvzf $OUTFILE --exclude='*.tgz' --exclude='xmsbackup*.tar.gz' /var/log/xms /var/log/dialogic /var/log/messages* /etc/profile.d/ct_intel.sh /etc/xms /usr/dialogic/cfg /etc/hosts /var/lib/xms/meters/currentValue.txt /etc/fstab /etc/cluster/cluster.conf /etc/sysctl.conf /etc/sysconfig &>/dev/null
setpass;
next

echo -e "\n\n File saved to $OUTFILE\n\n"
