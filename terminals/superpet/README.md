Disassembly by Doug Staley
==========================

The files in this directory are the work of Doug Staley.  He was a member of
the Toronto PET User's Group in the early 1980's and may have been the first
person to reverse engineer parts of the SoftBox, having worked on it in 1983.
Doug disassembled the terminal program on the SoftBox boot disk and produced
source files that could be assembled using the Waterloo 6502 assembler.

Mike Naberezny contacted Doug in February 2013 while searching for
the SoftBox manual.  At that time, Mike had been working with Steve Gray
and the two had just finished disassembling the terminal program.
It was quite a surprise to learn that Doug had done the same work thirty
years earlier, and that he saved it!  The two independent disassemblies
are remarkably similar.

SuperPET Changes
----------------

Doug also modified the SoftBox terminal to use the extra features of
the SuperPET.

These changes were found:

 - PET Detection code has been removed.  The original terminal detects whether
   the machine has 40 or 80 columns.  In this version, it is assumed that
   the machine is always a SuperPET and has 80 columns.

 - Screen height has been reduced to 24 lines.  The SoftBox terminal supports
   Lear Seigler ADM-3A control codes.  The ADM-3A has a 24 line screen but
   the original SoftBox terminal has 25 lines.  This causes problems for
   some CP/M programs that expect an ADM-3A to have only 24 lines.

 - SuperPET character set has been switched on.  The SuperPET has a double-size
   character ROM.  In addition to the normal PET/CBM character set, it also
   has a "true ASCII" set.

 - Keyboard scanning has been modified.  This fixes typing some characters,
   notably curly braces.

The modified files are marked with a ``2``, such as ``main.asm`` (original
disassembly) and ``main2.asm`` (modified version).

Current State
-------------

These files are included mainly for reference and historical interest.
