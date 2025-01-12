#!/bin/bash

# Define variables
UBUNTU_DISTRO="jammy"
ROS_VERSION="2"
ROS_DISTRO="humble"
ROS_PYTHON_VERSION="3"
TZ="America/Toronto"

# Set timezone
ln -snf /usr/share/zoneinfo/$TZ /etc/localtime
echo $TZ > /etc/timezone

# Update and install locales
apt update
apt install -y locales software-properties-common curl git
locale-gen en_US en_US.UTF-8
update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
export LANG=en_US.UTF-8

# Configure repositories
add-apt-repository universe
curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/ros2.list > /dev/null

# Install ROS2 and dependencies
apt update
apt upgrade -y
apt install -y ros-${ROS_DISTRO}-desktop \
    python3-colcon-common-extensions \
    python3-rosdep2 \
    libeigen3-dev \
    ros-${ROS_DISTRO}-xacro \
    ros-${ROS_DISTRO}-tinyxml2-vendor \
    ros-${ROS_DISTRO}-ros2-control \
    ros-${ROS_DISTRO}-realtime-tools \
    ros-${ROS_DISTRO}-control-toolbox \
    ros-${ROS_DISTRO}-moveit \
    ros-${ROS_DISTRO}-ros2-controllers \
    ros-${ROS_DISTRO}-test-msgs \
    ros-${ROS_DISTRO}-joint-state-publisher \
    ros-${ROS_DISTRO}-joint-state-publisher-gui \
    ros-${ROS_DISTRO}-robot-state-publisher \
    ros-${ROS_DISTRO}-rviz2

# Add ROS2 to the environment
echo "source /opt/ros/${ROS_DISTRO}/setup.bash" >> ~/.bashrc
source /opt/ros/${ROS_DISTRO}/setup.bash

# Clone Flexiv ROS2 repository
mkdir -p ~/flexiv_ros2_ws/src
cd ~/flexiv_ros2_ws/src
git clone https://github.com/flexivrobotics/flexiv_ros2.git
cd flexiv_ros2
git submodule update --init --recursive

# Use rosdep to install dependencies
cd ~/flexiv_ros2_ws
rosdep update
rosdep install --from-paths ~/flexiv_ros2_ws/src --ignore-src --rosdistro $ROS_DISTRO -r -y

# Build and install dependencies for Flexiv RDK
cd ~/flexiv_ros2_ws/src/flexiv_ros2/flexiv_hardware/rdk/thirdparty
bash build_and_install_dependencies.sh ~/rdk_install

# Build Flexiv RDK
cd ~/flexiv_ros2_ws/src/flexiv_ros2/flexiv_hardware/rdk
mkdir build
cd build
source /opt/ros/${ROS_DISTRO}/setup.bash
cmake .. -DCMAKE_INSTALL_PREFIX=~/rdk_install
cmake --build . --target install --config Release

# Build Flexiv ROS package
cd ~/flexiv_ros2_ws
source /opt/ros/${ROS_DISTRO}/setup.bash
colcon build --symlink-install --cmake-args -DCMAKE_PREFIX_PATH=~/rdk_install

# Install ROS Control, Controllers, and MoveIt
apt install -y ros-${ROS_DISTRO}-ros2-control \
    ros-${ROS_DISTRO}-ros2-controllers \
    ros-${ROS_DISTRO}-moveit

# Add Flexiv ROS2 to the environment
echo "source ~/flexiv_ros2_ws/install/setup.bash" >> ~/.bashrc
source ~/flexiv_ros2_ws/install/setup.bash

echo "Setup complete. Please restart your terminal or source ~/.bashrc to use the Flexiv ROS2 workspace."
