#!/bin/bash

max_consecutive_failures=1

tetherlog=/tmp/tether_log

cat <<< "0
0" > "$tetherlog"

adb logcat -b all -c

while true; do

sleep 1
TZ=America/New_York date

# check if adb device detected
adb devices | grep -v "devices" | grep "device" &> /dev/null
if [ $? -eq 1 ]; then
    echo "No adb devices detected"
    continue
fi

# check if tether client is running
pgrep -f "linux/run.sh" &> /dev/null
if [ $? -eq 1 ]; then
    echo "No tether process running"
    continue
fi

# init/read counter from file
counter=0
num_restarts=0
if [ -f "$tetherlog" ]; then
    counter=$(head -n 1 $tetherlog)
    num_restarts=$(head -n 2 $tetherlog | tail -n 1)
fi
echo "Number of connectivity failures: $counter"
echo "Number of restarts: $num_restarts"

# check for internet (web) connectivity
# wget -q --spider http://google.com
# echo -e "GET http://google.com HTTP/1.0\n\n" | nc google.com 80 > /dev/null 2>&1
# ping -q -w1 -c1 google.com &>/dev/null && echo online || echo offline
# ping -q -w2 -c1 google.com &> /dev/null
logcat=$(adb logcat -t 500)
echo $logcat | grep -i "unknown exception\|uncaught exception" &> /dev/null

if [ $? -ne 0 ]; then
    echo "Online"
    counter=0
else
    echo "Offline"
    (( counter += 1 ))
    if [ $counter -ge $max_consecutive_failures ]; then
        # no internet connectivity, restart phone tether app and reset counter
        adb shell am force-stop "com.koushikdutta.tether"
	adb logcat -b all -c
	echo $logcat
        counter=0
        (( num_restarts += 1 ))
	sleep 10
    fi
fi

# save to file for next time the cron job runs
cat <<< "$counter
$num_restarts" > "$tetherlog"

done
