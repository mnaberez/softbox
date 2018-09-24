# SoftBox Terminals

This directory contains SoftBox terminal programs that run on
Commodore computers.

## Files

 - `disasm/` is a disassembly of the original terminal for PET/CBM.

 - `pet.asm` is an updated PET/CBM version.

 - `cbm2.asm` is a port for CBM-II computers.

## Assemble

The `.asm` files can be assembled with the
[ACME](http://www.esw-heim.tu-clausthal.de/~marco/smorbrod/acme/)
assembler:

    $ acme -v1 --cpu 6502 --format cbm --outfile pet.prg pet.asm

The program file can then be copied to a Commodore disk.  The terminal does
not need to be copied onto a SoftBox boot disk to run.  It may be loaded
and run from any device as long as there is a SoftBox boot disk in unit 8,
drive 0.
