	include "../../../../include/registers.i"
	include "hardware/dmabits.i"
	include "hardware/intbits.i"
	
LVL3_INT_VECTOR		equ $6c
SCREEN_WIDTH_BYTES	equ (320/8)
SCREEN_BIT_DEPTH	equ 5
	
entry:	
	lea	level3InterruptHandler(pc),a3
 	move.l	a3,LVL3_INT_VECTOR

	;; install copper list and enable DMA
	lea 	CUSTOM,a1
	lea	copper(pc),a0
	move.l	a0,COP1LC(a1)
	move.w  COPJMP1(a1),d0
	move.w  #(DMAF_SETCLR!DMAF_COPPER!DMAF_RASTER!DMAF_MASTER),dmacon(a1)
	
.mainLoop:
	bra.b	.mainLoop

level3InterruptHandler:
	movem.l	d0-a6,-(sp)

.checkVerticalBlank:
	lea	CUSTOM,a5
	move.w	INTREQR(a5),d0
	and.w	#INTF_VERTB,d0	
	beq.s	.checkCopper

.verticalBlank:
	move.w	#INTF_VERTB,INTREQ(a5)	; clear interrupt bit	

.resetBitplanePointers:
	lea	bitplanes(pc),a1
	lea     BPL1PTH(a5),a2
	moveq	#SCREEN_BIT_DEPTH-1,d0
.bitplaneloop:
	move.l	a1,(a2)
	lea	SCREEN_WIDTH_BYTES(a1),a1 ; bit plane data is interleaved
	addq	#4,a2
	dbra	d0,.bitplaneloop
	
.checkCopper:
	lea	CUSTOM,a5
	move.w	INTREQR(a5),d0
	and.w	#INTF_COPER,d0	
	beq.s	.interruptComplete
.copperInterrupt:
	move.w	#INTF_COPER,INTREQ(a5)	; clear interrupt bit	
	
.interruptComplete:
	movem.l	(sp)+,d0-a6
	rte

copper:
	dc.w    DIWSTRT,$2c71 
	dc.w	DIWSTOP,$2cd1
	dc.w	BPLCON0,(SCREEN_BIT_DEPTH<<12)|$200 ; set color depth and enable COLOR
	dc.w	BPL1MOD,SCREEN_WIDTH_BYTES*SCREEN_BIT_DEPTH-SCREEN_WIDTH_BYTES
	dc.w	BPL2MOD,SCREEN_WIDTH_BYTES*SCREEN_BIT_DEPTH-SCREEN_WIDTH_BYTES
 
 	include	"out/image-copper-list.s"


    ; Set number of bitplanes to 4, so Copper cannot be blocked by bitplane DMA.
	dc.w	BPLCON0,(4<<12)|$200

    ; First color block
	dc.w	$3001,$FFFE  ; WAIT 
	dc.w	COLOR00, $F00
	dc.w	$3101,$FFFE  ; WAIT 
	dc.w    DDFSTRT,$0038 
	dc.w	DDFSTOP,$00D0
	dc.w	COLOR00, $000

	dc.w	$3801,$FFFE  ; WAIT 
	dc.w	COLOR00, $F00
	dc.w	$3901,$FFFE  ; WAIT 
	dc.w    DDFSTRT,$0039 
	dc.w	DDFSTOP,$00D0
	dc.w	COLOR00, $000

	dc.w	$4001,$FFFE  ; WAIT 
	dc.w	COLOR00, $F00
	dc.w	$4101,$FFFE  ; WAIT 
	dc.w    DDFSTRT,$003A 
	dc.w	DDFSTOP,$00D0
	dc.w	COLOR00, $000

	dc.w	$4801,$FFFE  ; WAIT 
	dc.w	COLOR00, $F00
	dc.w	$4901,$FFFE  ; WAIT 
	dc.w    DDFSTRT,$003B 
	dc.w	DDFSTOP,$00D0
	dc.w	COLOR00, $000

	dc.w	$5001,$FFFE  ; WAIT 
	dc.w	COLOR00, $F00
	dc.w	$5101,$FFFE  ; WAIT 
	dc.w    DDFSTRT,$003C 
	dc.w	DDFSTOP,$00D0
	dc.w	COLOR00, $000
	dc.w	$5101,$FFFE  ; WAIT 

	dc.w	$5801,$FFFE  ; WAIT 
	dc.w	COLOR00, $F00
	dc.w	$5901,$FFFE  ; WAIT 
	dc.w    DDFSTRT,$003D 
	dc.w	DDFSTOP,$00D0
	dc.w	COLOR00, $000

	; Second color block
	dc.w    $7001,$FFFE  ; WAIT
	dc.w	COLOR00, $F00
    dc.w    $7101,$FFFE  ; WAIT
  	dc.w    DDFSTRT,$003E 
	dc.w	DDFSTOP,$00D0
	dc.w	COLOR00, $000

	dc.w    $7801,$FFFE  ; WAIT
	dc.w	COLOR00, $F00
    dc.w    $7901,$FFFE  ; WAIT
  	dc.w    DDFSTRT,$003F 
	dc.w	DDFSTOP,$00D0
	dc.w	COLOR00, $000

	dc.w    $8001,$FFFE  ; WAIT
	dc.w	COLOR00, $F00
    dc.w    $8101,$FFFE  ; WAIT
 	dc.w    DDFSTRT,$0040 
	dc.w	DDFSTOP,$00D0
	dc.w	COLOR00, $000

	dc.w    $8801,$FFFE  ; WAIT
	dc.w	COLOR00, $F00
    dc.w    $8901,$FFFE  ; WAIT
    dc.w    DDFSTRT,$0041 
	dc.w	DDFSTOP,$00D0
	dc.w	COLOR00, $000

	dc.w    $9001,$FFFE  ; WAIT
	dc.w	COLOR00, $F00
    dc.w    $9101,$FFFE  ; WAIT
    dc.w    DDFSTRT,$0042 
	dc.w	DDFSTOP,$00D0
	dc.w	COLOR00, $000

	dc.w    $9801,$FFFE  ; WAIT
	dc.w	COLOR00, $F00
    dc.w    $9901,$FFFE  ; WAIT
    dc.w    DDFSTRT,$0043 
	dc.w	DDFSTOP,$00D0
	dc.w	COLOR00, $000

	dc.w    $A001,$FFFE  ; WAIT
	dc.w	COLOR00, $F00
    dc.w    $A101,$FFFE  ; WAIT
    dc.w    DDFSTRT,$0044 
	dc.w	DDFSTOP,$00D0
	dc.w	COLOR00, $000

	; Third color block
	dc.w    $B801,$FFFE  ; WAIT
	dc.w	COLOR00, $F00
	dc.w    $B901,$FFFE  ; WAIT
	dc.w    DDFSTRT,$0045 
	dc.w	DDFSTOP,$00D0
	dc.w	COLOR00, $000

	dc.w    $C001,$FFFE  ; WAIT
	dc.w	COLOR00, $F00
	dc.w    $C101,$FFFE  ; WAIT
	dc.w    DDFSTRT,$0046 
	dc.w	DDFSTOP,$00D0
	dc.w	COLOR00, $000

	dc.w    $C801,$FFFE  ; WAIT
	dc.w	COLOR00, $F00
	dc.w    $C901,$FFFE  ; WAIT
	dc.w    DDFSTRT,$0047 
	dc.w	DDFSTOP,$00D0
	dc.w	COLOR00, $000

	dc.w    $D001,$FFFE  ; WAIT
	dc.w	COLOR00, $F00
	dc.w    $D101,$FFFE  ; WAIT
	dc.w    DDFSTRT,$0048 
	dc.w	DDFSTOP,$00D0
	dc.w	COLOR00, $000

	dc.w    $D801,$FFFE  ; WAIT
	dc.w	COLOR00, $F00
	dc.w    $D901,$FFFE  ; WAIT
	dc.w    DDFSTRT,$0049 
	dc.w	DDFSTOP,$00D0
	dc.w	COLOR00, $000

	dc.w    $E001,$FFFE  ; WAIT
	dc.w	COLOR00, $F00
	dc.w    $E101,$FFFE  ; WAIT
	dc.w    DDFSTRT,$004A 
	dc.w	DDFSTOP,$00D0
	dc.w	COLOR00, $000

	dc.w    $E801,$FFFE  ; WAIT
	dc.w	COLOR00, $F00
	dc.w    $E901,$FFFE  ; WAIT
	dc.w    DDFSTRT,$004B 
	dc.w	DDFSTOP,$00D0
	dc.w	COLOR00, $000

	dc.w    $ffdf,$fffe ; Cross vertical boundary

; Fourth color block: Set DIWSTRT too late
	dc.w    $0001,$FFFE  ; WAIT
	dc.w	COLOR00, $F00
	dc.w    $0101,$FFFE  ; WAIT
	dc.w    DDFSTRT,$004C 
	dc.w	DDFSTOP,$00D0
	dc.w	COLOR00, $000

	dc.w    $0801,$FFFE  ; WAIT
	dc.w	COLOR00, $F00
	dc.w    $0901,$FFFE  ; WAIT
	dc.w    DDFSTRT,$004D 
	dc.w	DDFSTOP,$00D0
	dc.w	COLOR00, $000

	dc.w    $1001,$FFFE  ; WAIT
	dc.w	COLOR00, $F00
	dc.w    $1101,$FFFE  ; WAIT
	dc.w    DDFSTRT,$004E 
	dc.w	DDFSTOP,$00D0
	dc.w	COLOR00, $000

	dc.w    $1801,$FFFE  ; WAIT
	dc.w	COLOR00, $F00
	dc.w    $1901,$FFFE  ; WAIT
	dc.w    DDFSTRT,$004F 
	dc.w	DDFSTOP,$00D0
	dc.w	COLOR00, $000

	dc.w    $2001,$FFFE  ; WAIT
	dc.w	COLOR00, $F00
	dc.w    $2101,$FFFE  ; WAIT
	dc.w    DDFSTRT,$0050 
	dc.w	DDFSTOP,$00D0
	dc.w	COLOR00, $000

	dc.w    $2801,$FFFE  ; WAIT
	dc.w	COLOR00, $F00
	dc.w    $2901,$FFFE  ; WAIT
	dc.w    DDFSTRT,$0051 
	dc.w	DDFSTOP,$00D0
	dc.w	COLOR00, $000

	dc.w    DDFSTRT,$0038 ; Reset normal values
	dc.w	DDFSTOP,$00D0

	dc.l	$fffffffe

bitplanes:
	incbin	"out/image.bin"
	