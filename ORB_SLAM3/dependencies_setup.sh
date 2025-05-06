ORB_SLAM3_dir=.

# terminate upon error
set -e

cd $ORB_SLAM3_dir
mkdir dependencies
cd dependencies

echo "Downloading and Building Pangolin"
git clone --recursive -O Pangolin https://github.com/stevenlovegrove/Pangolin.git
cd Pangolin

./scripts/install_prerequisites.sh recommended

cmake -B build -DPython3_EXECUTABLE=`which python3`
cmake --build build
cd build
make install
cd ..

echo "Downloading and Installing OpenCV 4.4"
cd $ORB_SLAM3_dir/dependencies
wget -O opencv.zip https://github.com/opencv/opencv/archive/refs/tags/4.4.0.zip
unzip opencv.zip
cd opencv-4.4.0
mkdir -p build && cd build
cmake ..
cmake --build .

make install

apt-get install libcanberra-gtk*
echo "Successfully installed and built dependencies"
