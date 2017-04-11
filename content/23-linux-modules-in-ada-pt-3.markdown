Tags: ada, linux, kernel, os
date: 2016/11/25 20:00:00
title: Writing Linux Modules in Ada - Part 3
url: 2016/11/25/writing-linux-modules-in-ada-part-3
save_as: 2016/11/25/writing-linux-modules-in-ada-part-3/index.html

<a class="github-button" href="https://github.com/alkhimey/Ada_Kernel_Module_Toolkit/"  data-style="mega" aria-label="View alkhimey/Ada_Kernel_Module_Toolkit on GitHub">View on Github</a>
<a class="github-button" href="https://github.com/alkhimey/Ada_Kernel_Module_Toolkit" data-icon="octicon-star" data-style="mega" data-count-href="/alkhimey/Ada_Kernel_Module_Toolkit/stargazers" data-count-api="/repos/alkhimey/Ada_Kernel_Module_Toolkit#stargazers_count" data-count-aria-label="# stargazers on GitHub" aria-label="Star alkhimey/Ada_Kernel_Module_Toolkit on GitHub">Star on Github</a>
<a class="github-button" href="https://github.com/alkhimey/Ada_Kernel_Module_Toolkit/archive/blog-post-pt-3.zip" data-icon="octicon-cloud-download" data-style="mega" aria-label="Download alkhimey/Ada_Kernel_Module_Toolkit on GitHub">Download Pt-3</a>


<script async defer src="https://buttons.github.io/buttons.js"></script>

<!--
<a href="https://github.com/alkhimey/Ada_Kernel_Module_Toolkit"><img style="position: absolute; top: 0; right: 0; border: 0;" src="https://camo.githubusercontent.com/a6677b08c955af8400f44c6298f40e7d19cc5b2d/68747470733a2f2f73332e616d617a6f6e6177732e636f6d2f6769746875622f726962626f6e732f666f726b6d655f72696768745f677261795f3664366436642e706e67" alt="Fork me on GitHub" data-canonical-src="https://s3.amazonaws.com/github/ribbons/forkme_right_gray_6d6d6d.png"></a>
-->

In this part, I will continue porting capabilities to the run-time

## Image

The [```'Image```](http://www.adaic.org/resources/add_content/standards/05rm/html/RM-3-5.html#I1590) attribute is used to return the string representation of a value. This value can be integer, boolean, enumeration etc.

The run-time have a separate implementation of the attribute for each supported type. Here is the list of files from my native run-time:

    :::bash
    /usr/gnat/lib/gcc/x86_64-pc-linux-gnu/4.9.4/rts-native/adainclude$  lsg img
    s-imgbiu.adb
    s-imgbiu.ads
    s-imgboo.adb
    s-imgboo.ads
    s-imgcha.adb
    s-imgcha.ads
    s-imgdec.adb
    s-imgdec.ads
    s-imgenu.adb
    s-imgenu.ads
    s-imgint.adb
    s-imgint.ads
    s-imgllb.adb
    s-imgllb.ads
    s-imglld.adb
    s-imglld.ads
    s-imglli.adb
    s-imglli.ads
    s-imgllu.adb
    s-imgllu.ads
    s-imgllw.adb
    s-imgllw.ads
    s-imgrea.adb
    s-imgrea.ads
    s-imguns.adb
    s-imguns.ads
    s-imgwch.adb
    s-imgwch.ads
    s-imgwiu.adb
    s-imgwiu.ads
        
These packages are not preset in our module's run-time, so when attempting to compile something like this:

    :::ada
    package body Ada_Foo_Pack is
       procedure Ada_Foo is
          S : String := Integer'Image (42) & Character'Val (0);
       begin
          Print_Kernel (S);
       end Ada_Foo;
    begin
       null;
    end Ada_Foo_Pack;
    
Will result in compiler error:

    :::bash
    ada_foo_pack.adb:3:22: construct not allowed in configurable run-time mode
    ada_foo_pack.adb:3:22: file s-imgint.ads not found
    ada_foo_pack.adb:3:22: entity "System.Img_Int.Image_Integer" not available
    
### First Step

The first step would be to copy one of the native implementations as is.

Unfortunately, the compilation results in the following errors:

    :::bash
    s-imgint.adb:75:10: violation of restriction "No_Recursion" at /home/artium/Projects/Ada_Kernel_Module_Toolkit/rts/gnat.adc:18
    s-imgint.ads:42:07: violation of restriction "No_Default_Initialization" at /home/artium/Projects/Ada_Kernel_Module_Toolkit/rts/gnat.adc:74

### No_Default_Initialization

The second violation points to the _out_ parameter ```P``` of the following declaration

    :::ada
    procedure Image_Integer
      (V : Integer;
       S : in out String;
       P : out Natural);


After some reading documentation and asking for help at the #ada irc channel, I understood that this violation happens because _gnat.adc_ has both the [```No_Default_Initialization```](https://docs.adacore.com/gnat_rm-docs/html/gnat_rm/gnat_rm/standard_and_implementation_defined_restrictions.html#no-default-initialization) restriction and the [```Normalize_Scalars```](http://www.adaic.org/resources/add_content/standards/05rm/html/RM-H-1.html) pragma.

As _sparre_ from the irc channel explains, "_Normalize_Scalars is a default initialization and you can't override the default initialization of an "out" parameter_".

As explained in [part 1](/2016/10/23/writing-linux-modules-in-ada-part-1/), the file _gnat.c_ was inherited from the bare bones tutorial. I do not know why the ```No_Default_Initialization``` restriction was added, but ```Normalize_Scalars``` looks pretty useful. Between these two I chose to remove the first one.

### No_Recursion

This one is simple, the code have a recursion:

    :::ada
    procedure Set_Digits
      (T : Integer;
       S : in out String;
       P : in out Natural)
    is
    begin
       if T <= -10 then
          Set_Digits (T / 10, S, P);
          P := P + 1;
          S (P) := Character'Val (48 - (T rem 10));
       else
          P := P + 1;
          S (P) := Character'Val (48 - T);
       end if;
    end Set_Digits;

The following version I wrote does not use recursion:

    :::ada
    procedure Set_Digits
      (T : Integer;
       S : in out String;
       P : in out Natural)
    is
       D : Natural := 0; -- will store number of digits
    begin
 
       declare
          T2 : Integer := T;
       begin
          while T2 /= 0 loop
             D := D + 1;
             T2 := T2 / 10;
          end loop;
       end;
 
       if D = 0 then
          P := P + 1;
          S (P) := '0';
       else
          for I in reverse 0 .. D - 1 loop
             P := P + 1;
             S (P) := Character'Val (48 - (T / 10 ** I) rem 10);
          end loop;
       end if;
    end Set_Digits;
 
The exponent operator I used in the code required copying additional files to the run-time:

    :::bash
    s-exnint.ads
    s-exnint.adb

It was very tempting to rewrite this package completely, as it is not the most efficient implementation possible and does not use the Ada type system intelligently.

But as I already explained, I am guided by the principle of doing as little changes as possible to the native run-time. 

### The Unknown Symbol

After the changes made, compiling the module resulted in a warning:

    :::bash
    WARNING: "system__img_int__image_integer" [/home/artium/Projects/Ada_Kernel_Module_Toolkit/hello.ko] undefined!

Trying to insert the module resulted in an error:

    :::bash
    $sudo insmod hello.ko
    insmod: ERROR: could not insert module hello.ko: Unknown symbol in module
    $dmesg | tail -1
    [132897.268341] hello: Unknown symbol system__img_int__image_integer (err 0)
    
It turns out that I forgot to add the run-time lib (_```libgnat.a```_) to the module's makefile. I am a little bit puzzled about why the previous stuff worked.

After adding _"```rts/adalib/libgnat.a```"_ to _```hello-y``` variable, the module loaded and produced the desired output:

    :::bash
    $ sudo insmod hello.ko 
    $ dmesg | tail -1
    [76863.379199]  42

### Enumeration

To make the ```Image``` attribute work with enumeration types I had to copy two additional files from the native run time:

    :::bash
    s-imenne.ads
    s-imenne.adb

I also had to comment two additional restrictions in the ```gnat.adc```:

    :::ada
    -- pragma Discard_Names;
    -- pragma Restrictions (No_Enumeration_Maps);

What happens here is that the compiler will generate the strings and store them in the compiled binary.

When compiling calls to ```Some_Type'Image(Some_Value)``` the compiler will emit a call to an run-time function that will actually do the location of the correct string.

Notice that ```Some_Value``` can also be a variable, that is why the string must be resolved at run time.

### Real Types

To add support for ```Image``` of real types (fixed and floating point), a bunch of additional files should be copied:

    :::bash
    s-exnlli.adb
    s-exnlli.ads
    s-expllu.adb
    s-expllu.ads
    s-expuns.adb
    s-expuns.ads
    s-fatllf.ads
    s-flocon.adb
    s-flocon.ads
    s-imglli.adb
    s-imglli.ads
    s-imgllu.adb
    s-imgllu.ads
    s-imgrea.adb
    s-imgrea.ads
    s-imguns.adb
    s-imguns.ads
    s-powtab.ads
    s-unstyp.ads

I modified one of the file, ```s-flocon.adb``` and removed the import of ```__gnat_init_float```. The Code that supposed to [initialize](http://wiki.osdev.org/FPU) the FPU does nothing now. I have no problems with that, so far. After all, the Linux kernel should have already did the initialization before our module is being insert.

Additionally a fixed point restriction should be lifted from ```gnat.adc```:

    :::ada
    --  pragma Restrictions (No_Fixed_Point);

### Final Words

That is all for now. Next I will do ```Interfaces``` package and start binding functions from the Kernel itself.
