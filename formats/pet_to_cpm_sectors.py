# Print mapping of PET sectors to CP/M sectors

with open("8050.csv") as f:
    lines = f.readlines()

# pet sector: [cp/m sector, cp/m sector]
pet_to_cpm={}
for line in lines:
    parts = [ int(x) for x in line.split(",") ]
    cpm_track, cpm_sector, pet_track, pet_sector = parts

    k = "%02d_%02d" % (pet_track, pet_sector)
    v = "%02d_%02d" % (cpm_track, cpm_sector)
    if not k in pet_to_cpm:
        pet_to_cpm[k] = []
    pet_to_cpm[k].append(v)

# print results
last_track = "01"
for k in sorted(pet_to_cpm.keys()):
    # print a blank line between tracks
    track = k.split("_")[0]
    if track != last_track:
        print("")
    last_track = track

    # print pet sector: [cp/m sector, cp/m sector]
    print("%s: [%s]" % (k, ', '.join(pet_to_cpm[k])))
