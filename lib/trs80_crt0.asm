;       TRS 80  Program boot
;
;       Stefano Bodrato 2008
;
;       $Id: trs80_crt0.asm,v 1.15 2016-05-15 20:15:44 dom Exp $
;



                MODULE  trs80_crt0
;--------
; Include zcc_opt.def to find out some info
;--------

        defc    crt0 = 1
        INCLUDE "zcc_opt.def"

;--------
; Some scope definitions
;--------

        EXTERN    _main           ;main() is always external to crt0 code

        PUBLIC    cleanup         ;jp'd to by exit()
        PUBLIC    l_dcal          ;jp(hl)


        PUBLIC    exitsp          ;atexit() variables
        PUBLIC    exitcount

        PUBLIC    heaplast        ;Near malloc heap variables
        PUBLIC    heapblocks

        PUBLIC    __sgoioblk      ;stdio info block

        PUBLIC    base_graphics   ;Graphical variables
        PUBLIC    coords          ;Current xy position

        PUBLIC	snd_tick	; Sound variable
        PUBLIC	bit_irqstatus	; current irq status when DI is necessary


;--------
; Set an origin for the application (-zorg=) default to $5200
;--------

        IF      !myzorg
			IF (startup=2)
                defc    myzorg  = 22500
			ELSE
                defc    myzorg  = $5200
			ENDIF
        ENDIF
                org     myzorg

start:
        ld      (start1+1),sp   ;Save entry stack
IF      STACKPTR
        ld      sp,STACKPTR
ENDIF
        ld      hl,-64
        add     hl,sp
        ld      sp,hl
        ld      (exitsp),sp

; Optional definition for auto MALLOC init
; it assumes we have free space between the end of 
; the compiled program and the stack pointer
	IF DEFINED_USING_amalloc
		INCLUDE "amalloc.def"
	ENDIF

IF !DEFINED_nostreams
 IF DEFINED_ANSIstdio
; Set up the std* stuff so we can be called again
        ld      hl,__sgoioblk+2
        ld      (hl),19 ;stdin
        ld      hl,__sgoioblk+6
        ld      (hl),21 ;stdout
        ld      hl,__sgoioblk+10
        ld      (hl),21 ;stderr
 ENDIF
ENDIF

        call    _main           ;Call user program

cleanup:
;
;       Deallocate memory which has been allocated here!
;
IF !DEFINED_nostreams
 IF DEFINED_ANSIstdio
        EXTERN     closeall
        call    closeall
 ENDIF
ENDIF

cleanup_exit:
start1: ld      sp,0            ;Restore stack to entry value
        ret

l_dcal: jp      (hl)            ;Used for function pointer calls


;-----------
; Define the stdin/out/err area. For the z88 we have two models - the
; classic (kludgey) one and "ANSI" model
;-----------
__sgoioblk:
IF DEFINED_ANSIstdio
        INCLUDE "stdio_fp.asm"
ELSE
        defw    -11,-12,-10
ENDIF



        INCLUDE "crt0_runtime_selection.asm"

;-----------
; Now some variables
;-----------
coords:         defw    0       ; Current graphics xy coordinates
IF (startup=2)
base_graphics:  defw    $4800   ; Address of the Graphics map   COLOUR GENIE
ELSE
base_graphics:  defw    $3c00   ; Address of the Graphics map
ENDIF


exitsp:         defw    0       ; Address of where the atexit() stack is
exitcount:      defb    0       ; How many routines on the atexit() stack

heaplast:       defw    0       ; Address of last block on heap
heapblocks:     defw    0       ; Number of blocks

IF DEFINED_USING_amalloc
EXTERN ASMTAIL
PUBLIC _heap
; The heap pointer will be wiped at startup,
; but first its value (based on ASMTAIL)
; will be kept for sbrk() to setup the malloc area
_heap:
                defw ASMTAIL	; Location of the last program byte
                defw 0
ENDIF

IF DEFINED_NEED1bitsound
snd_tick:       defb	0	; Sound variable
bit_irqstatus:	defw	0
ENDIF

;-----------------------
; Floating point support
;-----------------------
IF NEED_floatpack
        INCLUDE         "float.asm"
fp_seed:        defb    $80,$80,0,0,0,0 ;FP seed (unused ATM)
extra:          defs    6               ;FP register
fa:             defs    6               ;FP Accumulator
fasign:         defb    0               ;FP register

ENDIF

                defm    "Small C+ TRS80"        ;Unnecessary file signature
                defb    0


