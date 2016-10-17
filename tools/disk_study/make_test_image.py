import sys

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
    formats = {"d64":"4040", "d80":"8050", "d82":"8250"}
    if len(sys.argv) != 2 or sys.argv[1] not in formats:
        msg = "Usage: python make_test_image.py %s\n" % (
            "|".join(sorted(formats)))
        sys.stderr.write(msg)
        sys.exit(1)

    if sys.argv[1] == "d64":
        image_filename = "test.d64"
        csv_filename = "4040_pet_sectors.csv"
        is_valid_ts = is_valid_4040_ts
    elif sys.argv[1] == "d80":
        image_filename = "test.d80"
        csv_filename = "8050_pet_sectors.csv"
        is_valid_ts = is_valid_8050_ts
    elif sys.argv[1] == "d82":
        image_filename = "test.d82"
        csv_filename = "8250_pet_sectors.csv"
        is_valid_ts = is_valid_8250_ts

    pet_track, pet_sector = 1, 0
    i = 0
    end_of_disk = False

    with open(image_filename, "wb") as image:
        with open(csv_filename, "w") as csv:
            while not end_of_disk:
                first_half = chr(0) + chr(0) + ("%04X" % i).ljust(126, chr(0))
                csv.write("%02X,%02X,0,%04X\n" % (pet_track, pet_sector, i))
                i += 1

                second_half = chr(0) + chr(0) + ("%04X" % i).ljust(126, chr(0))
                csv.write("%02X,%02X,1,%04X\n" % (pet_track, pet_sector, i))
                i += 1

                sector_data = first_half + second_half
                assert len(sector_data) == 256
                image.write(sector_data)

                pet_sector += 1
                if not is_valid_ts(pet_track, pet_sector):
                    pet_sector = 0
                    pet_track += 1

                if not is_valid_ts(pet_track, pet_sector):
                    end_of_disk = True
