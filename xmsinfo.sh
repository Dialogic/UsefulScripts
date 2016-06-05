#!/bin/bash
starttime=`date +"%Y-%m-%d_%H-%M-%S"`
OUTFILE=xmsinfo-$starttime.tgz

if [ $# -eq 1 ]; then
	OUTFILE=$1
fi

ls -lR /usr/dialogic > /var/log/xms/dirlisting.out


touch /var/log/xms/additionalinfo.out
echo "" > /var/log/xms/additionalinfo.out


echo "----------------------------------------------------------------------------" >> /var/log/xms/additionalinfo.out
echo "ifconfig" >> /var/log/xms/additionalinfo.out
echo "----------------------------------------------------------------------------" >> /var/log/xms/additionalinfo.out
ifconfig >> /var/log/xms/additionalinfo.out
echo "----------------------------------------------------------------------------" >> /var/log/xms/additionalinfo.out
echo "ps -fe" >> /var/log/xms/additionalinfo.out
echo "----------------------------------------------------------------------------" >> /var/log/xms/additionalinfo.out
ps -fe >> /var/log/xms/additionalinfo.out
echo "----------------------------------------------------------------------------" >> /var/log/xms/additionalinfo.out
echo "rpm -qa" >> /var/log/xms/additionalinfo.out
echo "----------------------------------------------------------------------------" >> /var/log/xms/additionalinfo.out
rpm -qa >> /var/log/xms/additionalinfo.out
echo "----------------------------------------------------------------------------" >> /var/log/xms/additionalinfo.out
echo "netstat -anope" >> /var/log/xms/additionalinfo.out
echo "----------------------------------------------------------------------------" >> /var/log/xms/additionalinfo.out
netstat -anope >> /var/log/xms/additionalinfo.out
echo "----------------------------------------------------------------------------" >> /var/log/xms/additionalinfo.out
echo "route" >> /var/log/xms/additionalinfo.out
echo "----------------------------------------------------------------------------" >> /var/log/xms/additionalinfo.out
route >> /var/log/xms/additionalinfo.out
echo "----------------------------------------------------------------------------" >> /var/log/xms/additionalinfo.out
echo "df -h" >> /var/log/xms/additionalinfo.out
echo "----------------------------------------------------------------------------" >> /var/log/xms/additionalinfo.out
df -h >> /var/log/xms/additionalinfo.out
echo "----------------------------------------------------------------------------" >> /var/log/xms/additionalinfo.out
echo "free -ml" >> /var/log/xms/additionalinfo.out
echo "----------------------------------------------------------------------------" >> /var/log/xms/additionalinfo.out
free -ml >> /var/log/xms/additionalinfo.out
echo "----------------------------------------------------------------------------" >> /var/log/xms/additionalinfo.out
echo "uptime" >> /var/log/xms/additionalinfo.out
echo "----------------------------------------------------------------------------" >> /var/log/xms/additionalinfo.out
uptime >> /var/log/xms/additionalinfo.out
echo "----------------------------------------------------------------------------" >> /var/log/xms/additionalinfo.out
echo "top -b -n 1" >> /var/log/xms/additionalinfo.out
echo "----------------------------------------------------------------------------" >> /var/log/xms/additionalinfo.out
top -b -n 1 >> /var/log/xms/additionalinfo.out
echo "----------------------------------------------------------------------------" >> /var/log/xms/additionalinfo.out
echo "sar -A" >> /var/log/xms/additionalinfo.out
echo "----------------------------------------------------------------------------" >> /var/log/xms/additionalinfo.out
sar -A >> /var/log/xms/additionalinfo.out
echo "----------------------------------------------------------------------------" >> /var/log/xms/additionalinfo.out
echo "iptables --list" >> /var/log/xms/additionalinfo.out
echo "----------------------------------------------------------------------------" >> /var/log/xms/additionalinfo.out
iptables --list >> /var/log/xms/additionalinfo.out
echo "----------------------------------------------------------------------------" >> /var/log/xms/additionalinfo.out
echo "firewall-cmd --list-all-zones" >> /var/log/xms/additionalinfo.out
echo "----------------------------------------------------------------------------" >> /var/log/xms/additionalinfo.out
firewall-cmd --list-all-zones >> /var/log/xms/additionalinfo.out
echo "----------------------------------------------------------------------------" >> /var/log/xms/additionalinfo.out
echo "hostname" >> /var/log/xms/additionalinfo.out
echo "----------------------------------------------------------------------------" >> /var/log/xms/additionalinfo.out
hostname >> /var/log/xms/additionalinfo.out
echo "----------------------------------------------------------------------------" >> /var/log/xms/additionalinfo.out
echo "ping hostname" >> /var/log/xms/additionalinfo.out
echo "----------------------------------------------------------------------------" >> /var/log/xms/additionalinfo.out
ping `hostname` -c 1 >> /var/log/xms/additionalinfo.out
echo "----------------------------------------------------------------------------" >> /var/log/xms/additionalinfo.out
echo "env" >> /var/log/xms/additionalinfo.out
echo "----------------------------------------------------------------------------" >> /var/log/xms/additionalinfo.out
env >> /var/log/xms/additionalinfo.out
echo "----------------------------------------------------------------------------" >> /var/log/xms/additionalinfo.out
echo "proc/meminfo" >> /var/log/xms/additionalinfo.out
echo "----------------------------------------------------------------------------" >> /var/log/xms/additionalinfo.out
cat /proc/meminfo >> /var/log/xms/additionalinfo.out
echo "----------------------------------------------------------------------------" >> /var/log/xms/additionalinfo.out
echo "proc/cpuinfo" >> /var/log/xms/additionalinfo.out
echo "----------------------------------------------------------------------------" >> /var/log/xms/additionalinfo.out
cat /proc/cpuinfo >> /var/log/xms/additionalinfo.out
echo "----------------------------------------------------------------------------" >> /var/log/xms/additionalinfo.out
echo "lscpu" >> /var/log/xms/additionalinfo.out
echo "----------------------------------------------------------------------------" >> /var/log/xms/additionalinfo.out
lscpu >> /var/log/xms/additionalinfo.out
echo "----------------------------------------------------------------------------" >> /var/log/xms/additionalinfo.out
echo "/etc/system-release" >> /var/log/xms/additionalinfo.out
echo "----------------------------------------------------------------------------" >> /var/log/xms/additionalinfo.out
cat /etc/system-release >> /var/log/xms/additionalinfo.out
echo "----------------------------------------------------------------------------" >> /var/log/xms/additionalinfo.out
echo "cron tasks" >> /var/log/xms/additionalinfo.out
echo "----------------------------------------------------------------------------" >> /var/log/xms/additionalinfo.out
crontab -l >> /var/log/xms/additionalinfo.out
cat /etc/passwd | sed 's/^\([^:]*\):.*$/crontab -u \1 -l 2>\&1/' | grep -v "no crontab for" | sh >> /var/log/xms/additionalinfo.out
echo "----------------------------------------------------------------------------" >> /var/log/xms/additionalinfo.out
echo "ethtool --show-offload" >> /var/log/xms/additionalinfo.out
echo "----------------------------------------------------------------------------" >> /var/log/xms/additionalinfo.out
for nic in `ls /sys/class/net` ; do ethtool --show-offload $nic; done >> /var/log/xms/additionalinfo.out
echo "----------------------------------------------------------------------------" >> /var/log/xms/additionalinfo.out
echo "lspci" >> /var/log/xms/additionalinfo.out
echo "----------------------------------------------------------------------------" >> /var/log/xms/additionalinfo.out
lspci >> /var/log/xms/additionalinfo.out
echo "----------------------------------------------------------------------------" >> /var/log/xms/additionalinfo.out
echo "sysctl -A" >> /var/log/xms/additionalinfo.out
echo "----------------------------------------------------------------------------" >> /var/log/xms/additionalinfo.out
sysctl -A >> /var/log/xms/additionalinfo.out
echo "----------------------------------------------------------------------------" >> /var/log/xms/additionalinfo.out
echo "dmidecode | egrep -i 'manufacturer|product|vendor'" >> /var/log/xms/additionalinfo.out
echo "----------------------------------------------------------------------------" >> /var/log/xms/additionalinfo.out
dmidecode | egrep -i 'manufacturer|product|vendor' >> /var/log/xms/additionalinfo.out
echo "----------------------------------------------------------------------------" >> /var/log/xms/additionalinfo.out
echo "dmidecode " >> /var/log/xms/additionalinfo.out
echo "----------------------------------------------------------------------------" >> /var/log/xms/additionalinfo.out
dmidecode  >> /var/log/xms/additionalinfo.out



touch /var/log/xms/webuiinfo.out
echo "" > /var/log/xms/webuiinfo.out

#echo "############################################################################" >> /var/log/xms/webuiinfo.out
#echo "WebUI" >> /var/log/xms/webuiinfo.out
#echo "############################################################################" >> /var/log/xms/webuiinfo.out
#echo "----------------------------------------------------------------------------" >> /var/log/xms/webuiinfo.out
#curl http://127.0.0.1:10080/system >> /var/log/xms/webuiinfo.out 2> /dev/null
#echo "----------------------------------------------------------------------------" >> /var/log/xms/webuiinfo.out
#curl http://127.0.0.1:10080/system/network >> /var/log/xms/webuiinfo.out 2> /dev/null
#echo "----------------------------------------------------------------------------" >> /var/log/xms/webuiinfo.out
#curl http://127.0.0.1:10080/system/network/eth0 >> /var/log/xms/webuiinfo.out 2> /dev/null
#echo "----------------------------------------------------------------------------" >> /var/log/xms/webuiinfo.out
#curl http://127.0.0.1:10080/license >> /var/log/xms/webuiinfo.out 2> /dev/null
#echo "----------------------------------------------------------------------------" >> /var/log/xms/webuiinfo.out
#curl http://127.0.0.1:10080/codecs >> /var/log/xms/webuiinfo.out 2> /dev/null
#echo "----------------------------------------------------------------------------" >> /var/log/xms/webuiinfo.out
#curl http://127.0.0.1:10080/services >> /var/log/xms/webuiinfo.out 2> /dev/null
#echo "----------------------------------------------------------------------------" >> /var/log/xms/webuiinfo.out
#curl http://127.0.0.1:10080/sip >> /var/log/xms/webuiinfo.out 2> /dev/null
#echo "----------------------------------------------------------------------------" >> /var/log/xms/webuiinfo.out
#curl http://127.0.0.1:10080/routing >> /var/log/xms/webuiinfo.out 2> /dev/null
#echo "----------------------------------------------------------------------------" >> /var/log/xms/webuiinfo.out
#curl http://127.0.0.1:10080/rtp >> /var/log/xms/webuiinfo.out 2> /dev/null
#echo "----------------------------------------------------------------------------" >> /var/log/xms/webuiinfo.out
#curl http://127.0.0.1:10080/msml >> /var/log/xms/webuiinfo.out 2> /dev/null
#echo "----------------------------------------------------------------------------" >> /var/log/xms/webuiinfo.out
#curl http://127.0.0.1:10080/mrcpclient >> /var/log/xms/webuiinfo.out 2> /dev/null
#echo "----------------------------------------------------------------------------" >> /var/log/xms/webuiinfo.out
#curl http://127.0.0.1:10080/httpclient >> /var/log/xms/webuiinfo.out 2> /dev/null
#echo "----------------------------------------------------------------------------" >> /var/log/xms/webuiinfo.out
OAMHOST="127.0.0.1"
OAMPORT="10080"
dumpsubs(){
local CURPATH=$1
local RESPONSE="$(curl -s http://$OAMHOST:$OAMPORT$CURPATH)"
echo -e "\n------------------------------------------------------------------------------">> /var/log/xms/webuiinfo.out
echo -e "$CURPATH">> /var/log/xms/webuiinfo.out
echo -e "------------------------------------------------------------------------------">> /var/log/xms/webuiinfo.out
echo -e "$RESPONSE\n" >> /var/log/xms/webuiinfo.out
local ITEMS="$(echo -e "$RESPONSE" |grep uri |  grep resource | awk -F'"' '{print $2}')"
#echo $ITEMS
for item in $ITEMS
do
   dumpsubs "$CURPATH/$item"
done
}
echo -e "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" >> /var/log/xms/webuiinfo.out
echo -e "XMS FULL WebUI Dump" >> /var/log/xms/webuiinfo.out
echo -e "host:      `hostname`" >> /var/log/xms/webuiinfo.out
echo -e "OAM:       http://$OAMHOST:$OAMPORT" >> /var/log/xms/webuiinfo.out
echo -e "starttime: $starttime" >> /var/log/xms/webuiinfo.out
echo -e "Outfile:   $OUTFILE" >> /var/log/xms/webuiinfo.out
echo -e "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" >> /var/log/xms/webuiinfo.out
dumpsubs "" 




touch /var/log/xms/mediafileinfo.out
echo "" > /var/log/xms/mediafileinfo.out
echo "----------------------------------------------------------------------------" >> /var/log/xms/mediafileinfo.out
echo Cache Info >> /var/log/xms/mediafileinfo.out
echo "----------------------------------------------------------------------------" >> /var/log/xms/mediafileinfo.out
echo `ls -l /var/cache/xms/http/xmserver/ |wc -l` files found in cache >> /var/log/xms/mediafileinfo.out
echo Files- >> /var/log/xms/mediafileinfo.out
ls -la /var/cache/xms/http/xmserver/ >> /var/log/xms/mediafileinfo.out
echo "----------------------------------------------------------------------------" >> /var/log/xms/mediafileinfo.out
echo Media Files >> /var/log/xms/mediafileinfo.out
echo "----------------------------------------------------------------------------" >> /var/log/xms/mediafileinfo.out
find /var/lib/xms/media -type f -name '*' -exec ls -al {} \; >> /var/log/xms/mediafileinfo.out

echo "----------------------------------------------------------------------------" >> /var/log/xms/mediafileinfo.out
echo Small Files >> /var/log/xms/mediafileinfo.out
echo "----------------------------------------------------------------------------" >> /var/log/xms/mediafileinfo.out
find / -type f -size -16c -name '*.amr' -printf "%p  - %c - %k KB\n"  >> /var/log/xms/webuiinfo.out
find / -type f -size -16c -name '*.wav' -printf "%p  - %c - %k KB\n"  >> /var/log/xms/webuiinfo.out

echo "----------------------------------------------------------------------------" >> /var/log/xms/mediafileinfo.out
echo All Files >> /var/log/xms/mediafileinfo.out
echo "----------------------------------------------------------------------------" >> /var/log/xms/mediafileinfo.out 
find / -type f -name '*.amr' -exec ls -al {} \;  >> /var/log/xms/mediafileinfo.out

tar cvzf $OUTFILE --exclude='*.tgz' /var/log/xms /var/log/dialogic /var/log/messages /etc/profile.d/ct_intel.sh /boot/grub/menu.lst /etc/xms /usr/dialogic/cfg /etc/hosts /var/lib/xms/meters/currentValue.txt

echo -e "\n\n File saved to $OUTFILE\n\n"

