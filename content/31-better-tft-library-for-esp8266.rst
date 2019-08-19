Better TFT Library for ESP8266
###############################

:date: 2019/08/20 03:00:00
:tags: esp8266, arduino, embedded, ili9341
:authors: Artium Nihamkin
:category: ESP8266/ESP32

.. role:: c(code)
   :language: c

In 2016 I wrote a `tutorial
<2016/03/04/connecting-esp8266-with-ili9341-tft-display/>`_ about connecting
ESP8266 with an ili9341 TFT display. That tutorial suggested using Adafruit's
library modified to work with the ESP8266.

Now I discovered that there is a much better library which is tailored for the
ESP8266. This library is called `TFT_eSPI
<https://github.com/Bodmer/TFT_eSPI>`_.

This library is available from Arduino's library manager, thus the process of
installation is very easy.

.. image:: /files/esp8266/arduino_library_manager.png
    :alt: TFT_eSPI in Arduino Library Manager.
    :align: center

One thing to notice is that after installation, it is required to go to the file **User_Setup.h** which is in the librarie's directory and edit it.
There are a lot of parameters there, the important are the definition of the ESP8266 pins that will be used for connecting the TFT display:

For example, for my Lolin NodeMCU V3 I used the following configuration:

.. code-block:: c

    #define TFT_CS   PIN_D2  // Chip select control pin D8
    #define TFT_DC   PIN_D1  // Data Command control pin
    //#define TFT_RST  PIN_D4  // Reset pin (could connect to NodeMCU RST, see next line)
    #define TFT_RST  -1 

Also check that ILI9341 driver is selected (TFT_eSPI supports several screen models):

.. code-block:: c

    // Only define one driver, the other ones must be commented out
    #define ILI9341_DRIVER
    //#define ST7735_DRIVER      // Define additional parameters below for this display
    //#define ILI9163_DRIVER     // Define additional parameters below for this display
    //#define S6D02A1_DRIVER
    //#define RPI_ILI9486_DRIVER // 20MHz maximum SPI
    //#define HX8357D_DRIVER
    //#define ILI9481_DRIVER
    //#define ILI9486_DRIVER
    //#define ILI9488_DRIVER     // WARNING: Do not connect ILI9488 display SDO to MISO if other devices share the SPI bus (TFT SDO does NOT tristate when CS is high)
    //#define ST7789_DRIVER      // Full configuration option, define additional parameters below for this display
    //#define ST7789_2_DRIVER    // Minimal configuration option, define additional parameters below for this display
    //#define R61581_DRIVER
    //#define RM68140_DRIVER


The API is similar to Adafruit in most cases, but additionally TFT_eSPI has
more features like ability to draw Sprites.

As a demonstration of how quicker it is, here are few comparisons of the
graphics test program. I tried several SPI frequencies, this can be controlled using the :code:`#define SPI_FREQUENCY` macro in *User_Setup.h*.


Adafruit_ILI9341 Library
------------------------
 .. parsed-literal::
    ILI9341 Test!
    Display Power Mode: 0x94
    MADCTL Mode: 0x48
    Pixel Format: 0x5
    Image Format: 0x80
    Self Diagnostic: 0xC0
    Benchmark                Time (microseconds)
    Screen fill              1606040
    Text                     92026
    Lines                    809972
    Horiz/Vert Lines         134436
    Rectangles (outline)     85586
    Rectangles (filled)      3329421
    Circles (filled)         421733
    Circles (outline)        356141
    Triangles (outline)      184657
    Triangles (filled)       1121997
    Rounded rects (outline)  166946
    Rounded rects (filled)   3330265
    Done!

TFT_eSPI with SPI_FREQUENCY set to 27000000
---------------------------------------------
 .. parsed-literal::   
    TFT_eSPI library test!
    Benchmark                Time (microseconds)
    Screen fill              237671
    Text                     27003
    Lines                    160091
    Horiz/Vert Lines         20537
    Rectangles (outline)     13842
    Rectangles (filled)      487678
    Circles (filled)         115760
    Circles (outline)        101732
    Triangles (outline)      37935
    Triangles (filled)       194903
    Rounded rects (outline)  48270
    Rounded rects (filled)   554112
    Done!

TFT_eSPI with SPI_FREQUENCY set to 40000000
--------------------------------------------
 .. parsed-literal::
    TFT_eSPI library test!
    Benchmark                Time (microseconds)
    Screen fill              161174
    Text                     23332
    Lines                    137703
    Horiz/Vert Lines         14246
    Rectangles (outline)     9835
    Rectangles (filled)      330783
    Circles (filled)         93076
    Circles (outline)        87518
    Triangles (outline)      32453
    Triangles (filled)       142416
    Rounded rects (outline)  39809
    Rounded rects (filled)   380746
    Done!

TFT_eSPI with SPI_FREQUENCY set to 80000000
--------------------------------------------
 .. parsed-literal::
    TFT_eSPI library test!
    Benchmark                Time (microseconds)
    Screen fill              84359
    Text                     20697
    Lines                    118085
    Horiz/Vert Lines         7990
    Rectangles (outline)     5913
    Rectangles (filled)      173302
    Circles (filled)         71464
    Circles (outline)        78870
    Triangles (outline)      27596
    Triangles (filled)       91296
    Rounded rects (outline)  33468
    Rounded rects (filled)   207793
    Done!


TFT_eSPI with SPI_FREQUENCY set to 80000000 and CPU running at 160 MHz
----------------------------------------------------------------------
 .. parsed-literal::
    TFT_eSPI library test!
    Benchmark                Time (microseconds)
    Screen fill              81344
    Text                     13412
    Lines                    79826
    Horiz/Vert Lines         7326
    Rectangles (outline)     5143
    Rectangles (filled)      166979
    Circles (filled)         51367
    Circles (outline)        51259
    Triangles (outline)      18983
    Triangles (filled)       74893
    Rounded rects (outline)  22796
    Rounded rects (filled)   194053
    Done!
