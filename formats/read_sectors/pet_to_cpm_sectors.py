# Print mapping of PET sectors to CP/M sectors

# Read PET data lines generated by make_test_image.py
with open("8050_pet_sectors.csv") as f:
    pet_lines = f.readlines()

# Build dict of {identifier: pet t/s info}
ids_to_pet_info = {}
for line in pet_lines:
    parts = [ int(x, 16) for x in line.split(",") ]
    pet_track, pet_sector, pet_half, identifier = parts
    ids_to_pet_info[identifier] = (pet_track, pet_sector, pet_half)

# Read CP/M data lines generated by readall.com
cpm_lines = []
with open("8050_cpm_sectors.csv") as f:
    lines = f.readlines()
for line in lines:
    if "BDOS" in line:
        break
    if "," in line:
        cpm_lines.append(line)

# Build dict of {pet ts: [cp/m ts, cp/m ts]}
pet_to_cpm = {}
for line in cpm_lines:
    parts = [ int(x, 16) for x in line.split(",") ]
    cpm_track, cpm_sector, identifier = parts

    pet_track, pet_sector, pet_half = ids_to_pet_info[identifier]
    k = "%03d_%03d" % (pet_track, pet_sector)
    v = "%03d_%03d" % (cpm_track, cpm_sector)
    if not k in pet_to_cpm:
        pet_to_cpm[k] = [None, None]
    pet_to_cpm[k][pet_half] = v

# Print mapping of PET track/sectors to CP/M track/sectors
for k in sorted(pet_to_cpm.keys()):
    v = pet_to_cpm[k]
    print("%s: [%s, %s]" % (k, v[0], v[1]))
