#!/usr/bin/env python
'''
Convert a SoftBox-formatted D82 image into a CP/M image

Usage: python d82_to_cpm.py <input.d82> <output.cpm>
'''

import sys


def d82_to_cpm(input_filename, output_filename):
    inp = open(input_filename, "rb")
    out = open(output_filename, "wb")

    pet_track, pet_sector = 1, 0
    cpm_track, cpm_sector = 0, 0

    for i in range(0, 8158):
        # each 256-byte pet sector holds two 128-byte cp/m sectors
        if i & 1 == 0:
            pet_sector_data = inp.read(256)
            assert len(pet_sector_data) == 256
            cpm_sector_data = pet_sector_data[0:128]
        else:
            cpm_sector_data = pet_sector_data[128:256]

        # write 128-byte cp/m sector out
        out.write(cpm_sector_data)

        # increment cp/m track/sector counters
        cpm_sector += 1
        if cpm_sector > 31:
            cpm_track += 1
            cpm_sector = 0

        if i & 1:
            # increment pet track/sector counters
            pet_sector += 1
            if not is_valid_8250_ts(pet_track, pet_sector):
                pet_sector = 0
                pet_track += 1

            # skip over the 3 reserved 8250 tracks: 37, 38, 39
            # 29 sectors on each
            if pet_track == 37:
                pet_track = 40
                inp.read(29 * 3 * 256)

    inp.close()
    out.close()


def is_valid_8250_ts(track, sector):
    valid = False
    if track >= 1 and track <= 39:
        valid = sector >= 0 and sector <= 28
    elif track >= 40 and track <= 53:
        valid = sector >= 0 and sector <= 26
    elif track >= 54 and track <= 64:
        valid = sector >= 0 and sector <= 24
    elif track >= 65 and track <= 77:
        valid = sector >= 0 and sector <= 22
    elif track >= 78 and track <= 116:
        valid = sector >= 0 and sector <= 28
    elif track >= 117 and track <= 130:
        valid = sector >= 0 and sector <= 26
    elif track >= 131 and track <= 141:
        valid = sector >= 0 and sector <= 24
    elif track >= 142 and track <= 154:
        valid = sector >= 0 and sector <= 22
    return valid


if __name__ == '__main__':
    if len(sys.argv) < 3:
        sys.stderr.write(__doc__ + "\n")
        sys.exit(1)

    d82_to_cpm(sys.argv[1], sys.argv[2])
