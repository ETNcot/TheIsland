extends Node2D

# BASIC
func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	change_scene()

#--------------------------------------------------------------------------

# SCENE
func change_scene():
	if global.trans_scene:
		if global.current_scene == "camp":
			get_tree().change_scene_to_file("res://scenes/world.tscn")
			global.finish_change_scene()
#--------------------------------------------------------------------------


# SIGNAL
func _on_world_exit_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		global.trans_scene = true
#--------------------------------------------------------------------------
