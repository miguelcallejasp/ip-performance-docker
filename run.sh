#! /bin/bash

set -e

ROLE=${ROLE:="tx"}
DESTINATION=${DESTINATION:="rx"}
MIN_MTU=${MTU:=1450}
MAX_MTU=${MTU:=1600}
L4P=${L4P:="TCP"}

if [ $ROLE = "tx" ]; then

echo "Getting MTU setup for destination: $DESTINATION"
  for ((MTU=$MIN_MTU; MTU<=$MAX_MTU; MTU++))
  do
  ping -s $MTU -c1 $DESTINATION | grep -E "PING"
  ping -s $MTU -c1 $DESTINATION | grep -E "rtt" | tee -a rtt
  ping -s $MTU -c1 $DESTINATION | awk '/icmp_seq/ { print $7 }' | tee -a avg_time
  done

echo "Configured MTU: "
ifconfig | grep MTU

sleep 3
echo "------------------------------------------------------------"
echo "Establishing connection with $DESTINATION 1 second int. 30 samples MSS"
echo "------------------------------------------------------------"
iperf -c $DESTINATION -i1 -t30 -m
echo "------------------------------------------------------------"
echo "Establishing connection with $DESTINATION BIDERECTIONAL 30 samples MSS"
echo "------------------------------------------------------------"
iperf -c $DESTINATION -d -i1 -t10 -m
echo "------------------------------------------------------------"
echo "Establishing connection with $DESTINATION PARALLEL (2) 10 samples MSS"
echo "------------------------------------------------------------"
iperf -c $DESTINATION -P2 -i1 -t10 -m
echo "------------------------------------------------------------"
echo "Establishing connection with $DESTINATION PARALLEL (4) 10 samples MSS"
echo "------------------------------------------------------------"
iperf -c $DESTINATION -P4 -i1 -t10 -m
echo "------------------------------------------------------------"
echo "Establishing connection with $DESTINATION PARALLEL (8) 10 samples MSS"
echo "------------------------------------------------------------"
iperf -c $DESTINATION -P4 -i1 -t10 -m
echo "------------------------------------------------------------"
echo "Establishing connection with $DESTINATION Force Window Size 10 samples MSS"
echo "------------------------------------------------------------"
iperf -c $DESTINATION -i1 -t10 -m -w 8000
exit 0

else

echo "Container set in Receiver mode"
	if [ $L4P = "TCP" ]; then
	echo "Test will begin with Layer 4 Protocol: TCP"
	iperf -s
	fi
	if [ $L4P = "UDP" ]; then
	echo "Test will begin with Layer 4 Protocol: UDP"
	iperf -su
	fi
fi
