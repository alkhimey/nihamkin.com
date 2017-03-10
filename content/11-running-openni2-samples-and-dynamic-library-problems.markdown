Tags: openni, linux
date: 2013/08/02 17:00:00
updated: 2013/09/25 04:30:00
title: OpenNI2 Samples and Dynamic Library Problems
draft: false

While experimenting with the OpenNI2 samples, I sometimes would get the following error when trying to run one of the executables:

    :::shell
    ~/OpenNI-Linux-x86-2.2$ Samples/Bin/SimpleViewer
    Samples/Bin/SimpleViewer: error while loading shared libraries: libOpenNI2.so: cannot open shared object file: No such file or directory
    
The dynamic library file _libOpenNI2.so_ is located in the Bin folder alongside the executable. One would expect that like with DLLs on Windows, the dynamic linker have the executable's directory in it's search path.

Well, it turns out that for Linux's linker it is not the case. It searches in the _working directory_ but not in the directory of the executable.

This can be easily fixed by copying the library into a directory that is on the search path of the linker. According to [this guide](http://tldp.org/HOWTO/Program-Library-HOWTO/shared-libraries.html), the convention is to put libraries in _/usr/local/lib_. So all that needs to be done are the following actions:

    :::shell
    ~$sudo cp "OpenNI-Linux-x86-2.2 Samples/Redist/libOpenNI2.so" /usr/local/lib
    ~$sudo ldconfig
    

