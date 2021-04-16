start:
	mov cr, 10
	mov br, 500
	mov ar, 1
again:
	store br
	add ar, 1
	sub cr, 1

	jz cr, again
	stop
