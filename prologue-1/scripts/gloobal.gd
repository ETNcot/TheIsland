extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


var current_scene = "world"
var is_first_load = true
var trans_scene = false

var init_posx = 140
var init_posy = 125

var enter_posx = 165
var enter_posy = 235


func finish_change_scene():
	trans_scene = false
	if current_scene == "world":
		current_scene = "camp"
	else :
		current_scene = "world"
