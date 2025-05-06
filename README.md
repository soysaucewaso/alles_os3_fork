## ORBSLAM3 Summary
Orbslam3 is a Visual Simulataneous Localization and Mapping algorithm. This repo contains a ROS2 wrapper to subscribe to image/IMU topics and publish to pose estimates.

### Alternatives
jnskkmhr's orbslam3(ROS2 Wrapper) and jnskkmhr's ORB-SLAM3-STEREO-FIXED has better documentation, has been tested much more, and provides all functionality this repo provides

### Efficacy
This repo mapped and localized accurately for me with EuRoC ros2 bags

When I tested ORB_SLAM3 with a RealSense D435i mounted on a tenth-scale car in Stereo-only mode, it achieved loop closure, but couldn't reliably detect turns.

When I used a rosbag to build a map, and tested localization on that same map, ORB_SLAM3 quickly lost itself and never regained localization.

Tested on Ubuntu 20.04 with ROS2 Galactic.

### Notes
In the original ORB SLAM3 paper, the author concluded Stereo-Inertial performed worse than Stereo-only for land vehicles due to lack of gyroscopic excitiation.

## Install Instructions

### ORBSLAM3 Dependencies
```
cd ORB_SLAM3
./dependencies_setup.sh
```

It terminates early if any error occurs, so before rerunning comment out lines which were successfully ran.

Building dependencies can take around an hour.

### ORBSLAM3
Next, build ORBSLAM3

```
cd ORB_SLAM3
chmod +x build.sh
sudo ./build.sh
cd ..
```

### Wrapper Dependencies
```
cd ROS2_WRAPPER/src/orbslam3ros2
./ORB_SLAM3_ROS2_setup.sh
```

### Wrapper Build

First change Line 5 of CMakeLists.txt to your own **python site-packages** path.

Then change Line 8 of CMakeModules/FindORB_SLAM3.cmake to the path to ORB_SLAM3.

```
cd ../..
colcon build --symlink-install orbslam3
```

## Running
     
### Source the workspace

`$ source ~/colcon_ws/install/local_setup.bash`

Run orbslam mode, which you want.
This repository only support MONO, STEREO, RGBD, STEREO-INERTIAL mode now.
You can find vocabulary file and config file in here. (e.g. orbslam3_ros2/vocabulary/ORBvoc.txt, orbslam3_ros2/config/monocular/TUM1.yaml for monocular SLAM).

#### MONO mode

`$ ros2 run orbslam3 mono PATH_TO_VOCABULARY PATH_TO_YAML_CONFIG_FILE`

#### STEREO mode

`$ ros2 run orbslam3 stereo PATH_TO_VOCABULARY PATH_TO_YAML_CONFIG_FILE BOOL_RECTIFY`

#### RGBD mode

`$ ros2 run orbslam3 rgbd PATH_TO_VOCABULARY PATH_TO_YAML_CONFIG_FILE`

#### STEREO-INERTIAL mode

`$ ros2 run orbslam3 stereo-inertial PATH_TO_VOCABULARY PATH_TO_YAML_CONFIG_FILE BOOL_RECTIFY [BOOL_EQUALIZE]`



## Implementation Notes
This repository includes UZSLAM-LAB's ORB_SLAM3 with fixes to work with the wrapper.
These fixes were based off of zang09's ORB-SLAM3-STEREO-FIXED

The wrapper is based off of zang09's ORB_SLAM3_ROS2, with fixes from jsnkkmhr's orbslam3.

