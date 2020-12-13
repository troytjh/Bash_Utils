		.global main
		.data
		.text
t		.set 0x30F
i		.set r7
j		.set r8
main:
		; PxDIR
		movw R0, #0x4C04 ; P1 --> DIR offset (movw imm16 to [15:0] LSB)
		bl	PxHIGH
		movw R0, #0x4C05 ; P2 --> DIR + Port offset (0x04+0x01)
		bl	PxHIGH

Blink:
		; PxOUT --> ON
		movw R0, #0x4C02 ; P1 --> OUT offset
		bl	PxHIGH
		movw R0, #0x4C03 ; P2 --> OUT + Port offset (0x02+0x01)
		bl	PxHIGH

		bl 	delay

		; PxOUT --> OFF
		movw R0, #0x4C02 ; P1 --> OUT offset
		bl PxLOW
		movw R0, #0x4C03 ; P2 --> OUT + Port offset (0x02+0x01)
		bl PxLOW

		bl delay

		b Blink

PxHIGH:
		movt R0, #0x4000 ; P1 --> ON
		mov R1, #0x01
		strb R1, [R0]
		bx		lr

PxLOW:
		movt R0, #0x4000 ; Periph offset
		mov R1, #0x00
		strb R1, [R0]
		bx		lr


delay: 	mov		i, #t

L1:		mov		j, #t		; outer loop

L2:		subs 	j, #0x01	; inner loop
		bne		L2

		subs	i, #0x01
		bne		L1
		bx		lr

loop:
		nop

		B loop
		.end
