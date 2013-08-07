#!/usr/bin/env python
'''
Convert a CP/M image into a SoftBox-formatted D80 image

Usage: python cpm_to_d80.py <input.cpm> <output.d80>
'''

import sys


def cpm_to_d80(input_filename, output_filename):
    inp = open(input_filename, "rb")
    out = open(output_filename, "wb")

    pet_track, pet_sector = 1, 0
    cpm_track, cpm_sector = 0, 0

    # TODO: why is +8 needed?
    for i in range(0, 3984 + 8):
        # each 256-byte pet sector holds two 128-byte cp/m sectors
        cpm_sector_data = inp.read(128)
        if len(cpm_sector_data) != 128:
            cpm_sector_data = chr(0) * 128
        out.write(cpm_sector_data)

        # increment cp/m track/sector counters
        cpm_sector += 1
        if cpm_sector > 31:
            cpm_track += 1
            cpm_sector = 0

        if i & 1:
            # increment pet track/sector counters
            pet_sector += 1
            if not is_valid_8050_ts(pet_track, pet_sector):
                pet_sector = 0
                pet_track += 1

            # skip over the 3 reserved 8050 tracks: 37, 38, 39
            # 29 sectors on each
            if pet_track == 37:
                pet_track = 40
                # TODO: a Commodore directory should be written here
                out.write(chr(0) * 256 * 29 * 3)

    inp.close()
    out.close()


def is_valid_8050_ts(track, sector):
    valid = False
    if track >= 1 and track <= 39:
        valid = sector >= 0 and sector <= 28
    elif track >= 40 and track <= 53:
        valid = sector >= 0 and sector <= 26
    elif track >= 54 and track <= 64:
        valid = sector >= 0 and sector <= 24
    elif track >= 65 and track <= 77:
        valid = sector >= 0 and sector <= 22
    return valid


if __name__ == '__main__':
    if len(sys.argv) < 3:
        sys.stderr.write(__doc__ + "\n")
        sys.exit(1)

    cpm_to_d80(sys.argv[1], sys.argv[2])
