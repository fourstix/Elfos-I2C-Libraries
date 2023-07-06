# Elfos-I2C-Libraries
Libraries for using various I2C devices with an 1802-Mini with the PIO and I2C expansion boards. 

Platform  
--------
The programs were written to run displays from an [1802-Mini](https://github.com/dmadole/1802-Mini) by David Madole running with the [1802/Mini PIO Parallel Expansion Board](https://github.com/arhefner/1802-Mini-PIO) with the [I2C interface board](https://github.com/arhefner/1802-Mini-I2C) by Tony Hefner. 

These programs were assembled and linked with updated versions of the Asm-02 assembler and Link-02 linker by Mike Riley. The updated versions required to assemble and link this code are available at [arhefner/Asm-02](https://github.com/arhefner/Asm-02) and [arhefner/Link-02](https://github.com/arhefner/Link-02).

1802-Mini v4.5 Configuration 
-----------------------------
For this configuration, the code is assembled with the expansion group  I2C_GROUP  defined as 02 in sysconfig.inc and with the I2C_PORT define statement set equal to 7.

Card Groups and Ports
-------------------------
<table>
<tr><th>Group</th><th>Ports</th><th>Card</th></tr>
<tr><td rowspan = "3">ALL</td><td>1</td><td>

[Pixie Video](https://groups.io/g/cosmacelf/message/39132)

</td></tr>
<tr><td>4</td><td>

[Front Panel](https://github.com/dmadole/1802-Mini-Front-Panel)

</td></tr>
<tr><td>5</td><td>

[Expander](https://github.com/dmadole/1802-Mini-Expander-RTC)

</td></tr>
<tr><td rowspan = "4">00</td><td>2</td><td rowspan="2">

[Compact Flash](https://github.com/dmadole/1802-Mini-Compact-Flash)

</td></tr>
<tr><td>3</td></tr>
<tr><td>6</td><td rowspan="2">

[UART](https://github.com/dmadole/1802-Mini-1854-Serial)

</td></tr>
<tr><td>7</td></tr>
<tr><td rowspan="3">01</td><td>3</td><td>

[Real Time Clock](https://github.com/dmadole/1802-Mini-Expander-RTC)

</td></tr>
<tr><td>6</td><td rowspan="2">

[TMS9X19 Video](https://github.com/dmadole/1802-Mini-9918-Video)

</td></tr>
<tr><td>7</td></tr>
<tr><td rowspan="4">02</td><td>2</td><td rowspan="2">

[SPI/MicroSD](https://github.com/arhefner/1802-Mini-SPI-DMA)

</td></tr>
<tr><td>3</td></tr>

<tr><td>6</td><td>

[PIO](https://github.com/arhefner/1802-Mini-PIO)

</td></tr>
<tr><td>7</td><td>

[I2C Adapter](https://github.com/arhefner/1802-Mini-I2C)
</td></tr>

</table>

External Flags
-------------------------
<table>
<tr><th>Flag</th><th>Card</th><th>Function</th></tr>
<tr><td>/EF1</td><td>Pixie Video</td><td>Video Status</td></tr>
<tr><td>/EF2</td><td>Processor</td><td>Software IO</td></tr>
<tr><td>/EF3</td><td>PIO/I2C</td><td>SDA</td></tr>
<tr><td rowspan="2">/EF4</td><td>Front Panel</td><td>Input Button</td></tr>
<tr><td>PIO/I2C</td><td>SCL (Clock-Stretching)</td></tr>
</table>

Supported Devices
------------------
<table>
<tr><th>Device</th><th>Library</th></tr>
<tr><td>Adafruit 7 Segment LED display</td><td>led7</td></tr>
<tr><td>Sparkfun 14-Segment Alphanumeric display</td><td>alnum</td></tr>
<tr><td>Sparkfun Qwiic Single Relay</td><td>relay</td></tr>
<tr><td>Sparkfun Qwiic Joystick</td><td>joystick</td></tr>
<tr><td>LM75A temperature Sensor</td><td>lm75a</td></tr>
</table>

I2C Library API
----------------
(TBD)

Device Library API
-------------------
(TBD)

Demo programs
-------------



Repository Contents
-------------------
(TBD)


License Information
-------------------

This code is public domain under the MIT License, but please buy me a beverage
if you use this and we meet someday (Beerware).

References to any products, programs or services do not imply
that they will be available in all countries in which their respective owner operates.

Adafruit, the Adafruit logo, and other Adafruit products and services are
trademarks of the Adafruit Industries, in the United States, other countries or both. 

Sparkfun, the Sparkfun logo, and other Sparkfun products and services are
trademarks of the Sparkfun Electronics, in the United States, other countries or both. 

Any company, product, or services names may be trademarks or services marks of others.

All libraries used in this code are copyright their respective authors.

This code is based on code written by Tony Hefner and assembled with the Asm/02 assembler and Link/02 linker written by Mike Riley.

Elf/OS  
Copyright (c) 2004-2023 by Mike Riley

Asm/02 1802 Assembler  
Copyright (c) 2004-2023 by Mike Riley

Link/02 1802 Linker  
Copyright (c) 2004-2023 by Mike Riley

The 1802/Mini PIO Parallel Expansion Board   
Copyright (c) 2022-2023 by Tony Hefner

The 1802/Mini I2C Adapter Board   
Copyright (c) 2022-2023 by Tony Hefner

The 1802-Mini Microcomputer Hardware   
Copyright (c) 2020-2023 by David Madole  

Many thanks to the original authors for making their designs and code available as open source, and a big thank you to Bernie Murphy for his testing, code contributions and suggestions.

This code, firmware, and software is released under the [MIT License](http://opensource.org/licenses/MIT).

The MIT License (MIT)

Copyright (c) 2023 by Gaston Williams

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

**THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.**
