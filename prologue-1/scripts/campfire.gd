extends CharacterBody2D

# VARIABLE
#--------------------------------------------------------------------------




# BASIC
func _ready() -> void:
	$AnimatedSprite2D.play("default")

func _physics_process(delta: float) -> void:
	pass
#--------------------------------------------------------------------------
