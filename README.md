# WASM-MNN Integration 

## Project Setup

```
.
├── README.md
├── README_CN.md
├── demo
│   ├── README.md
│   ├── README_CN.md
│   └── app
├── mnn-paper.pdf
├── normal_build
│   └── MNN
├── original_models
│   ├── pose_model.pb
│   ├── recognition_model.pb
│   └── segment_model.tflite
├── preload
│   ├── pose_input.png
│   ├── pose_model.mnn
│   ├── recognition_input.jpg
│   ├── recognition_model.mnn
│   ├── recognition_text.txt
│   ├── segment_input.png
│   └── segment_model.mnn
└── wasm_build
    └── MNN
```

- `demo`: flask webapp serving wasm application
- `original_models`: pre-trained tf and tflite models to be converted
- `normal_build`: contains MNNConverter and demo programs built with g++ (for testing only)
- `wasm_build`: demo programs built with emcc
- `preload`: folder with pre-compiled MNN models and input files, see below for explanation

## Build MNN Demo

### 0. Setup Emscripten

[Link](https://emscripten.org/docs/getting_started/downloads.html)

Add emcc compiler and wrappers to PATH:
```
source /Users/zhenfengqiu/emsdk/emsdk_env.sh
```

### 1. Normal Build (Converter & Demo)

https://www.yuque.com/mnn/cn/build_linux

```bash
cd normal_build/MNN
./schema/generate.sh
mkdir build && cd build 
cmake -DMNN_BUILD_CONVERTER=ON -DMNN_BUILD_DEMO=ON .. 
make -j8
```

### 2. Convert Models

[Download picture recognition model](https://github.com/tensorflow/models/blob/master/research/slim/nets/mobilenet/README.md)



```bash 
./MNNConvert -f TF --modelFile ../../../original_models/pose_model.pb --MNNModel ../../../preload/pose_model.mnn --bizCode biz  

./MNNConvert -f TFLITE --modelFile ../../../original_models/segment_model.tflite --MNNModel ../../../preload/segment_model.mnn --bizCode biz

./MNNConvert -f TF --modelFile ../../../original_models/recognition_model.pb --MNNModel ../../../preload/recognition_model.mnn --bizCode biz
```

### 3. Test Normal Build Demos
#### Pose model

```
./multiPose.out ../../../preload/pose_model.mnn ../../../preload/pose_input.png ../../../preload/pose_output_normal.png
```
Output:
```
main, 381, cost time: 7.458000 ms
main, 405, cost time: 0.144000 ms
```

#### Segment model
```
./segment.out ../../../preload/segment_model.mnn ../../../segment_input.png ../../../segment_output_normal.png    
```
Output:
```
input: w:257 , h:257, bpp: 3
origin size: 121, 140
Mask: w=257, h=257, c=21
```

#### Recognition model
```
./pictureRecognition.out ../../../preload/recognition_model.mnn ../../../preload/recognition_input.jpg ../../../preload/recognition_text.txt
```
Output: 
```
Can't Find type=4 backend, use 0 instead
input: w:224 , h:224, bpp: 3
origin size: 480, 360
output size:1001
cougar, puma, catamount, mountain lion, painter, panther, Felis concolor: 0.157613
Japanese spaniel: 0.078149
chow, chow chow: 0.051703
Arctic fox, white fox, Alopex lagopus: 0.045174
drilling platform, offshore rig: 0.042530
tiger cat: 0.029871
wire-haired fox terrier: 0.020189
Persian cat: 0.019359
magpie: 0.017908
porcupine, hedgehog: 0.015940
```



### 4. WASM Build (Demo only)



```bash
cd wasm_build/MNN
./schema/generate.sh
mkdir build && cd build 
```

#### Build Dynamic Library

First, set platform requirement to enable shared library compilation by adding the following line to CMakeLists.txt (added at line 38, after versioning and project specification):

```
SET_PROPERTY(GLOBAL PROPERTY TARGET_SUPPORTS_SHARED_LIBS TRUE)
```

Compile main library as side module:
```
emcmake cmake -DMNN_BUILD_DEMO=ON -DCMAKE_BUILD_TYPE=Debug -DMNN_SEP_BUILD=OFF -DCMAKE_CXX_FLAGS="-s RELOCATABLE=1 -s ASSERTIONS=2 -s INITIAL_MEMORY=2080374784" -DCMAKE_SHARED_LINKER_FLAGS="-s SIDE_MODULE=1" ..
```
Compiler flags: 

- `ASSERTIONS=2`: debugging option to check for stack and heap problems
- `INITIAL_MEMORY=2080374784`: see [issue#1](https://github.com/endo1phin/aly-frontend-research/issues/1)
- `RELOCATABLE=1`  (implied by `SIDE_MODULE=1`): [gcc link option](https://gcc.gnu.org/onlinedocs/gcc-10.1.0/gcc/Link-Options.html#Link-Options): Produce a relocatable object as output. This is also known as [partial linking](https://carsontang.github.io/unix/2013/06/01/guide-to-object-file-linking/).
- `--preload-file`: containing the converted models and input file
- `--pre-js`: specify model and input name in `Module[arguments]` for the main program



Linker flag (Emscripten):
- `SIDE_MODULE=1`: dynamically linked side modules that does not contain system library, see [Emscripten's linking wiki](https://github.com/emscripten-core/emscripten/wiki/Linking)

We also need to force the library to compile to `.wasm` instead of regular shared library file `.so` by changing the `-o libMNN.so` to `-o libMNN.wasm` in `CMakeFiles/MNN.dir/link.txt`. 

Then run `emmake make -j12 MNN` where `-j` specify the # of thread used to compile. This should yield a `libMNN.wasm` in `/build`.

Finally compile the main module (e.g. `multiPose.out`) with:

```
emcc ../demo/exec/multiPose.cpp -s MODULARIZE=1 -s MAIN_MODULE=1 -s ASSERTIONS=2 -s INITIAL_MEMORY=2080374784 -s RUNTIME_LINKED_LIBS="['libMNN.wasm']" --preload-file /Users/zhenfengqiu/aly-frontend-research/preload@/ --pre-js /Users/zhenfengqiu/aly-frontend-research/wasm_build/pre-js.js <libraries> -o multiPose.out.js 
```

Where `<libraries>` are contents of `CMakeFiles/multiPose.dir/includes_CXX.rsp`

### 5. Test WASM Build Demos

See README in `demo`

Flask environment variables:
```
export FLASK_APP=app.py
export FLASK_ENV=development
flask run
```

## Webassembly integration 



