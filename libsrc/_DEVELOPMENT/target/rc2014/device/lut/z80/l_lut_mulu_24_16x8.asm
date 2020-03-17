;
;  feilipu, 2020 January
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;------------------------------------------------------------------------------
;
; Using RC2014 LUT Module
;
;------------------------------------------------------------------------------
;
; 2020 feilipu

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_math

PUBLIC l_lut_mulu_24_16x8

l_lut_mulu_24_16x8:

    ; multiplication of 16-bit number and 8-bit number into a 24-bit product
    ;
    ; enter : hl = 16-bit multiplier   = x
    ;          e =  8-bit multiplicand = y
    ;
    ; exit  : ahl = 24-bit product
    ;         carry reset
    ;
    ; uses  : af, bc, de, hl

    ld b,e
    ld c,__IO_LUT_OPERAND_LATCH ; operand latch address

    out (c),l                   ; multiply lsb
    in l,(c)                    ; lsb
    inc c
    in a,(c)                    ; msb

    dec c                       ; operand latch address
    out (c),h
    in h,(c)                    ; lsb

    add a,h                     ; add to msb final
    ld h,a                      ; hl = final

    inc c
    in a,(c)                    ; msb
    adc a,0

    ret
