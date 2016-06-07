#!/bin/bash

#will do the compress every ~240 x 15 or 3600 seconds (1hour)
COUNTTILLZIP=240
SLEEPTIME=15

trap onExit INT SIGHUP SIGINT SIGTERM

function onExit() {
    clear
    echo "Exit Trap Received"
    echo "Generating final tgz monitor-$starttime-final.tgz"
	sar -A > sar-output.txt
    tar cvzf "monitor-$starttime-final.tgz" *-output.txt /var/lib/xms/meters/rrd /var/log/messages
    echo 'Clearing temp files'
       rm -f tmptop.txt
       rm -f tmpps.txt
       rm -f sar-output.txt
       rm -f top-output.txt
       rm -f ps-output.txt
       rm -f meters-output.txt
       rm -f topthreads-output.txt
       rm -f tmp-network.txt
    echo -e "Cleanup complete!\n"
    echo -e "Exiting\n\n"
    exit 
}

#Put here anything that should be done once per script run
#start network capture 
# Comment out line with tcpdump if you don't want network tracing 
echo -e "Starting background network trace for 4xx and 5xx errors\n" 
rm -f tmp-network.txt
tcpdump -i any -v port 5060 | grep -P "SIP/2.0 [4|5]" > tmp-network.txt &

while true
do
       LOOPCOUNTER=0
       #clean up the temp files used as old ones are no saved in tgz
       echo 'Clearing temp files'
       rm -f tmptop.txt
       rm -f tmpps.txt
       rm -f top-output.txt
       rm -f ps-output.txt
       rm -f meters-output.txt
       rm -f topthreads-output.txt
       
       starttime=`date +"%y_%m_%d-%H_%M_%S.%3N"`
       hostname=`hostname`
       
       while [ $LOOPCOUNTER -lt $COUNTTILLZIP ]; do
       let LOOPCOUNTER=LOOPCOUNTER+1
       clear
       looptimestamp=`date +"%y-%m-%d_%H:%M:%S.%3N"`
       echo -e $looptimestamp "-" $hostname [$LOOPCOUNTER out of $COUNTTILLZIP]"\n"
       echo -e "\nDisk/Mem Usage:"
         free -m
       #echo -e "\n"
       # df
       #echo -e "\n\n\nUptime:" `uptime`
	   #echo -e "\nXMS Cache file count:"
	   #echo `ls -l /var/cache/xms/http/xmserver/ | wc -l`

        top -b -n 1  > tmptop.txt
        
	    echo -e $looptime stamp "----------------"  > tmpps.txt
	    ps -A  -Lo %cpu,pid,lwp,comm=,args >> tmpps.txt
	    
        echo -e "\n\nCPU Intensive Threads:"
	      grep -P '^ *[0-9][0-9][0-9]\.' tmpps.txt
          grep -P '^ *[4-9][0-9]\.' tmpps.txt
          
        echo -e "\n\nTop Info:"
          grep Cpu tmptop.txt 
          grep Mem: tmptop.txt
          grep Swap: tmptop.txt
	    echo -e "\n"
	      grep PID tmptop.txt
          grep ssp tmptop.txt
          grep appmanager tmptop.txt
          grep xmserver tmptop.txt
        
        #these can be commended out based on tech used
          grep msml tmptop.txt
          grep vxml tmptop.txt
          grep rest tmptop.txt
          grep netann tmptop.txt
        
          grep httpclient tmptop.txt

        #used by mrb/lb
        #  grep java tmptop.txt
        
        #Alternatively you can use
        #top -n 1 -b | head -20

	    
        echo -e "\n\nMeters(if available):"
          grep xmsRtpSessions /var/lib/xms/meters/currentValue.txt
          grep xmsSignalingSessions /var/lib/xms/meters/currentValue.txt
          grep calls.active /var/lib/xms/meters/currentValue.txt
          grep xmsMediaTransactions /var/lib/xms/meters/currentValue.txt
#        grep xmsLicenseUsage /var/lib/xms/meters/currentValue.txt

#	mpstat -P ALL 1 | tee mpstats.txt

        if [[ -f tmp-network.txt ]] ;
        then
            echo -e "\n\nNetwork Error count:" `cat tmp-network.txt | wc -l ` "\n"
            #cat tmp-network.txt >> networkerror-output.txt
            cat /dev/null > tmp-network.txt
        fi
        
        echo -e  "\n$looptime-$hostname\n" >> top-output.txt
        cat tmptop.txt >> top-output.txt
        echo -e  "\n$looptime-$hostname\n" >> ps-output.txt
	    cat tmpps.txt >> ps-output.txt
        echo -e "\n$looptime-$hostname\n" >> meters-output.txt
        cat /var/lib/xms/meters/currentValue.txt >> meters-output.txt
       
        echo -e  "\n$looptime-$hostname\n" >> topthreads-output.txt
        top -b -n 1 -H >> topthreads-output.txt
	
        
        ## additional activites or spy can be done here such as watching messagefile or netcap for 15 seconds or looking for errors to print
        #timeout $SLEEPTIME tail -F -n0 tmp-network.txt
        #timeout $SLEEPTIME ./scripttorunfortime.sh
        echo -e "\n\n"
        sleep $SLEEPTIME

        rm -f tmptop.txt
        rm -f tmpps.txt
	        
        done
##put all things there that need to be gathered once per compress loop

	sar -A > sar-output.txt

    tar cvzf "monitor-$starttime.tgz" *-output.txt /var/lib/xms/meters/rrd /var/log/messages
    #delete files over 7 days old   
    find . -name 'monitor-*.tgz' -mtime +7 -delete
done

onExit