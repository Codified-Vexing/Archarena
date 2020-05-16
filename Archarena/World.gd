extends Spatial
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	
func _input(event):
	if event.is_action_pressed("ui_cancel"):
		if get_tree().paused:
			get_tree().paused = false
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			get_tree().paused = true
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
#	if event.is_action_type():
#		$Bottomrock.translation.x = G.hero.translation.x
#		$Bottomrock.translation.z = G.hero.translation.z
