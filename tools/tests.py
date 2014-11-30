#!/usr/bin/env python
'''
Check that each file assembles and that the output binary
is identical to the original file.
'''
import filecmp
import os
import subprocess
import sys

FILES = {'apps/backup.asm':          'apps/backup.com',
         'apps/cold.asm':            'apps/cold.com',
         'apps/format.asm':          'apps/format.com',
         'apps/memtest.asm':         'apps/memtest.com',
         'apps/newsys.asm':          'apps/newsys.com',
         'apps/read.asm':            'apps/read.com',
         'apps/set.asm':             'apps/set.com',
         'apps/softsoak.asm':        'apps/softsoak.com',
         'apps/time.asm':            'apps/time.com',
         'apps/xfer.asm':            'apps/xfer.com',
         'apps/mw1000/devnum.asm':   'apps/mw1000/devnum.com',
         'apps/mw1000/format.asm':   'apps/mw1000/format.com',
         'apps/mw1000/mwdos291.asm': 'apps/mw1000/mwdos291.com',
         'apps/mw1000/mwformat.asm': 'apps/mw1000/mwformat.com',
         'apps/mw1000/newdos.asm':   'apps/mw1000/newdos.com',
         'apps/mw1000/newsys.asm':   'apps/mw1000/newsys.com',
         'bios/1981-09-08.asm':      'bios/1981-09-08.bin',
         'bios/1981-10-27.asm':      'bios/1981-10-27.bin',
         'bios/1983-06-09.asm':      'bios/1983-06-09.bin',
         'bios/bios.asm':            None,
         'cbm/pet.asm':              None,
         'cbm/cbm2.asm':             None,
         'cpm22/cpm.asm':            'cpm22/cpm.prg'}

if __name__ == '__main__':
    if sys.version_info[:2] < (2, 7):
        sys.stderr.write("Python 2.7 or later required\n")
        sys.exit(1)

    repo_root = os.path.abspath(os.path.join(__file__, "../.."))
    os.chdir(repo_root)

    failures = []
    for src in sorted(FILES.keys()):
        original = FILES[src]

        # choose assembler command
        if 'cbm' in src:
            cmd = "acme -v1 --cpu 6502 -f cbm -o ./a.bin '%s'" % src
        else:
            cmd = "z80asm './%s' -o './a.bin' " % src

        # assemble the file
        try:
            subprocess.check_output(cmd, shell=True)
        except subprocess.CalledProcessError as exc:
            sys.stdout.write(exc.output)
            sys.stderr.write("%s: assembly failed\n" % src)
            failures.append(src)
            continue

        # check assembled output is identical to original binary
        if original is None:
            sys.stdout.write("%s: assembled\n" % src)
        else:
            if filecmp.cmp('./%s' % original, './a.bin'):
                sys.stdout.write("%s: ok\n" % src)
            else:
                failures.append(src)
                sys.stderr.write("%s: not ok\n" % src)

    if os.path.exists('a.bin'):
        os.unlink('a.bin')

    if failures:
        sys.exit(1)
