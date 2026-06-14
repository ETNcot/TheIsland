extends Node

# VARIABLE
var current_scene = "world"
var is_first_load = true
var trans_scene = false

var mashroom_chunks = 0

var init_posx = 140
var init_posy = 125

var enter_posx = 165
var enter_posy = 235

var player_attack = false
var enemy_well_placed = false
var mashroom_well_placed = false
#--------------------------------------------------------------------------

# BASIC
func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	pass
#--------------------------------------------------------------------------


# SCENE
func finish_change_scene():
	trans_scene = false
	if current_scene == "world":
		current_scene = "camp"
	else :
		current_scene = "world"
#--------------------------------------------------------------------------
