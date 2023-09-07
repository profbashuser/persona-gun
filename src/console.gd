extends Control

var vis = false

const enemy = preload("res://scenes/enemyTest.tscn")

func _ready() -> void:
	$Label.text = ""
	

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("console"):
		vis = !vis
		$LineEdit.text = ""
	
	if vis:
		$LineEdit.grab_focus()
		
		if Input.is_action_just_pressed("enter"):
			var text: PackedStringArray = $LineEdit.text.split(" ")
			
			for i in get_method_list():
				if (i["name"] == text[0]) && !(text[0].begins_with("_")):
					call_deferred(text[0], text)
			
			$LineEdit.text = ""
			print(text)
	
	visible = vis
	

func trace(args):
	if typeof(args) == TYPE_ARRAY:
		for i in range(args.size()):
			var item = args[i]
			if i != 0:
				$Label.text += item + " "
	elif typeof(args) == TYPE_STRING:
		$Label.text += args + " "
	$Label.text += "\n"

func spawn(args):
	if len(args) == 4:
		
		var instance = enemy.instantiate()

		instance.position = Vector3(
			float(args[1]),
			float(args[2]) + 1,
			float(args[3])
		)
		
		get_tree().current_scene.add_child(instance)
		trace("enemy spawned at " + str(Vector3(
			float(args[1]),
			float(args[2]),
			float(args[3])
		)))

func cls(_args):
	$Label.text = ""
	
