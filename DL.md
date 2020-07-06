# Glossary

## Compiler Workflow 编译步骤


1. Lexing produces tokens
2. Parsing produces an abstract syntax tree
3. Analysis produces a code flow graph
4. Optimization produces a reduced code flow graph
5. Code gen produces object code
6. Linkage produces a complete executable
7. Loader instructs the OS how to start running the executable


## Preprocessing 预处理

The preprocessor does several things. Here we look at how it includes header files.

> The preprocessor replaces the line `#include <stdio.h>` with the textual content of the file 'stdio.h', which declares the printf() function among other things.

Only the declaration is included. The implementation of the function is filled by the linker, through either dynamic or static linking.

For example, in the following file:

```C
// mylib.c
#include <stdio.h>
#include <stdlib.h>

void say_hi() {
    printf("mylib!\n");
}

// test.c
#include <stdio.h> 
#include <stdlib.h> 
#include "mylib.h"

int main(int argc, char *argv[]){ 
    say_hi();
    printf("main!\n");
    return 0;
}
```

Preprocessed using "preprocessing only" flag `-E`: `clang -E test.c >> test_preprocessed.c`:

```c
// ...

# 142 "/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/usr/include/stdio.h" 3 4
int printf(const char * restrict, ...) __attribute__((__format__ (__printf__, 1, 2)));

// ...

# 3 "test.c" 2

# 1 "./mylib.h" 1
void say_hi();

# 4 "test.c" 2
int main(int argc, char *argv[]){
    say_hi();
    printf("main!\n");
    return 0;
}
```





## Symbol Table 符号表

[Wikipedia](https://en.wikipedia.org/wiki/Symbol_table): 

> A symbol table is a data structure used by a compiler or interpreter, where each identifier (a.k.a. symbol) in a program's source code is associated with information relating to its declaration or appearance in the source. 

> A symbol table may only exist in memory during the translation process, or it may be embedded in the output of the translation, such as in an ABI object file for later use.

> The minimum information contained in a symbol table used by a translator includes the symbol's name, its relocatability attributes (absolute, relocatable, etc.), and its location or address.

## Object File 目标文件

[Nick Desaulniers](http://nickdesaulniers.github.io/blog/2016/08/13/object-files-and-symbols/):

> Object files are almost full executables. They contain machine code, but that code still requires a relocation step. 

> It also contains metadata about the addresses of its variables and functions (called symbols) in an associative data structure called a symbol table. 



## Static Library 静态库

[Program Library HOWTO: Static Libraries](http://tldp.org/HOWTO/Program-Library-HOWTO/static-libraries.html)

- Simply bundled object files
- Usually have `.a` extension
- Added to the binary by linker
- Copies code into the binary file
- May end up with large executable, but quite portable


## Dynamic (Shared) Library 动态库


- `.so` on Linux and `.dylib` on Mac
- Loaded on demand onto memory by OS at runtime
- Save memory space at cost of performance (loading takes time)

[G++ HOWTO](http://tldp.org/HOWTO/Program-Library-HOWTO/dl-libraries.html):
> The main difference is that the libraries aren't automatically loaded at program link time or start-up; instead, there is an API for opening a library, looking up symbols, handling errors, and closing the library. C users will need to include the header file `<dlfcn.h>` to use this API.


## C++ Virtual Method Table 虚函数表




# Emscripten





```bash
emcmake cmake 
    -DCMAKE_BUILD_TYPE=Debug \
    -DCMAKE_CXX_FLAGS=" \
        -s RELOCATABLE=1 \
        -s ASSERTIONS=2 \
        -s INITIAL_MEMORY=2080374784" \
    -DCMAKE_SHARED_LINKER_FLAGS="-s SIDE_MODULE=1"
```