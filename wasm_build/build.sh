git clone https://github.com/alibaba/MNN.git
cd MNN
./schema/generate.sh
mkdir build && cd build 

emcmake cmake \
    -DCMAKE_BUILD_TYPE=Debug \
    -DMNN_BUILD_DEMO=ON \
    -DMNN_BUILD_SHARED_LIBS=ON \
    -DCMAKE_CXX_FLAGS="\
        -s RELOCATABLE=1 \
        -s ASSERTIONS=2 \
        -s INITIAL_MEMORY=2080374784 \
        -s SIDE_MODULE=1" \
    -DCMAKE_SHARED_LINKER_FLAGS="-s SIDE_MODULE=1" ..

emmake make

osascript -e 'display notification "Build complete" with title "WASM Build"'

# emmake make segment.out 