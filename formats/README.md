# SoftBox Disk Formats

This directory contains reverse engineering work to determine how
the SoftBox stores CP/M data on Commodore floppy disks.

 - ``find_trk_sec/`` was the first attempt to map the disk layout.  For
   every CP/M track and sector, it calls the BIOS routine that is believed
   to look up the Commodore track/sector number.  This attempt produced
   some incorrect results so the operation of the BIOS routine is not
   understood yet.

 - ``read_sectors/`` is a second attempt.  It works by generating a
   special disk image.  Each Commodore sector (256 bytes) is known to hold
   two CP/M sectors (128 bytes each).  The disk image contains a unique
   number at every 128 bytes.  A program running on the SoftBox then reads
   every CP/M sector and prints the number found in the sector buffer.

 - ``convert/`` contains programs to convert between the CP/M disk
   images used by [cpmtools](http://www.moria.de/~michael/cpmtools/)
   and Commodore disk images.
