# Elfos-I2C-Libraries
Libraries for using various I2C devices with an 1802-Mini with the PIO and I2C expansion boards. 

Platform  
--------
The programs were written to run displays from an [1802-Mini](https://github.com/dmadole/1802-Mini) by David Madole running with the [1802/Mini PIO Parallel Expansion Board](https://github.com/arhefner/1802-Mini-PIO) with the [I2C interface board](https://github.com/arhefner/1802-Mini-I2C) by Tony Hefner. 

These programs were assembled and linked with updated versions of the Asm-02 assembler and Link-02 linker by Mike Riley. The updated versions required to assemble and link this code are available in the main branch of [arhefner/Asm-02](https://github.com/arhefner/Asm-02) and the [updates branch at arhefner/Link-02](https://github.com/arhefner/Link-02/tree/updates).  

The Windows versions of Asm/02 and Link/02 are available in the latest release at [fourstix/Asm-02](https://github.com/fourstix/Asm-02/releases) and [fourstix/Link-02](https://github.com/fourstix/Link-02/tree/updates).

Modification of I2C Adapter for Clock Stretching
------------------------------------------------

Version A of the [I2C Adapter](https://github.com/arhefner/1802-Mini-I2C) needs a single wire modification to support I2C clock stretching.  First, solder a wire from the EF4 post on JP1 to the SCL signal available on the right side of resistor R7 as shown in the diagrams below. Then, set the jumper at JP1 to use EF3 for the SDA line.  With this 
modification the I2C routines will be able to check EF4 to see if a device is holding the SCL line low for clock stretching, and EF3 is used for SDA.

The modification wire is shown in blue on the images below. One can add the modification wire to either the back side or the front side.  I found it easiest to solder the wire on the back side of the I2C Adapter.

[![Modification for Clock Stretching - Wire on Front](https://github.com/fourstix/Elfos-I2C-Libraries/blob/main/pics/modAfront.png)](https://github.com/arhefner/1802-Mini-I2C)

**Modification for Clock Stretching - Wire on Front**

[![Modification for Clock Stretching - Wire on Back](https://github.com/fourstix/Elfos-I2C-Libraries/blob/main/pics/modAback.png)](https://github.com/arhefner/1802-Mini-I2C)

**Modification for Clock Stretching - Wire on Back**

You can find more information about clock stretching and I2C in general in the Adafruit
tutorial [*Working with I2C Devices*](https://learn.adafruit.com/working-with-i2c-devices).


1802-Mini v4.5 Configuration 
-----------------------------
For this configuration, the code is assembled with the expansion group I2C_GROUP defined as 02 in sysconfig.inc and with the I2C_PORT define statement set equal to 7.

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
<tr><td>PIO/I2C</td><td>SCL (Clock Stretching)</td></tr>
</table>

Supported Devices
------------------
<table>
<tr><th colspan="2">First Group</th></tr>
<tr><th>Device</th><th>Library</th></tr>
<tr><td>Adafruit 7 Segment LED display</td><td>led7</td></tr>
<tr><td>Sparkfun 14-Segment Alphanumeric display</td><td>alnum</td></tr>
<tr><td>Sparkfun Qwiic Single Relay</td><td>relay</td></tr>
<tr><td>Sparkfun Qwiic Joystick</td><td>joystick</td></tr>
<tr><td>LM75A Temperature Sensor</td><td>lm75a</td></tr>
<tr><td>SHT31 Temperature and Humidity Sensor</td><td>sht31</td></tr>
<tr><th colspan="2">Second Group</th></tr>
<tr><th>Device</th><th>Library</th></tr>
<tr><td>Adafruit Non-Volatile Fram Breakout Board</td><td rowspan="2">mem</td></tr>
<tr><td>Sparkfun Qwiic EEPROM Breakout Board</td></tr>
<tr><td>Sparkfun Qwiic 12 Button Keypad</td><td>keypad</td></tr>
<tr><td>Sparkfun Qwiic Twist RGB Rotary Encoder</td><td>twist</td></tr>
<tr><td>I2C 16x2 Liquid Crystal Display</td><td rowspan="2">lcd</td></tr>
<tr><td>I2C 20x4 Liquid Crystal Display</td></tr>
<tr><td>Adafruit 8x8 BiColor LED Matrix</td><td rowspan="2">mtrx</td></tr>
<tr><td>Adafruit 8x8 LED Matrix</td></tr>
</table>

I2C Library API
----------------

<!-- A blank line is required before a link in a table. -->
<table>
<tr><th>Name</th><th>Description</th></tr>
<tr><td>

[i2c_init](https://github.com/fourstix/Elfos-I2C-Libraries/blob/main/I2C_API.md#i2c_init)
</td><td>Initialize the i2c bus</td></tr>
<tr><td>

[i2c_avail](https://github.com/fourstix/Elfos-I2C-Libraries/blob/main/I2C_API.md#i2c_avail) 
</td><td>Check for an i2c device at a given address</td></tr>
<tr><td>

[i2c_scan](https://github.com/fourstix/Elfos-I2C-Libraries/blob/main/I2C_API.md#i2c_scan) 
</td><td>Scan the i2c bus for any device with the id in RF.0</td></tr>
<tr><td>

[i2c_rdbuf](https://github.com/fourstix/Elfos-I2C-Libraries/blob/main/I2C_API.md#i2c_rdbuf)
</td><td>Read a message from the i2c bus</td></tr>
<tr><td>

[i2c_rdreg](https://github.com/fourstix/Elfos-I2C-Libraries/blob/main/I2C_API.md#i2c_rdreg)
</td><td>Read a message from a register in an i2c device</td></tr>
<tr><td>

[i2c_rdaddr](https://github.com/fourstix/Elfos-I2C-Libraries/blob/main/I2C_API.md#i2c_rdaddr)
</td><td>Read one byte of data from a given address on an i2c memory device</td></tr>
<tr><td>

[i2c_wrbuf](https://github.com/fourstix/Elfos-I2C-Libraries/blob/main/I2C_API.md#i2c_wrbuf)
</td><td>Write a message to the i2c bus</td></tr>
<tr><td>

[i2c_wraddr](https://github.com/fourstix/Elfos-I2C-Libraries/blob/main/I2C_API.md#i2c_wraddr)
</td><td>Write one byte of data to a given address on an i2c memory device</td></tr>
<tr><td>

[i2c_clear](https://github.com/fourstix/Elfos-I2C-Libraries/blob/main/I2C_API.md#i2c_clear)
</td><td>Attempt to clear a device error on the i2c bus</td></tr>
</table>

These API functions return DF=0 when successful, and DF=1 when there is an error. The [I2C API](I2C_API.md) are documented [here.](I2C_API.md)

Util Library API
-------------------
<table>
<tr><th>Name</th><th>Description</th></tr>
<tr><td>util_full_mult16</td><td>Multiply two 16-bit integer numbers into a full 32-bit integer product</td></tr>
<tr><td>util_write_10x</td><td>Write a 10X value into a buffer as a single-precession decimal string</td></tr>
<tr><td>util_c_to_f</td><td>Convert a 1X Celsius value into a 10X Fahrenheit value </td></tr>
<tr><td>util_delay</td><td>Delay for the amount of time specified in RC and then return</td></tr>
<tr><td>util_wait</td><td>Wait for the input key to be pressed, up to the amount of time specified in RC, and return. DF = 1 means the input key was pressed to end the wait.</td></tr>
</table>

GFX 1802 library
----------------
The matrix library implements the GFX Display Interface to support graphics functions provided by the common [GFX 1802 Library.](https://github.com/fourstix/GFX-1802-Library) The GFX 1802 Library is a common graphics library written in 1802 Assembler code and based on the Adafruit_GFX-Library written by Ladyada Limor Fried.

Example programs
----------------

<table>
<tr><th colspan="2">First Group</th></tr>
<tr><th>Device</th><th>Example Programs</th></tr>
<tr><td>(Any I2C device)</td><td>scanner</td></tr>
<tr><td>Adafruit 7 Segment LED display</td><td>led7print, led7clear, led7clock</td></tr>
<tr><td>Sparkfun 14-Segment Alphanumeric display</td><td>alprint, alclear, altest</td></tr>
<tr><td>Sparkfun Qwiic Single Relay</td><td>relay, relayOn, relayOff</td></tr>
<tr><td>Sparkfun Qwiic Joystick</td><td>joystick</td></tr>
<tr><td>LM75A Temperature Sensor</td><td>lm75a</td></tr>
<tr><td>SHT31 Temperature and Humidity Sensor</td><td>sht31</td></tr>
<tr><th colspan="2">Second Group</th></tr>
<tr><th>Device</th><th>Example Programs</th></tr>
<tr><td>Adafruit Non-Volatile Fram Breakout Board</td><td rowspan="2">memdump, memset , memtest</td></tr>
<tr><td>Sparkfun Qwiic EEPROM Breakout Board</td></tr>
<tr><td>Sparkfun Qwiic 12 Button Keypad</td><td>keypad</td></tr>
<tr><td>Sparkfun Qwiic Twist RGB Rotary Encoder</td><td>twist</td></tr>
<tr><td>I2C 16x2 Liquid Crystal Display</td><td rowspan="2">lcdchar, lcdscroll, lcdtext, lcdoff</td></tr>
<tr><td>I2C 20x4 Liquid Crystal Display</td></tr>
<tr><td>Adafruit 8x8 BiColor LED Matrix</td><td rowspan="2">bicolor, bichar</td></tr>
<tr><td>Adafruit 8x8 LED Matrix</td></tr>
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

<table>
<tr><td>

[![Adafruit Non-Volatile Fram Breakout Board](https://cdn-shop.adafruit.com/970x728/1895-03.jpg)](https://www.adafruit.com/product/1895)

[*Adafruit Non-Volatile Fram Breakout Board (1895)*](https://www.adafruit.com/product/1895)

</td><td>

[![Sparkfun Qwiic EEPROM Breakout Board](https://cdn.sparkfun.com//assets/parts/1/7/7/0/1/18355-SparkFun_Qwiic_EEPROM_Breakout_-_512Kbit-01.jpg)](https://www.sparkfun.com/products/18355)

[*Sparkfun Qwiic EEPROM Breakout Board*](https://www.sparkfun.com/products/18355)

</td></tr>
</table>

## memset  
**Usage:** memset [-f hh, default = 00][hhhh, default = 0000]  
Set a 128 byte block in the device memory to a hexadecimal byte value.
*Options:*  
*  -f hh byte value hh to set (default = 00). 
*  hhhh is block address in hex (default = 0000) 

## memdump  
**Usage:** memdump [hhhh, default = 0000]  
Show the contents of a 128 byte block in the device memory  
*Options:*   
*  hhhh is block address in hex (default = 0000)  

## memtest  
**Usage:** memtest [hhhh, default = 0000]  
Write a string to the device memory, read it back and verify match.  
*Options:*  
*  hhhh is the test address in hex (default = 0000)  

[![Sparkfun Qwiic 12 Button Keypad](https://cdn.sparkfun.com//assets/parts/1/3/7/7/7/15290-SparkFun_Qwiic_Keypad_-_12_Button-01.jpg)](https://www.sparkfun.com/products/15290)

[*Sparkfun Qwiic 12 Button Keypad*](https://www.sparkfun.com/products/15290)

Example program
----------------
## keypad  
**Usage:** keypad     
Show information read from the Sparkfun Qwiic 12 Button Keypad and display keys pressed.  


[![Sparkfun Qwiic Twist RGB Rotary Encoder](https://cdn.sparkfun.com//assets/parts/1/3/4/3/3/15083-SparkFun_Qwiic_Twist_-_RGB_Rotary_Encoder_Breakout-01.jpg)](https://www.sparkfun.com/products/15083)

[*Sparkfun Qwiic Twist RGB Rotary Encoder*](https://www.sparkfun.com/products/15083)

Example program
----------------
## twist  
**Usage:** twist   
Show information read information from a Sparkfun Qwiic Twist RGB Rotary Encoder and change the color as the knob is turned.  

<table>
<tr><td>

[![I2C 16x2 Liquid Crystal Display](https://www.sunfounder.com/cdn/shop/products/CN0133-01_500x.jpg?v=1617877359)](https://www.sunfounder.com/products/i2c-lcd1602-module)

[*I2C 16x2 Liquid Crystal Display*](https://www.sunfounder.com/products/i2c-lcd1602-module)

</td><td>

[![I2C 20x4 Liquid Crystal Display](https://www.sunfounder.com/cdn/shop/products/CN0132-01_500x.jpg?v=1629964807)](https://www.sunfounder.com/products/i2c-lcd2004-module)

[*I2C 20x4 Liquid Crystal Display*](https://www.sunfounder.com/products/i2c-lcd2004-module)

</td></tr>
</table>

Example program
----------------

## lcdchar  
**Usage:** lcdchar [-s|-l, default = -s (16x2 display)]  
Show various character and cursor functions on a Liquid Crystal Display with I2C 
*Options:* 
*  -s = small 16x2 display (default)
*  -l = large 20x4 display  

## lcdscroll  
**Usage:** lcdscroll  
Show scrolling text on a Liquid Crystal Display with I2C  

## lcdtext  
**Usage:** lcdtext  
Show changing the text direction on a Liquid Crystal Display with I2C  

## lcdoff  
**Usage:** lcdoff  
Blank and turn off the backlight on a Liquid Crystal Display with I2C  

[![Adafruit Bicolor 8x8 LED Matrix](https://cdn-shop.adafruit.com/970x728/902-00.jpg)](https://www.adafruit.com/product/902)

[*Adafruit Bicolor 8x8 LED Matrix (902)*](https://www.adafruit.com/product/902)

Example program
----------------

The graphics functions for the matrix example programs are provided by the common [GFX 1802 Library.](https://github.com/fourstix/GFX-1802-Library)  

## bicolor  
**Usage:** bicolor [-r 0|1|2|3]  
Show graphics functions available on an Adafruit Bicolor 8x8 LED Matrix.
The option -r n, where n = 0,1,2 or 3, will rotate the display n*90 degrees counter-clockwise.
## bichar 
**Usage:** bichar [-r 0|1|2|3]  
Show the printable ASCII character set on an Adafruit Bicolor 8x8 LED Matrix   
The option -r n, where n = 0,1,2 or 3, will rotate the display n*90 degrees counter-clockwise.

Nick's Libraries
----------------
These I2C libraries were written by Milton 'Nick' DeNicholas who was kind enough to share his code. The assembled library files and source files for each library are available in subdirectories underneath the */nick/* directory.

<table>
<tr><td>

[![MCP23017 16-bit GPIO Expander](https://cdn-shop.adafruit.com/970x728/732-02.jpg)](https://www.adafruit.com/product/732)

[*MCP23017 16-bit GPIO Expander*](https://www.adafruit.com/product/732)

</td><td>

[![BlinkM Smart LED](https://images.squarespace-cdn.com/content/v1/5c155684f407b4100552994c/1545605929235-6BZ1XQYJ049H753BWAR4/tm_blinkm_closeup_obliq_sma.jpg?format=2500w)](https://thingm.com/products/blinkm)

[*BlinkM Smart LED*](https://www.sunfounder.com/products/i2c-lcd2004-module)

</td></tr>
<tr><td>

[![PCF8591 8 Bit A/D D/A Converter](https://cdn-shop.adafruit.com/970x728/4648-04.jpg)](https://www.adafruit.com/product/4648)

[*PCF8591 8 Bit A/D D/A Converter*](https://www.adafruit.com/product/4648)

</td><td>

[![TSL2561 LUX Sensor](https://cdn-shop.adafruit.com/970x728/1980-08.jpg)](https://www.adafruit.com/product/1980)

[*TSL2561 LUX Sensor*](https://www.adafruit.com/product/1980)

</td></tr>

</table>

Supported Devices
------------------------
<table>
<tr><th>Device</th><th>Library</th></tr>
<tr><td>MCP23017 16-bit GPIO Expander</td><td>mscp23017</td></tr>
<tr><td>BlinkM Smart LED</td><td>blinkm</td></tr>
<tr><td>PCF8591 8 Bit A/D D/A Converter</td><td>pcf8591</td></tr>
<tr><td>TSL2561 LUX Sensor</td><td>tsl2561</td></tr>
</table>

Repository Contents
-------------------
* **/src/**  --Source files for assembling I2C libraries and example programs.
* **/src/alnum/**  -- Source files for Sparkfun 14 Segment Alphanumeric display library.
  * alnum.bat - Windows batch file to assemble source files to create library. 
  * clean.bat - Windows batch file to delete binaries before rebuilding.
* **/src/example/**  -- Source files for Elf/OS I2c library example programs.
  * build.bat - Windows batch file to assemble source files to first set of example programs. 
  * build2.bat - Windows batch file to assemble source files to create second set of example programs.
  * clean.bat - Windows batch file to delete binaries before rebuilding.
* **/src/i2c/**  -- Source files for Elf/OS I2C library.
  * i2c.bat - Windows batch file to assemble source files to create library. 
  * clean.bat - Windows batch file to delete binaries before rebuilding.
* **/src/include/**  -- Include files for Elf/OS I2c libraries and example programs.
* **/src/joystick/**  -- Source files for Sparkfun Qwiic Joystick library.
  * joystick.bat - Windows batch file to assemble source files to create library. 
  * clean.bat - Windows batch file to delete binaries before rebuilding.
* **/src/led7/**  -- Source files for Adafruit 7 Segment LED display library.
  * led7.bat - Windows batch file to assemble source files to create library. 
  * clean.bat - Windows batch file to delete binaries before rebuilding.
* **/src/lm75a/**  -- Source files for LM75A temperature sensor library.
  * lm75a.bat - Windows batch file to assemble source files to create library. 
  * clean.bat - Windows batch file to delete binaries before rebuilding.
* **/src/relay/**  -- Source files for Sparkfun Qwiic Single relay library.
  * relay.bat - Windows batch file to assemble source files to create library. 
  * clean.bat - Windows batch file to delete binaries before rebuilding.
* **/src/sht31/**  -- Source files for SHT31 temperature and humidity sensor library.
  * sht31.bat - Windows batch file to assemble source files to create library. 
  * clean.bat - Windows batch file to delete binaries before rebuilding.
* **/src/mem/**  -- Source files for Adafruit Non-Volatile Fram and Sparkfun Qwiic EEPROM Breakout Boards library.
  * mem.bat - Windows batch file to assemble source files to create library. 
  * clean.bat - Windows batch file to delete binaries before rebuilding.
* **/src/keypad/**  -- Source files for Sparkfun Qwiic 12 Button Keypad library.
  * keypad.bat - Windows batch file to assemble source files to create library. 
  * clean.bat - Windows batch file to delete binaries before rebuilding.
* **/src/twist/**  -- Source files for Sparkfun Qwiic Twist RGB Rotary Encoder library.
  * twist.bat - Windows batch file to assemble source files to create library. 
  * clean.bat - Windows batch file to delete binaries before rebuilding.
* **/src/lcd/**  -- Source files for I2C 16x2 and I2C 20x4 Liquid Crystal Displays library.
  * lcd.bat - Windows batch file to assemble source files to create library. 
  * clean.bat - Windows batch file to delete binaries before rebuilding.
* **/src/matrix/**  -- Source files for Adafruit 8x8 LED Matrices library.
  * matrix.bat - Windows batch file to assemble source files to create library. 
  * clean.bat - Windows batch file to delete binaries before rebuilding.
* **/src/util/**  -- Source files for common utility library.
  * util.bat - Windows batch file to assemble source files to create library. 
  * clean.bat - Windows batch file to delete binaries before rebuilding.
* **/lib/**  -- Assembled Elf/OS I2C library files for linking with example programs.
* **/bin/**  -- Binary files for Elf/OS I2C example programs.
* **/nick/**  -- Various I2C libraries written by Milton 'Nick' DeNicholas.
* **/nick/mcp23017/**  -- I2C library for the MCP23017 16-bit GPIO Expander written by Milton 'Nick' DeNicholas.
  * mcp23017.lib - Assembled I2C library for the MCP23017 16-bit GPIO Expander. 
  * **/nick/mcp23017/include** -- include files for MCP23017 16-bit GPIO Expander Library programs.
  * **/nick/mcp23017/src** -- source files for MCP23017 16-bit GPIO Expander Library.
* **/nick/blinkm/**  -- I2C library for the BlinkM Smart LED written by Milton 'Nick' DeNicholas.
  * blinkm.lib - Assembled I2C library for the BlinkM Smart LED. 
  * **/nick/blinkm/include** -- include files for BlinkM Smart LED Library.
  * **/nick/blinkm/src** -- source files for BlinkM Smart LED Library.
* **/nick/pcf8591/**  -- I2C library for the BlinkM Smart LED written by Milton 'Nick' DeNicholas.
  * pcf8591.lib - Assembled I2C library for the PCF8591 8 Bit A/D D/A Converter. 
  * **/nick/pcf8591/include** -- include files for PCF8591 8 Bit A/D D/A Converter Library.
  * **/nick/pcf8591/src** -- source files for PCF8591 8 Bit A/D D/A Converter Library.
* **/nick/tsl2561/**  -- I2C library for the TSL2561 LUX Sensor written by Milton 'Nick' DeNicholas.
  * tsl2561.lib - Assembled I2C library for the TSL2561 LUX Sensor. 
  * **/nick/tsl2561/include** -- include files for TSL2561 LUX Sensor Library.
  * **/nick/tsl2561/src** -- source files for TSL2561 LUX Sensor Library.

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

SunFounder, the SunFounder logo, and other SunFounder products and services are
trademarks of the SunFounder, Inc. in the United States, other countries or both. 

Any company, product, or services names may be trademarks or services marks of others.

All libraries used in this code are copyright their respective authors.

MCP23017 16-bit GPIO Expander I2C Library  
Copyright (c) 2023 by Milton 'Nick' DeNicholas  

BlinkM Smart LED I2C Library  
Copyright (c) 2023 by Milton 'Nick' DeNicholas  

PCF8591 8 Bit A/D D/A Converter I2C Library  
Copyright (c) 2023 by Milton 'Nick' DeNicholas  

TSL2561 LUX Sensor I2C Library  
Copyright (c) 2023 by Milton 'Nick' DeNicholas  

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

Many thanks to the original authors for making their designs and code available as open source, and a big thank you to Bernie Murphy for his testing, code contributions and suggestions.  Many thanks to Milton 'Nick' DeNicholas for kindly contributing his libraries.

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
