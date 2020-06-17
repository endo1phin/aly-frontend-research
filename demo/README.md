# Demo

A webapp that uses webassembly to run mobilenet_v3 tensorflow checkpoint compiled by MNN.

## Build MNN Demo

### 0. Install Emscripten

[Link](https://emscripten.org/docs/getting_started/downloads.html)

### 1. Build converter

https://www.yuque.com/mnn/cn/build_linux

```bash
cd MNN
./schema/generate.sh
mkdir build && cd build 
cmake -DMNN_BUILD_CONVERTER=ON .. 
make -j8
```

### 2. Convert mobilenet model

[Download](https://github.com/tensorflow/models/blob/master/research/slim/nets/mobilenet/README.md) mobilenet v3 checkpoint.

```bash 
./MNNConvert -f TF --modelFile ../../demo/mobilenet-v3.pb --MNNModel ../../demo/mobilenet-v3.mnn --bizCode biz
```

### 3. Build demo driver using Emscripten

```bash
/usr/local/Cellar/emscripten/1.39.18/bin/emcmake cmake -DMNN_BUILD_DEMO=ON ..
/usr/local/Cellar/emscripten/1.39.18/bin/emmake make
```




### Use demo driver to recognize pictures

```
cp pictureRecognition.out ../../demo/pictureRecognition.out
cd ../../demo/
./pictureRecognition.out mobilenet-v3.mnn testcat.jpg synset_words.txt
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

