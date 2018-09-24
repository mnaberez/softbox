all: clean out.prg

out.prg:
	cp -f pet.asm out.asm
	as6500 -l -o out.asm
	rm -f out.asm
	aslink out -i
	srec_cat out.ihx -intel -offset -0x0400 -o out.bin -binary
	bash -c "printf '\x00\x04' | cat - out.bin > out.prg"

clean:
	rm -f out.*
