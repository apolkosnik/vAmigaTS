## Objective

Same as diw4 with a slightly different Copper trigger coordinates

## Copper list

	dc.w    DIWSTRT,$6c81
	dc.w	DIWSTOP,$80c1 ; (1)
	dc.w	BPLCON0,(SCREEN_BIT_DEPTH<<12)|$200 ; set color depth and enable COLOR
	dc.w	BPL1MOD,SCREEN_WIDTH_BYTES*SCREEN_BIT_DEPTH-SCREEN_WIDTH_BYTES
	dc.w	BPL2MOD,SCREEN_WIDTH_BYTES*SCREEN_BIT_DEPTH-SCREEN_WIDTH_BYTES
 
 	include	"out/image-copper-list.s"

	; Try to modify DIWSTOP around the trigger position
	dc.w    $7FDD,$FFFE   ; WAIT 
	dc.w	DIWSTOP,$2cc1 ; Just in time.

	dc.w	$8801,$FFFE   ; WAIT 
	dc.w    DIWSTRT,$E081
	dc.w    DIWSTOP,$0cC1

	dc.w    $ffdf,$fffe   ; Cross vertical boundary

	dc.w    $0bDF,$FFFE   ; WAIT 
	dc.w    DIWSTOP,$7FC1 ; Too late

	dc.l	$fffffffe

