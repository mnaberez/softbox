# Find unused sectors

with open("8050_pet_to_cpm.txt") as f:
    lines = f.readlines()

# pet sector: # of CP/M sectors
counts = {}
for line in lines:
    pet, cpm = line.split(":", 1)
    counts[pet] = len(cpm.split(","))

# find PET sectors with any free space:
#   one PET sector = 256 bytes, one CP/M sector = 128 bytes
#   a PET sector has free space if it has less than 2 CP/M sectors mapped
pet_sectors = [ k for k, v in counts.items() if v != 2 ]

# print results
print(sorted(pet_sectors))
print(len(pet_sectors))
