# UsefulScripts
This is a collection of tools and scripts that can be used to monitor, administrate or troubleshoot your Dialogic platform

### xmsinfo.sh
This tool can be used to collect system level information and logs.  It is used to gather and review data for debugging issues with the XMS services or the OS environment.

_Note: Is is recommended that this script be run with root access either as root account or via sudo_

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
