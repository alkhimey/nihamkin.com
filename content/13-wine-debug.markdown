---
categories: Linux, Windows, Wine
date: 2013/11/09 14:00:00
title: Making Legacy Software Work On Windows
draft: False
---

It sometimes happens that programs written for old versions of Windows will not work on new versions even with compatibility mode enabled. It is not uncommon for such program to crash and show some cryptic message that even a person of technical background can not understand.  Sometimes only a simple fix is required, like providing a missing DLL or creating a registry key, yet the program will not tell us what it actually expected to find. Recently I have discovered a technique that can help debug such situations. It might surprise the reader the the solution comes from the Linux world.

[Wine](http://www.winehq.org) is a tool that allows running Windows programs on Linux. It does this by providing a Linux implementation of Window's API and system calls. One neat feature of Wine is the ability to output which system calls are being called during an execution of a program. 

### Example

I will demonstrate how to get advantage of this feature  with a game called "Janes F-15". This is a flight simulator released in 1998 for Windows 95.

The problem I had, was not with the game itself but with it's installer. The installer would say "ERROR, Copying files" right after it began it's operation. Which files it was unable to copy it did not specify.

![setup error message](/files/f15-setup.png)

Finding which file is missing can be done by reading the debug messages. The debug messages are enabled by setting the _WINEDEBUG_ environment variable before running the program:

$$code(lang=shell)
$ export WINEDEBUG=warn+all
$$/code

The number of messages produced by even a boilerplate program is very big, the console will spit text long after the application is closed, and it will be hard to determine cause and effect behavior.  Therefore different "debug" channels exist. In the example above I have used the "all" channel and limited it only to warnings. Other scenarios would require other channels. In the following [link](http://wiki.winehq.org/DebugChannels) a complete documentation of all the channels can be found.

So I set the environment variable and run the installer. Just before clicking the last "next" button of the wizard (which causes the installation process to actually start), I brought the the console to the front. Clicking on the final "next" button caused some more messages to be printed into the console, with the most relevant messages being printed last:

![screenshot of the console](/files/f15-setup-debug-small.png)

It is now clear what the problem is. 

$$code(lang=shell)
warn:ntdll:NtQueryAttributesFile L"\\??\\C:\\windows\\system32\\EAREMOVE.EXE" not found (c0000034)
warn:file:OpenFile (C:\windows\system32\EAREMOVE.EXE): return = HFILE_ERROR error= 2
warn:ntdll:NtQueryAttributesFile L"\\??\\C:\\Janes\\F15\\EAREMOVE.EXE" not found (c0000034)
warn:file:OpenFile (C:\Janes\F15\EAREMOVE.EXE): return = HFILE_ERROR error= 2
warn:ntdll:NtQueryAttributesFile L"\\??\\E:\\EAREMOVE.EXE" not found (c0000034)
warn:file:OpenFile (.\EAREMOVE.EXE): return = HFILE_ERROR error= 2
$$/code


The installer searches for a file called "EAREMOVE.EXE", first in system32 directory, then inside the directory where the game is about to be installed, and finally on the installation disk. I do not know what is the logic behind this behavior and why this file was missing. 

Creating an empty file named "EAREMOVE.EXE" in the system32 directory solved the problem and allowed the installer to continue. The game was installed correctly and I was able to run it.






