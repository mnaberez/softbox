# SoftBox Disk Formats

This directory contains reverse engineering work to determine how
the SoftBox stores CP/M data on Commodore floppy disks.

 - ``find_trk_sec/`` maps the disk layout without actually accessing the
   disk.  For every CP/M track and sector, it calls the SoftBox BIOS
   routines that look up the Commodore track/sector number.

 - ``read_sectors/`` maps the disk layout by generating a special disk
   image and then reading sectors from it.  Each Commodore sector (256
   bytes) is known to hold two CP/M sectors (128 bytes each).  The disk
   image contains a unique number at the start of every CP/M sector.  A
   program run on the SoftBox reads every CP/M sector and prints the
   number found in the sector buffer.

 - ``convert/`` contains programs to convert between the CP/M disk
   images used by [cpmtools](http://www.moria.de/~michael/cpmtools/)
   and Commodore disk images.
