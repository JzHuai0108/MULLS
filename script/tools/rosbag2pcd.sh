#!/bin/sh

# firstly, you need to install ros
# We will take ros kinetic as an example
# echo "install [ros] kinetic"
# #refer to http://wiki.ros.org/kinetic/Installation/Ubuntu
# sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
# sudo apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654
# sudo apt-get update
# sudo apt-get install ros-kinetic-desktop-full
# echo "Please make sure there's no other distribution (not konetic) of ros on your system"
# echo "source /opt/ros/kinetic/setup.bash" >> ~/.bashrc
# source ~/.bashrc
# sudo apt install python-rosdep python-rosinstall python-rosinstall-generator python-wstool build-essential
# sudo apt install python-rosdep
# sudo rosdep init
# rosdep update
# echo "install [ros] done"

# then do the covertion 
# roscore should be launched in another terminal 

# batch processing all the ros bags in the folder and save them all into a single folder for pcd files
# (comment the following four lines if you want to do the convertion one by one)
rosbag_folder_path=/media/jhuai/T7/jhuai/nebulaN
rosbag_folder_path=/media/jhuai/BackupPlus/jhuai/data/nebula/L_Spot3_Mix
for rosbag in ${rosbag_folder_path}/*bag
do
	NAME="${rosbag_folder_path}/$(basename ${rosbag} .bag)"
	echo "processing ${NAME}"
	# rosrun pcl_ros bag_to_pcd ${rosbag} /husky2/velodyne_points ${NAME}_velodyne/pcd
	# rosrun pcl_ros bag_to_pcd ${rosbag} /husky2/velodyne_front/velodyne_points ${NAME}_velodyne_front/pcd
	# rosrun pcl_ros bag_to_pcd ${rosbag} /husky2/velodyne_rear/velodyne_points ${NAME}_velodyne_rear/pcd
	# rosrun pcl_ros bag_to_pcd ${rosbag} /husky2/hvm/lidar/points ${NAME}_hovermap/pcd
	rosrun pcl_ros bag_to_pcd ${rosbag} /spot3/hvm/lidar/points ${NAME}_hovermap/pcd
done

# do the processing for a single rosbag
# single_rosbag_path=/home/panyue/datadisk/ros_folder/rosbags/xxxxxxx.bag
# pcd_folder_path=/home/panyue/datadisk/ros_folder/rospcd/
# rosrun pcl_ros bag_to_pcd ${single_rosbag_path} sensor_msgs/PointCloud2 ${pcd_folder_path}