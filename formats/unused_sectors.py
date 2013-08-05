# Find unused sectors

with open("8050.csv") as f:
    lines = f.readlines()

# pet sector: # of CP/M sectors
counts = {}
for line in lines:
    parts = [ int(x) for x in line.split(",") ]
    cpm_track, cpm_sector, pet_track, pet_sector = parts

    k = "%02d_%02d" % (pet_track, pet_sector)
    if not k in counts:
        counts[k] = 0
    counts[k] += 1

# find PET sectors with any free space:
#   one PET sector = 256 bytes, one CP/M sector = 128 bytes
#   a PET sector has free space if it has less than 2 CP/M sectors mapped
pet_sectors = [ k for k, v in counts.items() if v < 2 ]

# print results
print(sorted(pet_sectors))
print(len(pet_sectors))
