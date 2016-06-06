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
``` bash
16-06-05_19:55:28.501 - xms [1 out of 240]
Disk/Mem Usage:
             total       used       free     shared    buffers     cached
Mem:          7824       5052       2771         11          0       3102
-/+ buffers/cache:       1949       5874
Swap:         8079          0       8079

CPU Intensive Threads:

Top Info:
%Cpu(s):  0.7 us,  6.1 sy,  0.0 ni, 93.0 id,  0.0 wa,  0.0 hi,  0.1 si,  0.0 st
KiB Mem:   8011996 total,  5175232 used,  2836764 free,      752 buffers
KiB Swap:  8273916 total,        0 used,  8273916 free.  3176904 cached Mem


  PID USER      PR  NI    VIRT    RES    SHR S  %CPU %MEM     TIME+ COMMAND
10007 root      rt   0 2652480 646256 121436 S   0.0  8.1 709:54.20 ssp_x86Linux_bo
12532 root      20   0  187424   2324   1896 S   0.0  0.0   0:46.40 appmanager
12509 root      20   0  316604  48432  17000 S   0.0  0.6  52:24.44 xmserver
12698 root      20   0 1524784   5216   3312 S   0.0  0.1  10:23.55 msml_main
12692 root      20   0 2525180  25344   7452 S   6.5  0.3  26:12.17 vxmlinterpreter
12546 root      20   0 1639812   4848   3976 S   0.0  0.1   7:02.31 xmsrest
12576 root      20   0  177616   1644   1332 S   0.0  0.0   7:00.27 netann
12514 root      20   0  170116   2504   1536 S   0.0  0.0   0:00.00 httpclient
12598 root      20   0  170116   2500   1536 S   0.0  0.0   0:00.00 httpclient
12850 root      20   0  170116   2504   1536 S   0.0  0.0   0:00.00 httpclient


Meters(if available):
xmsResources.xmsRtpSessions = 0
xmsResources.xmsSignalingSessions = 0
msml.resources.calls.active = 0
msml.resources.xmscalls.active = 0
xmsResources.xmsMediaTransactions = 0


Network Error count: 0
```

### genXMScores.sh
This bash script can be used to collect system level information and cores for the running XMS processes.

By default it will create a directory named xmscores-YYY-MM-DD_hh-mm-ss and save in it the core files, executable binaries and xmsinfo output.

The script will also try and obtain the backtrace for each of the core files and will save it to `corebtinfo.log`


_Note: It is recommended that this script be run with root access either as root account or via sudo_

Usage:
``` bash
xms# ./genXMScores.sh  
```

## License
Copyright © 2016 Dialogic Corporation.

Permission is hereby granted, free of charge, to any person obtaining a copy of this sample software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, and /or sublicense the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

__Third Party Software__

Third party software (e.g., drivers, utilities, operating system components, etc.) which may be distributed with the Software will also be subject to the terms and conditions of any third party licenses, which may be supplied with such third party software.
