extends Node2D


# BASIC FUNCTION
func _ready() -> void:
	if global.is_first_load:
		$player.position.x = global.init_posx
		$player.position.y = global.init_posy
		global.is_first_load = false
	else :
		$player.position.x = global.enter_posx
		$player.position.y = global.enter_posy


func _process(delta: float) -> void:
	change_scene()
#--------------------------------------------------------------------------


# SCENE
func change_scene():
	if global.trans_scene:
		if global.current_scene == "world":
			get_tree().change_scene_to_file("res://scenes/camp.tscn")
			global.finish_change_scene()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		global.trans_scene = true
#--------------------------------------------------------------------------
