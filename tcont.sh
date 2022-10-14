#!/bin/bash
# Script for starting and stopping Lxde container 
#
#

#for i in {1..10}
#do	 
#   sudo rsync -axu c0/* c$i
#done

c_no=$1 ; oper=$2 ;
#tpath=/usr/local/lxde1
tpath=
#if

#echo  Command:  sudo docker run --name=lxde1${c_no} --rm -d -p 590${c_no}:5901 tyder/lxde1  $oper 

if [ ${c_no} -lt 1 ] 
then
    c_no=1
elif [ ${c_no} -gt 9 ]
then
    c_no=9
fi    

if [ $oper == 'start' ]
then
    echo  Start:  sudo docker run --name=lxde1${c_no} --rm  -d \
	  -v "$PWD"/c${c_no}/cp_store:${tpath}/store -v "$PWD"/c${c_no}/cp_home:${tpath}/cp_home -p 590${c_no}:5901 tyder/lxde1  $oper
#    
    sudo docker run --name=lxde1${c_no} --rm  -d \
          -v "$PWD"/c${c_no}/cp_store:${tpath}/store -v "$PWD"/c${c_no}/cp_home:${tpath}/cp_home -p 590${c_no}:5901 tyder/lxde1  $oper
   
elif [ $oper == 'stop' ]
then
    echo Stop: sudo docker stop lxde1${c_no}
    sudo docker stop lxde1${c_no}

else
    echo Bad operation argument: $oper, must be start or stop
fi    

#echo  Command:  sudo docker run --name=lxde1${c_no} --rm -d -p 808${c_no}:8080 tyder/lxde1  $oper 
#



#
