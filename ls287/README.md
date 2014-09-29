# SoftBox PROMs

This directory contains address decoding PROMs used by the SoftBox and
HardBox.

## Files

Two different PROM versions have been found:

 - `softbox.bin` is used only by the earliest known SoftBox.  This SoftBox
   has a brown case with only one LED and the PCB slides into the case on
   rails.  The PCB has "SoftBox" etched into it.  This PROM only supports
   the SoftBox CP/M memory map (60K RAM and 4K ROM).

 - `stuntbox.bin` is used on all later SoftBox and HardBox units.  The PCB
   has "StuntBox" etched into it.  This PROM supports both the SoftBox
   CP/M memory map and the HardBox memory map (56K RAM and 8K ROM).  The
   map will be selected by A6 on the PROM, which is set by a wire strap
   on the PCB.

## Credits

The early PROM was dumped by Nils Eilers.  The later PROM was dumped by
Martin Hoffmann-Vetter.  Martin did the reverse engineering work on
both versions.
