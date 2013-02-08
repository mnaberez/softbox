# SoftBox BIOS

This directory contains a disassembly of the SoftBox BIOS.  The BIOS
is 4K and is split into two 2716 EPROMs in the SoftBox.  IC3 contains
the lower half (F000-F7FF) and IC4 contains the upper half (F800-FFFF).

## Files

Each binary contains the complete 4K BIOS.  The binaries are named by
the version strings found inside them.

 - `1981-10-27.bin` is the October 27, 1981 version.  It was found in
   an early version of the SoftBox hardware (brown case with three LEDs).

 - `1983-06-09.bin` is the June 9, 1983 version.  It is the most recent
   version known.

 - `1983-06-09.asm` is the disassembly.

## Disassemble

  Disassemble using [z80dasm](http://www.tablix.org/~avian/z80dasm/):

    $ z80dasm --labels --origin=61440 1981-10-27.bin > 1981-10-27.asm

## Assemble

  Assemble using [z80asm](http://savannah.nongnu.org/projects/z80asm):

     $ z80asm --input 1983-06-09.asm --output 1983-06-09.bin
