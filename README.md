# UsefulScripts
This is a collection of tools and scripts that can be used to monitor, administrate or troubleshoot your Dialogic PowerMedia XMS platform.

## Obtaining the scripts
A zip file with the latest version of the scripts can always be found at https://github.com/Dialogic/UsefulScripts/archive/master.zip
or checked out via git from https://github.com/Dialogic/UsefulScripts.git

This can be obtained directly from you XMS shell by executing
``` bash
wget https://github.com/Dialogic/UsefulScripts/archive/master.zip
```

Individual scripts can be accessed directly
``` bash
wget  https://raw.githubusercontent.com/Dialogic/UsefulScripts/master/xmsinfo.sh
```
_Note: After downloading or extracting the files you may need to change the permissions of the files before they can be executed via the `chmod +x *.sh`_


## Script details
### xmsinfo.sh
This bash script can be used to collect system level information and logs.  It is used to gather and review data for debugging issues with the XMS services or the OS environment.

_Note: It is recommended that this script be run with root access either as root account or via sudo_

By default it will create a tgz in the local directory named xmsinfo-YYY-MM-DD_hh-mm-ss.tgz, but a different location/path can be passed in via command line argument

Usage:
``` bash
xms# ./xmsinfo.sh  
```
or
``` bash
xms# ./xmsinfo.sh /path/to/myfilename.tgz  
```
or
``` bash
xms$ sudo ./xmsinfo.sh
```

This script will collect the following and save it in additionalinfo.out
+ Network configuration (ip address, firewall, port usage)
+ System information (OS version, CPU info, Mem)
+ Package info (rpms install)
+ Process information (ps, env, cron task list)
+ Usage / performance data (top, sar, free, uptime, df)

The script will also export the data in the xmsWebUI and store it in webuiinfo.out, and will also detect and list out saved media files and cache information into mediafileinfo.out

It will package the above with all the xms config files, lic information, XMS logs, HMP(media core) logs and system message logs into the tgz

### gracefulShutdown.sh
This bash script can be used to begin a graceful shutdown of the XMS services.  

By default the graceful shutdown timer is set to 6 mins, but this line `SHUTDOWNTIMER=360` in the script can be changed to the desired values

The `gracefulShutdown.log` will contain the details from the script execution.

Usage:
``` bash
xms# ./gracefulShutdown.sh  
```

### gracefulRestart.sh
This bash scripts can be used to begin a graceful shutdown of the XMS services followed by a restart

By default the graceful shutdown timer is set to 6 mins, but this line `SHUTDOWNTIMER=360` in the script can be changed to the desired values

The `gracefulRestart.log` will contain the details from the script execution.

Usage:
``` bash
xms# ./gracefulRestart.sh  
```

### cacheClear.sh
This bash script can be used to clear the cache of any files that may be there.  

This can be useful as it has been found that allowing the cache to expand to a large number of files can impact the fetch and play times on the system.

The `cacheClear.log` will contain the details from the script execution.

_Note: It is recommended that this script be run with root access either as root account or via sudo_

Usage:
``` bash
xms# ./cacheClear.sh
```

### cacheClearandDisable.sh
This bash script can be used to clear the cache of any files that may be there.  Also, this version of the script will disable the caching of http files.

This can be useful as it has been found that allowing the cache to expand to a large number of files can impact the fetch and play times on the system.  It is recommended that applications that are playing a large number of files with different filenames or files that are not frequently reused (voicemail, custom messaging, etc) disable the cache or frequently clear the cache backlog.

The `cacheClearandDisable.log` will contain the details from the script execution.

_Note: It is recommended that this script be run with root access either as root account or via sudo_

Usage:
``` bash
xms# ./cacheClearandDisable.sh
```

### monitor.sh
This bash script can be used to monitor system level and XMS level resources.  It is useful for monitoring systems in case of failure conditions and to capture performance and environmental data.

This can be used to log information over a long period of time or to simply view the information via the terminal.

Information gathered and displayed on screen each loop:
- System memory/CPU/disk space
- Several XMS meters (SipSessions, RTP sessions, lic counters)
- High CPU usage threads and processes
- Top information for XMS internal processes
- Network 4xx/5xx error counters

Additional detailed information will be saved in the "xxxx-output.txt" files that can be reviewed for historical data.

The screen output will be updated every 15seconds and the historical data files will be compressed to a tgz file every 240 loops (240x15=3600seconds or 1 h).  This timing can be changed by modifying the `COUNTTILLZIP=240` and `SLEEPTIME=15` at the top of the script.

_Note: It is recommended that this script be run with root access either as root account or via sudo_

Usage:
``` bash
xms# ./monitor.sh
```
to run in the background
``` bash
xms# nohup ./monitor.sh > /dev/null &
```

Sample output:
