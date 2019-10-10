#asm

; Repeated pattern are replaced by the following subroutines


.clisp_opt3b
	ld	(clisp_opt3_smc+1),a
	jr	clisp_opt3_common
.clisp_opt3a
	ld	hl,(_errmsg_ill_type)
.clisp_opt3
	ld	a,16
	ld	(clisp_opt3_smc+1),a
	push	hl
	ld	hl,1	;const
	push	hl
	ld	hl,24	;const
	call	l_glongsp	;
	call	_err_msg	; __opt3__
.clisp_opt3_common
	pop	bc
	pop	bc
	pop	bc
	pop	bc
	call	l_int2long_s
	exx
.clisp_opt3_smc
	ld	hl,16	;const
	add	hl,sp
	ld	sp,hl
	exx
	ret

.clisp_opt4a
	pop af
	ex af,af
	ld	hl,8	;const
	add	hl,sp
	xor	a
	ld	(hl),a
	inc	hl
	ld	(hl),a
	inc	hl
	ld	(hl),a
	inc	hl
	ld	(hl),a
	ld	hl,12	;const
	add	hl,sp
	push	hl
	ld	hl,20	;const
	jr	_clisp_opt4a
.clisp_opt4
	pop af
	ex af,af
._clisp_opt4a
	add	hl,sp
	call	l_glong	; __opt4__
	pop	bc
	call	l_plong
	ex af,af
	push af
	ret

.clisp_opt11
	ld	hl,4	;const
	add	hl,sp
	jp	l_glong


.clisp_opt13a
	ld	hl,14	;const
	call	l_gintspsp	;
	jr		clisp_opt13
.clisp_opt13b
	inc hl
	inc hl
	add	hl,sp
	push	hl
.clisp_opt13
	ld	hl,0	;const
	ld	d,h
	ld	e,l
	pop	bc
	pop af
	ex	af,af
	call	l_plong
	ex	af,af
	push af
	ret

.clisp_opt14
	ld	hl,65535	;const
	call	l_int2long_s
	exx			; __opt14__
	ld	hl,16	;const
	add	hl,sp
	ld	sp,hl
	exx
	ret

.clisp_opt15
	inc	a
	inc	a
	ld	l,a
	ld	h,0
	call	l_gintsp	;
	call	_l_car
	jp	_l_eval

.clisp_opt16
	inc	a
	inc	a
	ld	l,a
	ld	h,0
	call	l_gintsp	;
	jp	_D_GET_TAG

.clisp_opt17
	inc	a
	inc	a
	ld	l,a
	ld	h,0
	call	l_gintsp	;
	call	_l_car
	jp	l_pint_pop

.clisp_opt18
	ld	hl,6	;const
	call	l_gintsp	;
	call	_l_car
	call	_D_GET_TAG	; __opt18__
	ld	de,8192
	and	a
	sbc	hl,de
	scf
	ret

.clisp_opt19
	ld	hl,6	;const
	add	hl,sp
	push	hl
	call	l_gint	;
	call	_l_cdr	; __opt19__
	pop af
	ret

.clisp_opt20
	ld	h,0
	ld	l,a
	call	l_gintsp	;
	jp	l_gint	;

.clisp_opt21
	ld	h,0
	ld	l,a
	call	l_gintsp	;
	jp	_l_car	;

.clisp_opt22
	ld	h,0
	ld	l,a
	call	l_gintsp	;
	jp	_D_GET_TAG

.clisp_opt23
	push	hl
	ld	hl,1	;const
	push	hl
	ld	hl,18	;const
	call	l_gintsp	;
	push	hl
	call	_err_msg
	pop	bc
	pop	bc
	pop	bc
	pop	bc
	pop	bc
	pop	bc
	pop	bc
	pop	bc
	ret

.clisp_opt24
	ld	hl,65535	;const
	pop	bc
	pop	bc
	pop	bc
	pop	bc
	pop	bc
	ret

.clisp_opt25
	ld	h,0
	ld	l,a
	call	l_gintsp	;__opt25__
	call	_l_car	;
	jp	_l_eval


.clisp_opt26
	ld	h,0
	ld	l,a
	call	l_gintsp	;__opt26__
	call	_l_cdr
	call	_l_car
	jp	_l_eval


#endasm