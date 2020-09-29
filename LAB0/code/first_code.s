	.syntax unified
	.cpu cortex-m4
	.thumb
.text
.global main
.equ AA, 0x5500

main:
	movs r0, #AA
	movs r1, #20
	adds r2, r0, r1
	b main
