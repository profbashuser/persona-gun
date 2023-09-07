extends Node



func fround(x, n = 0) -> float:
	n = pow(10, n)
	x = x * n
	if x >= 0: x = floor(x + 0.5)
	else: x = ceil(x - 0.5)
	return x/n

func toperc(val, max):
	return floor((val / max) * 100)

#func arrayrem(arr: Array, i:int) -> Array:
	#var array:Array = arr
	#arr.remove(i)
	#return arr

#func _process(delta: float) -> void:
#	if root is Node3D:
#		get_tree().call_group("Enemy", "set_target", get_node("Player"))
