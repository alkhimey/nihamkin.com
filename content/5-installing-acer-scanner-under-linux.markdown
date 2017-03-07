Tags: Linux
date: 2012/11/12 14:00:00
title: How to Install an Acer Scanner Under Linux
draft: false


I own an old Acer szw4300U scanner. Making it work with Linux is not exactly a plug and play, but not very complex either. Here is how it is done.

#### Drivers

An easy way is to use [SANE](http://www.sane-project.org/) which is a framework that connects scanning software (frontends) with the scanners' drivers (backends). 

On the [following page](http://www.sane-project.org/sane-mfgs.html) you can find a list of supported scanners with reference to their drivers. My scanner uses a "snapscan" driver.

Both SANE and the drivers are already installed by default on most Linux distributions. To verify that SANE is installed use the following command:

$$code(lang=shell)
~$ scanimage -V
scanimage (sane-backends) 1.0.22; backend version 1.0.22
$$/code

*scanimage* is a defualt frontend that is bundled with SANE. Let's try to scan something with it. Do not forget to plug your scanner into the computer:

$$code(lang=shell)
~$ scanimage
[snapscan] Cannot open firmware file /usr/share/sane/snapscan/your-firmwarefile.bin.
[snapscan] Edit the firmware file entry in snapscan.conf.
scanimage: open of device snapscan:libusb:006:002 failed: Invalid argument
$$/code


The issue here is that my driver is a generic one, meaning it can handle different models of scanners depending on a provided firmware file. A firmware file has .bin extension and can be found on the windows driver installation disc. The disc usually contains several firmware files, to find out which is the firmware file for your scanner model please refer to this [table at the snapscan homepage](http://snapscan.sourceforge.net/#supported). Notice that the number after the V in the name of the file is the version number, so you might find that your disc contains an older version than the one listed on the website. Nevertheless, the firmware will still fit.

#### Configuration

The next step is to configure snapscan to use the firmware. For example my file is 
*U176V042.BIN*. We need to copy it into /usr/share/sane/snapscan/ (create the directory if it does not exist). 

Now open */etc/sane.d/snapscan.conf* and do the following:

Uncomment the line 
$$code(lang=shell)
/dev/usb/scanner0 bus=usb
$$/code

and then replace
$$code(lang=shell)
firmware /usr/share/sane/snapscan/your-firmware.bin
$$/code

with
$$code(lang=shell)
firmware /usr/share/sane/snapscan/U176V042.BIN
$$/code

#### Frontend

Finally we can test the scanner:
$$code(lang=shell)
~$ scanimage > test.pnm
[snapscan] Scanner warming up - waiting 20 seconds.
[snapscan] Scanner warming up - waiting 20 seconds.
~$ pnmtojpeg test.pnm > test.jpeg

$$/code

If you want a GUI frontend you can see the [list here](http://www3.sane-project.org/sane-frontends.html). I personaly use XSane and it is quite good.

#### Common Problems

If you get an error similar to 

$$code(lang=shell)
[snapscan] Cannot open firmware file /usr/share/sane/snapscan/U176V042.BIN
$$/code

And absolutely sure that there are no typos in the conf file, I would suggest to look into the permissions of *U176V042.BIN* file. The permissions should allow reading for "all". Here is a reminder of how to do it:

$$code(lang=shell)
/usr/share/sane/snapscan$ sudo chmod a+r U176V042.BIN
$$/code



