		.global main
		.data
		.text
main:
		movw R0, #0x4C04 // P1DIR
		movt R0, #0x4000 // P1DIR
		mov	R1, #0x01
		strb R1, [R0]

		movw R0, #0x4C05 // P2DIR
		movt R0, #0x4000 // P2DIR
		mov R1, #0x01
		strb R1, [R0]

		movw R0, #0x4C02 // P1OUT --> OFF
		movt R0, #0x4000 // P1OUT --> OFF
		mov R1, #0x00
		strb R1, [R0]

		movw R0, #0x4C03 // P2OUT --> OFF
		movt R0, #0x4000 // P2OUT --> OFF
		mov R1, #0x00
		strb R1, [R0]

loop:
		nop

		B loop
		.end


