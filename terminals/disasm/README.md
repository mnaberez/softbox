# SoftBox Disassembly

This directory contains a disassembly of the original SoftBox
terminal program for Commodore PET/CBM computers.

## Files

 - `k.prg` is the original binary that was copied from a SoftBox boot disk.

 - `k.asm` is reverse engineered source code for `k.prg`.

## Assemble

The assembler used is `as6500`, part of the [`asxxxx`](http://shop-pdp.net/ashtml/asxxxx.htm)
package.  To assemble:

    $ make

The binary will be written to ``out.prg``.  It should be identical to the
original ``k.prg``.
