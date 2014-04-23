#!/usr/bin/env python
'''
Convert a SoftBox-formatted D64 image into a CP/M image

Usage: python d64_to_cpm.py <input.d64> <output.cpm>
'''

import sys

def d64_to_cpm(input_filename, output_filename):
    inp = open(input_filename, "rb")
    out = open(output_filename, "wb")
    pet_track, pet_sector = 1, 0
    cpm_track, cpm_sector = 0, 0

    for i in range(0, 1244):
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
            if not is_valid_4040_ts(pet_track, pet_sector):
                pet_sector = 0
                pet_track += 1

            # skip over the 3 reserved 4040 tracks: 16, 17, 18
            # 21 sectors on tracks 16 & 17, 19 sectors on track 18
            if pet_track == 16:
                pet_track = 19
                inp.read(256 * 21) # track 16
                inp.read(256 * 21) # track 17
                inp.read(256 * 19) # track 18

    inp.close()
    out.close()

def is_valid_4040_ts(track, sector):
    valid = False
    if track >= 1 and track <= 17:
        valid = sector >= 0 and sector <= 20
    elif track >= 18 and track <= 24:
        valid = sector >= 0 and sector <= 18
    elif track >= 25 and track <= 30:
        valid = sector >= 0 and sector <= 17
    elif track >= 31 and track <= 35:
        valid = sector >= 0 and sector <= 16
    return valid


if __name__ == '__main__':
    if len(sys.argv) < 3:
        sys.stderr.write(__doc__ + "\n")
        sys.exit(1)

    d64_to_cpm(sys.argv[1], sys.argv[2])
