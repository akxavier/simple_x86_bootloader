# A Simple x86 Bootloader
A very primitive bootloader created with NASM assembly language.

## Summary
- In real mode memory is addressed using a logical address rather than a physical address.
- Given a logical address starting at A, with offset B, reconstructed physical address would be (A * 0x10 + B).
#### Creating Data Segment
- Code resides at 0x7C00, so DS may begin at 0x7C0
```
mov ax, 0x7C0
mov ds, ax
```
#### Creating Stack Segment
- We create the stack segment right after the 512 bytes of the bootloader, i.e., from 0x7E0 and stack pointer is set initially to point to 0x2000.
```
mov ax, 0x7E0
mov ss, ax
mov sp, 0x2000
```
#### Clear Screen - Int 10/AH=07h Interrupt
- AH = 07h
- AL = number of lines by which to scroll down (00h = clear entire window)
- BH = attribute uses to write blank lines on top of the window
- CH, CL = row, column of window's upper left corner
- DH, DL = row, column of window's lower right corner

#### Moving the Cursor - Int 10/AH=02h Interrupt
- AH = 02h
- BH = page number
- We have set page number as [bp + 4] because, contents of bp takes up 2 bytes and the argument takes up two bytes (Also note that the new bp is the old sp).

#### Printing message - Int 10/AH=0Eh Interrupt
- AH = 0Eh
- AL = character to write
- BH = page number
