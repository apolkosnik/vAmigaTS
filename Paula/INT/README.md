## Objective

Verify basic interrupt timing properties (i.e., timing).

#### int1

First half: A level 4 interrupt is issued and acknowledged with varying delays.
Second half: The level 4 interrupt is followed by a level 5 interrupt with varying delay.

#### int2

The CPU runs in an infinite loop. In each iteration, it reads the VERTB bit in INTREQR and changes the background color to green if the bit is set. The Copper changes the color back to red and black. In AmigaForever (most likely on the real machine, too), the upper area toggles between green and black which means that the bit is sometimes 1 and sometimes 0. In the latter case, the IRQ handler has been executed before the CPU was able to check the bit. The result of this test backs the hypthesis that the bit INTREQR changes faster than Paula's IRQ level lines that actually trigger the IRQ inside the CPU.

#### int3

Issues a level 4 interrupt and acknowledges it with varying delays (similar to int1 first half).

#### int4

Same as int3, but IRQ is acknowledged immediately after triggering.

#### int5

Same as int3, but IRQ is disabled immediately after triggering.

#### int6

Issues a level 4 interrupt followed by a level 5 interrupt (similar to int1 second half).

#### int7

Same idea as int6. It is tried to discard some interrupts by deleting bits in INTREQ. 

#### int8

Uses the CPU to change the background color in a loop and the Copper to trigger an interrupt at a fixed location. The (flickering) result gives some insight into the timing behaviour of an interrupt call.

#### intena1 

INTENA timing test. The Copper is used to change INTENA at fixed locations. The CPU is used to continously write INTENA into the background color register.

#### intreq1 

Same as intena1, but for INTREQ


Dirk Hoffmann, 2019
