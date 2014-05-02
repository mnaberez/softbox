# SoftBox BIOS

This directory contains a disassembly of the SoftBox BIOS.  The BIOS
is 4K and is split into two 2716 EPROMs in the SoftBox.  IC3 contains
the lower half (F000-F7FF) and IC4 contains the upper half (F800-FFFF).

## Files

Several BIOS versions are available.  The dates were taken from the
version strings inside them.

 - `1981-10-27` is the October 27, 1981 version.  It was found in
   an early version of the SoftBox hardware (brown case with three LEDs).


 - `1983-06-09` is the June 9, 1983 version.  This version adds CBM 8250
   support but a bug in the `ieeenum` routine causes it to fail for tracks
   100+.  It is believed that SSE produced a later BIOS to fix this bug
   but it has not been found.

 - `bios` is not an original BIOS from SSE.  It is a present-day version
   based on `1983-06-09` that fixes CBM 8250 support.

The `.bin` files are dumps of original EPROMs from Small Systems
Engineering Ltd.  The corresponding `.asm` files are disassemblies that
should assemble to identical binaries.

## Disassemble

Disassemble using [z80dasm](http://www.tablix.org/~avian/z80dasm/):

    $ z80dasm --labels --origin=61440 1981-10-27.bin > 1981-10-27.asm

## Assemble

Assemble using [z80asm](http://savannah.nongnu.org/projects/z80asm):

    $ z80asm --input 1983-06-09.asm --output 1983-06-09.bin
