extends CharacterBody2D


const speed = 80
var current_dir = "none"


func _ready() -> void:
	$AnimatedSprite2D.play("idle_front")
	current_camera()

func _physics_process(delta: float) -> void:
	plyer_movement(delta)

func plyer_movement(delta):
	if Input.is_action_pressed("ui_right"):
		current_dir ="right"
		play_anim(1)
		velocity.x = speed
		velocity.y = 0
	elif  Input.is_action_pressed("ui_left"):
		current_dir ="left"
		play_anim(1)
		velocity.x = - speed
		velocity.y = 0
	elif Input.is_action_pressed("ui_down"):
		current_dir ="down"
		play_anim(1)
		velocity.y = speed
		velocity.x = 0
	elif Input.is_action_pressed("ui_up"):
		current_dir ="up"
		play_anim(1)
		velocity.y = - speed
		velocity.x = 0
	else:
		play_anim(0)
		velocity.x = 0
		velocity.y = 0
	
	move_and_slide()
	
func play_anim(movement):
	var dir = current_dir
	var anim = $AnimatedSprite2D
	
	if dir == "right":
		anim.flip_h = false
		if movement == 1:
			anim.play("walk_side")
		else :
			anim.play("idle_side")
			
	if dir == "left":
		anim.flip_h = true
		if movement == 1:
			anim.play("walk_side")
		else :
			anim.play("idle_side")
			
	if dir == "down":
		anim.flip_h = false
		if movement == 1:
			anim.play("walk_front")
		else :
			anim.play("idle_front")
			
	if dir == "up":
		anim.flip_h = false
		if movement == 1:
			anim.play("walk_back")
		else :
			anim.play("idle_back")

func current_camera():
	if global.current_scene == "world":
		$Camera_world.enabled = true
		$Camera_camp.enabled = false
	elif global.current_scene == "camp":
		$Camera_world.enabled = false
		$Camera_camp.enabled = true
		

func player():
	pass
