# SoftBox

This repository holds files related to the
[SoftBox](http://mikenaberezny.com/hardware/pet-cbm/sse-softbox-z80-computer/),
a Z80-based single board computer for CP/M that attaches to
Commodore PET/CBM computers as an IEEE-488 peripheral.

## Files

 - `disasm/` contains the original PET/CBM terminal and a disassembly of it.

 - `pet.asm` is an updated version of the PET/CBM terminal.

 - `cbm2.asm` is a port of the terminal to CBM-II.  Work in Progress.

## Assemble

The `.asm` files can be assembled with the
[ACME](http://www.esw-heim.tu-clausthal.de/~marco/smorbrod/acme/)
assembler:

    $ acme -v1 --cpu 6502 --format cbm --outfile pet.prg pet.asm

The program file can then be copied to a Commodore disk.  The terminal does
not need to be copied onto a SoftBox boot disk to run.  It may be loaded
and run from any device as long as there is a SoftBox boot disk in unit 8,
drive 0.
