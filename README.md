# Elfos-I2C-Libraries
Libraries for using various I2C devices with an 1802-Mini with the PIO and I2C expansion boards. 

Platform  
--------
The programs were written to run displays from an [1802-Mini](https://github.com/dmadole/1802-Mini) by David Madole running with the [1802/Mini PIO Parallel Expansion Board](https://github.com/arhefner/1802-Mini-PIO) with the [I2C interface board](https://github.com/arhefner/1802-Mini-I2C) by Tony Hefner. 

These programs were assembled and linked with updated versions of the Asm-02 assembler and Link-02 linker by Mike Riley. The updated versions required to assemble and link this code are available at [arhefner/Asm-02](https://github.com/arhefner/Asm-02) and [arhefner/Link-02](https://github.com/arhefner/Link-02).

1802-Mini v4.5 Configuration 
-----------------------------
For this configuration, the code is assembled with the expansion group  I2C_GROUP  defined as 02 in sysconfig.inc and with the I2C_PORT define statement set equal to 7.

Modification of I2C Adapter
-----------------------------

Version A of the I2C Adapter needs a single wire modification to support I2C clock stretching.  The jumper at JP1 must be set to use EF3 for the SDA line.  Then solder a wire from the EF4 post on JP1 to the SCL signal available on the right side of resistor R7 as shown in the diagrams below.  I found it easiest to solder the wire on the backside of then I2C Adapter.

![Modification - Front View](https://github.com/fourstix/Elfos-I2C-Libraries/blob/main/pics/modAfront.png)

![Modification - Back View](https://github.com/fourstix/Elfos-I2C-Libraries/blob/main/pics/modAback.png)

You can find more information about clock-stretching and I2C in general in the Adafruit
tutorial [*Working with I2C Devices*](https://learn.adafruit.com/working-with-i2c-devices).

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
<tr><td>LM75A Temperature Sensor</td><td>lm75a</td></tr>
<tr><td>SHT31 Temperature and Humidity Sensor</td><td>sht31</td></tr>
</table>

I2C Library API
----------------
<table>
<tr><th>Name</th><th>Description</th></tr>
<tr><td>i2c_init</td><td>Initialize the i2c bus</td></tr>
<tr><td>i2c_avail</td><td>Check for an i2c device at a given address</td></tr>
<tr><td>i2c_wrbuf</td><td>Write a message to the i2c bus</td></tr>
<tr><td>i2c_rdbuf</td><td>Read a message from the i2c bus</td></tr>
<tr><td>i2c_rdreg</td><td>Read a message from a register in an i2c device.</td></tr>
<tr><td>i2c_scan</td><td>Scan the i2c bus for any device with the id in RF.0</td></tr>
<tr><td>i2c_clear</td><td>Attempt to clear a device error on the i2c bus</td></tr>
</table>

These API functions return DF=0 when successful, and DF=1 when there is an error.

Util Library API
-------------------
<table>
<tr><th>Name</th><th>Description</th></tr>
<tr><td>util_full_mult16</td><td>Multiply two 16-bit integer numbers into a full 32-bit integer product</td></tr>
<tr><td>util_write_10x</td><td>Write a 10X value into a buffer as a single-precession decimal string</td></tr>
<tr><td>util_c_to_f</td><td>Convert a 1X Celsius value into a 10X Fahrenheit value </td></tr>
<tr><td>util_delay</td><td>Wait for the amount of time specified in RC and then return</td></tr>
</table>


Example programs
----------------

<table>
<tr><th>Device</th><th>Example Programs</th></tr>
<tr><td>(Any I2C device)</td><td>scanner</td></tr>
<tr><td>Adafruit 7 Segment LED display</td><td>led7print, led7clear, led7clock</td></tr>
<tr><td>Sparkfun 14-Segment Alphanumeric display</td><td>alprint, alclear, altest</td></tr>
<tr><td>Sparkfun Qwiic Single Relay</td><td>relay, relayOn, relayOff</td></tr>
<tr><td>Sparkfun Qwiic Joystick</td><td>joystick</td></tr>
<tr><td>LM75A Temperature Sensor</td><td>lm75a</td></tr>
<tr><td>SHT31 Temperature and Humidity Sensor</td><td>sht31</td></tr>
</table>

[![Adafruit List of I2C Devices](https://cdn-learn.adafruit.com/guides/cropped_images/000/001/701/medium640/PhotoFunia-1501383296.jpg)](https://learn.adafruit.com/i2c-addresses)

[*Adafruit List of I2C Devices*](https://learn.adafruit.com/i2c-addresses)

Example program
----------------
## scanner
**Usage:** scanner    
Scan the i2c bus and list the devices found.

[![Adafruit 4-Digit 7-Segment Display - Red](https://cdn-shop.adafruit.com/970x728/878-05.jpg)](https://www.adafruit.com/product/878)

[*Adafruit 4-Digit 7-Segment Display - Red (878)*](https://www.adafruit.com/product/878)

Example programs
----------------
## led7print
**Usage:** led7print *hhhh*    
Print the hex digits *hhhh* on the Adafruit 7 Segment LED display.

## led7clear
**Usage:** led7clear    
Clear the Adafruit 7 Segment LED display.

## led7clock
**Usage:** led7clock    
Display a digital clock on the Adafruit 7 Segment LED display.  Requires the 1802-Mini RTC (Real Time Clock) Card.  Press the input button to exit the program.

[![Sparkfun Qwiic Alphanumeric Display - Blue](https://cdn.sparkfun.com/assets/parts/1/5/1/8/2/16426-Demo-01.jpg)](https://cdn.sparkfun.com/assets/parts/1/5/1/8/2/16426-Demo-01.jpg)

[*Sparkfun Qwiic Alphanumeric Display - Blue (SPX-16426)*](https://www.sparkfun.com/products/16426)

Example programs
----------------
## alprint  
**Usage:** alprint *cccc*    
Print the characters *cccc* on the Sparkfun 14 Segment LED display.

## alclear  
**Usage:** alclear    
Clear the Sparkfun 14 Segment LED display.

## altest  
**Usage:** altest     
Turn on four segments, one per each character, along with the colon and decimal point to test the Sparkfun 14 Segment LED display.

[![Sparkfun Qwiic Single Relay](https://cdn.sparkfun.com//assets/parts/1/3/4/5/1/15093-SparkFun_Qwiic_Single_Relay-01.jpg)](https://www.sparkfun.com/products/15093)

[*Sparkfun Qwiic Single Relay (COM-15093)*](https://www.sparkfun.com/products/15093)

Example programs
----------------
## relay
**Usage:** relay [-s|-t|-v, default = -s]   
Show state, show version or toggle the Sparkfun Qwiic Single Relay.  
*Options:* 
*  -s Show relay state (default)
*  -t Toggle relay state
*  -v show relay Version
           
## relayOn
**Usage:** relayOn   
Turn on the Sparkfun Qwiic Single Relay.

## relayOff
**Usage:** relayOff   
Turn off the Sparkfun Qwiic Single Relay.

[![Sparkfun Qwiic Joystick](https://cdn.sparkfun.com/assets/parts/1/3/5/5/8/15168-SparkFun_Qwiic_Joystick-01.jpg)](https://www.sparkfun.com/products/15168)

[*SparkFun Qwiic Joystick (COM-15168)*](https://www.sparkfun.com/products/15168)

Example program
----------------
## joystick
**Usage:** joystick   
Show information read from the Sparkfun Qwiic Joystick.


[![LM75A Temperature Sensor](https://m.media-amazon.com/images/I/51C7YSnVaTL._SL1010_.jpg)](https://www.amazon.com/s?k=lm75a+temperature+sensor&i=industrial&crid=M44WMUW0SOME&sprefix=lm75a+temperature+sensor%252Cindustrial%252C76)

[*LM75A Temperature Sensor*](https://www.amazon.com/s?k=lm75a+temperature+sensor&i=industrial&crid=M44WMUW0SOME&sprefix=lm75a+temperature+sensor%252Cindustrial%252C76)

Example program
----------------
## lm75a
**Usage:** lm75a [-c|-f, default = -c]  
Show the temperature read from the LM75A temperature sensor.  

*Options:*
* -c show temperature in Celsius (default)   
* -f show temperature in Fahrenheit

[![Adafruit SHT31 Temperature & Humidity Sensor](https://cdn-shop.adafruit.com/970x728/2857-03.jpg)](https://www.adafruit.com/product/2857)

[*Adafruit SHT31 Temperature & Humidity Sensor (2857)*](https://www.adafruit.com/product/2857)

Example program
----------------
## sht31
**Usage:** sht31 [-c|-d|-e|-f|-h|-r|-s, default = -c]  
Show temperature, humidity and dewpoint readings from the SHT31 temperature and humidity sensor.  
*Options:* 
* -c show readings in Celsius (default)
* -d Disable heater
* -e Enable heater 
* -f show reading in Fahrenheit
* -h show Heater state (on or off)
* -r Reset sensor
* -s show Status byte values

Repository Contents
-------------------
* **/src/**  --Source files for assembling I2C libraries and example programs.
* **/src/alnum/**  -- Source files for Sparkfun 14 Segment Alphanumeric display library.
  * alnum.bat - Windows batch file to assemble source files to create library 
  * clean.bat - Windows batch file to delete binaries before rebuilding
* **/src/example/**  -- Source files for Elf/OS I2c library example programs.
  * build.bat - Windows batch file to assemble source files to create example programs 
  * clean.bat - Windows batch file to delete binaries before rebuilding
* **/src/i2c/**  -- Source files for Elf/OS I2C library.
  * i2c.bat - Windows batch file to assemble source files to create library 
  * clean.bat - Windows batch file to delete binaries before rebuilding
* **/src/include/**  -- Include files for Elf/OS I2c libraries and example programs.
* **/src/joystick/**  -- Source files for Sparkfun Qwiic Joystick library.
  * joystick.bat - Windows batch file to assemble source files to create library 
  * clean.bat - Windows batch file to delete binaries before rebuilding
* **/src/led7/**  -- Source files for Adafruit 7 Segment LED display library.
  * led7.bat - Windows batch file to assemble source files to create library 
  * clean.bat - Windows batch file to delete binaries before rebuilding
* **/src/lm75a/**  -- Source files for LM75A temperature sensor library.
  * lm75a.bat - Windows batch file to assemble source files to create library 
  * clean.bat - Windows batch file to delete binaries before rebuilding
* **/src/relay/**  -- Source files for Sparkfun Qwiic Single relay library.
  * relay.bat - Windows batch file to assemble source files to create library 
  * clean.bat - Windows batch file to delete binaries before rebuilding
* **/src/sht31/**  -- Source files for SHT31 temperature and humidity sensor library.
  * sht31.bat - Windows batch file to assemble source files to create library 
  * clean.bat - Windows batch file to delete binaries before rebuilding
* **/src/util/**  -- Source files for common utility library.
  * util.bat - Windows batch file to assemble source files to create library 
  * clean.bat - Windows batch file to delete binaries before rebuilding
* **/lib/**  -- Assembled Elf/OS I2C library files for linking with example programs
* **/bin/**  -- Binary files for Elf/OS I2C example programs.


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
