Tags: Ada, X11
date: 2015/09/01 17:00:00
title: Trying Ada Bindings for X11
url: 2015/09/01/trying-ada-bindings-for-x11/
save_as: 2015/09/01/trying-ada-bindings-for-x11/index.html

Ada bindings for X11 were written Intermentics company and sponsored by Ada Joint Program Office (AJPO).

While intemetics has long been gone (looks like the it's domain is owned by L3 now), and AJPO was closed in 1998, the bindings are still around.

The "latest" version can be downloaded from [this page on adapower web site](http://www.adapower.com/index.php?Command=Class&ClassID=AdaGUI) (the download link is at the bottom named *x11ada*)

I was surprised how smooth was the process of building and running a demo program. The following tutorial will walk through this process.



## Setup 

* The tools I used for this tutorial are *gnat 4.9.3* and *gprbuild 2014*.
* Create a directory for your project. I called it "*ada11_testing*".
* Download "*x11ada_v1.30.tar.gz*" from the link provided above. Inside you will find "*ada*" directory. Copy this whole directory to "*ada11_testing*".
* Create a directory called "*obj*" inside "*ada11_testing*".

## Project File

Create "*test.gpr*" file with the following contents:

    :::ada
    
    project test is
      for main use ("test");
      
      for Source_Dirs use ("./**");
      
      for Object_Dir use "obj";
      
      for Exec_Dir use ".";
      
      package Linker is
         for Default_Switches("Ada") use ("-lX11");
      end Linker;
      
      package Compiler is
         for Default_Switches("Ada") use ("-gnateE", "-gnat2012"); 
      end Compiler;
      
      for Languages use ("Ada", "C");
    
    end test;
    

## Code ##

Being thin bindings, every *C* function of X11 library has an equivalent Ada function. Therefore example programs, documentation and tutorials that are aimed at C are suitable for Ada programmers as well.

I used example program from the following [article](http://www.linuxjournal.com/article/4879) of Linux Magazine.

    :::ada
    
    with Interfaces.C;
    with X;
    with X.Xlib;
    
    procedure Test is 
       
       use type Interfaces.C.Int;
       use type Interfaces.C.Unsigned;
       use type X.Xlib.XDisplay_access;
       
       Cant_Open_Display_Error: exception;
       
       Display          : X.Xlib.XDisplay_access;
       Screen_Num       : Interfaces.C.Int;
       Win              : X.Window;
       Graphics_Context : X.Xlib.GC;
       Report           : aliased X.Xlib.XEvent;
       
    begin
    
       Display := X.Xlib.XOpenDisplay( null );
       
       if Display = null  then
          raise Cant_Open_Display_Error;
       end if;
       
       Screen_num     := X.Xlib.DefaultScreen(Display);
       
       Win := X.Xlib.XCreateSimpleWindow
         (Display      => Display, 
          Parent       => X.Xlib.RootWindow(Display, Screen_Num), 
          XX           => 50, 
          Y            => 50, 
          Width        => 200, 
          Height       => 200, 
          Border_Width => 0, 
          Border       => X.Xlib.BlackPixel(Display, Screen_Num), 
          Background   => X.Xlib.WhitePixel(Display, Screen_Num));
       
       X.Xlib.XMapWindow(display, Win);
       
       X.Xlib.XSelectInput(Display, Win, X.StructureNotifyMask);
   
       loop
          X.Xlib.XNextEvent(Display, Report'access);
          
          exit when Report.Event_Type = X.MapNotify;
       end loop;
       
       Graphics_Context := X.Xlib.XDefaultGC(Display, Screen_Num);
     
       X.Xlib.XSetForeground(Display, Graphics_Context, X.Xlib.BlackPixel(Display, Screen_Num));
       
       X.Xlib.XDrawLine(Display, X.Drawable(Win), Graphics_Context, 10, 10, 190, 190);
       X.Xlib.XDrawLine(Display, X.Drawable(Win), Graphics_Context, 10, 190, 190, 10);
       
       X.Xlib.XSelectInput
         (Display, 
          Win, 
          Interfaces.C.Long( Interfaces.C.Unsigned( X.ButtonPressMask) or X.ButtonReleaseMask)
         );
       
       loop
          X.Xlib.XNextEvent(Display, Report'access);
          
          exit when Report.Event_Type = X.ButtonRelease;
       end loop;
       
       X.Xlib.XDestroyWindow(Display, Win);
       X.Xlib.XCloseDisplay(Display);   
       
    end Test;
    
Building with gprbuild:

    :::shell
    gprbuild -P test.gpr

And that is all it takes to use 20 years old software package!































