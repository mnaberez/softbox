all: clean out.prg diff

diff: out.prg
	diff k.prg out.prg

out.prg:
	as6500 -l -o+out k.asm
	aslink -i out
	srec_cat out.hex -intel -offset -0x0400 -o out.bin -binary
	bash -c "printf '\x00\x04' | cat - out.bin > out.prg"

clean:
	rm -f out.*
