; z80dasm 1.1.3
; command line: z80dasm --origin=256 --address --labels --source format.com

	org	00100h

	jp l011eh		;0100	c3 1e 01 	. . . 
	nop			;0103	00 	. 
	nop			;0104	00 	. 
	nop			;0105	00 	. 
	nop			;0106	00 	. 
	nop			;0107	00 	. 
	nop			;0108	00 	. 
	nop			;0109	00 	. 
l010ah:
	nop			;010a	00 	. 
	nop			;010b	00 	. 
l010ch:
	nop			;010c	00 	. 
	nop			;010d	00 	. 
l010eh:
	nop			;010e	00 	. 
	nop			;010f	00 	. 
l0110h:
	nop			;0110	00 	. 
	nop			;0111	00 	. 
l0112h:
	nop			;0112	00 	. 
	nop			;0113	00 	. 
l0114h:
	nop			;0114	00 	. 
	nop			;0115	00 	. 
	nop			;0116	00 	. 
	nop			;0117	00 	. 
	nop			;0118	00 	. 
	nop			;0119	00 	. 
	nop			;011a	00 	. 
	ld (hl),a			;011b	77 	w 
	dec hl			;011c	2b 	+ 
	ld a,b			;011d	78 	x 
l011eh:
	ld hl,l0132h		;011e	21 32 01 	! 2 . 
	jp l0983h		;0121	c3 83 09 	. . . 
	push af			;0124	f5 	. 
	inc b			;0125	04 	. 
	nop			;0126	00 	. 
	nop			;0127	00 	. 
	rst 30h			;0128	f7 	. 
	inc b			;0129	04 	. 
	inc bc			;012a	03 	. 
	ld bc,l0114h		;012b	01 14 01 	. . . 
	nop			;012e	00 	. 
	nop			;012f	00 	. 
	ld e,001h		;0130	1e 01 	. . 
l0132h:
	call sub_0984h		;0132	cd 84 09 	. . . 
	call sub_0999h		;0135	cd 99 09 	. . . 
	ld hl,l04f2h		;0138	21 f2 04 	! . . 
	call sub_0888h		;013b	cd 88 08 	. . . 
	call sub_0999h		;013e	cd 99 09 	. . . 
	ld hl,l04f2h		;0141	21 f2 04 	! . . 
	call sub_0888h		;0144	cd 88 08 	. . . 
	call sub_0999h		;0147	cd 99 09 	. . . 
	ld hl,004d8h		;014a	21 d8 04 	! . . 
	call sub_0888h		;014d	cd 88 08 	. . . 
	call sub_0999h		;0150	cd 99 09 	. . . 
	ld hl,l04c8h		;0153	21 c8 04 	! . . 
	call sub_0888h		;0156	cd 88 08 	. . . 
	call sub_0999h		;0159	cd 99 09 	. . . 
	ld hl,l04b9h		;015c	21 b9 04 	! . . 
	call sub_0888h		;015f	cd 88 08 	. . . 
l0162h:
	call sub_0999h		;0162	cd 99 09 	. . . 
	ld hl,l04f2h		;0165	21 f2 04 	! . . 
	call sub_0888h		;0168	cd 88 08 	. . . 
	call sub_0999h		;016b	cd 99 09 	. . . 
	ld hl,0049ch		;016e	21 9c 04 	! . . 
	call sub_0888h		;0171	cd 88 08 	. . . 
	call sub_0999h		;0174	cd 99 09 	. . . 
	ld hl,l0479h		;0177	21 79 04 	! y . 
	call sub_0893h		;017a	cd 93 08 	. . . 
	call sub_02f5h		;017d	cd f5 02 	. . . 
	call sub_0999h		;0180	cd 99 09 	. . . 
	ld hl,l04f2h		;0183	21 f2 04 	! . . 
	call sub_0888h		;0186	cd 88 08 	. . . 
	ld hl,(l010ah)		;0189	2a 0a 01 	* . . 
	ld a,h			;018c	7c 	| 
	or l			;018d	b5 	. 
	jp nz,l0194h		;018e	c2 94 01 	. . . 
	call sub_0980h		;0191	cd 80 09 	. . . 
l0194h:
	ld de,0ffbfh		;0194	11 bf ff 	. . . 
	ld hl,(l010ah)		;0197	2a 0a 01 	* . . 
	add hl,de			;019a	19 	. 
	ld (l010ch),hl		;019b	22 0c 01 	" . . 
	ld hl,(l010ch)		;019e	2a 0c 01 	* . . 
	add hl,hl			;01a1	29 	) 
	sbc a,a			;01a2	9f 	. 
	ld h,a			;01a3	67 	g 
	ld l,a			;01a4	6f 	o 
	push hl			;01a5	e5 	. 
	ld hl,(l010ch)		;01a6	2a 0c 01 	* . . 
	ld de,0fff0h		;01a9	11 f0 ff 	. . . 
	ld a,h			;01ac	7c 	| 
	rla			;01ad	17 	. 
	jp c,l01b3h		;01ae	da b3 01 	. . . 
	add hl,de			;01b1	19 	. 
	add hl,hl			;01b2	29 	) 
l01b3h:
	ccf			;01b3	3f 	? 
	sbc a,a			;01b4	9f 	. 
	ld h,a			;01b5	67 	g 
	ld l,a			;01b6	6f 	o 
	pop de			;01b7	d1 	. 
	ld a,h			;01b8	7c 	| 
	or d			;01b9	b2 	. 
	ld h,a			;01ba	67 	g 
	ld a,l			;01bb	7d 	} 
	or e			;01bc	b3 	. 
	ld l,a			;01bd	6f 	o 
	ld a,h			;01be	7c 	| 
	or l			;01bf	b5 	. 
	jp z,l01cfh		;01c0	ca cf 01 	. . . 
	call sub_0999h		;01c3	cd 99 09 	. . . 
	ld hl,l0461h		;01c6	21 61 04 	! a . 
	call sub_0888h		;01c9	cd 88 08 	. . . 
	jp l0162h		;01cc	c3 62 01 	. b . 
l01cfh:
	ld hl,(l010ch)		;01cf	2a 0c 01 	* . . 
	ld (l010eh),hl		;01d2	22 0e 01 	" . . 
	ld hl,l010eh		;01d5	21 0e 01 	! . . 
	call sub_05e7h		;01d8	cd e7 05 	. . . 
	ld hl,(l010eh)		;01db	2a 0e 01 	* . . 
	ld de,0ff80h		;01de	11 80 ff 	. . . 
	ld a,h			;01e1	7c 	| 
	rla			;01e2	17 	. 
	jp c,l01e8h		;01e3	da e8 01 	. . . 
	add hl,de			;01e6	19 	. 
	add hl,hl			;01e7	29 	) 
l01e8h:
	jp c,l01f7h		;01e8	da f7 01 	. . . 
	call sub_0999h		;01eb	cd 99 09 	. . . 
	ld hl,0044bh		;01ee	21 4b 04 	! K . 
	call sub_0888h		;01f1	cd 88 08 	. . . 
	jp l0162h		;01f4	c3 62 01 	. b . 
l01f7h:
	ld hl,(l010eh)		;01f7	2a 0e 01 	* . . 
	ld de,0fffeh		;01fa	11 fe ff 	. . . 
	ld a,h			;01fd	7c 	| 
	rla			;01fe	17 	. 
	jp c,l0204h		;01ff	da 04 02 	. . . 
	add hl,de			;0202	19 	. 
	add hl,hl			;0203	29 	) 
l0204h:
	sbc a,a			;0204	9f 	. 
	ld h,a			;0205	67 	g 
	ld l,a			;0206	6f 	o 
	push hl			;0207	e5 	. 
	ld hl,(l010eh)		;0208	2a 0e 01 	* . . 
	ld de,0fff6h		;020b	11 f6 ff 	. . . 
	ld a,h			;020e	7c 	| 
	rla			;020f	17 	. 
	jp c,l0215h		;0210	da 15 02 	. . . 
	add hl,de			;0213	19 	. 
	add hl,hl			;0214	29 	) 
l0215h:
	ccf			;0215	3f 	? 
	sbc a,a			;0216	9f 	. 
	ld h,a			;0217	67 	g 
	ld l,a			;0218	6f 	o 
	pop de			;0219	d1 	. 
	ld a,h			;021a	7c 	| 
	or d			;021b	b2 	. 
	ld h,a			;021c	67 	g 
	ld a,l			;021d	7d 	} 
	or e			;021e	b3 	. 
	ld l,a			;021f	6f 	o 
	ld a,h			;0220	7c 	| 
	or l			;0221	b5 	. 
	jp nz,l027ch		;0222	c2 7c 02 	. | . 
	call sub_0999h		;0225	cd 99 09 	. . . 
	ld hl,00007h		;0228	21 07 00 	! . . 
	call sub_087bh		;022b	cd 7b 08 	. { . 
	call sub_0893h		;022e	cd 93 08 	. . . 
	ld hl,l0436h		;0231	21 36 04 	! 6 . 
	call sub_0893h		;0234	cd 93 08 	. . . 
	ld hl,(l010ah)		;0237	2a 0a 01 	* . . 
	call sub_087bh		;023a	cd 7b 08 	. { . 
	call sub_0893h		;023d	cd 93 08 	. . . 
	ld hl,l0422h+1		;0240	21 23 04 	! # . 
	call sub_0888h		;0243	cd 88 08 	. . . 
	call sub_0999h		;0246	cd 99 09 	. . . 
	ld hl,l0410h		;0249	21 10 04 	! . . 
	call sub_0893h		;024c	cd 93 08 	. . . 
	call sub_02f5h		;024f	cd f5 02 	. . . 
	ld hl,(l010ah)		;0252	2a 0a 01 	* . . 
	ld de,0ffa7h		;0255	11 a7 ff 	. . . 
	add hl,de			;0258	19 	. 
	ld a,h			;0259	7c 	| 
	or l			;025a	b5 	. 
	jp z,l0261h		;025b	ca 61 02 	. a . 
	call sub_0980h		;025e	cd 80 09 	. . . 
l0261h:
	call sub_0999h		;0261	cd 99 09 	. . . 
	ld hl,l04f2h		;0264	21 f2 04 	! . . 
	call sub_0888h		;0267	cd 88 08 	. . . 
	call sub_0999h		;026a	cd 99 09 	. . . 
	ld hl,003f9h		;026d	21 f9 03 	! . . 
	call sub_0888h		;0270	cd 88 08 	. . . 
	ld hl,l010ch		;0273	21 0c 01 	! . . 
	call sub_07a9h		;0276	cd a9 07 	. . . 
	jp l02c9h		;0279	c3 c9 02 	. . . 
l027ch:
	call sub_0999h		;027c	cd 99 09 	. . . 
	ld hl,l03e8h		;027f	21 e8 03 	! . . 
	call sub_0893h		;0282	cd 93 08 	. . . 
	ld hl,(l010ah)		;0285	2a 0a 01 	* . . 
	call sub_087bh		;0288	cd 7b 08 	. { . 
	call sub_0893h		;028b	cd 93 08 	. . . 
	ld hl,003d1h		;028e	21 d1 03 	! . . 
	call sub_0888h		;0291	cd 88 08 	. . . 
	call sub_0999h		;0294	cd 99 09 	. . . 
	ld hl,003a6h		;0297	21 a6 03 	! . . 
	call sub_0893h		;029a	cd 93 08 	. . . 
	call sub_02f5h		;029d	cd f5 02 	. . . 
	ld hl,(l010ah)		;02a0	2a 0a 01 	* . . 
	ld a,h			;02a3	7c 	| 
	or l			;02a4	b5 	. 
	jp z,l02abh		;02a5	ca ab 02 	. . . 
	call sub_0980h		;02a8	cd 80 09 	. . . 
l02abh:
	call sub_0999h		;02ab	cd 99 09 	. . . 
	ld hl,l04f2h		;02ae	21 f2 04 	! . . 
	call sub_0888h		;02b1	cd 88 08 	. . . 
	call sub_0999h		;02b4	cd 99 09 	. . . 
	ld hl,l0396h		;02b7	21 96 03 	! . . 
	call sub_0888h		;02ba	cd 88 08 	. . . 
	ld hl,l010ch		;02bd	21 0c 01 	! . . 
	call sub_06e5h		;02c0	cd e5 06 	. . . 
	ld hl,l0110h		;02c3	21 10 01 	! . . 
	call sub_05f4h		;02c6	cd f4 05 	. . . 
l02c9h:
	call sub_0999h		;02c9	cd 99 09 	. . . 
	ld hl,l04f2h		;02cc	21 f2 04 	! . . 
	call sub_0888h		;02cf	cd 88 08 	. . . 
	ld hl,(l0110h)		;02d2	2a 10 01 	* . . 
	ld a,h			;02d5	7c 	| 
	or l			;02d6	b5 	. 
	jp nz,l02e6h		;02d7	c2 e6 02 	. . . 
	call sub_0999h		;02da	cd 99 09 	. . . 
	ld hl,00384h		;02dd	21 84 03 	! . . 
	call sub_0888h		;02e0	cd 88 08 	. . . 
	jp l0162h		;02e3	c3 62 01 	. b . 
l02e6h:
	call sub_0999h		;02e6	cd 99 09 	. . . 
	ld hl,l035fh		;02e9	21 5f 03 	! _ . 
	call sub_0888h		;02ec	cd 88 08 	. . . 
	jp l0162h		;02ef	c3 62 01 	. b . 
	call sub_0980h		;02f2	cd 80 09 	. . . 
sub_02f5h:
	ld hl,00080h		;02f5	21 80 00 	! . . 
	ld (l0112h),hl		;02f8	22 12 01 	" . . 
	ld hl,(l0112h)		;02fb	2a 12 01 	* . . 
	ld (hl),050h		;02fe	36 50 	6 P 
	call sub_04f8h		;0300	cd f8 04 	. . . 
	ld hl,(l0112h)		;0303	2a 12 01 	* . . 
	inc hl			;0306	23 	# 
	ld l,(hl)			;0307	6e 	n 
	ld h,000h		;0308	26 00 	& . 
	ld a,h			;030a	7c 	| 
	or l			;030b	b5 	. 
	jp nz,l0318h		;030c	c2 18 03 	. . . 
	ld hl,00000h		;030f	21 00 00 	! . . 
	ld (l010ah),hl		;0312	22 0a 01 	" . . 
	jp l0323h		;0315	c3 23 03 	. # . 
l0318h:
	ld hl,(l0112h)		;0318	2a 12 01 	* . . 
	inc hl			;031b	23 	# 
	inc hl			;031c	23 	# 
	ld l,(hl)			;031d	6e 	n 
	ld h,000h		;031e	26 00 	& . 
	ld (l010ah),hl		;0320	22 0a 01 	" . . 
l0323h:
	ld hl,(l010ah)		;0323	2a 0a 01 	* . . 
	ld de,0ff9fh		;0326	11 9f ff 	. . . 
	ld a,h			;0329	7c 	| 
	rla			;032a	17 	. 
	jp c,l0330h		;032b	da 30 03 	. 0 . 
	add hl,de			;032e	19 	. 
	add hl,hl			;032f	29 	) 
l0330h:
	ccf			;0330	3f 	? 
	sbc a,a			;0331	9f 	. 
	ld h,a			;0332	67 	g 
	ld l,a			;0333	6f 	o 
	push hl			;0334	e5 	. 
	ld hl,(l010ah)		;0335	2a 0a 01 	* . . 
	ld de,0ff85h		;0338	11 85 ff 	. . . 
	ld a,h			;033b	7c 	| 
	rla			;033c	17 	. 
	jp c,l0342h		;033d	da 42 03 	. B . 
	add hl,de			;0340	19 	. 
	add hl,hl			;0341	29 	) 
l0342h:
	sbc a,a			;0342	9f 	. 
	ld h,a			;0343	67 	g 
	ld l,a			;0344	6f 	o 
	pop de			;0345	d1 	. 
	ld a,h			;0346	7c 	| 
	and d			;0347	a2 	. 
	ld h,a			;0348	67 	g 
	ld a,l			;0349	7d 	} 
	and e			;034a	a3 	. 
	ld l,a			;034b	6f 	o 
	ld a,h			;034c	7c 	| 
	or l			;034d	b5 	. 
	jp z,l035bh		;034e	ca 5b 03 	. [ . 
	ld de,0ffe0h		;0351	11 e0 ff 	. . . 
	ld hl,(l010ah)		;0354	2a 0a 01 	* . . 
	add hl,de			;0357	19 	. 
	ld (l010ah),hl		;0358	22 0a 01 	" . . 
l035bh:
	ret			;035b	c9 	. 
	call sub_0980h		;035c	cd 80 09 	. . . 
l035fh:
	ld (l0362h),hl		;035f	22 62 03 	" b . 
l0362h:
	ld b,h			;0362	44 	D 
	ld l,a			;0363	6f 	o 
	jr nz,$+112		;0364	20 6e 	  n 
	ld l,a			;0366	6f 	o 
	ld (hl),h			;0367	74 	t 
	jr nz,$+119		;0368	20 75 	  u 
	ld (hl),e			;036a	73 	s 
	ld h,l			;036b	65 	e 
	jr nz,l03d2h		;036c	20 64 	  d 
	ld l,c			;036e	69 	i 
	ld (hl),e			;036f	73 	s 
	ld l,e			;0370	6b 	k 
	ld h,l			;0371	65 	e 
	ld (hl),h			;0372	74 	t 
	ld (hl),h			;0373	74 	t 
	ld h,l			;0374	65 	e 
	jr nz,$+47		;0375	20 2d 	  - 
	jr nz,l03edh		;0377	20 74 	  t 
	ld (hl),d			;0379	72 	r 
	ld a,c			;037a	79 	y 
	jr nz,l03deh		;037b	20 61 	  a 
	ld h,a			;037d	67 	g 
	ld h,c			;037e	61 	a 
	ld l,c			;037f	69 	i 
	ld l,(hl)			;0380	6e 	n 
	ld l,02eh		;0381	2e 2e 	. . 
	ld l,00fh		;0383	2e 0f 	. . 
	add a,a			;0385	87 	. 
	inc bc			;0386	03 	. 
	ld b,(hl)			;0387	46 	F 
	ld l,a			;0388	6f 	o 
	ld (hl),d			;0389	72 	r 
	ld l,l			;038a	6d 	m 
	ld h,c			;038b	61 	a 
	ld (hl),h			;038c	74 	t 
	jr nz,l03f2h		;038d	20 63 	  c 
	ld l,a			;038f	6f 	o 
	ld l,l			;0390	6d 	m 
	ld (hl),b			;0391	70 	p 
	ld l,h			;0392	6c 	l 
	ld h,l			;0393	65 	e 
	ld (hl),h			;0394	74 	t 
	ld h,l			;0395	65 	e 
l0396h:
	dec c			;0396	0d 	. 
	sbc a,c			;0397	99 	. 
	inc bc			;0398	03 	. 
	ld b,(hl)			;0399	46 	F 
	ld l,a			;039a	6f 	o 
	ld (hl),d			;039b	72 	r 
	ld l,l			;039c	6d 	m 
	ld h,c			;039d	61 	a 
	ld (hl),h			;039e	74 	t 
	ld (hl),h			;039f	74 	t 
	ld l,c			;03a0	69 	i 
	ld l,(hl)			;03a1	6e 	n 
	ld h,a			;03a2	67 	g 
	ld l,02eh		;03a3	2e 2e 	. . 
	ld l,028h		;03a5	2e 28 	. ( 
	xor c			;03a7	a9 	. 
	inc bc			;03a8	03 	. 
	ld d,b			;03a9	50 	P 
	ld (hl),d			;03aa	72 	r 
	ld h,l			;03ab	65 	e 
	ld (hl),e			;03ac	73 	s 
	ld (hl),e			;03ad	73 	s 
	jr nz,l0402h		;03ae	20 52 	  R 
	ld b,l			;03b0	45 	E 
	ld d,h			;03b1	54 	T 
	ld d,l			;03b2	55 	U 
	ld d,d			;03b3	52 	R 
	ld c,(hl)			;03b4	4e 	N 
	jr nz,l042bh		;03b5	20 74 	  t 
	ld l,a			;03b7	6f 	o 
	jr nz,l041dh		;03b8	20 63 	  c 
	ld l,a			;03ba	6f 	o 
	ld l,(hl)			;03bb	6e 	n 
	ld (hl),h			;03bc	74 	t 
	ld l,c			;03bd	69 	i 
	ld l,(hl)			;03be	6e 	n 
	ld (hl),l			;03bf	75 	u 
	ld h,l			;03c0	65 	e 
	inc l			;03c1	2c 	, 
	jr nz,l0422h		;03c2	20 5e 	  ^ 
	ld b,e			;03c4	43 	C 
	jr nz,l043bh		;03c5	20 74 	  t 
	ld l,a			;03c7	6f 	o 
	jr nz,l042bh		;03c8	20 61 	  a 
	ld h,d			;03ca	62 	b 
	ld l,a			;03cb	6f 	o 
	ld (hl),d			;03cc	72 	r 
	ld (hl),h			;03cd	74 	t 
	jr nz,l040ah		;03ce	20 3a 	  : 
	jr nz,l03e6h		;03d0	20 14 	  . 
l03d2h:
	call nc,03a03h		;03d2	d4 03 3a 	. . : 
	jr nz,l0440h		;03d5	20 69 	  i 
	ld (hl),e			;03d7	73 	s 
	jr nz,l044eh		;03d8	20 74 	  t 
	ld l,a			;03da	6f 	o 
	jr nz,l043fh		;03db	20 62 	  b 
	ld h,l			;03dd	65 	e 
l03deh:
	jr nz,$+104		;03de	20 66 	  f 
	ld l,a			;03e0	6f 	o 
	ld (hl),d			;03e1	72 	r 
	ld l,l			;03e2	6d 	m 
	ld h,c			;03e3	61 	a 
	ld (hl),h			;03e4	74 	t 
	ld (hl),h			;03e5	74 	t 
l03e6h:
	ld h,l			;03e6	65 	e 
	ld h,h			;03e7	64 	d 
l03e8h:
	ld c,0ebh		;03e8	0e eb 	. . 
	inc bc			;03ea	03 	. 
	ld b,h			;03eb	44 	D 
	ld l,c			;03ec	69 	i 
l03edh:
	ld (hl),e			;03ed	73 	s 
	ld l,e			;03ee	6b 	k 
	jr nz,l0460h		;03ef	20 6f 	  o 
	ld l,(hl)			;03f1	6e 	n 
l03f2h:
	jr nz,$+102		;03f2	20 64 	  d 
	ld (hl),d			;03f4	72 	r 
	ld l,c			;03f5	69 	i 
	halt			;03f6	76 	v 
	ld h,l			;03f7	65 	e 
	jr nz,l040eh		;03f8	20 14 	  . 
	call m,04603h		;03fa	fc 03 46 	. . F 
	ld l,a			;03fd	6f 	o 
	ld (hl),d			;03fe	72 	r 
	ld l,l			;03ff	6d 	m 
	ld h,c			;0400	61 	a 
	ld (hl),h			;0401	74 	t 
l0402h:
	ld (hl),h			;0402	74 	t 
	ld l,c			;0403	69 	i 
	ld l,(hl)			;0404	6e 	n 
	ld h,a			;0405	67 	g 
	jr nz,l0470h		;0406	20 68 	  h 
	ld h,c			;0408	61 	a 
	ld (hl),d			;0409	72 	r 
l040ah:
	ld h,h			;040a	64 	d 
	jr nz,l0471h		;040b	20 64 	  d 
	ld l,c			;040d	69 	i 
l040eh:
	ld (hl),e			;040e	73 	s 
	ld l,e			;040f	6b 	k 
l0410h:
	djnz $+21		;0410	10 13 	. . 
	inc b			;0412	04 	. 
	ld d,b			;0413	50 	P 
	ld (hl),d			;0414	72 	r 
	ld l,a			;0415	6f 	o 
	ld h,e			;0416	63 	c 
	ld h,l			;0417	65 	e 
	ld h,l			;0418	65 	e 
	ld h,h			;0419	64 	d 
	jr nz,l0444h		;041a	20 28 	  ( 
	ld e,c			;041c	59 	Y 
l041dh:
	cpl			;041d	2f 	/ 
	ld c,(hl)			;041e	4e 	N 
	add hl,hl			;041f	29 	) 
	jr nz,l0461h		;0420	20 3f 	  ? 
l0422h:
	jr nz,l0434h		;0422	20 10 	  . 
	ld h,004h		;0424	26 04 	& . 
	ld a,(07720h)		;0426	3a 20 77 	:   w 
	ld l,c			;0429	69 	i 
	ld l,h			;042a	6c 	l 
l042bh:
	ld l,h			;042b	6c 	l 
	jr nz,l0490h		;042c	20 62 	  b 
	ld h,l			;042e	65 	e 
	jr nz,l0496h		;042f	20 65 	  e 
	ld (hl),d			;0431	72 	r 
	ld h,c			;0432	61 	a 
	ld (hl),e			;0433	73 	s 
l0434h:
	ld h,l			;0434	65 	e 
	ld h,h			;0435	64 	d 
l0436h:
	ld (de),a			;0436	12 	. 
	add hl,sp			;0437	39 	9 
	inc b			;0438	04 	. 
	ld b,h			;0439	44 	D 
	ld h,c			;043a	61 	a 
l043bh:
	ld (hl),h			;043b	74 	t 
	ld h,c			;043c	61 	a 
	jr nz,$+113		;043d	20 6f 	  o 
l043fh:
	ld l,(hl)			;043f	6e 	n 
l0440h:
	jr nz,l04aah		;0440	20 68 	  h 
	ld h,c			;0442	61 	a 
	ld (hl),d			;0443	72 	r 
l0444h:
	ld h,h			;0444	64 	d 
	jr nz,$+102		;0445	20 64 	  d 
	ld l,c			;0447	69 	i 
	ld (hl),e			;0448	73 	s 
	ld l,e			;0449	6b 	k 
	jr nz,l045fh		;044a	20 13 	  . 
	ld c,(hl)			;044c	4e 	N 
	inc b			;044d	04 	. 
l044eh:
	ld b,h			;044e	44 	D 
	ld (hl),d			;044f	72 	r 
	ld l,c			;0450	69 	i 
	halt			;0451	76 	v 
	ld h,l			;0452	65 	e 
	jr nz,l04c3h		;0453	20 6e 	  n 
	ld l,a			;0455	6f 	o 
	ld (hl),h			;0456	74 	t 
	jr nz,l04c2h		;0457	20 69 	  i 
	ld l,(hl)			;0459	6e 	n 
	jr nz,$+117		;045a	20 73 	  s 
	ld a,c			;045c	79 	y 
	ld (hl),e			;045d	73 	s 
	ld (hl),h			;045e	74 	t 
l045fh:
	ld h,l			;045f	65 	e 
l0460h:
	ld l,l			;0460	6d 	m 
l0461h:
	dec d			;0461	15 	. 
	ld h,h			;0462	64 	d 
	inc b			;0463	04 	. 
	ld b,h			;0464	44 	D 
	ld (hl),d			;0465	72 	r 
	ld l,c			;0466	69 	i 
	halt			;0467	76 	v 
	ld h,l			;0468	65 	e 
	jr nz,$+102		;0469	20 64 	  d 
	ld l,a			;046b	6f 	o 
	ld h,l			;046c	65 	e 
	ld (hl),e			;046d	73 	s 
	ld l,(hl)			;046e	6e 	n 
	daa			;046f	27 	' 
l0470h:
	ld (hl),h			;0470	74 	t 
l0471h:
	jr nz,$+103		;0471	20 65 	  e 
	ld a,b			;0473	78 	x 
	ld l,c			;0474	69 	i 
	ld (hl),e			;0475	73 	s 
	ld (hl),h			;0476	74 	t 
	jr nz,$+35		;0477	20 21 	  ! 
l0479h:
	jr nz,l04f7h		;0479	20 7c 	  | 
	inc b			;047b	04 	. 
	jr z,l04bfh		;047c	28 41 	( A 
	jr nz,l04f4h		;047e	20 74 	  t 
	ld l,a			;0480	6f 	o 
	jr nz,$+82		;0481	20 50 	  P 
	inc l			;0483	2c 	, 
	jr nz,l04f5h		;0484	20 6f 	  o 
	ld (hl),d			;0486	72 	r 
	jr nz,l04dbh		;0487	20 52 	  R 
	ld b,l			;0489	45 	E 
	ld d,h			;048a	54 	T 
	ld d,l			;048b	55 	U 
	ld d,d			;048c	52 	R 
	ld c,(hl)			;048d	4e 	N 
	jr nz,$+118		;048e	20 74 	  t 
l0490h:
	ld l,a			;0490	6f 	o 
	jr nz,$+116		;0491	20 72 	  r 
	ld h,l			;0493	65 	e 
	ld h,d			;0494	62 	b 
	ld l,a			;0495	6f 	o 
l0496h:
	ld l,a			;0496	6f 	o 
	ld (hl),h			;0497	74 	t 
	add hl,hl			;0498	29 	) 
	jr nz,$+65		;0499	20 3f 	  ? 
	jr nz,l04b7h		;049b	20 1a 	  . 
	sbc a,a			;049d	9f 	. 
	inc b			;049e	04 	. 
	ld b,(hl)			;049f	46 	F 
	ld l,a			;04a0	6f 	o 
	ld (hl),d			;04a1	72 	r 
	ld l,l			;04a2	6d 	m 
	ld h,c			;04a3	61 	a 
	ld (hl),h			;04a4	74 	t 
	jr nz,l050bh		;04a5	20 64 	  d 
	ld l,c			;04a7	69 	i 
	ld (hl),e			;04a8	73 	s 
	ld l,e			;04a9	6b 	k 
l04aah:
	jr nz,l051bh		;04aa	20 6f 	  o 
	ld l,(hl)			;04ac	6e 	n 
	jr nz,$+121		;04ad	20 77 	  w 
	ld l,b			;04af	68 	h 
	ld l,c			;04b0	69 	i 
	ld h,e			;04b1	63 	c 
	ld l,b			;04b2	68 	h 
	jr nz,$+102		;04b3	20 64 	  d 
	ld (hl),d			;04b5	72 	r 
	ld l,c			;04b6	69 	i 
l04b7h:
	halt			;04b7	76 	v 
	ld h,l			;04b8	65 	e 
l04b9h:
	inc c			;04b9	0c 	. 
	cp h			;04ba	bc 	. 
	inc b			;04bb	04 	. 
	dec a			;04bc	3d 	= 
	dec a			;04bd	3d 	= 
	dec a			;04be	3d 	= 
l04bfh:
	jr nz,$+63		;04bf	20 3d 	  = 
	dec a			;04c1	3d 	= 
l04c2h:
	dec a			;04c2	3d 	= 
l04c3h:
	jr nz,$+63		;04c3	20 3d 	  = 
	dec a			;04c5	3d 	= 
	dec a			;04c6	3d 	= 
	dec a			;04c7	3d 	= 
l04c8h:
	dec c			;04c8	0d 	. 
	rlc h		;04c9	cb 04 	. . 
	ld b,(hl)			;04cb	46 	F 
	ld l,a			;04cc	6f 	o 
	ld (hl),d			;04cd	72 	r 
	jr nz,$+82		;04ce	20 50 	  P 
	ld b,l			;04d0	45 	E 
	ld d,h			;04d1	54 	T 
	jr nz,l0517h		;04d2	20 43 	  C 
	ld d,b			;04d4	50 	P 
	cpl			;04d5	2f 	/ 
	ld c,l			;04d6	4d 	M 
	jr nz,l04f0h		;04d7	20 17 	  . 
	in a,(004h)		;04d9	db 04 	. . 
l04dbh:
	ld b,h			;04db	44 	D 
	ld l,c			;04dc	69 	i 
	ld (hl),e			;04dd	73 	s 
	ld l,e			;04de	6b 	k 
	jr nz,$+104		;04df	20 66 	  f 
	ld l,a			;04e1	6f 	o 
	ld (hl),d			;04e2	72 	r 
	ld l,l			;04e3	6d 	m 
	ld h,c			;04e4	61 	a 
	ld (hl),h			;04e5	74 	t 
	ld (hl),h			;04e6	74 	t 
	ld l,c			;04e7	69 	i 
	ld l,(hl)			;04e8	6e 	n 
	ld h,a			;04e9	67 	g 
	jr nz,$+114		;04ea	20 70 	  p 
	ld (hl),d			;04ec	72 	r 
	ld l,a			;04ed	6f 	o 
	ld h,a			;04ee	67 	g 
	ld (hl),d			;04ef	72 	r 
l04f0h:
	ld h,c			;04f0	61 	a 
	ld l,l			;04f1	6d 	m 
l04f2h:
	nop			;04f2	00 	. 
	push af			;04f3	f5 	. 
l04f4h:
	inc b			;04f4	04 	. 
l04f5h:
	nop			;04f5	00 	. 
	nop			;04f6	00 	. 
l04f7h:
	nop			;04f7	00 	. 
sub_04f8h:
	ld c,00ah		;04f8	0e 0a 	. . 
	ld de,00080h		;04fa	11 80 00 	. . . 
	jp 00005h		;04fd	c3 05 00 	. . . 
	ld bc,01c00h		;0500	01 00 1c 	. . . 
	ld hl,04000h		;0503	21 00 40 	! . @ 
	ld de,0d400h		;0506	11 00 d4 	. . . 
	ldir		;0509	ed b0 	. . 
l050bh:
	jp 0f075h		;050b	c3 75 f0 	. u . 
	ld a,(hl)			;050e	7e 	~ 
	ld (l083ch),a		;050f	32 3c 08 	2 < . 
	call 0f054h		;0512	cd 54 f0 	. T . 
	ld e,000h		;0515	1e 00 	. . 
l0517h:
	push de			;0517	d5 	. 
	call sub_0635h		;0518	cd 35 06 	. 5 . 
l051bh:
	ld a,(l083ch)		;051b	3a 3c 08 	: < . 
	call 0f05ah		;051e	cd 5a f0 	. Z . 
	ld (l083dh),a		;0521	32 3d 08 	2 = . 
	ld hl,04000h		;0524	21 00 40 	! . @ 
	ld bc,01c00h		;0527	01 00 1c 	. . . 
	pop de			;052a	d1 	. 
	or a			;052b	b7 	. 
	ret nz			;052c	c0 	. 
	push de			;052d	d5 	. 
	call 0f039h		;052e	cd 39 f0 	. 9 . 
l0531h:
	call 0f03fh		;0531	cd 3f f0 	. ? . 
	ld (hl),a			;0534	77 	w 
	inc hl			;0535	23 	# 
	dec bc			;0536	0b 	. 
	ld a,b			;0537	78 	x 
	or c			;0538	b1 	. 
	jr nz,l0531h		;0539	20 f6 	  . 
	call 0f03ch		;053b	cd 3c f0 	. < . 
	pop de			;053e	d1 	. 
	push de			;053f	d5 	. 
	call 0f060h		;0540	cd 60 f0 	. ` . 
	pop de			;0543	d1 	. 
	push de			;0544	d5 	. 
	call sub_0647h		;0545	cd 47 06 	. G . 
	ld a,(l083ch)		;0548	3a 3c 08 	: < . 
	call 0f05ah		;054b	cd 5a f0 	. Z . 
	ld (l083dh),a		;054e	32 3d 08 	2 = . 
	ld hl,06000h		;0551	21 00 60 	! . ` 
	ld bc,l0800h		;0554	01 00 08 	. . . 
	pop de			;0557	d1 	. 
	or a			;0558	b7 	. 
	ret nz			;0559	c0 	. 
	push de			;055a	d5 	. 
	call 0f039h		;055b	cd 39 f0 	. 9 . 
l055eh:
	call 0f03fh		;055e	cd 3f f0 	. ? . 
	ld (hl),a			;0561	77 	w 
	inc hl			;0562	23 	# 
	dec bc			;0563	0b 	. 
	ld a,b			;0564	78 	x 
	or c			;0565	b1 	. 
	jr nz,l055eh		;0566	20 f6 	  . 
	call 0f03ch		;0568	cd 3c f0 	. < . 
	pop de			;056b	d1 	. 
	call 0f060h		;056c	cd 60 f0 	. ` . 
	ld a,(l083ch)		;056f	3a 3c 08 	: < . 
	call 0f05ah		;0572	cd 5a f0 	. Z . 
	ld (l083dh),a		;0575	32 3d 08 	2 = . 
	ret			;0578	c9 	. 
	ld c,(hl)			;0579	4e 	N 
	call 0f01bh		;057a	cd 1b f0 	. . . 
	ld de,04000h		;057d	11 00 40 	. . @ 
	ld bc,00000h		;0580	01 00 00 	. . . 
l0583h:
	call 0f01eh		;0583	cd 1e f0 	. . . 
	push bc			;0586	c5 	. 
	ld bc,00000h		;0587	01 00 00 	. . . 
l058ah:
	call 0f021h		;058a	cd 21 f0 	. ! . 
	push bc			;058d	c5 	. 
	push de			;058e	d5 	. 
	call 0f027h		;058f	cd 27 f0 	. ' . 
	or a			;0592	b7 	. 
	jr nz,l05e1h		;0593	20 4c 	  L 
	pop de			;0595	d1 	. 
	ld bc,00080h		;0596	01 80 00 	. . . 
	ld hl,00080h		;0599	21 80 00 	! . . 
	ldir		;059c	ed b0 	. . 
	pop bc			;059e	c1 	. 
	inc c			;059f	0c 	. 
	ld a,c			;05a0	79 	y 
	cp 040h		;05a1	fe 40 	. @ 
	jr nz,l058ah		;05a3	20 e5 	  . 
	pop bc			;05a5	c1 	. 
	inc c			;05a6	0c 	. 
	ld a,c			;05a7	79 	y 
	cp 002h		;05a8	fe 02 	. . 
	jr nz,l0583h		;05aa	20 d7 	  . 
	ret			;05ac	c9 	. 
	ld c,(hl)			;05ad	4e 	N 
	call 0f01bh		;05ae	cd 1b f0 	. . . 
	ld hl,04000h		;05b1	21 00 40 	! . @ 
	ld bc,00000h		;05b4	01 00 00 	. . . 
l05b7h:
	call 0f01eh		;05b7	cd 1e f0 	. . . 
	push bc			;05ba	c5 	. 
	ld bc,00000h		;05bb	01 00 00 	. . . 
l05beh:
	call 0f021h		;05be	cd 21 f0 	. ! . 
	push bc			;05c1	c5 	. 
	ld bc,00080h		;05c2	01 80 00 	. . . 
	ld de,00080h		;05c5	11 80 00 	. . . 
	ldir		;05c8	ed b0 	. . 
	push hl			;05ca	e5 	. 
	call 0f02ah		;05cb	cd 2a f0 	. * . 
	or a			;05ce	b7 	. 
	jr nz,l05e1h		;05cf	20 10 	  . 
	pop hl			;05d1	e1 	. 
	pop bc			;05d2	c1 	. 
	inc c			;05d3	0c 	. 
	ld a,c			;05d4	79 	y 
	cp 040h		;05d5	fe 40 	. @ 
	jr nz,l05beh		;05d7	20 e5 	  . 
	pop bc			;05d9	c1 	. 
	inc c			;05da	0c 	. 
	ld a,c			;05db	79 	y 
	cp 002h		;05dc	fe 02 	. . 
	jr nz,l05b7h		;05de	20 d7 	  . 
	ret			;05e0	c9 	. 
l05e1h:
	pop hl			;05e1	e1 	. 
	pop hl			;05e2	e1 	. 
	pop hl			;05e3	e1 	. 
	jp l07d1h		;05e4	c3 d1 07 	. . . 
sub_05e7h:
	ld a,(hl)			;05e7	7e 	~ 
	call 0f051h		;05e8	cd 51 f0 	. Q . 
	ld (hl),c			;05eb	71 	q 
	inc hl			;05ec	23 	# 
	ld (hl),000h		;05ed	36 00 	6 . 
	ret			;05ef	c9 	. 
	ld a,(hl)			;05f0	7e 	~ 
	jp 0f078h		;05f1	c3 78 f0 	. x . 
sub_05f4h:
	ld a,(l083dh)		;05f4	3a 3d 08 	: = . 
	ld (hl),a			;05f7	77 	w 
	inc hl			;05f8	23 	# 
	xor a			;05f9	af 	. 
	ld (hl),a			;05fa	77 	w 
	ld a,(l083dh)		;05fb	3a 3d 08 	: = . 
	or a			;05fe	b7 	. 
	ret z			;05ff	c8 	. 
	ld de,l0622h		;0600	11 22 06 	. " . 
	ld c,009h		;0603	0e 09 	. . 
	call 00005h		;0605	cd 05 00 	. . . 
	ld hl,0eac0h		;0608	21 c0 ea 	! . . 
l060bh:
	ld e,(hl)			;060b	5e 	^ 
	push hl			;060c	e5 	. 
	ld c,002h		;060d	0e 02 	. . 
	call 00005h		;060f	cd 05 00 	. . . 
	pop hl			;0612	e1 	. 
	inc hl			;0613	23 	# 
	ld a,(hl)			;0614	7e 	~ 
	cp 00dh		;0615	fe 0d 	. . 
	jr nz,l060bh		;0617	20 f2 	  . 
	ld de,l0632h		;0619	11 32 06 	. 2 . 
	ld c,009h		;061c	0e 09 	. . 
	call 00005h		;061e	cd 05 00 	. . . 
	ret			;0621	c9 	. 
l0622h:
	dec c			;0622	0d 	. 
	ld a,(bc)			;0623	0a 	. 
	ld b,h			;0624	44 	D 
	ld l,c			;0625	69 	i 
	ld (hl),e			;0626	73 	s 
	ld l,e			;0627	6b 	k 
	jr nz,$+103		;0628	20 65 	  e 
	ld (hl),d			;062a	72 	r 
	ld (hl),d			;062b	72 	r 
	ld l,a			;062c	6f 	o 
	ld (hl),d			;062d	72 	r 
	jr nz,l066ah		;062e	20 3a 	  : 
	jr nz,l0656h		;0630	20 24 	  $ 
l0632h:
	dec c			;0632	0d 	. 
	ld a,(bc)			;0633	0a 	. 
	inc h			;0634	24 	$ 
sub_0635h:
	ld c,006h		;0635	0e 06 	. . 
	ld hl,l082ah		;0637	21 2a 08 	! * . 
	ld a,(l083ch)		;063a	3a 3c 08 	: < . 
	rra			;063d	1f 	. 
	jp nc,0f05dh		;063e	d2 5d f0 	. ] . 
	ld hl,l0830h		;0641	21 30 08 	! 0 . 
	jp 0f05dh		;0644	c3 5d f0 	. ] . 
sub_0647h:
	ld c,003h		;0647	0e 03 	. . 
	ld hl,l0836h		;0649	21 36 08 	! 6 . 
	ld a,(l083ch)		;064c	3a 3c 08 	: < . 
	rra			;064f	1f 	. 
	jp nc,0f05dh		;0650	d2 5d f0 	. ] . 
	ld hl,l0839h		;0653	21 39 08 	! 9 . 
l0656h:
	jp 0f05dh		;0656	c3 5d f0 	. ] . 
	ld a,(hl)			;0659	7e 	~ 
	ld (l083ch),a		;065a	32 3c 08 	2 < . 
	call 0f054h		;065d	cd 54 f0 	. T . 
	push de			;0660	d5 	. 
	ld e,00fh		;0661	1e 0f 	. . 
	ld hl,l0821h+1		;0663	21 22 08 	! " . 
	ld a,(l083ch)		;0666	3a 3c 08 	: < . 
	rra			;0669	1f 	. 
l066ah:
	jr nc,l066fh		;066a	30 03 	0 . 
	ld hl,00826h		;066c	21 26 08 	! & . 
l066fh:
	ld c,004h		;066f	0e 04 	. . 
	call 0f05dh		;0671	cd 5d f0 	. ] . 
	ld a,(l083ch)		;0674	3a 3c 08 	: < . 
	call 0f05ah		;0677	cd 5a f0 	. Z . 
	ld (l083dh),a		;067a	32 3d 08 	2 = . 
	pop de			;067d	d1 	. 
	cp 001h		;067e	fe 01 	. . 
	ret nz			;0680	c0 	. 
	ld e,001h		;0681	1e 01 	. . 
	push de			;0683	d5 	. 
	call sub_0647h		;0684	cd 47 06 	. G . 
	ld a,(l083ch)		;0687	3a 3c 08 	: < . 
	call 0f05ah		;068a	cd 5a f0 	. Z . 
	ld (l083dh),a		;068d	32 3d 08 	2 = . 
	pop de			;0690	d1 	. 
	or a			;0691	b7 	. 
	ret nz			;0692	c0 	. 
	push de			;0693	d5 	. 
	call 0f033h		;0694	cd 33 f0 	. 3 . 
	ld hl,06000h		;0697	21 00 60 	! . ` 
	ld bc,l0800h		;069a	01 00 08 	. . . 
l069dh:
	ld a,(hl)			;069d	7e 	~ 
	call 0f042h		;069e	cd 42 f0 	. B . 
	inc hl			;06a1	23 	# 
	dec bc			;06a2	0b 	. 
	ld a,b			;06a3	78 	x 
	or c			;06a4	b1 	. 
	jr nz,l069dh		;06a5	20 f6 	  . 
	call 0f036h		;06a7	cd 36 f0 	. 6 . 
	pop de			;06aa	d1 	. 
	push de			;06ab	d5 	. 
	call 0f060h		;06ac	cd 60 f0 	. ` . 
	pop de			;06af	d1 	. 
	push de			;06b0	d5 	. 
	call sub_0635h		;06b1	cd 35 06 	. 5 . 
	ld a,(l083ch)		;06b4	3a 3c 08 	: < . 
	call 0f05ah		;06b7	cd 5a f0 	. Z . 
	ld (l083dh),a		;06ba	32 3d 08 	2 = . 
	pop de			;06bd	d1 	. 
	or a			;06be	b7 	. 
	ret nz			;06bf	c0 	. 
	push de			;06c0	d5 	. 
	call 0f033h		;06c1	cd 33 f0 	. 3 . 
	ld hl,04000h		;06c4	21 00 40 	! . @ 
	ld bc,01c00h		;06c7	01 00 1c 	. . . 
l06cah:
	ld a,(hl)			;06ca	7e 	~ 
	call 0f042h		;06cb	cd 42 f0 	. B . 
	inc hl			;06ce	23 	# 
	dec bc			;06cf	0b 	. 
	ld a,b			;06d0	78 	x 
	or c			;06d1	b1 	. 
	jr nz,l06cah		;06d2	20 f6 	  . 
	call 0f036h		;06d4	cd 36 f0 	. 6 . 
	pop de			;06d7	d1 	. 
	call 0f060h		;06d8	cd 60 f0 	. ` . 
	ld a,(l083ch)		;06db	3a 3c 08 	: < . 
	call 0f05ah		;06de	cd 5a f0 	. Z . 
	ld (l083dh),a		;06e1	32 3d 08 	2 = . 
	ret			;06e4	c9 	. 
sub_06e5h:
	ld a,(hl)			;06e5	7e 	~ 
	ld (l083ch),a		;06e6	32 3c 08 	2 < . 
	call 0f054h		;06e9	cd 54 f0 	. T . 
	ld a,(l083ch)		;06ec	3a 3c 08 	: < . 
	and 001h		;06ef	e6 01 	. . 
	add a,030h		;06f1	c6 30 	. 0 
	ld (l07feh),a		;06f3	32 fe 07 	2 . . 
	ld e,00fh		;06f6	1e 0f 	. . 
	ld c,014h		;06f8	0e 14 	. . 
	ld hl,007fdh		;06fa	21 fd 07 	! . . 
	call 0f05dh		;06fd	cd 5d f0 	. ] . 
	ld a,(l083ch)		;0700	3a 3c 08 	: < . 
	call 0f05ah		;0703	cd 5a f0 	. Z . 
	ld (l083dh),a		;0706	32 3d 08 	2 = . 
	or a			;0709	b7 	. 
	ret nz			;070a	c0 	. 
	ld a,(l083ch)		;070b	3a 3c 08 	: < . 
	call 0f078h		;070e	cd 78 f0 	. x . 
	ld hl,04000h		;0711	21 00 40 	! . @ 
	ld de,04001h		;0714	11 01 40 	. . @ 
	ld bc,000ffh		;0717	01 ff 00 	. . . 
	ld (hl),0e5h		;071a	36 e5 	6 . 
	ldir		;071c	ed b0 	. . 
	ld a,007h		;071e	3e 07 	> . 
	ld (l0821h),a		;0720	32 21 08 	2 ! . 
	ld a,001h		;0723	3e 01 	> . 
	ld (l0820h),a		;0725	32 20 08 	2   . 
l0728h:
	call sub_073eh		;0728	cd 3e 07 	. > . 
	ld a,(l083ch)		;072b	3a 3c 08 	: < . 
	call 0f05ah		;072e	cd 5a f0 	. Z . 
	ld (l083dh),a		;0731	32 3d 08 	2 = . 
	or a			;0734	b7 	. 
	ret nz			;0735	c0 	. 
	ld hl,l0821h		;0736	21 21 08 	! ! . 
	dec (hl)			;0739	35 	5 
	jp p,l0728h		;073a	f2 28 07 	. ( . 
	ret			;073d	c9 	. 
sub_073eh:
	ld hl,l0818h		;073e	21 18 08 	! . . 
	ld c,006h		;0741	0e 06 	. . 
	ld a,(l083ch)		;0743	3a 3c 08 	: < . 
	call 0f057h		;0746	cd 57 f0 	. W . 
	call 0f04bh		;0749	cd 4b f0 	. K . 
	ld a,(04000h)		;074c	3a 00 40 	: . @ 
	call 0f045h		;074f	cd 45 f0 	. E . 
	call 0f036h		;0752	cd 36 f0 	. 6 . 
	ld hl,l0811h		;0755	21 11 08 	! . . 
	ld c,007h		;0758	0e 07 	. . 
	ld a,(l083ch)		;075a	3a 3c 08 	: < . 
	call 0f057h		;075d	cd 57 f0 	. W . 
	call 0f04bh		;0760	cd 4b f0 	. K . 
	call 0f048h		;0763	cd 48 f0 	. H . 
	call 0f036h		;0766	cd 36 f0 	. 6 . 
	ld a,(l083ch)		;0769	3a 3c 08 	: < . 
	call 0f054h		;076c	cd 54 f0 	. T . 
	ld e,002h		;076f	1e 02 	. . 
	call 0f033h		;0771	cd 33 f0 	. 3 . 
	ld hl,04001h		;0774	21 01 40 	! . @ 
	ld c,0ffh		;0777	0e ff 	. . 
	call 0f04bh		;0779	cd 4b f0 	. K . 
	call 0f036h		;077c	cd 36 f0 	. 6 . 
	ld a,(l083ch)		;077f	3a 3c 08 	: < . 
	call 0f057h		;0782	cd 57 f0 	. W . 
	ld hl,l07f8h		;0785	21 f8 07 	! . . 
	ld c,005h		;0788	0e 05 	. . 
	call 0f04bh		;078a	cd 4b f0 	. K . 
	ld a,(l083ch)		;078d	3a 3c 08 	: < . 
	and 001h		;0790	e6 01 	. . 
	add a,030h		;0792	c6 30 	. 0 
	call 0f042h		;0794	cd 42 f0 	. B . 
	ld a,(l0820h)		;0797	3a 20 08 	:   . 
	call 0f04eh		;079a	cd 4e f0 	. N . 
	ld a,(l0821h)		;079d	3a 21 08 	: ! . 
	call 0f04eh		;07a0	cd 4e f0 	. N . 
	call 0f048h		;07a3	cd 48 f0 	. H . 
	jp 0f036h		;07a6	c3 36 f0 	. 6 . 
sub_07a9h:
	ld c,(hl)			;07a9	4e 	N 
	call 0f01bh		;07aa	cd 1b f0 	. . . 
	ld hl,00080h		;07ad	21 80 00 	! . . 
l07b0h:
	ld (hl),0e5h		;07b0	36 e5 	6 . 
	inc l			;07b2	2c 	, 
	jr nz,l07b0h		;07b3	20 fb 	  . 
	ld bc,00002h		;07b5	01 02 00 	. . . 
	call 0f01eh		;07b8	cd 1e f0 	. . . 
	ld bc,00000h		;07bb	01 00 00 	. . . 
l07beh:
	push bc			;07be	c5 	. 
	call 0f021h		;07bf	cd 21 f0 	. ! . 
	call 0f02ah		;07c2	cd 2a f0 	. * . 
	pop bc			;07c5	c1 	. 
	or a			;07c6	b7 	. 
	jp nz,l07d1h		;07c7	c2 d1 07 	. . . 
	inc bc			;07ca	03 	. 
	ld a,c			;07cb	79 	y 
	cp 040h		;07cc	fe 40 	. @ 
	jr nz,l07beh		;07ce	20 ee 	  . 
	ret			;07d0	c9 	. 
l07d1h:
	ld de,l07deh		;07d1	11 de 07 	. . . 
	ld c,009h		;07d4	0e 09 	. . 
	call 00005h		;07d6	cd 05 00 	. . . 
	ld c,001h		;07d9	0e 01 	. . 
	jp 00005h		;07db	c3 05 00 	. . . 
l07deh:
	dec c			;07de	0d 	. 
	ld a,(bc)			;07df	0a 	. 
	ld c,b			;07e0	48 	H 
	ld l,c			;07e1	69 	i 
	ld (hl),h			;07e2	74 	t 
	jr nz,$+99		;07e3	20 61 	  a 
	ld l,(hl)			;07e5	6e 	n 
	ld a,c			;07e6	79 	y 
	jr nz,l0854h		;07e7	20 6b 	  k 
	ld h,l			;07e9	65 	e 
	ld a,c			;07ea	79 	y 
	jr nz,l0861h		;07eb	20 74 	  t 
	ld l,a			;07ed	6f 	o 
	jr nz,$+99		;07ee	20 61 	  a 
	ld h,d			;07f0	62 	b 
	ld l,a			;07f1	6f 	o 
	ld (hl),d			;07f2	72 	r 
	ld (hl),h			;07f3	74 	t 
	jr nz,l0830h		;07f4	20 3a 	  : 
	jr nz,l081ch		;07f6	20 24 	  $ 
l07f8h:
	ld d,l			;07f8	55 	U 
	ld (03220h),a		;07f9	32 20 32 	2   2 
	jr nz,$+80		;07fc	20 4e 	  N 
l07feh:
	jr nc,$+60		;07fe	30 3a 	0 : 
l0800h:
	ld b,e			;0800	43 	C 
	ld d,b			;0801	50 	P 
	cpl			;0802	2f 	/ 
	ld c,l			;0803	4d 	M 
	jr nz,$+88		;0804	20 56 	  V 
	ld (0322eh),a		;0806	32 2e 32 	2 . 2 
	jr nz,$+70		;0809	20 44 	  D 
	ld c,c			;080b	49 	I 
	ld d,e			;080c	53 	S 
	ld c,e			;080d	4b 	K 
	inc l			;080e	2c 	, 
	ld e,b			;080f	58 	X 
	ld e,b			;0810	58 	X 
l0811h:
	ld b,d			;0811	42 	B 
	dec l			;0812	2d 	- 
	ld d,b			;0813	50 	P 
	jr nz,l0848h		;0814	20 32 	  2 
	jr nz,l0849h		;0816	20 31 	  1 
l0818h:
	ld c,l			;0818	4d 	M 
	dec l			;0819	2d 	- 
	ld d,a			;081a	57 	W 
	nop			;081b	00 	. 
l081ch:
	inc de			;081c	13 	. 
	ld bc,03223h		;081d	01 23 32 	. # 2 
l0820h:
	ret			;0820	c9 	. 
l0821h:
	call 03053h		;0821	cd 53 30 	. S 0 
	ld a,(0532ah)		;0824	3a 2a 53 	: * S 
	ld sp,02a3ah		;0827	31 3a 2a 	1 : * 
l082ah:
	jr nc,$+60		;082a	30 3a 	0 : 
	ld b,e			;082c	43 	C 
	ld d,b			;082d	50 	P 
	cpl			;082e	2f 	/ 
	ld c,l			;082f	4d 	M 
l0830h:
	ld sp,0433ah		;0830	31 3a 43 	1 : C 
	ld d,b			;0833	50 	P 
	cpl			;0834	2f 	/ 
	ld c,l			;0835	4d 	M 
l0836h:
	jr nc,$+60		;0836	30 3a 	0 : 
	ld c,e			;0838	4b 	K 
l0839h:
	ld sp,04b3ah		;0839	31 3a 4b 	1 : K 
l083ch:
	pop hl			;083c	e1 	. 
l083dh:
	pop de			;083d	d1 	. 
l083eh:
	inc hl			;083e	23 	# 
	ld a,(hl)			;083f	7e 	~ 
	dec hl			;0840	2b 	+ 
l0841h:
	ret nc			;0841	d0 	. 
l0842h:
	call 0203eh		;0842	cd 3e 20 	. >   
	call sub_098bh		;0845	cd 8b 09 	. . . 
l0848h:
	ret			;0848	c9 	. 
l0849h:
	ld a,00ah		;0849	3e 0a 	> . 
	call sub_098bh		;084b	cd 8b 09 	. . . 
	ld a,00dh		;084e	3e 0d 	> . 
	call sub_098bh		;0850	cd 8b 09 	. . . 
	ret			;0853	c9 	. 
l0854h:
	ld a,002h		;0854	3e 02 	> . 
	ld (l083eh),a		;0856	32 3e 08 	2 > . 
	ld a,l			;0859	7d 	} 
	call sub_086bh		;085a	cd 6b 08 	. k . 
	ld (l0841h),a		;085d	32 41 08 	2 A . 
	ld a,l			;0860	7d 	} 
l0861h:
	call sub_086fh		;0861	cd 6f 08 	. o . 
	ld (l0842h),a		;0864	32 42 08 	2 B . 
	ld hl,l083eh		;0867	21 3e 08 	! > . 
	ret			;086a	c9 	. 
sub_086bh:
	rrca			;086b	0f 	. 
	rrca			;086c	0f 	. 
	rrca			;086d	0f 	. 
	rrca			;086e	0f 	. 
sub_086fh:
	and 00fh		;086f	e6 0f 	. . 
	cp 00ah		;0871	fe 0a 	. . 
	jp m,l0878h		;0873	fa 78 08 	. x . 
	add a,007h		;0876	c6 07 	. . 
l0878h:
	add a,030h		;0878	c6 30 	. 0 
	ret			;087a	c9 	. 
sub_087bh:
	ld a,001h		;087b	3e 01 	> . 
	ld (l083eh),a		;087d	32 3e 08 	2 > . 
	ld a,l			;0880	7d 	} 
	ld (l0841h),a		;0881	32 41 08 	2 A . 
	ld hl,l083eh		;0884	21 3e 08 	! > . 
	ret			;0887	c9 	. 
sub_0888h:
	ld a,(hl)			;0888	7e 	~ 
	or a			;0889	b7 	. 
	jp z,l0849h		;088a	ca 49 08 	. I . 
	call sub_08a5h		;088d	cd a5 08 	. . . 
	jp l0849h		;0890	c3 49 08 	. I . 
sub_0893h:
	ld a,(hl)			;0893	7e 	~ 
	or a			;0894	b7 	. 
	ret z			;0895	c8 	. 
	call sub_08a5h		;0896	cd a5 08 	. . . 
	ret			;0899	c9 	. 
	ld a,(hl)			;089a	7e 	~ 
	or a			;089b	b7 	. 
	jp z,l0842h+1		;089c	ca 43 08 	. C . 
	call sub_08a5h		;089f	cd a5 08 	. . . 
	jp l0842h+1		;08a2	c3 43 08 	. C . 
sub_08a5h:
	ld b,a			;08a5	47 	G 
	inc hl			;08a6	23 	# 
	inc hl			;08a7	23 	# 
	inc hl			;08a8	23 	# 
l08a9h:
	ld a,(hl)			;08a9	7e 	~ 
	call sub_098bh		;08aa	cd 8b 09 	. . . 
	dec b			;08ad	05 	. 
	inc hl			;08ae	23 	# 
	jp nz,l08a9h		;08af	c2 a9 08 	. . . 
	ret			;08b2	c9 	. 
	ld a,(bc)			;08b3	0a 	. 
	ld c,a			;08b4	4f 	O 
	jp 00005h		;08b5	c3 05 00 	. . . 
	ex de,hl			;08b8	eb 	. 
	pop hl			;08b9	e1 	. 
	ld c,(hl)			;08ba	4e 	N 
	inc hl			;08bb	23 	# 
	ld b,(hl)			;08bc	46 	F 
	jp l08c6h		;08bd	c3 c6 08 	. . . 
	ld b,h			;08c0	44 	D 
	ld c,l			;08c1	4d 	M 
	pop hl			;08c2	e1 	. 
	ld e,(hl)			;08c3	5e 	^ 
	inc hl			;08c4	23 	# 
	ld d,(hl)			;08c5	56 	V 
l08c6h:
	inc hl			;08c6	23 	# 
	push hl			;08c7	e5 	. 
	jp l08ceh		;08c8	c3 ce 08 	. . . 
	ex de,hl			;08cb	eb 	. 
	ld b,h			;08cc	44 	D 
	ld c,l			;08cd	4d 	M 
l08ceh:
	ld a,d			;08ce	7a 	z 
	cpl			;08cf	2f 	/ 
	ld d,a			;08d0	57 	W 
	ld a,e			;08d1	7b 	{ 
	cpl			;08d2	2f 	/ 
	ld e,a			;08d3	5f 	_ 
	inc de			;08d4	13 	. 
	ld hl,00000h		;08d5	21 00 00 	! . . 
	ld a,011h		;08d8	3e 11 	> . 
l08dah:
	push hl			;08da	e5 	. 
	add hl,de			;08db	19 	. 
	jp nc,l08e0h		;08dc	d2 e0 08 	. . . 
	ex (sp),hl			;08df	e3 	. 
l08e0h:
	pop hl			;08e0	e1 	. 
	push af			;08e1	f5 	. 
	ld a,c			;08e2	79 	y 
	rla			;08e3	17 	. 
	ld c,a			;08e4	4f 	O 
	ld a,b			;08e5	78 	x 
	rla			;08e6	17 	. 
	ld b,a			;08e7	47 	G 
	ld a,l			;08e8	7d 	} 
	rla			;08e9	17 	. 
	ld l,a			;08ea	6f 	o 
	ld a,h			;08eb	7c 	| 
	rla			;08ec	17 	. 
	ld h,a			;08ed	67 	g 
	pop af			;08ee	f1 	. 
	dec a			;08ef	3d 	= 
	jp nz,l08dah		;08f0	c2 da 08 	. . . 
	ld l,c			;08f3	69 	i 
	ld h,b			;08f4	60 	` 
	ret			;08f5	c9 	. 
	ld b,h			;08f6	44 	D 
	ld c,l			;08f7	4d 	M 
	pop hl			;08f8	e1 	. 
	ld e,(hl)			;08f9	5e 	^ 
	inc hl			;08fa	23 	# 
	ld d,(hl)			;08fb	56 	V 
	inc hl			;08fc	23 	# 
	push hl			;08fd	e5 	. 
	ld l,c			;08fe	69 	i 
	ld h,b			;08ff	60 	` 
	ld a,h			;0900	7c 	| 
	or l			;0901	b5 	. 
	ret z			;0902	c8 	. 
	ex de,hl			;0903	eb 	. 
	ld a,h			;0904	7c 	| 
	or l			;0905	b5 	. 
	ret z			;0906	c8 	. 
	ld b,h			;0907	44 	D 
	ld c,l			;0908	4d 	M 
	ld hl,00000h		;0909	21 00 00 	! . . 
	ld a,010h		;090c	3e 10 	> . 
l090eh:
	add hl,hl			;090e	29 	) 
	ex de,hl			;090f	eb 	. 
	add hl,hl			;0910	29 	) 
	ex de,hl			;0911	eb 	. 
	jp nc,l0916h		;0912	d2 16 09 	. . . 
	add hl,bc			;0915	09 	. 
l0916h:
	dec a			;0916	3d 	= 
	jp nz,l090eh		;0917	c2 0e 09 	. . . 
	ret			;091a	c9 	. 
	call sub_0932h		;091b	cd 32 09 	. 2 . 
	ld a,020h		;091e	3e 20 	>   
	call sub_098bh		;0920	cd 8b 09 	. . . 
	ret			;0923	c9 	. 
	call sub_0932h		;0924	cd 32 09 	. 2 . 
	ld a,00ah		;0927	3e 0a 	> . 
	call sub_098bh		;0929	cd 8b 09 	. . . 
	ld a,00dh		;092c	3e 0d 	> . 
	call sub_098bh		;092e	cd 8b 09 	. . . 
	ret			;0931	c9 	. 
sub_0932h:
	push hl			;0932	e5 	. 
	ld a,h			;0933	7c 	| 
	and 080h		;0934	e6 80 	. . 
	jp z,l0945h		;0936	ca 45 09 	. E . 
	ld a,l			;0939	7d 	} 
	cpl			;093a	2f 	/ 
	ld l,a			;093b	6f 	o 
	ld a,h			;093c	7c 	| 
	cpl			;093d	2f 	/ 
	ld h,a			;093e	67 	g 
	inc hl			;093f	23 	# 
	ld a,02dh		;0940	3e 2d 	> - 
	call sub_098bh		;0942	cd 8b 09 	. . . 
l0945h:
	ld c,030h		;0945	0e 30 	. 0 
	ld de,02710h		;0947	11 10 27 	. . ' 
	call sub_0967h		;094a	cd 67 09 	. g . 
	ld de,l03e8h		;094d	11 e8 03 	. . . 
	call sub_0967h		;0950	cd 67 09 	. g . 
	ld de,00064h		;0953	11 64 00 	. d . 
	call sub_0967h		;0956	cd 67 09 	. g . 
	ld de,0000ah		;0959	11 0a 00 	. . . 
	call sub_0967h		;095c	cd 67 09 	. g . 
	ld de,00001h		;095f	11 01 00 	. . . 
	call sub_0967h		;0962	cd 67 09 	. g . 
	pop hl			;0965	e1 	. 
	ret			;0966	c9 	. 
sub_0967h:
	call sub_0979h		;0967	cd 79 09 	. y . 
	jp c,l0971h		;096a	da 71 09 	. q . 
	inc c			;096d	0c 	. 
	jp sub_0967h		;096e	c3 67 09 	. g . 
l0971h:
	ld a,c			;0971	79 	y 
	call sub_098bh		;0972	cd 8b 09 	. . . 
	add hl,de			;0975	19 	. 
	ld c,030h		;0976	0e 30 	. 0 
	ret			;0978	c9 	. 
sub_0979h:
	ld a,l			;0979	7d 	} 
	sub e			;097a	93 	. 
	ld l,a			;097b	6f 	o 
	ld a,h			;097c	7c 	| 
	sbc a,d			;097d	9a 	. 
	ld h,a			;097e	67 	g 
	ret			;097f	c9 	. 
sub_0980h:
	jp 00000h		;0980	c3 00 00 	. . . 
l0983h:
	jp (hl)			;0983	e9 	. 
sub_0984h:
	ret			;0984	c9 	. 
	ld hl,0fffeh		;0985	21 fe ff 	! . . 
	jp l099ah		;0988	c3 9a 09 	. . . 
sub_098bh:
	push hl			;098b	e5 	. 
	push de			;098c	d5 	. 
	push bc			;098d	c5 	. 
	push af			;098e	f5 	. 
	ld c,002h		;098f	0e 02 	. . 
	ld e,a			;0991	5f 	_ 
	call 00005h		;0992	cd 05 00 	. . . 
	pop af			;0995	f1 	. 
	pop bc			;0996	c1 	. 
	pop de			;0997	d1 	. 
	pop hl			;0998	e1 	. 
sub_0999h:
	ret			;0999	c9 	. 
l099ah:
	push de			;099a	d5 	. 
	push bc			;099b	c5 	. 
	push hl			;099c	e5 	. 
	ld c,001h		;099d	0e 01 	. . 
	call 00005h		;099f	cd 05 00 	. . . 
	pop hl			;09a2	e1 	. 
	ld (hl),a			;09a3	77 	w 
	inc hl			;09a4	23 	# 
	ld (hl),000h		;09a5	36 00 	6 . 
	pop bc			;09a7	c1 	. 
	pop de			;09a8	d1 	. 
	ret			;09a9	c9 	. 
	ld a,(hl)			;09aa	7e 	~ 
	jp sub_098bh		;09ab	c3 8b 09 	. . . 
l09aeh:
	cp 004h		;09ae	fe 04 	. . 
l09b0h:
	jp c,0d33eh		;09b0	da 3e d3 	. > . 
	ld (l09aeh),a		;09b3	32 ae 09 	2 . . 
	ld a,l			;09b6	7d 	} 
	ld (l09aeh+1),a		;09b7	32 af 09 	2 . . 
	ld a,0c9h		;09ba	3e c9 	> . 
	ld (l09b0h),a		;09bc	32 b0 09 	2 . . 
	ld a,e			;09bf	7b 	{ 
	jp l09aeh		;09c0	c3 ae 09 	. . . 
	ld a,0dbh		;09c3	3e db 	> . 
	ld (l09aeh),a		;09c5	32 ae 09 	2 . . 
	ld a,l			;09c8	7d 	} 
	ld (l09aeh+1),a		;09c9	32 af 09 	2 . . 
	ld a,0c9h		;09cc	3e c9 	> . 
l09ceh:
	ld (l09b0h),a		;09ce	32 b0 09 	2 . . 
	call l09aeh		;09d1	cd ae 09 	. . . 
l09d4h:
	ld h,000h		;09d4	26 00 	& . 
	ld l,a			;09d6	6f 	o 
	ret			;09d7	c9 	. 
	push af			;09d8	f5 	. 
	ld a,0c0h		;09d9	3e c0 	> . 
	jr nc,l09ceh		;09db	30 f1 	0 . 
	ret			;09dd	c9 	. 
	push af			;09de	f5 	. 
	ld a,040h		;09df	3e 40 	> @ 
	jr nc,l09d4h		;09e1	30 f1 	0 . 
	ret			;09e3	c9 	. 
	ei			;09e4	fb 	. 
	ret			;09e5	c9 	. 
	di			;09e6	f3 	. 
	ret			;09e7	c9 	. 
	ld a,c			;09e8	79 	y 
	add hl,bc			;09e9	09 	. 
	jp c,l0971h		;09ea	da 71 09 	. q . 
	inc c			;09ed	0c 	. 
	jp sub_0967h		;09ee	c3 67 09 	. g . 
	ld a,c			;09f1	79 	y 
	call sub_098bh		;09f2	cd 8b 09 	. . . 
	add hl,de			;09f5	19 	. 
	ld c,030h		;09f6	0e 30 	. 0 
	ret			;09f8	c9 	. 
	ld a,l			;09f9	7d 	} 
	sub e			;09fa	93 	. 
	ld l,a			;09fb	6f 	o 
	ld a,h			;09fc	7c 	| 
	sbc a,d			;09fd	9a 	. 
	ld h,a			;09fe	67 	g 
	ret			;09ff	c9 	. 
