## Objective

This test suite verfies some general properties of Denise.

#### deniseid

Reads DFF07C (DENISEID) and visualizes all 16 bits. Each bit is represented by a color bar. The uppermost color bar visualizes bit #15, the lower most color bar visualizes bit #0. A bright color indicates a 1, a dark color a 0.

#### agatest

Performs the following AGA check from

http://amiga-dev.wikidot.com/hardware:deniseid

```
is_AGA:
    move.w 0xdff07c,d0    
    moveq  #31-1,d2
    and.w  #0xff,d0
check_loop:
    move.w 0xdff07C,d1
    and.w  #0xff,d1
    cmp.b  d0,d1
    bne.b  not_AGA
    dbf    d2,check_loop
    or.b   #0xf0,d0
    cmp.b  #0xf8,d0
    bne.b  not_AGA
    moveq  #1,d0
    rts
not_AGA:
    moveq  #0,d0
    rts
```

If an AGA chipset has been detected, the second half of the screen is drawn in red. OCS and ECS machines draw in yellow instead.



Dirk Hoffmann, 2019