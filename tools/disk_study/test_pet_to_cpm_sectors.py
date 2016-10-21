import unittest
import sys
from StringIO import StringIO
from tempfile import NamedTemporaryFile
from textwrap import dedent

from pet_to_cpm_sectors import SectorMapper, Unused, Multiple

class SectorMapperTests(unittest.TestCase):
    def _makeOne(self):
        return SectorMapper(stdout=StringIO())

    def test_load_pet_csv_parses_and_sets_pet_data(self):
        with NamedTemporaryFile() as ntf:
            csv = dedent(
            '''
            ;comments and blank lines should be ignored
            01,02,000B
            0A,0B,000F
            ''')
            ntf.write(csv)
            ntf.flush()

            mapper = self._makeOne()
            mapper.load_pet_csv(ntf.name)
            self.assertEqual(
                mapper.pet_data,
                [[0x01, 0x02, 0x000B], [0x0A, 0x0B, 0x000F]]
                )

    def test_load_cpm_csv_parses_and_sets_cpm_data(self):
        with NamedTemporaryFile() as ntf:
            csv = dedent(
            '''
            ;comments and blank lines should be ignored
            0C,1B,019B
            0C,1C,019C
            BDOS err and below should be ignored
            0C,1D,019D
            ''')
            ntf.write(csv)
            ntf.flush()
            mapper = self._makeOne()
            mapper.load_cpm_csv(ntf.name)
            self.assertEqual(
                mapper.cpm_data,
                [[0x0C, 0x1B, 0x19B], [0x0C, 0x1C, 0x019C]]
                )

    def test_analyze_data_maps_each_pet_sector_to_two_cpm_sectors(self):
        mapper = self._makeOne()
        mapper.pet_data = [
            # track, sector, sector half (0/1), identifier
            [0x01, 0x00, 0, 0x0000],
            [0x01, 0x00, 1, 0x0001],
        ]
        mapper.cpm_data = [
            # track, sector, identifier
            [0x00, 0x00, 0x0000],
            [0x00, 0x01, 0x0001],
        ]
        mapper.analyze_data()
        self.assertEqual(
            mapper.pet_to_cpm, {
                # (pet track, sector): [(cpm t, s), (cpm t, s)]
                (1, 0): [(0, 0), (0, 1)]
                },
            )

    def test_analyze_data_finds_corrupted_id_in_cpm_data(self):
        mapper = self._makeOne()
        mapper.pet_data = [
            # track, sector, sector half (0/1), identifier
            [0x01, 0x00, 0, 0x0000],
            [0x01, 0x00, 1, 0x0001],
        ]
        mapper.cpm_data = [
            # track, sector, identifier
            [0x00, 0x00, 0xAAAA],  # identifier not in pet data
            [0x00, 0x01, 0xBBBB],  # identifier not in pet data
        ]
        mapper.analyze_data()
        self.assertEqual(
            mapper.corrupted_cpm_sectors,
            set([(0x00, 0x00), (0x00, 0x01)])
            )

    def test_analyze_data_finds_crossed_pet_half_sectors(self):
        mapper = self._makeOne()
        mapper.pet_data = [
            # track, sector, sector half (0/1), identifier
            [0x01, 0x00, 0, 0x0000],
            [0x01, 0x00, 1, 0x0001],
            [0x10, 0x00, 1, 0x0002],
        ]
        mapper.cpm_data = [
            # track, sector, identifier
            [0x00, 0x00, 0x0000],
            [0x00, 0x01, 0x0000], # same id in two sectors means crossed
        ]
        mapper.analyze_data()
        self.assertEqual(
            mapper.crossed_pet_half_sectors,
            set([(1, 0, 0)]) # track, sector, half
        )

    def test_analyze_data_finds_unused_pet_half_sector(self):
        mapper = self._makeOne()
        mapper.pet_data = [
            # track, sector, sector half (0/1), identifier
            [0x01, 0x00, 0, 0x0000],
            [0x01, 0x00, 1, 0x0001],
        ]
        mapper.cpm_data = [
            # track, sector, identifier
            [0x00, 0x00, 0x0000],
        ]
        mapper.analyze_data()
        self.assertEqual(
            mapper.unused_pet_half_sectors,
            set([(1, 0, 1)]) # track, sector, half
        )

    def test_analyze_data_finds_unused_pet_tracks(self):
        mapper = self._makeOne()
        mapper.pet_data = [
            # track, sector, sector half (0/1), identifier
            [0x05, 0x00, 0, 0x0000],
            [0x05, 0x00, 1, 0x0001],
            [0x08, 0x00, 0, 0x0002],
            [0x08, 0x00, 1, 0x0003],
        ]
        mapper.cpm_data = [
            # track, sector, identifier
            [0x00, 0x01, 0x0000],
            [0x00, 0x02, 0x0001],
            [0x00, 0x03, 0x0002],
            [0x00, 0x04, 0x0003],
        ]
        mapper.analyze_data()
        self.assertEqual(
            mapper.unused_pet_tracks,
            set([1, 2, 3, 4, 6, 7]) # tracks 5 and 8 are used
        )

    def test__print_report(self):
        mapper = self._makeOne()
        mapper.pet_data = [[0x05, 0x00, 0, 0x0000]]
        mapper.cpm_data = [[0x00, 0x01, 0x0000]]
        mapper.analyze_data()
        mapper.print_report() # shouldn't raise

    def test__print_mapping(self):
        mapper = self._makeOne()
        mapper.pet_to_cpm = {
            (5, 5): [Unused, Multiple],
            (5, 6): [(1,2), (1,3)],
            }
        mapper._print_mapping()
        out = mapper.stdout.getvalue()
        self.assertTrue('005_05: [UNUSED, MULTIPLE]' in out)
        self.assertTrue('005_06: [001_02, 001_03]' in out)

    def test__print_crossed_pet_half_sectors(self):
        mapper = self._makeOne()
        mapper.crossed_pet_half_sectors = [
            (1, 2, 0),
            (1, 2, 1),
            ]
        mapper._print_crossed_pet_half_sectors()
        out = mapper.stdout.getvalue()
        self.assertTrue('001_02 (lower half)' in out)
        self.assertTrue('001_02 (upper half)' in out)

    def test__print_corrupted_cpm_sectors(self):
        mapper = self._makeOne()
        mapper.corrupted_cpm_sectors = [
            (1, 2),
            (1, 3),
            ]
        mapper._print_corrupted_cpm_sectors()
        out = mapper.stdout.getvalue()
        self.assertTrue('001_02' in out)
        self.assertTrue('001_03' in out)

    def test__print_unused_pet_half_sectors(self):
        mapper = self._makeOne()
        mapper.unused_pet_half_sectors = [
            (1, 1, 0),
            (1, 2, 1),
            ]
        mapper._print_unused_pet_half_sectors()
        out = mapper.stdout.getvalue()
        self.assertTrue('001_01 (lower half)' in out)
        self.assertTrue('001_02 (upper half)' in out)

    def test__print_unused_pet_tracks(self):
        mapper = self._makeOne()
        mapper.unused_pet_tracks = [16, 17]
        mapper._print_unused_pet_tracks()
        out = mapper.stdout.getvalue()
        self.assertTrue('016' in out)
        self.assertTrue('017' in out)

def test_suite():
    return unittest.findTestCases(sys.modules[__name__])

if __name__ == '__main__':
    unittest.main(defaultTest='test_suite')
