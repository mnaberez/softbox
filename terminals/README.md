# SoftBox Terminals

This directory contains SoftBox terminal programs that run on
Commodore computers.

## Directories

 - `pet_original/`: Disassembly of the original PET terminal (`K.PRG`) with no
   changes.  It will assemble to an identical binary.

 - `pet_speedcode/`: Experiment in making the PET terminal faster by
   using code generation to make faster screen routines.  It also has various other
   changes.  It now assembles to over 2048 bytes which means it cannot be stored directly
   on a SoftBox boot disk.

 - `superpet`: Disassembly of the original PET terminal by Doug Staley with changes
   for the SuperPET.  This was made in the 1980's and requires the Waterloo 6502 assembler,
   which is not available.  It is for reference only.

 - `cbm2/`: Port of the terminal for CBM-II (B-series and P-series).

## Assemble

Run `make` in each directory to assemble:

    $ make

The program file can then be copied to a Commodore disk.  The terminal does
not need to be copied onto a SoftBox boot disk to run.  It may be loaded
and run from any device as long as there is a SoftBox boot disk in unit 8,
drive 0.
