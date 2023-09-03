extends Node


func fround(x, n = 0) -> float:
	n = pow(10, n)
	x = x * n
	if x >= 0: x = floor(x + 0.5)
	else: x = ceil(x - 0.5)
	return x/n
