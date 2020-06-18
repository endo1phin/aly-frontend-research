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
./MNNConvert -f TF --modelFile ../../../original_models/pose_model.pb --MNNModel ../../../pose_model.mnn --bizCode biz  

./MNNConvert -f TFLITE --modelFile ../../../original_models/segment_model.tflite --MNNModel ../../../segment_model.mnn --bizCode biz

./MNNConvert -f TF --modelFile ../../../original_models/recognition_model.pb --MNNModel ../../../recognition_model.mnn --bizCode biz
```

### 3. Test Normal Build Demos
#### Pose model

```
./multiPose.out ../../../pose_model.mnn ../../../pose_input.png ../../../pose_output_normal.png
```
Output:
```
main, 381, cost time: 7.458000 ms
main, 405, cost time: 0.144000 ms
```

#### Segment model
```
./segment.out ../../../segment_model.mnn ../../../segment_input.png ../../../segment_output_normal.png    
```
Output:
```
input: w:257 , h:257, bpp: 3
origin size: 121, 140
Mask: w=257, h=257, c=21
```

#### Recognition model
```
./pictureRecognition.out ../../../recognition_model.mnn ../../../recognition_input.jpg ../../../recognition_text.txt
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
Since emcc needs to preload the file system when building, we need to append a compiler flag at the bottom of `CMakeList.txt`:

```
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} --preload-file ../../../preload")
```
Continue down the toolchain, using emcc wrappers:
```
emcmake cmake -DMNN_BUILD_DEMO=ON ..
emmake make pictureRecognition.out
emmake make segment.out 
emmake make multiPose.out
```

### 5. Test WASM Build Demos

See README in `demo`

## Webassembly integration 

To-do

