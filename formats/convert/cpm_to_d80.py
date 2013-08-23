#!/usr/bin/env python
'''
Convert a CP/M image into a SoftBox-formatted D80 image

Usage: python cpm_to_d80.py <input.cpm> <output.d80>
'''

import sys
import base64

# This is the data for tracks 37, 38, and 39 that allows the disk to
# boot the SoftBox system.  These tracks hold normal CBM filesystem
# data.  They contain the CBM directory, terminal program that runs
# on the PET/CBM, and the CP/M system image file.
boot_tracks = base64.b64decode('''
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAJQ0y4+k6Rd+3wvvlzXfgzYTgyvvlzYrgzdHfzbLfw9LgwwXfPgEy1ek+
    ADLT6c1U4SpD381H4c274Drj6f6A0gXfzXfgzYTgDgDCbubNPuAy1+kBAAC3
    yjvmTwvNXuBETc2+4320wkjmPgLDAd8i5enrKkPfARAACTrd6bc61+nKZObN
    ZOFzw2zmTwYACQlzI3IOAjpF37fAxc2K4DrV6T09wrvmwcV5PT3Cu+blKrnp
    V3cjFPKM5s3g4Srn6Q4CIuXpxc3R38HNuN8q5ekOADrE6UeluCPCmubhIuXp
    zdrhzdHfwcXNuN/BOuPpIeHpvtrS5nc0DgIAACEAAPXNaSUO4c1R6M2c48MB
    481R6MO85c1R6MP+5c1y4c1R6MMk5c1R6M0W5MMB4yqv6cMp6TpC38MB3+si
    senD2uEqv+nDKekqrenDKenNUejNO+TDAeMqu+kiRd/JOtbp/v/CO+k6Qd/D
    Ad/mHzJB38nNUejDk+fNUejDnOfNUejD0ucqQ999L198Lyqv6aRXfaNfKq3p
    6yKv6X2jb3yiZyKt6ck63um3ypHpKkPfNgA64Om3ypHpdzrf6TLW6c1F6CoP
    3/kqRd99RMnNUeg+AjLV6Q4AzQfnzAPmyeUAAAAAgAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAlDyQ6aje3wDp2OP5VwDwydjjJzVoZzSQk
    zUkezTUWef4symslyTpxNz36piVHMnE3OnI3PbjClCUycjc6cjeQnzwypjfN
    0yUyczfD8wrNegTJOnM3t8R6BDpxN7fMegQhcjeWys8lPcLzCjQ9MqY3PDJz
    N8PzCjXDxSU6cTdf/jI+ANBXIXQ3GTd+yfXN0yURczfS8CUad68SIXE3NDqm
    N7fKExfxMqY3IXI3t8g0yc1aJnqzw+QlzVomerMvyuQlr8PkJTpqN83zCj3D
    5CU6ajfN8wq3w+Ql9jf1OqY3t8phJs0IC83XC8JJJuagwlQmzcELylQm8Z/D
    5CXxP5/DJRBCQREiJASQCAkgCQhCARECSEIEBIQkhAQkICEIEJAkJEIQhCSB
    IQkgQgghCSQkIgkIhCISCSANCjYwSyBQRVQgQ1AvTSB2ZXJzLiAyLjINCihj
    KSAxOTgxIEtlaXRoIEZyZXdpbg0KUmV2aXNpb24gNC83LzgxAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACUX
    4eZ/d/H+f8IA5zrV6f4BwgDnzdLgzVrlIUXffrfC/uY9MuPpNgDD0uCvMtXp
    xSpD3+shIQAZfuZ/9X4XI34X5h9Pfh8fHx/mD0fxI24sLS4GwovnISAAGXch
    DAAZeZbCR+chDgAZeJbmf8p/58XVzaLk0cEuAzpF3zzKhOchDAAZcSEOABlw
    zVHkOkXfPMJ/58HFLgQMyoTnzSTlLgU6Rd88yoTnwa/DAd/lzWnhNsDhwX0y
    Rd/DeOEO/80D58zB5ckOAM0D58wD5snrGU4GACEMABl+D+aAgU8+AIhHfg/m
    D4BHIQ4AGX6Hh4eH9YBH9eF94bXmAckODM0Y4yolGAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAwwDwwwPwwwbwwwnwwwzw
    ww/wwxLwwxXwwxjwwxvwwx7wwyHwwyTwwyfwwyrwwy3wwzDwAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAQGBXruBAIb
    ACAgAAAAAAEC////////CAECAAAAAACxBLIFswbqDusP0RzXHcUR0hLUE/QT
    2RT5FKsaqhq6Grsa2hq9G6gAqQAABfLNIMMwyiXl/+tzctET+iVQATkhWhnN
    ewvN6Qr+IspcJP4nwtgkJRnkJTqmN7fCWCXBryE0DSLBN8PkJfY39c17C/48
    xHQEzdYKt8KPJs2dCs3WCv4mwo8mzZ0Kw3cmKsE3KxEAACN+/j7CnyZUXf4N
    wpYmI+UqwTd6s8x0BDp2OP4gwsMmzTYN4SLBN8pUJsNPJuHDYSbNCAtPxcR0
    BDfNqAwjfvZAd8HmIMywBH7mgMSMBB8fH7Z3ef4syscmyRGWOAEAT8MAJw4A
    EeY4BjvNewsqwTcrfiP+HCHlL4VvPv+MZ3u5whchepDCFyHhPMkzM8P4IK/J
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAA5AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAgkABC
    AAAAAAAAQQiEkIEIkkkJJAJAhAEIEiQAAggBAEIIEAQkEICJCEAkJIIEkAIS
    EhJAISQIRCAQiQkIiQIRCEkJJJJJCSQkJJCSJBABCQgAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAlBEPfESEA
    GeVyI3Ijcs314coM6M1e4REPAM2l5+HlX3mWI3ieI3ue2gbocytwK3HNLePD
    5OfhySpD3xEgAM2l5yEhABlxI3Ajd8kqr+k6Qt9Pzerg5evNWd/hzEfffR/Y
    Kq/pTUTNC+Eir+nDo+I61ukhQt++yHfDIeg+/zLe6SpD337mHz0y1un+HtJ1
    6DpC3zLf6X4y4Onm4HfNReg6Qd8qQ9+2d8k+IsMB3yEAACKt6SKv6a8yQt8h
    gAAisenN2uHDIejNcuHNUejDUeTNUejDouQOAOt+/j/KwujNpuB+/j/EcuHN
    UegOD80Y48Pp4SrZ6SJD381R6M0t48PpJQVHzdwKzdwKKsE3KyvluA4Aynwk
    DM3cCv4NyoMkuMJvJM2dCrjKbyTN6QrNewv+AACZJP47ypkkuMqZJP4N4SLB
    N8LYJHn+AtrYJM3WCkfN3ArN3ArDuyTFzdMVwc3cCv4NyLjCsyTN1gq4ytIk
    zZ0K/izKSSTJzdMVw0kkzQMP9TokObf6ExfxzdMVef4sykkkyc1JHvV45oPE
    qgTxyc1aGc17C/4iygol/ifEdARPzdwK/g3IR83WCrnKICV4zdMVwwslzfMK
    zdYKuco5JXj2gM3TFc2dCv4syvokyXjN0xV5zfMKwxElzVoZzVglzSQkKk04
    GTpMOEfDcSPN7iUGAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAgkABCAAAAAAAAQQiEkIEIkkkJJAJAhAEIEiQAAggBAEIIEAQkEICJ
    CEAkJIIEkAISEhJAISQIRCAQiQkIiQIRCEkJJJJJCSQkJJCSJBABCQgAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAm
    A0MAATMd////Hx3///8fHf///x8d////Hx3///8fHf///x8d////Hx3///8f
    Hf///x8d////Hx3///8fHf///x8d////Hx3///8fHf///x8d////Hx3///8f
    Hf///x8d////Hx3///8fHf///x8d////Hx3///8fHf///x8d////Hx3///8f
    Hf///x8d////Hx3///8fHf///x8d////Hx3///8fHf///x8d////Hx3///8f
    Hf///x8Shx9+HAAAAAAAG/z//x8b////Bxv///8HG////wcb////Bxv///8H
    G////wcb////Bxv///8HG////wcb////Bxv///8HJgsABAANBDIAnigxMDM5
    KQAAAExmBCAgU09GVEJPWCBMT0FERVIgKEMpIENPUFlSSUdIVCAxOTgxIEtF
    SVRIIEZSRVdJTiAgIC0tLS0gIFJFVklTT04gOiAgNSBKVUxZIDE5ODEgICAg
    IHipT4WQqQaFkakAhQipAIUUhRWFFoUXhRiFGYUaqQqNPQtYqQ6NTOgghAep
    FIUBqQCFBoULqSiFCalVjQCACo0AhM0AhNAISs0AgNACBgmpGiDoBiDUCK0i
    6K1A6Cn7jUDoqTSNI+ipxo0i6KAAiND9qf+NIuipPI0R6I0h6I0j6Kk8jSHo
    rUDoCQaNQOitI+gKkPqtIiYMaCUTpgvQFskgsBUKqr0eB4UNvR8HhQ4gGwdM
    jQdMuAlMmQdsDQCJB38HhAeJB8kIzAjUCF4H3QffCAsI7Qf/B0UIVAhZCEoI
    OwkeCV4IawjRB9cHcQdjB08IHwizCe4IBgkYCIkHqQdM0v+tTOhIqQ4g0v9o
    jUzoYK1M6EipjiDS/2iNTOhgqf+FE2Cpf4UTYGAg9AcgiAmxAoUHpQyFBmDJ
    QJDtyWCwBSk/TKwHyYCwIClfqik/8BXJG7ARiklAqq1M6EpKsAaKKR9MigeK
    TIoHKX8JQEyKB6kMjUzoYKkOjUzoYKYE0AimCaUF8AXGBcqGBGCkBfD7xgVg
    pgonAUMAM04b////Bxv///8HG////wcZ////ARn///8BGf///wEZ////ARn/
    //8BGf///wEZ////ARn///8BGf///wEZ////ARn///8BF///fwAX//9/ABf/
    /38AF///fwAX//9/ABf//38AF///fwAX//9/ABf//38AF///fwAX//9/ABf/
    /38AF///fwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAJg4S6M0S6ND4Skiw
    IqUJyVDQBr3nCkwMCr2XCskB8AeQCo03C7AI7joL0APuOwto6IjQ1e4Q6M45
    C9DDrTcLyf/wIs04C/AdyQAQCil/rDoL8ANJEGDJQJAlyWCwIaw7C/ADKR9g
    yUDwFclbsBGsOgvQDEitTOhKSmiQAwkgYKw6C/AgogvJCvAYogjJDPASohrJ
    HvAMSK1M6EpKaLAFCYBgimDJAGAhIyUmKF8eDCIkJ1wp/wp/UUVUVU9eNzlX
    UllJUP84L0FER0pM/zQ2U0ZISzr/NSpaQ0JNOw0xM1hWTiw//zIrAUBd/z4B
    MC0AWyA8G/8uPbK1uK04DP//sSYPw1zXw1jXfwAADQpTRVQgVVBQRVINCkRJ
    Ug0KU0VUIExPV0VSDQpTVEFUICouKg0KU1VCTUlUIEdOQVNIRVINChoaGhoa
    GhoaGhoaGhoaGhoaGhoaGhoaGgAAAAAAAAAAKGMpIENvcHlyaWdodCAxOTgx
    IERpZ2l0YWwgUmVzZWFyY2gAAAAAAAjUAABfDgLDBQDFzYzUwck+Dc2S1D4K
    w5LUPiDDktTFzZjU4X63yCPlzYzU4cOs1A4NwwUAXw4OwwUAzQUAMu7bPMkO
    D8PD1K8y7dsRzdvDy9QOEMPD1A4Rw8PUDhLDw9QRzdvD39QOE8MFAM0FALfJ
    DhTD9NQmECKI1OEBCwAjfv4/wgnXBA3CAdd4t8lESVIgRVJBIFRZUEVTQVZF
    UkVOIFVTRVJbFgEABy4hENcOAHn+BtARztsGBBq+wk/XEyMFwjzXGv4gwlTX
    eckjBcJP1wzDM9evMgfUMavbxXkfHx8f5g9fzRXVzbjUMqvbwXnmDzLv2829
    1DoH1LfCmNcxq9vNmNTN0NXGQc2M1D4+zYzUzTnVEYAAzdjVzdDVMu/bzV7W
    xAnWOvDbt8Kl2s0u1yHB118WABkZfiNmb+l32B/ZXdmt2RDajtql2iHzdiIA
    1CEA1OkB39fDp9RSRUFEIEVSUk9SAAHw18On1E5PIEZJTEUAJhHN2tQ8wgHa
    AQfazafUzdXVw4bbTk8gU1BBQ0UAzV7WwgnWOvDb9c1U2M3p1MJ52iHN2xHd
    2wYQzULYKojU681P1v49yj/a/l/Cc9rrIyKI1M1e1sJz2vFHIfDbfrfKWdq4
    cMJz2nCvMs3bzenUym3aEc3bzQ7Vw4bbzerXw4bbzWbYwwnWAYLazafUw4bb
    RklMRSBFWElTVFMAzfjX/hDSCdZfOs7b/iDKCdbNFdXDidvN9dU6ztv+IMLE
    2jrw27fKids9Mu/bzSnVzb3Uw4nbEdbbGv4gwgnW1c1U2NEhg9vNQNjN0NTK
    a9shAAHl683Y1RHN28351MIB2+ERgCYSMsbcAbrczdPdwc3T3SEO3342ALfA
    wwnqzfvczRTd2PVPzZDd8cn+Dcj+Csj+Ccj+CMj+IMk6Dt+3wkXdzQbq5gHI
    zQnq/hPCQt3NCer+A8oAAK/JMg7fPgHJOgrft8Ji3cXNI93Bxc0M6sHFOg3f
    t8QP6sF5IQzf/n/INP4g0DV+t8h5/gjCed01yf4KwDYAyXnNFN3SkN31Dl7N
    SN3x9kBPef4JwkjdDiDNSN06DN/mB8KW3cnNrN0OIM0M6g4IwwzqDiPNSN3N
    yd06DN8hC9++0A4gzUjdw7ndDg3NSN0OCsNI3Qr+JMgDxU/NkN3Bw9PdOgzf
    MgvfKkPfTiMmE9L63+Uqwel7lV96nFfhK8Pk3+UqwekZ2g/geZV4nNoP4Ovh
    I8P63+HF1eXrKs7pGURNzR7q0Sq16XMjctEqt+lzI3LBeZNPeJpHKtDp680w
    6k1EwyHqIcPpTjrj6bcfDcJF4Ec+CJZPOuLpDcpc4LcXw1PggMkqQ98REAAZ
    CTrd6bfKceBuJgDJCV4jVuvJzT7gTwYAzV7gIuXpySrl6X20yTrD6Srl6Sk9
    wpDgIufpOsTpTzrj6aG1byLl6ckqQ98RDAAZySpD3xEPABnrIREAGcnNruB+
    MuPp634y4enNpuA6xemmMuLpyc2u4DrV6f4Cwt7gr0864+mBd+s6JhQjRsMk
    6iq56esqsekOgMNP3yHq6X4jvsA8ySH//yLq6ckqyOnrKurpIyLq6c2V4dIZ
    4sP+4Trq6eYDBgWHBcIg4jLp6bfAxc3D383U4cHDnuF55gc8X1d5Dw8P5h9P
    eIeHh4eHsU94Dw8P5h9HKr/pCX4HHcJW4snVzTXi5v7BsQ8VwmTid8nNXuER
    EAAZxQ4R0Q3I1Trd6bfKiOLF5U4GAMOO4g3FTiNG5Xmwyp3iKsbpfZF8mNRc
    4uEjwcN14irG6Q4DzergI0RNKr/pNgAjC3ixwrHiKsrp6yq/6XMjcs2h3yqz
    6TYDIzYAzf7hDv/NBeLN9eHIzV7hPuW+yiYV6Kk0jSHoriDoimqpf7AGpAjQ
    Aqm/jSLorSDoKT/JP9D3qf+NIuiKapDBapAMapAMapAXapBdTFsFTMYFIM8F
    ojyOIegg6AZM5wQgzwWFDSDPBYUOojyOIeggGwdM5wQgzwWFESDPBYUSIM8F
    hQ0gzwWFDqAAIM8FkQ3I0ALmDqUROOkBhRGlEukAhRIFEdDlTOcEIM8FhREg
    zwWFEiDPBYUNIM8FhQ6gAIjQ/bENIPsFyNAC5g6lETjpAYURpRLpAIUSBRHQ
    5UznBCAuBiD7BUznBK1A6AkCjUDoLEDoMPutIOhJ/0itQOgp/Y1A6Kk8jSHo
    LEDoEPupNI0h6GgmFvACSYAgiAmRAuYEpgTkCdAQqQCFBKQFwBjQA0yOCOYF
    YGCpAIUFhQRgogCGBIYFhgqpIJ0AgJ0AgZ0Agp0Ag50AhJ0AhZ0Ahp0Ah+jQ
    5WCpAIUEYKkAhQxgqf+FDGCpAYUKYKkAhQpgIIgJqSCRAsjECdD5YCBeCKYF
    6OAZ8BgYpQJlCYUCkALmA6kgoACRAsjECdD58ONgqQCFAqUJhQ2pgIUDhQ6i
    GKAAsQ2RAsjECdD3pQ2FAhhlCYUNpQ6FA2kAhQ7K0OGgAKkgkQLIxAnQ+WCp
    ASypAKYEnT8LYKJPqQCdPwvKEPpgpgTo4FCwB70/C/D2hgRgIIgJpAmIJhfN
    NeIf0uzj0cHDwOMXPM1k4uHRyXmwwsDjIQAAyQ4AHiDVBgAqQ98J681e4cHN
    T9/Nw9/DxuHNVOEODM0Y4ypD334REAAZd8314cjNROEOEB4MzQHkzS3jwyfk
    DgzNGOPN9eHIDgAeDM0B5M0t48NA5A4PzRjjzfXhyM2m4H715c1e4esqQ98O
    INXNT9/NeOHRIQwAGU4hDwAZRuHxd3m+eMqL5D4A2ovkPoAqQ98RDwAZd8l+
    I7YrwBp3EyMadxsrya8yRd8y6uky6+nNHuHAzWnh5oDADg/NGOPN9eHIARAA
    zV7hCesqQ98JDhA63em3yujkfrcawtvkd7fC4SYYtLcwN17/ORtTRkhdS7s1
    QURHSg1MQDYJV1JZXElQf1FFVFUKT1s0AUNCri7/ATNaVk6sMP//MgBYIE0e
    /68xX7O2uf+6//+qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq
    qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq
    qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq
    qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq
    qqqqqqqqqqqqqqqqqqomGRHN28P51A4Vw/TUDhbDw9QOF8MFAB7/DiDDBQDN
    E9WHh4eHIe/btjIEAMk679syBADJ/mHY/nvQ5l/JOqvbt8qW1Trv27c+AMS9
    1BGs283L1MqW1Tq72z0yzNsRrNvN+dTCltURB9QhgAAGgM1C2CG62zYAIzUR
    rNvN2tTKltU679u3xL3UIQjUzazUzcLVyqfVzd3Vw4LXzd3VzRrVDgoRBtTN
    BQDNKdUhB9RGI3i3yrrVfs0w1XcFw6vVdyEI1CKI1MkOC80FALfIDgHNBQC3
    yQ4ZwwUAEYAADhrDBQAhq9t+t8g2AK/NvdQRrNvN79Q679vDvdQRKNchANwG
    JhrNXtY68Nu3wgnWIc7bAQsAfv4gyjPYI9Yw/grSCdZXeObgwgnWeAcHB4Da
    CdaA2gnWgtoJ1kcNwgjYyX7+IMIJ1iMNwjPYeMkGA34SIxMFwkLYySGAAIHN
    WdZ+ya8yzds68Nu3yD0h79u+yMO91Drw27fIPSHv277IOu/bw73UzV7WzVTY
    Ic7bfv4gwo/YBgs2PyMFwojYHgDVzenUzOrXyhvZOu7bDw8P5mBPPgrNS9gX
    2g/Z0Xsc1eYD9cLM2M2Y1MXN0NXBxkHNktQ+Os2S1MPU2M2i1D46zZLUzaLU
    BgF4zUvY5n/+IML52PH1/gPC99g+Cc1L2OZ//iDKDiYbABkRANR9k3ya0nHb
    w+Ha4T3CcdvNZtjNXtYh8NvlfjLN2z4QzWDW4X4y3duvMu3bEVwAIc3bBiHN
    QtghCNR+t8o+2/4gyj7bI8Mw2wYAEYEAfhK3yk/bBCMTw0PbeDKAAM2Y1M3V
    1c0a1c0AATGr280p1c291MOC181m2MMJ1gF6282n1MOG20JBRCBMT0FEAENP
    Tc1m2M1e1jrO29YgIfDbtsIJ1sOC1wAAAAAAAAAAAAAAAAAAAAAAACQkJCAg
    ICAgU1VCAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAmHOUGAMXlzfvc5n/hwf4NysHe/grKwd7+CMIW
    3ni3yu/dBToM3zIK38Nw3v5/wibewwfe791+BSvDqd7+BcI33sXlzcndrzIL
    38Px3f4Qwkje5SEN3z4Blnfhw+/d/hjCX97hOgvfIQzfvtLh3TXNpN3DTt7+
    FcJr3sNN3uHD4d3+EsKm3sXNsd3B4eXFeLfKit4jTgXF5c1/3eHBw3je5ToK
    37fK8d0hDN+WMgrfzaTdIQrfNcKZ3sPx3SN3BMXlT81/3eHBfv4DeMK93v4B
    ygAAudrv3eFwDg3DSN3NBt3DAd/NFerDAd95PMrg3jzKBurDDOrNBuq3ypHp
    zQnqJgrh6XfJDA3IfLcfZ30fb8Pr4A6AKrnpr4YjDcL94MkMDcgpwwXhxTpC
    308hAQDNBOHBebVveLRnySqt6TpC30/N6uB95gHJIa3pTiNGzQvhIq3pKsjp
    I+sqs+lzI3LJzV7hEQkAGX4X0CEP3MNK380e4cghDdzDSt8quek66emFb9Ak
    ySpD3xEOABl+yc1p4TYAyc1p4faAd8kq6unrKrPpe5Yjep7JzX/h2BNyK3PJ
    e5VvepxnyQ7/Kuzp6yrM6c2V4dDFzffgKr3p6yrs6RnBDMrE4b7IzX/h0M0s
    4cl3yc2c4c3g4Q4Bzbjfw9rhzeDhzbLfIbHpw+PhIbnpTiYN0uI6Qd++wvbi
    I37WJML24j0yRd8OAc1r4s2M4cPS4jrU6cMB38X1OsXpL0d5oE/xoJHmH8HJ
    Pv8y1Okh2OlxKkPfItnpzf7hzaHfDgDNBeLN9eHKlOMq2enrGv7lykrj1c1/
    4dHSlOPNXuE62OlPBgB5t8qD4xr+P8p843j+Dcp84/4MGspz45bmf8It48N8
    48VOzQfjwcIt4xMjBA3DU+M66unmAzJF3yHU6X4X0K93yc3+4T7/wwHfzVTh
    DgzNGOPN9eHIzUThzV7hNuUOAM1r4s3G4c0t48Ok41BZebDK0eML1cXNNeIf
    0uzjwdEqxul7lXqc0vTjE8XVQksmAmBJ/40i6K1A6AkCjUDoqTyNIegsQOhQ
    +6k0jSPorUDoSpD6qTyNI+ip/40i6K1A6Eqw+mCp/3imCPAUrW8CSKIAxgi9
    cAKdbwLo5AjQ9WhYyf/w4GDmGtAG5hnQAuYY5hSlFM0DBNAoqQCFFOYVpRXJ
    PNAcqQCFFeYWpRbJPNAQqQCFFuYXpRfJGNAEqQCFF6UG0BHGAdANqRSFASCI
    CbECSYCRAq03C80+C/AKjT4LqRCNPAvQIcn/8B2tPAvwBc48C9ATzj0L0A6p
    BI09C6kAjTcLqQKFASDUCfALpgjgUPAFnW8C5ghoqGiqaEBIpQaFDKn/hQYg
    iAmlB5ECJgTEBPAJiLECyJECiNDzqSCRAmAgiAmkBMjECfAIsQKIkQLI0POI
    qSCRAmCpAIUEIIgJpQIYZQmFDaUDaQCFDqkYOOUFqkyeCKnAoIOmCeBQ0ASp
    gKCHhQ2EDqkAhQSlDcUC0AalDsUD8B+lDYUPOOUJhQ2lDoUQ6QCFDqAAsQ2R
    D8jECdD3TFEJoACpIJECyMQJ0PlgSKkAhQOlBYUCCgplAgoKJgMKJgOFAqUJ
    yVDQBAYCJgMYpASlA2mAhQNoYKkChQtgxgvwDDjpIMUJsAKFBEyNBzjpIMkZ
    sPaFBUyNB603C404C6IAjjoLjjsLjhDoqf+NNwupCo05C6AIrSUD5H4SvsIf
    5cP95M2U5OvNlOTrGr7CH+UTIxq+wh/lDRMjDcLN5AHs/wnrCRq+2hfldwED
    AAnrCX4SPv8y0unDEOQhRd81yc1U4SpD3+UhrOkiQ98OAc0Y48314eEiQ9/I
    6yEPABkOEa93Iw3CRuUhDQAZd82M4c3948N44a8y0unNouTN9eHIKkPfAQwA
    CX485h93yoPlRzrF6aAh0ummyo7lw6zlAQIACTR+5g/KtuUOD80Y48314cKs
    5TrT6TzKtuXNJOXN9eHKtuXDr+XNWuTNu+CvwwHfzQXfw3jhPgEy1ek+/zLT
    6c274Drj6SHh6b7a5uX+gML75c1a5a8AEaqqqqqqqqqqqqqqqqqqqqoGvecK
    TAwKvZcKyQHwB5AKjTcLsAjuOgvQA+47C2joiNDV7hDozjkL0MOtNwvJ//Ai
    zTgL8B3JABAKKX+sOgvwA0kQYMlAkCXJYLAhrDsL8AMpH2DJQPAVyVuwEaw6
    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
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA''')


def cpm_to_d80(input_filename, output_filename):
    inp = open(input_filename, "rb")
    out = open(output_filename, "wb")

    pet_track, pet_sector = 1, 0
    cpm_track, cpm_sector = 0, 0

    for i in range(0, 3992):
        # each 256-byte pet sector holds two 128-byte cp/m sectors
        cpm_sector_data = inp.read(128)
        if len(cpm_sector_data) != 128:
            cpm_sector_data = chr(0) * 128
        out.write(cpm_sector_data)

        # increment cp/m track/sector counters
        cpm_sector += 1
        if cpm_sector > 31:
            cpm_track += 1
            cpm_sector = 0

        if i & 1:
            # increment pet track/sector counters
            pet_sector += 1
            if not is_valid_8050_ts(pet_track, pet_sector):
                pet_sector = 0
                pet_track += 1

            # skip over the 3 reserved 8050 tracks: 37, 38, 39
            # 29 sectors on each
            if pet_track == 37:
                pet_track = 40
                out.write(boot_tracks)
                # TODO: option to write non-bootable disk
                # out.write(chr(0) * 256 * 29 * 3)

    inp.close()
    out.close()


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
    if len(sys.argv) < 3:
        sys.stderr.write(__doc__ + "\n")
        sys.exit(1)

    cpm_to_d80(sys.argv[1], sys.argv[2])
