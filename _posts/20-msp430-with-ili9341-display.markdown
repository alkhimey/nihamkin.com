---
categories:  ili9341, msp430, embedded
date: 2016/04/30 20:00:00
title: Connecting MSP430 with ILI9341 TFT Display
draft: False
---

<center>
![msp430 launcpad connected to ili9341 display](/files/msp430photo.jpg)
</center>

In the previous post I described how to connect ESP8266 with an ILI9431 TFT display using the Adafruit library. Texas Instruments' MSP430 is another popular low cost 3.3v MCU used by the maker community. It has Energia which is an IDE forked from  and compatible to the Arduino IDE. Therefore porting the Adafruit library to work with it should be almost trivial.

The first step is to obtain an MSP430 launchpad. You will need one that come with an MCU that has at least 16Kb of FLASH, I will explain this requirement later in this post. The currently sold 9.99$ [value line](http://www.ti.com/ww/en/launchpad/launchpads-msp430-msp-exp430g2.html#tabs) version which comes with msp430g32553 MCU is sufficient. Older revisions of this launchpad might come with MCUs that does not have enough space.

After obtaining the launchpad, download and install [Energia](http://energia.nu). You might want to try to upload and run some of the basic examples before advancing forward.

Another requirement is to enable hardware UART by rotating jumpers on the launchpad as explained with [this tutorial](http://energia.nu/Serial.html). This will enable receiving debug messages from the graphicstest sketch.

As Energia is an Arduino-like environment, therefore not many [changes](https://github.com/alkhimey/Adafruit_ILI9341/commit/d232e057a852b474b509c42bb5a237d2f1905538) to the library were required. The graphicstest.ino example sketch had to be modified by excluding textTest function from the sketch when compiling for *msp430g32553*. This is because this MCU has 16Kb of ROM memory, while the full sketch size is ~19Kb. There are MCUs with even lower ROM sizes (eg *[msp430g2452](http://www.ti.com/product/MSP430G2452)* which has 8Kb), if anyone would like to try this sketch, it will be required to remove more test function to reduce the size even further.

Now [download](https://github.com/alkhimey/Adafruit_ILI9341/tree/msp430-support) the modified library and place it in the [library](http://energia.nu/Guide_Environment.html#libraries) folder of Energia. If you are cloning the repo, make sure to checkout "*msp430-support*" branch. After restarting Energia, you will be able to see the *Adafruit_ILI9341* examples in the *Examples* list.

Make the following connections. Those connections are specific to *msp430g32553* launchpad. Other launchpads in this family have different pins for hardware SPI, so be careful and look it up in the reference.

<center>
![msp430g32553 pinout](/files/LaunchPadMSP430G2553-V1.5-700px.jpg)
</center>

| ILI9341       |          | MSP430  |
|:------------- |:--------:| -------:|
| SDD/MISO      |  &#8660; | P1.6    |
| LED           |  &#8660; | 3.3V    |
| SCK           |  &#8660; | P1.5    |
| SDI/MOSI      |  &#8660; | P1.7    |
| DC/RS         |  &#8660; | P2.1    |
| RESET         |  &#8660; | 3.3V    |
| CS            |  &#8660; | P2.2    |
| GND           |  &#8660; | GND     |
| VCC           |  &#8660; | 3.3V    |

DC and CS can be any of the GPIO pins, yet they need to be consistent with the values passed to the library constructor.

Here are the results of the benchmark, textTest did not run therefore its results are 0.

$$code

ILI9341 Test!
Display Power Mode: 0x9C
MADCTL Mode: 0x48
Pixel Format: 0x5
Image Format: 0x0
Self Diagnostic: 0xC0
Benchmark                Time (microseconds)
Screen fill              3986432
Text                     0
Lines                    6518272
Horiz/Vert Lines         345088
Rectangles (outline)     235520
Rectangles (filled)      8283648
Circles (filled)         2135552
Circles (outline)        2848768
Triangles (outline)      2067456
Triangles (filled)       3433984
Rounded rects (outline)  1003008
Rounded rects (filled)   9315840
Done!

$$/code

It is also possible to use software SPI the example sketch has a commented section that describes how to perform this. Being said, this option is extremely slow and I do not advice using it with MSP430.



