ARG UBUNTU_DISTRO=jammy
FROM ubuntu:${UBUNTU_DISTRO}

# Set sheel to bash
# RUN rm /bin/sh && ln -s /bin/bash /bin/sh
SHELL ["/bin/bash", "-c"] 

# Get arg from env
ARG ROS_VERSION=2
ARG ROS_DISTRO=humble
ARG ROS_PYTHON_VERSION=3
ARG TZ=America/Toronto

# Set timezone
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Set locales for ROS2:humble
RUN apt update &&  apt install locales
RUN locale-gen en_US en_US.UTF-8
RUN update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
RUN export LANG=en_US.UTF-8

# Set source
RUN apt install software-properties-common -y
RUN add-apt-repository universe

RUN apt update &&  apt install curl -y
RUN curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" |  tee /etc/apt/sources.list.d/ros2.list > /dev/null

# Install ROS2:humble 
RUN apt update
RUN apt upgrade

RUN apt install ros-${ROS_DISTRO}-desktop -y

# Install foxgloves for ROS2
RUN apt install ros-${ROS_DISTRO}-foxglove-bridge -y

# Install realsense2 camera message
RUN apt install ros-${ROS_DISTRO}-realsense2-camera-msgs -y

# Install controller message
RUN apt install ros-${ROS_DISTRO}-controller-manager-msgs -y

# Install control toolbox
RUN apt install ros-${ROS_DISTRO}-control-toolbox -y

# Install controller manager message
RUN apt install ros-${ROS_DISTRO}-controller-manager-msgs -y

# Install MoveIt message
RUN apt install ros-${ROS_DISTRO}-moveit-msgs -y

# Sourcing ROS2 accros container
RUN echo "source /opt/ros/${ROS_DISTRO}/setup.bash" >> ~/.bashrc