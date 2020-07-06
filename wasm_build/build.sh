git clone https://github.com/alibaba/MNN.git
cd MNN
./schema/generate.sh
mkdir build && cd build 

emcmake cmake -DMNN_BUILD_DEMO=ON -DCMAKE_BUILD_TYPE=Debug -DMNN_SEP_BUILD=OFF -DCMAKE_CXX_FLAGS="-s RELOCATABLE=1 -s ASSERTIONS=2 -s INITIAL_MEMORY=2080374784" -DCMAKE_SHARED_LINKER_FLAGS="-s SIDE_MODULE=1" ..

emmake make -j12 MNN

# emcc ../demo/exec/pictureRecognition.cpp -s MODULARIZE=1 -s MAIN_MODULE=1 -s ALLOW_MEMORY_GROWTH=1 -s ASSERTIONS=2 -s INITIAL_MEMORY=2080374784 -s RUNTIME_LINKED_LIBS="['libMNN.wasm']" -I/Users/zhenfengqiu/aly-frontend-research/wasm_build/MNN/include -I/Users/zhenfengqiu/aly-frontend-research/wasm_build/MNN/source -I/Users/zhenfengqiu/aly-frontend-research/wasm_build/MNN/schema/current -I/Users/zhenfengqiu/aly-frontend-research/wasm_build/MNN/3rd_party -I/Users/zhenfengqiu/aly-frontend-research/wasm_build/MNN/3rd_party/flatbuffers/include -I/Users/zhenfengqiu/aly-frontend-research/wasm_build/MNN/3rd_party/half -I/Users/zhenfengqiu/aly-frontend-research/wasm_build/MNN/3rd_party/imageHelper -I/Users/zhenfengqiu/aly-frontend-research/wasm_build/MNN/3rd_party/OpenCLHeaders --preload-file /Users/zhenfengqiu/aly-frontend-research/preload@/ --pre-js /Users/zhenfengqiu/aly-frontend-research/wasm_build/pre-js.js  -o pictureRecognition.out.js 

emcc ../demo/exec/multiPose.cpp -s MODULARIZE=1 -s MAIN_MODULE=1 -s ASSERTIONS=2 -s INITIAL_MEMORY=2080374784 -s RUNTIME_LINKED_LIBS="['libMNN.wasm']" -I/Users/zhenfengqiu/aly-frontend-research/wasm_build/MNN/include -I/Users/zhenfengqiu/aly-frontend-research/wasm_build/MNN/source -I/Users/zhenfengqiu/aly-frontend-research/wasm_build/MNN/schema/current -I/Users/zhenfengqiu/aly-frontend-research/wasm_build/MNN/3rd_party -I/Users/zhenfengqiu/aly-frontend-research/wasm_build/MNN/3rd_party/flatbuffers/include -I/Users/zhenfengqiu/aly-frontend-research/wasm_build/MNN/3rd_party/half -I/Users/zhenfengqiu/aly-frontend-research/wasm_build/MNN/3rd_party/imageHelper -I/Users/zhenfengqiu/aly-frontend-research/wasm_build/MNN/3rd_party/OpenCLHeaders --preload-file /Users/zhenfengqiu/aly-frontend-research/preload@/ --pre-js /Users/zhenfengqiu/aly-frontend-research/wasm_build/pre-js.js  -o multiPose.out.js 

osascript -e 'display notification "Build complete" with title "WASM Build"'

# emcmake cmake -DCMAKE_BUILD_TYPE=Debug -DMNN_BUILD_DEMO=ON -DCMAKE_CXX_FLAGS="-s RELOCATABLE=1 -s ASSERTIONS=2 -s INITIAL_MEMORY=2080374784" -DCMAKE_SHARED_LINKER_FLAGS="-s SIDE_MODULE=1" ..