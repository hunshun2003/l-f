#!/bin/bash
python3 leader1.py $1 $2 &
python3 avoid1.py $1 $2 vel &
uav_id=1
while(( $uav_id< $2 ))
do
    python3 follower1.py $1 $uav_id $2 &
    let "uav_id++"
done
