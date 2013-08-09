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
    pet_track, pet_sector = 1, 0
    i = 0
    end_of_disk = False

    with open("test.d80", "wb") as image:
        with open("8050_pet_sectors.csv", "w") as csv:
            while not end_of_disk:
                first_half = ("%04X" % i).ljust(128, chr(0))
                i += 1
                csv.write("%02X,%02X,0,%04X\n" % (pet_track, pet_sector, i))

                second_half = ("%04X" % i).ljust(128, chr(0))
                i += 1
                csv.write("%02X,%02X,1,%04X\n" % (pet_track, pet_sector, i))

                sector_data = first_half + second_half
                image.write(sector_data)

                pet_sector += 1
                if not is_valid_8050_ts(pet_track, pet_sector):
                    pet_sector = 0
                    pet_track += 1

                if not is_valid_8050_ts(pet_track, pet_sector):
                    end_of_disk = True
