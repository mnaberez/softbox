# Find unused tracks

with open("8050.csv") as f:
    lines = f.readlines()

tracks = {}
for line in lines:
    cpm_track, cpm_sector, pet_track, pet_sector = line.split(",")
    tracks[int(pet_track)] = 1

used_tracks = sorted(tracks.keys())
max_track = max(used_tracks)

for i in range(1, max_track+1):
    if i not in used_tracks:
        print i
