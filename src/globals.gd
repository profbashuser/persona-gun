extends Node


var VIEWMODEL_FOV:float = 70
var FOV:float = 110

func _process(_delta: float) -> void:
	RenderingServer.global_shader_parameter_set("viewmodel_fov", VIEWMODEL_FOV)
