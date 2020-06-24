git clone https://github.com/alibaba/MNN.git
cd MNN
./schema/generate.sh
mkdir build && cd build 
emcmake cmake \
    -DCMAKE_BUILD_TYPE=Debug \
    -DMNN_BUILD_DEMO=ON \
    -DMNN_PORTABLE_BUILD=ON \
    -DCMAKE_CXX_FLAGS="\
        -s ASSERTIONS=2 \
        -s INITIAL_MEMORY=2080374784 \
        -s USE_PTHREADS=1 \
        -s RELOCATABLE=1 \
        --preload-file /Users/zhenfengqiu/aly-frontend-research/preload@/ \
        --pre-js /Users/zhenfengqiu/aly-frontend-research/wasm_build/pre-js.js" ..
emmake make pictureRecognition.out

# emmake make segment.out 