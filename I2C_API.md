# Elf/OS I2C API
API for various I2C functions for Elf/OS programs communicating through the I2C protocol. 

Platform
--------
These library API functions support the PIO and I2C Expansion cards running on the 1802-Mini Computer to provide support for the i2c protocol.

General Information
-------------------
This library contains routines to implement the i2c protocol using two
bits of a parallel port. The two bits should be connected to open-
collector or open-drain drivers such that when the output bit is HIGH,
the corresponding i2c line (SDA or SCL) is pulled LOW.

The current value of the output port is maintained in register R9.1.
This allows the routines to manipulate the i2c outputs without
disturbing the values of other bits on the output port.

These routines are meant to be called using the SCRT (Standard Call and Return) routines in Elf/OS, with X=R2 as the stack pointer.

I2C Library API
----------------
<!-- A blank line is required before a link in a table. -->
<table>
<tr><th>Name</th><th>Description</th></tr>
<tr><td>

[i2c_init](https://github.com/fourstix/Elfos-I2C-Libraries/blob/main/I2C_API.md#ic2_init)
</td><td>Initialize the i2c bus</td></tr>
<tr><td>

[i2c_avail](https://github.com/fourstix/Elfos-I2C-Libraries/blob/main/I2C_API.md#ic2_avail) 
</td><td>Check for an i2c device at a given address</td></tr>
<tr><td>

[i2c_scan](https://github.com/fourstix/Elfos-I2C-Libraries/blob/main/I2C_API.md#ic2_scan) 
</td><td>Scan the i2c bus for any device with the id in RF.0</td></tr>
<tr><td>

[i2c_rdbuf](https://github.com/fourstix/Elfos-I2C-Libraries/blob/main/I2C_API.md#ic2_rdbuf)
</td><td>Read a message from the i2c bus</td></tr>
<tr><td>

[i2c_rdreg](https://github.com/fourstix/Elfos-I2C-Libraries/blob/main/I2C_API.md#ic2_rdreg)
</td><td>Read a message from a register in an i2c device</td></tr>
<tr><td>

[i2c_rdaddr](https://github.com/fourstix/Elfos-I2C-Libraries/blob/main/I2C_API.md#ic2_rdaddr)
</td><td>Read one byte of data from a given address on an i2c memory device</td></tr>
<tr><td>

[i2c_wrbuf](https://github.com/fourstix/Elfos-I2C-Libraries/blob/main/I2C_API.md#ic2_wrbuf)
</td><td>Write a message to the i2c bus</td></tr>
<tr><td>

[i2c_wraddr](https://github.com/fourstix/Elfos-I2C-Libraries/blob/main/I2C_API.md#ic2_wraddr)
</td><td>Write one byte of data to a given address on an i2c memory device</td></tr>
<tr><td>

[i2c_clear](https://github.com/fourstix/Elfos-I2C-Libraries/blob/main/I2C_API.md#ic2_clear)
</td><td>Attempt to clear a device error on the i2c bus</td></tr>
</table>

I2C Setup API
-------------

## ic2_init
This routine initializes the i2c bus.  It should be called before any other i2c functions.

# Parameters
<table>
<tr><th> </th><th>Description</th></tr>
<tr><td>(None)</td><td>Initialize the i2c bus. Should be called before any other i2c functions.</td></tr>
</table>

# Returns
 DF = 0 (always successful)
 
# Example Code
```
call    i2c_init    ; initialize i2c bus
```

## ic2_avail
This routine writes the id to the i2c bus to see if a device is available.

# Parameters
<table>
<tr><th>#</th><th>Location</th><th>Name</th><th>Description</th><th>Size</th></tr>
<tr><td>1</td><td>(inline)</td><td>I2C Address</td><td>7-bit i2c address</td><td>1 byte</td></tr>
</table>

# Returns
DF = 0 if success, DF = 1 if not found (error) 

# Example Code
```
;------------------------------
; Sparkfun Qwiic Relay Address
;------------------------------
I2C_ADDR:   equ     $18

            call    i2c_avail
            db      I2C_ADDR
```

## ic2_scan
This routine writes the id to the i2c bus to see if a device is available. By incrementing the address register RF, one can easily scan a range of addresses

# Parameters
<table>
<tr><th>#</th><th>Location</th><th>Name</th><th>Description</th></tr>
<tr><td>1</td><td>RF.0</td><td>I2C Address</td><td>7-bit i2c address</td></tr>
</table>

# Returns
DF = 0 if success, DF = 1 if not found (error) 

# Example Code
```
;----------------------------------------------------------------------
; Scan for Sparkfun Qwiic Relay at its two possible I2C addresses
;----------------------------------------------------------------------
            ldi     $18           ; Set rf to relay primary address at $18
            plo     rf 
            
            call    i2c_scan
            lbnf    relay_found   ; DF = 0 means found at $18
                        
            inc     rf            ; check relay secondary address at $19

            call    i2c_scan
            lbnf    relay_found   ; DF = 0 means found at $19
            
            lbr     no_relay     
```

I2C READ API
------------
## ic2_rdbuf
This routine reads a message from a device on the i2c bus.

# Parameters
<table>
<tr><th>#</th><th>Location</th><th>Name</th><th>Description</th><th>Size</th></tr>
<tr><td>1</td><td>(inline)</td><td>I2C Address</td><td>7-bit i2c address</td><td>1 byte</td></tr>
<tr><td>2</td><td>(inline)</td><td>num_bytes</td><td>Number of bytes to read</td><td>1 byte</td></tr>
<tr><td>3</td><td>(inline)</td><td>Buffer Address</td><td>Address for data buffer</td><td>2 bytes</td></tr>
</table>

# Returns
DF = 0 if success, DF = 1 if not found (error) 

# Example Code
```
;------------------------------------------
; SHT31 Temperature/Humidity Sensor Address
;------------------------------------------
I2C_ADDR:   equ     $44

. . . 

call    i2c_rdbuf           ; read temp/humidity data
db      I2C_ADDR, 6         ; read 6 bytes into data buffer
dw      sht31_data_buf
lbdf    err_exit            ; DF=1 means an error occurred

. . . 

;------------------------------------------
; SHT31 Data Buffer (6 bytes)
;------------------------------------------
sht31_data_buf: 
        db 0,0            ; 16-bit temperature reading 
        db 0              ; CRC byte
        db 0,0            ; 16-bit humidity reading
        db 0              ; CRC byte
```

## ic2_rdreg
This routine reads a message from a register in an i2c device on the bus.  Some devices may refer to registers as commands.

## Note:
The function i2c_wrbuf is used to write a message to a register in an i2c device on the bus. 

# Parameters
<table>
<tr><th>#</th><th>Location</th><th>Name</th><th>Description</th><th>Size</th></tr>
<tr><td>1</td><td>(inline)</td><td>I2C Address</td><td>7-bit i2c address</td><td>1 byte</td></tr>
<tr><td>2</td><td>(inline)</td><td>reg_bytes</td><td>Number of bytes in register id</td><td>1 byte</td></tr>
<tr><td>3</td><td>(inline)</td><td>reg_id</td><td>Register Id</td><td>reg_bytes bytes</td></tr>
<tr><td>4</td><td>(inline)</td><td>data_bytes</td><td>Number of bytes to read from register</td><td>1 byte</td></tr>
<tr><td>3</td><td>(inline)</td><td>Buffer Address</td><td>Address for data buffer</td><td>2 bytes</td></tr>
</table>

# Returns
DF = 0 if success, DF = 1 if not found (error) 

# Example Code
```
;------------------------------
; Sparkfun Qwiic Relay Address 
;------------------------------
I2C_ADDR:   equ     $18

. . .

            call    i2c_rdreg
            db      I2C_ADDR
            db      1, $05            ; register 5 holds the relay state
            db      1                 ; read 1 byte relay state 
            dw      rly_state
            lbdf    err_exit          ; DF=1 means read failed

. . .

rly_state:  db     $00                ; relay state byte
```

## ic2_rdaddr
This routine reads a byte from an address in an i2c memory device.

# Parameters
<table>
<tr><th>#</th><th>Location</th><th>Name</th><th>Description</th><th>Size</th></tr>
<tr><td>1</td><td>(inline)</td><td>I2C Address</td><td>7-bit i2c address</td><td>1 byte</td></tr>
<tr><td>2</td><td>RD</td><td>Memory Address</td><td>16-bit memory address</td><td> </td></tr>
</table>

# Returns
DF = 0 if success, DF = 1 if not found (error)   
D = byte read from memory

# Example Code
```
;-------------------------------------------
; Adafruit Non-Volatile Fram Breakout Board
;-------------------------------------------
I2C_ADDR:   equ     $50

. . . 
            ; Set RD for memory address to read ($7000)
            ldi     $70                 ; read from memory address $7000
            plo     rd
            ldi     0   
            phi     rd

            call    i2c_rdaddr          ; send command to read a byte into D
            db      I2C_ADDR
            lbdf    err_exit            ; DF=1 means an error occurred
            
            ; save data read from I2C memory into RF.0
            plo     rf                  ; put data byte in D into RF.0           
```

I2C WRITE API
-------------

## ic2_wrbuf
This routine write a message to a device on the i2c bus.

## Note:
This routine is also used to write a message to a register (or command) on an i2c device. To write a message to a register, put the register bytes before the message data in the buffer and send the entire buffer as one i2c_wrbuf transaction.

# Parameters
<table>
<tr><th>#</th><th>Location</th><th>Name</th><th>Description</th><th>Size</th></tr>
<tr><td>1</td><td>(inline)</td><td>I2C Address</td><td>7-bit i2c address</td><td>1 byte</td></tr>
<tr><td>2</td><td>(inline)</td><td>num_bytes</td><td>Number of bytes to write</td><td>1 byte</td></tr>
<tr><td>3</td><td>(inline)</td><td>Buffer Address</td><td>Address for data buffer</td><td>2 bytes</td></tr>
</table>

# Returns
DF = 0 if success, DF = 1 if not found (error) 

# Example Code
```
I2C_ADDR:   equ     070h

. . . 
            call    i2c_wrbuf
            db      I2C_ADDR, 17
            dw      led7_display_buf
            lbdf    err_exit            ; DF=1 means an error occurred
. . .
          
led7_display_buf:
            db      $00     ; display position (always 0)
            db      $00, $00, $00, $00, $00, $00, $00, $00
            db      $00, $00, $00, $00, $00, $00, $00, $00
```

## ic2_wraddr
This routine write a byte to an address in an i2c memory device.

# Parameters
<table>
<tr><th>#</th><th>Location</th><th>Name</th><th>Description</th><th>Size</th></tr>
<tr><td>1</td><td>(inline)</td><td>I2C Address</td><td>7-bit i2c address</td><td>1 byte</td></tr>
<tr><td>2</td><td>RD</td><td>Memory Address</td><td>16-bit memory address</td><td> </td></tr>
<tr><td>3</td><td>D</td><td>Data byte</td><td>data byte to write to memory device</td><td> </td></tr>
</table>

# Returns
DF = 0 if success, DF = 1 if not found (error) 
D = byte read from memory

# Example Code
```
;-------------------------------------------
; Adafruit Non-Volatile Fram Breakout Board
;-------------------------------------------
I2C_ADDR:   equ     $50

. . . 
            ; Set RD for memory address to write ($7000)
            ldi     $70                 ; write to memory address $7000
            plo     rd
            ldi     0   
            phi     rd
             
            ldi     $00                 ; write data byte 00 into memory

            call    i2c_wraddr          ; send command to write byte in D
            db      I2C_ADDR           
            lbdf    err_exit            ; DF=1 means an error occurred            
```

I2C Error API
-------------

## ic2_clear
This routine attempts to clear an error condition where a device is out of sync and holding the SDA line low.

# Parameters
<table>
<tr><th> </th><th>Description</th></tr>
<tr><td>(None)</td><td>Attempt to clear an error on the i2c bus.</td></tr>
</table>

# Returns
DF = 0 if success, DF = 1 if error remains
# Example Code
```
bus_err:    call    i2c_clear   ; clear error on i2c bus
            lbdf    err_exit    ; DF=1 means an error remains            
```
