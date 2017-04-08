Tags: ada, linux, kernel, os
date: 2016/11/5 17:30:00
title: Writing Linux Modules in Ada - Part 2
url: 2016/11/05/writing-linux-modules-in-ada-part-2/
save_as: 2016/11/05/writing-linux-modules-in-ada-part-2/index.html

<a class="github-button" href="https://github.com/alkhimey/Ada_Kernel_Module_Toolkit/"  data-style="mega" aria-label="View alkhimey/Ada_Kernel_Module_Toolkit on GitHub">View on Github</a>
<a class="github-button" href="https://github.com/alkhimey/Ada_Kernel_Module_Toolkit" data-icon="octicon-star" data-style="mega" data-count-href="/alkhimey/Ada_Kernel_Module_Toolkit/stargazers" data-count-api="/repos/alkhimey/Ada_Kernel_Module_Toolkit#stargazers_count" data-count-aria-label="# stargazers on GitHub" aria-label="Star alkhimey/Ada_Kernel_Module_Toolkit on GitHub">Star on Github</a>
<a class="github-button" href="https://github.com/alkhimey/Ada_Kernel_Module_Toolkit/archive/blog-post-pt-2.zip" data-icon="octicon-cloud-download" data-style="mega" aria-label="Download alkhimey/Ada_Kernel_Module_Toolkit on GitHub">Download Pt-2</a>


<script async defer src="https://buttons.github.io/buttons.js"></script>

<!--
<a href="https://github.com/alkhimey/Ada_Kernel_Module_Toolkit"><img style="position: absolute; top: 0; right: 0; border: 0;" src="https://camo.githubusercontent.com/a6677b08c955af8400f44c6298f40e7d19cc5b2d/68747470733a2f2f73332e616d617a6f6e6177732e636f6d2f6769746875622f726962626f6e732f666f726b6d655f72696768745f677261795f3664366436642e706e67" alt="Fork me on GitHub" data-canonical-src="https://s3.amazonaws.com/github/ribbons/forkme_right_gray_6d6d6d.png"></a>
-->

In the [previous post](/2016/10/23/writing-linux-modules-in-ada-part-1/) I demonstrated that writing Linux kernel modules in Linux is not science fiction.

Yet, the produced module was extremely simple. Before improving it, some foundation needs to be added. Today I want to introduce the secondary stack.

## Secondary Stack

The existence of the secondary stack allows functions to return objects of unconstrained types.

For example:

    :::ada
    function Get_Answer return String is
    begin
       return "Forty Two";
    end Get_Answer;

The length of the returned ```String``` is unknown during compilation, and therefore it is problematic to allocate space for it on the primary stack. In this particular example the compiler might deduce the maximum size statically but generally, the size of the returned string could also depend on user input.

[This article](https://docs.adacore.com/gnat_ugx-docs/html/gnat_ugx/gnat_ugx/the_secondary_stack.html) has a good explanation about this stack.

The secondary stack is required for ```'Image``` attribute to work, which is in turn used in ```Interfaces.C``` package. Therefore it is important for the purpose of writing bindings to Kernel functions.

A [compiler switch](https://gcc.gnu.org/onlinedocs/gnat_ugn/Switches-for-gnatbind.html#index-g_t-D-_0028gnatbind_0029-683), as well as an attribute can control the size and type of the secondary stack.

> -D`nn'[k|m]
>    
>    This switch can be used to change the default secondary stack size value to a specified size nn, which is expressed in bytes by default, or in kilobytes when suffixed with k or in megabytes when suffixed with m.
>
>    The secondary stack is used to deal with functions that return a variable sized result, for example a function returning an unconstrained String. There are two ways in which this secondary stack is allocated.
>    
>    For most targets, the secondary stack is growing on demand and is allocated as a chain of blocks in the heap. The -D option is not very relevant. It only give some control over the size of the allocated blocks (whose size is the minimum of the default secondary stack size value, and the actual size needed for the current allocation request).
>    
>    For certain targets, notably VxWorks 653, the secondary stack is allocated by carving off a fixed ratio chunk of the primary task stack. The -D option is used to define the size of the environment task's secondary stack.
>

    :::ada
    task A_Task with
      Storage_Size         => 20 * 1024,
      Secondary_Stack_Size => 10 * 1024;

As can be understood from the example, each task has it's own secondary stack. We of course need only one secondary stack as there are no tasks in our run time.

## Implementation

The implementation of the secondary stack is located in **s-secsta.ads** and **s-secsta.ads** files.

I copied these files from the native rts of the installed gnat (_/usr/gnat/lib/gcc/x86_64-pc-linux-gnu/4.9.4/rts-native/adainclude/s-secsta.adb_) and started editing them.

I uploaded the diff [here](https://gist.github.com/alkhimey/0e859655e32a5289e95ee193d76fabdf/revisions). Please Ignore the difference at the license header, I had some confusion between AdaCore and FSF versions.


The interface is quite simple. A set of function like ```Init```, ```Allocate```, ```Mark``` that receive an pointer to the stack in the form of an ```System.Address```.

The reason to receive the stack as a parameter is because there might be several stacks in the system, for example a stack for each task. In this Kernel run time there are no tasks, so only one stack is required. Nevertheless, the interface can not be changed as gnat tools are expecting these exact signatures.

The implementation is even less Ada-iomatic. Untyped chunks of memory, unchecked conversions, unchecked deallocations and a lot of pointer work.

I decided not to change the implementation very much. Only remove the unnecessary stuff.

In the original code, dynamic stack is allocated on the heap as a linked list of memory chunks.

For static stack, if a stack of less that 10K is required than a memory chunk that is defined as a global in the package is used. Otherwise a memory chunk of the appropriate size is dynamically allocated.

    :::ada
       Default_Secondary_Stack_Size : Natural := 10 * 1024;
       --  Default size of a secondary stack. May be modified by binder -D switch
       --  which causes the binder to generate an appropriate assignment in the
       --  binder generated file.

Throughout the code, static and dynamic cases are distinguished with ```SS_Ratio_Dynamic```. There is almost no shared code.

    :::ada
       SS_Ratio_Dynamic : constant Boolean :=
                            Parameters.Sec_Stack_Percentage = Parameters.Dynamic;
       --  There are two entirely different implementations of the secondary
       --  stack mechanism in this unit, and this Boolean is used to select
       --  between them (at compile time, so the generated code will contain
       --  only the code for the desired variant). If SS_Ratio_Dynamic is
       --  True, then the secondary stack is dynamically allocated from the
       --  heap in a linked list of chunks. If SS_Ration_Dynamic is False,
       --  then the secondary stack is allocated statically by grabbing a
       --  section of the primary stack and using it for this purpose.


Since currently the run time does not support any kind of dynamic allocations, I removed all the dynamic stack branches, as well as the dynamic allocation of the static stack. This renders **```-D```** flag to have no effect on the code, a 10K stack is always allocated.

It is true that dynamic allocation in the kernel can be done with ```kmalloc```, but it is a bit tricky for me at this stage.

To allow the module code use the stack, I had to comment out a pragma restriction in the **gnat.adc** file.

    :::ada
    --pragma Restrictions (No_Secondary_Stack);

This file contains a set of pragmas that are applied globally to the project. A gpr file configuration of the _adc_ file might look like this:

    :::ada
    package Builder is
       for Global_Configuration_Pragmas use "gnat.adc";
    end Builder;

There are many other restrictions in that file that prevent using run time features that are not implemented.

After doing all this and adding a test module that demonstrates a function that return unconstrained string, I stumbled upon a strange error:

    :::shell
    $sudo insmod hello.ko 
    insmod: ERROR: could not insert module hello.ko: Invalid module format
    $dmesg | tail -2
    [36648.395725] module: overflow in relocation type 10 val ffffffffc04da000
    [36648.395731] module: `hello' likely not compiled with -mcmodel=kernel

It turns out I had to add the "```-mcmodel=kernel```" flag to the compilation section in the _gpr_ file.

## Conclusion
That is it. You can try it yourself using the "Download Pt-2" link at the top of the page. The "Download Pt-X" links are snapshots of the git repository that are compatible with the appropriate blog post. So even as I continue to improve the toolkit, readers will still be able to play with the original version.

My next steps will be to add ```'Image``` and ```Interfaces.C```. And after that I will be able to bind some kernel functions.

Stay tuned :)
