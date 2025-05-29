## ORBSLAM3 Summary
Orbslam3 is a Visual Simulataneous Localization and Mapping algorithm. This repo contains a ROS2 wrapper to subscribe to image/IMU topics and publish to pose estimates.

### Alternatives
jnskkmhr's orbslam3(ROS2 Wrapper) and jnskkmhr's ORB-SLAM3-STEREO-FIXED are a good alternative with docker images for easy deployment, and provide all functionality this repo provides

### Efficacy
This repo mapped and localized accurately for me with EuRoC ros2 bags

When I tested ORB_SLAM3 with a RealSense D435i mounted on a tenth-scale car in Stereo-only mode, it achieved loop closure, but couldn't reliably detect turns.

When I used a rosbag to build a map, and tested localization on that same map, ORB_SLAM3 quickly lost itself and never regained localization.

Tested on 2 Almost Identical Ubuntu 20.04s with ROS2 Galactic.

### Notes
In the original ORB SLAM3 paper, the author concluded Stereo-Inertial performed worse than Stereo-only for land vehicles due to lack of gyroscopic excitiation.

Only tested with Stereo and Stereo-Inertial. Also may support MONO and RGBD with a bit of tinkering
(Just replicate diffs between ROS2_wrapper and zang09/ORB_SLAM3_ROS2 from src/stereo and src/stereo-inertial to src/rgbd and src/monocular).

This repo installs both OpenCV 4.2 and 4.4 since the wrapper and ORB SLAM3 require different versions.

### Troubleshooting.

`C++: fatal error: Killed signal terminated program cc1plus` when running cmake --build or make
- This means the system ran out of memory. Reduce N_PARALLEL at the start of scripts.

ORB SLAM3 crashing without error output
- ORB SLAM3 is likely using OpenCV 4.5 instead of OpenCV 4.4.
- Rebuild ORB SLAM3 and it's dependencies until `sudo ldd ORB_SLAM3/lib/libORB_SLAM3.so | grep opencv`shows only 4.4

## Install Instructions

### ORBSLAM3 Dependencies
Install Pangolin and OpenCV 4.4
```
cd ORB_SLAM3
sudo ./dependencies_setup.sh
```

It terminates early if any error occurs, so before rerunning comment out lines which successfully ran.

Building dependencies can take around an hour.

### ORBSLAM3
Next, build ORBSLAM3

```
chmod +x build.sh
sudo ./build.sh
```

### Wrapper Dependencies

```
cd ../ROS2_WRAPPER/src/orbslam3ros2
sudo bash
export ROS_DISTRO=yourdistro
./ORB_SLAM3_ROS2_setup.sh
```

### Wrapper Build

First change Line 5 of ROS2_WRAPPER/src/orbslam3ros2/CMakeLists.txt to your own **python site-packages** path.

Then change Line 8 of ROS2_WRAPPER/src/orbslam3ros2/CMakeModules/FindORB_SLAM3.cmake to the path to ORB_SLAM3.

```
cd ../..
sudo bash
source /opt/ros/yourdistro/setup.bash
colcon build --symlink-install --packages-select orbslam3
```

## Running
     
### Source the workspace

`$ source ROS2_WRAPPER/install/local_setup.bash`

Run the preferred orbslam mode. 
Vocabulary file is at ../ORB_SLAM3/Vocabulary/ORBvoc.txt.
This repository only supports MONO, STEREO, RGBD, STEREO-INERTIAL mode now.
Config file is at ROS2_WRAPPER/src/orbslam3_ros2/config/<MODE>/<CAMERA>.yaml

#### MONO mode

`$ ros2 run orbslam3 mono ../ORB_SLAM3/Vocabulary/ORBvoc.txt src/orbslam3_ros2/config/monocular/<CAMERA>.yaml`

#### STEREO mode

`$ ros2 run orbslam3 stereo ../ORB_SLAM3/Vocabulary/ORBvoc.txt src/orbslam3_ros2/config/stereo/<CAMERA>.yaml BOOL_RECTIFY`

#### RGBD mode

`$ ros2 run orbslam3 rgbd ../ORB_SLAM3/Vocabulary/ORBvoc.txt src/orbslam3_ros2/config/rgbd/
<CAMERA>.yaml`

#### STEREO-INERTIAL mode

`$ ros2 run orbslam3 stereo-inertial ../ORB_SLAM3/Vocabulary/ORBvoc.txt src/orbslam3_ros2/config/rgbd/<CAMERA>.yaml BOOL_RECTIFY [BOOL_EQUALIZE]`


## Implementation Notes
This repository includes UZSLAM-LAB's ORB_SLAM3 with fixes to work with the wrapper.
These fixes were based off of zang09's ORB-SLAM3-STEREO-FIXED

The wrapper is based off of zang09's ORB_SLAM3_ROS2, with fixes from jsnkkmhr's orbslam3.

