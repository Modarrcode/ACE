#! /usr/bin/env bash
# author: I
# date created: today
# version: 0.0.1
# notes: Stuff and junk


# Display help message
USAGE(){
	echo -E
	echo $1
	echo -e "\nUsage:\n systemStats [-t temperature] [-f core-frequency] [-c cores] [-V volts]"
	echo -e "\t\t [-m arm mem] [-M gpu mem] [-f free memory] [-i ipv4 and ipv6 address]"
	echo -e "\t\t [-v version] [-h help]"
	echo -e "\t\t more information see: man systemstats"

}

# Check for arguments

if [ $# -lt 1 ];then
	USAGE "No argument detected"
	exit 1
elif [ $# -gt 10 ];then
	USAGE "Too many arguments"
elif [[ ( $1 == '--help') || ( $1 == '-h' ) ]];then
	USAGE "Help"
	exit 0

fi


# Frequently a script is written so that arguments can be passed in any order using 'flags'
# with flags method,some of the arguments can be made optional
#'a:b' means that 'a' is mandatory and requires an argument after the 'a' and 'b' is not, 'abc' means they all are optional

while getopts tfcVmMfivh OPTION
do
case ${OPTION}
in
t) TEMP=$(vcgencmd measure_temp | awk -F '=' '{print$2}')
   TEMPFULL=$(cat /sys/class/thermal/thermal_zone0/temp | awk '{print substr($0,1,2) "." substr($0,3) C}')
   echo "Temperature: ${TEMP}"
   echo "Full temperature: ${TEMPFULL}";;
m) ARM=$(vcgencmd get_mem arm | awk -F '=' '{print$2}')
   echo "arm memory: ${ARM}";;
M) GPU=$(vcgencmd get_mem gpu | awk -F '=' '{print$2}')
    echo "gpu memory: ${GPU}";;
f)  FREE=$(free -m | awk -F '=' '{print$1}')
    echo -e "free memory: \n ${FREE}";;
i) IFCONFIG=$(ifconfig wlan0 | grep inet -m 1  | awk '{print$2}')
    echo "IP: ${IFCONFIG}";;
c) CPU=$(cat /sys/devices/system/cpu/present)
    echo "Core amounts: ${CPU}";;
V) VOLTS=$(vcgencmd measure_volts | awk -F '=' '{print$2}')
     echo "Voltage: ${VOLTS}";;

*)  USAGE "\n ${*} argument was not recognised";;
esac
done
