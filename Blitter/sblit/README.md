## Objective

Performs simple blits with all 16 bit combinations of USEA/USEB/USEC/USED in BLTCON0

#### sblit *n*

*n* is the USEA/USEB/USEC/USED bit combination. The test case prepares the blit operation in the VBLANK interrupt handler. It then uses the Copper to trigger the blit. To measure timing, the background color is switched to green just before the blit starts and switched back to black when the blit terminates.

In the lower part, you can spot four additional short lines. In these lines, blits of size 1x1, 1x2, 2x1, and 2x2 are performed to get a glimpse of the ramp up and ramp down timing.

#### sblit*n*f and sblit*n*f2

Runs the test in exclusive and inclusive fill mode, respectively.

#### sline1

Runs the Line Blitter instead of the Copy Blitter.


Dirk Hoffmann, 2019