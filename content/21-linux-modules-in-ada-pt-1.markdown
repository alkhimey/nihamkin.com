Tags: ada, linux, kernel, os
date: 2016/10/23 13:30:00
title: Writing Linux Modules in Ada - Part 1
url: 2016/10/23/writing-linux-modules-in-ada-part-1
save_as: 2016/10/23/writing-linux-modules-in-ada-part-1/index.html
summary: In the following series of blog posts I will document my attempts to write Linux modules using the Ada language. <br> In part 1, I will demonstrate how to write in Ada and build a simple "hello world" Linux kernel module. <br> Additionally, I will introduce a basic customized Ada runtime to support our "hello world" module. This runtime will be extended in subsequent articles in the series.

<a class="github-button" href="https://github.com/alkhimey/Ada_Kernel_Module_Toolkit/"  data-style="mega" aria-label="View alkhimey/Ada_Kernel_Module_Toolkit on GitHub">View on Github</a>
<a class="github-button" href="https://github.com/alkhimey/Ada_Kernel_Module_Toolkit" data-icon="octicon-star" data-style="mega" data-count-href="/alkhimey/Ada_Kernel_Module_Toolkit/stargazers" data-count-api="/repos/alkhimey/Ada_Kernel_Module_Toolkit#stargazers_count" data-count-aria-label="# stargazers on GitHub" aria-label="Star alkhimey/Ada_Kernel_Module_Toolkit on GitHub">Star on Github</a>

<script async defer src="https://buttons.github.io/buttons.js"></script>

<!--
<a href="https://github.com/alkhimey/Ada_Kernel_Module_Toolkit"><img style="position: absolute; top: 0; right: 0; border: 0;" src="https://camo.githubusercontent.com/a6677b08c955af8400f44c6298f40e7d19cc5b2d/68747470733a2f2f73332e616d617a6f6e6177732e636f6d2f6769746875622f726962626f6e732f666f726b6d655f72696768745f677261795f3664366436642e706e67" alt="Fork me on GitHub" data-canonical-src="https://s3.amazonaws.com/github/ribbons/forkme_right_gray_6d6d6d.png"></a>
-->

In the following series of blog posts I will document my attempts to write Linux modules using the Ada language.

I am not a professional and my knowledge of the Linux kernel and gnat is not comprehensive. Please pardon me for any inaccuracies I make.

## Introduction and Motivation

Linux module is a binary that can be dynamically loaded and linked into the Kernel. One major use case is device drivers. Traditionally Linux modules are written in C and built using _kbuild_, an elaborate build system that is also used to build the kernel itself.

Code written for a module runs in the kernel with the privileges of the kernel, meaning that a programming error can cause anomalies such a system reboot, memory corruption of applications, data corruption of the hard disk and more.

Ada is a language that was designed specifically for embedded safety critical applications which makes it more suitable for writing device drivers.

## Preparations

First, I investigated the current process of writing and building modules. An example tutorial can be found [here](http://www.tldp.org/LDP/lkmpg/2.6/html/lkmpg.html).

In an nutshell, it is required to create a file that looks like this:

    :::c
    
    
    /*  
     *  hello-1.c - The simplest kernel module.
     */
    #include <linux/module.h>	/* Needed by all modules */
    #include <linux/kernel.h>	/* Needed for KERN_INFO */
    
    int init_module(void)
    {
    	printk(KERN_INFO "Hello world 1.\n");
    
        /* 
         * A non 0 return means init_module failed; module can't be loaded. 
         */
    	return 0;
    }
    
    void cleanup_module(void)
    {
    	printk(KERN_INFO "Goodbye world 1.\n");
    }
    

Additionally, a _mkefile_ that looks like this:

    :::make
    obj-m += hello-1.o
    
    all:
    	make  -C /lib/modules/$(shell uname -r)/build M=$(PWD) modules
    clean:
    	make  -C /lib/modules/$(shell uname -r)/build M=$(PWD) clean
    
Calling make will produce a *_.ko_* file which is the actual loadable module. It can be loaded and removed using the ```insmodule``` and ```rmodule```.

The difference between a _.ko_ and _.o_ file is the additional memory sections added by the linker.

## The Strategy

It is very tempting to abolish the cumbersome _kbuild_ system and use a _gpr_ file for the whole compilation and linkage. Unfortunately the makefiles that _kbuild_ is made of are too complex for me to understand, and I was able to imitate everything it does to produce the "_.ko_" file. Additionally, it is not safe to work around the _kbuild_ system as the internal details might change it future versions of the kernel.

So instead, I envision the following strategy. All the "logic" of the module will reside in Ada functions that will be compiled into a static library. The main file will be written in C and will consist of wrappers (eg ```init_module```, ```cleanup_module```) that will call the Ada functions. We will tell _kbuild_ about the existence of the Ada library, so it will link it into the module, and everyone will be happy.

## Hello World with Ada

### The Code

The Ada files contain a function which always return a constant 42. ```pragma Export``` is used to export the ```ada_foo``` symbol.

    :::ada
    package Ada_Foo_Pack is
    
       function Ada_Foo return Integer;
    
    private
       pragma Export
          (Convention    => C,
           Entity        => Ada_Foo,
           External_Name => "ada_foo");
    end Ada_Foo_Pack;
    
    :::ada
    package body Ada_Foo_Pack is
    
       Ultimate_Unswer : Integer := 0;
    
       function Ada_Foo return Integer is
       begin
    
          return Ultimate_Unswer;
    
       end Ada_Foo;
    
    begin
    
       --  This line of code will run during elaboration
       --
       Ultimate_Unswer := 42;
    
    end Ada_Foo_Pack;
    
The _C_ file performs the elaboration of Ada libraries by calling ```adakernelmoduleinit```, and then calls ```prink``` with the value returned by the Ada function.

    :::c
    #include <linux/module.h> /* Needed by all modules */
    #include <linux/kernel.h> /* Needed for KERN_INFO */
    
    extern void adakernelmoduleinit- (void);
    extern int ada_foo(void);
    
    int init_module(void)
    {
        adakernelmoduleinit();
        printk(KERN_ERR "Hello Ada %d.\n", ada_foo());
     
        return 0;
    }
    
    
    void cleanup_module(void)
    {
        printk(KERN_ERR "Goodbye Ada.\n");
    }

So far nothing too complicated. However when building the module, _kbuild_ complaints about many missing symbols. These missing symbols are part of the "Run Time". The calls to these methods are either produced by a compiler (for example ```delay 0.1;``` will implicitly call functions from the calendar package) or produced by the binder (initialization of the run time).

Normally, these functions can be found in _libgnat.so_, but this dynamic library is not available in the kernel space.

I also tried to tell _kbuild_ to statically link with _libgnat.a_, but it turns out that _libgnat.a_ is referencing other symbols which are supposed to be located in further libraries which complicates everything.

On top of this, linking the standard run time to the kernel does not make sense as it uses system calls (for example to open a file) which are available only in user space.


### The Run Time

The solution is to build a custom, degraded run time. Such run times are also known as "_Zero Footprint_".

To achieve this I followed "_[Ada Bare Bones](http://wiki.osdev.org/Ada_Bare_bones)_" tutorial that was written by Luke A. Guest.

To summarize, for building a run time, you will need _adainclude_ and _adalib_ directories. The first one will contain a copy of some of the files from the original run time, as well as _system.ads_, _gnat.ads_ and additional custom packages. The second directory will contain the compiled library _libgnat.a_.

When building the kernel module library, every relevant tool needs to be called with the "```--RTS=```" flag that specify the path to the directory that contains the above two.

Deprating a little bit from Luke's tutorial, I did some modifications to the directory structure, the compiler flags, removed the console package and changed the _last chance handler_ into a _null_ function.

The final directory structure would look like the following diagram. I have uploaded the complete project to githhub, and you can find this version of the project by looking for the [_blog-post-pt-1_ git tag](https://github.com/alkhimey/Ada_Kernel_Module_Toolkit/tree/blog-post-pt-1).

<a class="github-button" href="https://github.com/alkhimey/Ada_Kernel_Module_Toolkit/archive/blog-post-pt-1.zip" data-icon="octicon-cloud-download" data-style="mega" aria-label="Download alkhimey/Ada_Kernel_Module_Toolkit on GitHub">Download Pt-1</a>

    :::
    .
    ├── gnat.adc
    ├── kernel_module_lib.gpr
    ├── lib
    ├── main.c
    ├── Makefile
    ├── obj
    ├── rts
    │   ├── adainclude
    │   │   ├── ada.ads
    │   │   ├── a-unccon.ads
    │   │   ├── a-uncdea.ads
    │   │   ├── gnat.ads
    │   │   ├── g-souinf.ads
    │   │   ├── interfac.ads
    │   │   ├── last_chance_handler.adb
    │   │   ├── last_chance_handler.ads
    │   │   ├── s-atacco.adb
    │   │   ├── s-atacco.ads
    │   │   ├── s-maccod.ads
    │   │   ├── s-stoele.adb
    │   │   ├── s-stoele.ads
    │   │   └── system.ads
    │   ├── adalib
    │   ├── gnat.gpr
    │   └── obj
    └── src
        ├── ada_foo_pack.adb
        └── ada_foo_pack.ads

## Conclusion

The example module I have written is very simple proof of concept. The Ada part does not even use any of symbols exported by the kernel. In future articles I will make an attempt to write a usefull kernel module that actually does stuff.

