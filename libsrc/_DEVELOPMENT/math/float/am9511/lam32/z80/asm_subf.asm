
; float _subf (float left, float right) __z88dk_callee

SECTION code_clib
SECTION code_fp_am9511

PUBLIC asm_subf

EXTERN asm_am9511_sub_callee

    ; subtract sccz80 float from sccz80 float
    ;
    ; enter : stack = sccz80_float left, ret
    ;          DEHL = sccz80_float right
    ;
    ; exit  :  DEHL = sccz80_float(left+right)
    ;
    ; uses  : af, bc, de, hl, af', bc', de', hl'

DEFC  asm_subf = asm_am9511_sub_callee  ; enter stack = IEEE-754 float left
                                        ;        DEHL = IEEE-754 float right
                                        ; return DEHL = IEEE-754 float
