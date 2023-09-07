extends Control

var player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_parent().get_parent().get_parent().get_parent()
	$HealthBar.max_value = player.data.MAX_HEALTH
	
	#$ProgressBar.value = player.data.MAX_HEALTH


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	
	var hpbar:ProgressBar = $HealthBar
	
	if player.health == player.data.MAX_HEALTH:
		hpbar.value = move_toward(hpbar.value, player.health, delta * 20.0)
	
	hpbar.value = lerp(hpbar.value,player.health, delta * 8.0)
	var perc = Main.toperc(hpbar.value,hpbar.max_value)
	
	$HealthBar/PercentageLabel.text = str(perc) + '%'
	
	$HealthBar/SpeedLabel.text = str(Main.fround(player.velocity.length(), 2)) 
	
	if player.is_dead:
		$deathstuff.visible = true
	else:
		$deathstuff.visible = false
	
