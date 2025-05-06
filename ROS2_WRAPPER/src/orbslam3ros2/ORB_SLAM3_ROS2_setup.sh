# terminate upon error
set -e

mkdir dependencies
cd dependencies

echo "Downloading and Installing OpenCV 4.2"

wget -O opencv.zip https://github.com/opencv/opencv/archive/refs/tags/4.2.0.zip
unzip opencv.zip
cd opencv-4.2.0
mkdir -p build && cd build
cmake ..
cmake --build .

make install

sudo apt install ros-$ROS_DISTRO-vision-opencv
sudo apt install ros-$ROS_DISTRO-message-filters

echo "Successfuly Installed ROS2 Wrapper Dependenices"
