#!/usr/bin/env python

"""
Convert a CBMXfer disassembly to ACME assembler syntax.  This was
written to reassemble the SoftBox code and only converts what
was necessary for that program.

Usage:
  python cbmxfer2acme.py file.disasm > file.asm

"""

import sys
import os
import re

if len(sys.argv) > 1 and os.path.exists(sys.argv[1]):
    filename = sys.argv[1]
else:
    sys.stderr.write(__doc__)
    sys.exit(1)

f = open(filename, "r")
lines = [l.rstrip() for l in f.readlines()]
f.close()

for line in lines:
    # Indented comment line
    if re.match(r" {12,};", line):
        print(line[13:])
        continue

    line = line.lstrip()

    # Label or equate
    #   INIT_4080:
    #   BLINK_CNT = $01  ;Counter used for cursor blink timing
    if re.match(r"^[a-z]", line, re.IGNORECASE):
        parts = line.split(";", 1)  # "instruction ;comment"
        line = parts[0].lower()
        if len(parts) > 1:
            line += ";" + parts[1]
        print(line)
        continue

    # Add hexadecimal prefix to program counter directive
    #   *=0400
    if line.startswith("*"):
        asterisk, address = line.split("=", 1)
        line = "*=$" + re.sub(r"^[\s$]+", "", address)

    # Strip disassembly address and bytes
    #   $049D: 85 09     STA X_WIDTH   ;X_WIDTH = 40 characters
    #   $0720:           .WORD CMD_01  ;Store #$FF in $13
    #   $0B3F:           .BYT AA,AA,AA,AA,AA,AA,AA,AA  ;Filler
    if line.startswith("$"):
        line = line[17:]

    # Byte directive
    #   .BYT AA,AA,AA,AA,AA,AA,AA,AA  ;Filler
    if line.startswith(".BYT"):
        parts = line.split(";", 1)  # "instruction ;comment"
        byts = re.findall("([\dA-F]{2})", parts[0])
        line = "!byte " + ",".join(["$" + b for b in byts])
        if len(parts) > 1:
            line += " ; " + parts[1]

    # Word directive
    #   .WORD CMD_01  ;Store #$FF in $13
    if line.startswith(".WORD"):
        parts = line.split(";", 1)  # "instruction ;comment"
        line = "!word" + parts[0].replace(".WORD", "")
        if len(parts) > 1:
            line += " ; " + parts[1]

    # Text directive
    if line.startswith(".TEXT"):
        parts = line.split(";", 1)  # "instruction ;comment"
        line = "!text" + parts[0].replace(".TEXT", "")
        if len(parts) > 1:
            line += " ; " + parts[1]

    # Whole line comment without indent
    #   ;Detect 40/80 column screen and store in X_WIDTH
    if line.startswith(";"):
        pass

    # Empty line
    elif len(line) == 0:
        pass

    # Instruction
    #   STA X_WIDTH  ;X_WIDTH = 40 characters
    else:
        line = re.sub(r"ASL A ?", "asl ;a", line, flags=re.IGNORECASE)
        line = re.sub(r"LSR A ?", "lsr ;a", line, flags=re.IGNORECASE)
        line = re.sub(r"ROL A ?", "rol ;a", line, flags=re.IGNORECASE)
        line = re.sub(r"ROR A ?", "ror ;a", line, flags=re.IGNORECASE)

        parts = line.split(";", 1)  # "instruction ;comment"

        line = "    " + parts[0]
        if "!text" not in line:
            line = line.lower()

        if len(parts) > 1:
            line += ";" + parts[1]

    print(line)
