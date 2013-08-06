# Convert a SoftBox-formatted D80 image into a CP/M image

def is_valid_8050_ts(track, sector):
    '''Returns true if the given track and sector are valid for an 8050 disk'''
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

def find_d80_offset(track, sector):
    '''Returns the offset of an 8050 track and sector in a D80 disk image'''
    offset = sector * 256
    for t in range(1, track):
        if t >= 1 and t <= 39:
            sectors_on_track = 29
        elif t >= 40 and t <= 53:
            sectors_on_track = 27
        elif t >= 54 and t <= 64:
            sectors_on_track = 25
        elif t >= 65 and t <= 77:
            sectors_on_track = 23
        offset += sectors_on_track * 256
    return offset

if __name__ == '__main__':
    with open("8050.csv") as f:
        lines = f.readlines()

    # (cp/m track, cp/m sector): (pet track, pet sector)
    cpm_to_pet = {}
    for line in lines:
        parts = [ int(x, 16) for x in line.split(",") ]
        cpm_track, cpm_sector, pet_track, pet_sector = parts
        cpm_to_pet[(cpm_track, cpm_sector)] = (pet_track, pet_sector)

    with open("input.d80", "rb") as f:
        d80_data = f.read()

    with open("output.cpm", "wb") as f:
        cpm_track, cpm_sector = 0, 0

        for i in range(0, 3984):
            pet_track, pet_sector = cpm_to_pet[(cpm_track, cpm_sector)]

            # read pet sector data
            if is_valid_8050_ts(pet_track, pet_sector):
                offset = find_d80_offset(pet_track, pet_sector)
                pet_sector_data = d80_data[offset:offset+256]
            else:
                pet_sector_data = chr(0) * 256

            # one half of the pet sector is the cp/m sector
            if cpm_sector & 1:
                cpm_sector_data = pet_sector_data[128:256]
            else:
                cpm_sector_data = pet_sector_data[0:128]

            f.write(cpm_sector_data)

            cpm_sector += 1
            if cpm_sector > 31:
                cpm_track += 1
                cpm_sector = 0
