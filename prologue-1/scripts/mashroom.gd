extends CharacterBody2D


# VARIABLE
var health = 100

var collect = false

var player_attack_range = false
#--------------------------------------------------------------------------


# BASIC
func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	attacked()
#--------------------------------------------------------------------------

# ATTACKED
func attacked():
	if player_attack_range and global.player_attack and global.mashroom_well_placed:
		$AnimatedSprite2D.play("default")
		$Timer.start()
	if collect:
		global.mashroom_chunks += 3
		self.queue_free()
#--------------------------------------------------------------------------

# MARK
func mashroom():
	pass
#--------------------------------------------------------------------------


# SIGNAL
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player_attack_range = true
		#print("there")


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		player_attack_range = false
#--------------------------------------------------------------------------

# TIMER
func _on_timer_timeout() -> void:
	collect = true
#--------------------------------------------------------------------------
