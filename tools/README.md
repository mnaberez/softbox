# SoftBox Tools

 - ``convert`` has programs that can convert between CBM DOS disk images
   and CP/M disk images.  The SoftBox embeds a CP/M filesystem inside
   CBM DOS sectors.  The CP/M filesystem needs to be extracted to its
   own image file so CP/M utilities like ``cpmtools`` can work with it.

 - ``cpmtools/`` has a ``diskdefs`` file for the [cpmtools](http://www.moria.de/~michael/cpmtools/) package.  After the
   CP/M filesystem has been extracted into its own image file,
   ``cpmtools`` can manipulate that image.

 - ``disk_study/`` was used to study how the SoftBox uses the CBM DOS
   filesystem, and to troubleshoot a bug in the SoftBox's support for the
   CBM 8250 drive.  The programs there map how the CP/M filesystem is stored on
   the CBM DOS filesystem.  The SoftBox stores two CP/M sectors (128 bytes each)
   in a CBM DOS sector (256 bytes).  A special disk image is generated that
   contains a unique number at every 128 bytes.  A program is then run on
   the SoftBox that reads every CP/M sector and prints the number found in the
   sector buffer.
