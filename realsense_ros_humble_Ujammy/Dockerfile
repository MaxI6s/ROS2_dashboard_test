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

# Set locales for ROS
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

RUN mkdir -p /etc/apt/keyrings
RUN curl -sSf https://librealsense.intel.com/Debian/librealsense.pgp | tee /etc/apt/keyrings/librealsense.pgp > /dev/null
RUN echo "deb [signed-by=/etc/apt/keyrings/librealsense.pgp] https://librealsense.intel.com/Debian/apt-repo `lsb_release -cs` main" | tee /etc/apt/sources.list.d/librealsense.list

# Install ROS2:humble 
RUN apt update
RUN apt upgrade

RUN apt install ros-${ROS_DISTRO}-desktop -y

# Configure Ubuntu repositories
RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
RUN curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | apt-key add -

# Install librealsense2
RUN apt install ros-${ROS_DISTRO}-librealsense2* -y
RUN apt-get install librealsense2-utils -y

# Install librealsense2 ROS wrapper from source
RUN apt install ros-${ROS_DISTRO}-realsense2-* -y

# Sourcing ROS2 accros container
RUN echo "source /opt/ros/${ROS_DISTRO}/setup.bash" >> ~/.bashrc