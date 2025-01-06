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

# Install Git
RUN apt install git -y

# Installl dependencies
RUN apt install -y \
python3-colcon-common-extensions \
python3-rosdep2 \
libeigen3-dev \
ros-humble-xacro \
ros-humble-tinyxml2-vendor \
ros-humble-ros2-control \
ros-humble-realtime-tools \
ros-humble-control-toolbox \
ros-humble-moveit \
ros-humble-ros2-controllers \
ros-humble-test-msgs \
ros-humble-joint-state-publisher \
ros-humble-joint-state-publisher-gui \
ros-humble-robot-state-publisher \
ros-humble-rviz2

# Sourcing ROS2 accros container
RUN echo "source /opt/ros/${ROS_DISTRO}/setup.bash" >> ~/.bashrc

# Clone Flexiv ROS repo
RUN mkdir -p ~/flexiv_ros2_ws/src
RUN cd ~/flexiv_ros2_ws/src \
    && git clone https://github.com/flexivrobotics/flexiv_ros2.git
RUN cd ~/flexiv_ros2_ws/src/flexiv_ros2 \
    && git submodule update --init --recursive

# Rosdep
RUN cd ~/flexiv_ros2_ws \
    && rosdep update \
    && rosdep install --from-paths ~/flexiv_ros2_ws/src --ignore-src --rosdistro humble -r -y

# Installing dependencies for Flexiv RDK
RUN cd ~/flexiv_ros2_ws/src/flexiv_ros2/flexiv_hardware/rdk/thirdparty \
    && bash build_and_install_dependencies.sh ~/rdk_install

# Build Flexiv RDK
RUN cd ~/flexiv_ros2_ws/src/flexiv_ros2/flexiv_hardware/rdk \
    && mkdir build \
    && cd build \
    && source /opt/ros/${ROS_DISTRO}/setup.bash \
    && cmake .. -DCMAKE_INSTALL_PREFIX=/rdk_install \
    && cmake --build . --target install --config Release

# Build Flexiv ros package
RUN cd ~/flexiv_ros2_ws \
    && source /opt/ros/${ROS_DISTRO}/setup.bash \
    && colcon build --symlink-install --cmake-args -DCMAKE_PREFIX_PATH=~/rdk_install

# Install ROS Control
RUN apt install ros-${ROS_DISTRO}-ros2-control -y

# Install ROS Controllers
RUN apt install ros-${ROS_DISTRO}-ros2-controllers -y

# Install ROS MoveIt
RUN apt install ros-${ROS_DISTRO}-moveit -y

# Sourcing Flexiv ROS2 accros container
RUN echo "source ~/flexiv_ros2_ws/install/setup.bash" >> ~/.bashrc