仿真环境因为整个上传到github不现实，所以建议直接下载一键安装脚本
https://www.yuque.com/xtdrone/manual_cn/install_scripts
此脚本将会一键安装ros noetic、px4 1.13固件、Gazebo 11、以及XTDrone仿真环境

如果要在地图运行ego仿真，建议不要添加vins定位，一方面不容易跑通，另一方面非常容易飘，建议使用gazebo真值代替定位，修改egoplanner中的定位话题为/mavros/vision_pose/pose

安装好仿真环境后替换目录下的文件为仓库下的同名文件，如果没有则直接添加同名但后缀有1的文件，其中有个launch文件是应该放在PX4_Firmware的launch文件夹下
cd ~/XTDrone/communication
cd ~/XTDrone/control/keyboard
cd ~/XTDrone/communication
cd ~/XTDrone/sensing/pose_ground_truth
cd ~/XTDrone/coordination/formation_demo

修改ekf配置
gedit ~/PX4_Firmware/build/px4_sitl_default/etc/init.d-posix/rcS
通过注释来修改不同的参数
	# GPS used
	#param set EKF2_AID_MASK 1
	# Vision used and GPS denied
	param set EKF2_AID_MASK 24

	# Barometer used for hight measurement
	#param set EKF2_HGT_MODE 0
	# Barometer denied and vision used for hight measurement
	param set EKF2_HGT_MODE 3
3.删除原参数配置文件
重启仿真前，需要删除上一次记录在虚拟eeprom中的参数文件，否则仿真程序会读取该参数文件，导致本次rcS的修改不能生效
rm ~/.ros/eeprom/parameters*
rm -rf ~/.ros/sitl*


运行多无人机编队（机型为solo,后续为主机添加ego时需要修改为带相机的机型）
cd ~/PX4_Firmware
roslaunch px4 multi_vehicle.launch
建立通信
cd ~/XTDrone/communication
bash multi_vehicle_communication.sh
给3个solo提供位姿信息，注意这里使用的是Gazebo位姿真值，因为只有这样，它们的局部位置（local_position）才是在统一的坐标系下。
cd ~/XTDrone/sensing/pose_ground_truth
python get_local_pose.py solo 3
使用键盘控制所有无人机起飞
cd ~/XTDrone/control/keyboard
python multirotor_keyboard_control.py solo 3 vel
无人机悬停后，键盘按g键，进入leader-follower模式，然后启动多机协同脚本。
cd ~/XTDrone/coordination/formation_demo
bash run.sh solo 3
然后用利用multirotor_keyboard_control.py，按数字1或2或3键即可切换队形了


