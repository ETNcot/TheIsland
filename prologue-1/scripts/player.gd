extends CharacterBody2D

# VARIABLE
var player_health = 100
var player_alive = true
var enemy_attack_cooldown = true
var enemy_attack_range = false

var attack_ip = false

const speed = 80
var current_dir = "none"
#--------------------------------------------------------------------------

# BASIC FUNCTION
func _ready() -> void:
	$AnimatedSprite2D.play("idle_front")
	current_camera()

func _physics_process(delta: float) -> void:
	plyer_movement(delta)
	attack()
	enemy_attack()
	update_health()
	
	if $HealthBar.value <= 0:
		player_health = 0
		player_alive = false
		$AnimatedSprite2D.play("died")
		self.queue_free()
		print("you died!")
#--------------------------------------------------------------------------

# BEHAVIOR
func attack():
	var dir = current_dir
	
	if Input.is_action_pressed("attack"):
		global.player_attack = true
		attack_ip = true
		
		if dir == "right":
			$attack_timer.start()
			$AnimatedSprite2D.flip_h = false
			$AnimatedSprite2D.play("attack_side")
		elif dir == "left":
			$attack_timer.start()
			$AnimatedSprite2D.flip_h = true
			$AnimatedSprite2D.play("attack_side")
		elif dir == "down":
			$attack_timer.start()
			$AnimatedSprite2D.flip_h = false
			$AnimatedSprite2D.play("attack_front")
		elif dir == "up":
			$attack_timer.start()
			$AnimatedSprite2D.flip_h = false
			$AnimatedSprite2D.play("attack_back")

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
	
	if dir == "right" and not attack_ip:
		anim.flip_h = false
		if movement == 1:
			anim.play("walk_side")
		else :
			anim.play("idle_side")
			
	if dir == "left" and not attack_ip:
		anim.flip_h = true
		if movement == 1:
			anim.play("walk_side")
		else :
			anim.play("idle_side")
			
	if dir == "down" and not attack_ip:
		anim.flip_h = false
		if movement == 1:
			anim.play("walk_front")
		else :
			anim.play("idle_front")
			
	if dir == "up" and not attack_ip:
		anim.flip_h = false
		if movement == 1:
			anim.play("walk_back")
		else :
			anim.play("idle_back")

func enemy_attack():
	if enemy_attack_range and enemy_attack_cooldown:
		player_health -= 25
		#print("en att:",player_health)
		enemy_attack_cooldown = false
		$attacked_cooldown.start()

func update_health():
	var health = $HealthBar
	health.value = player_health
	
	#print("up,h v:", health.value)
	#print("up,p h", player_health)
	
	if health.value >= 100 :
		health.visible = false
	else :
		health.visible = true
#--------------------------------------------------------------------------

# CAMERA
func current_camera():
	if global.current_scene == "world":
		$Camera_world.enabled = true
		$Camera_camp.enabled = false
		print("camera: world")
	elif global.current_scene == "camp":
		$Camera_world.enabled = false
		$Camera_camp.enabled = true
		print("camera: camp")
#--------------------------------------------------------------------------


# MARK
func player():
	pass
#--------------------------------------------------------------------------


# SIGNAL
func _on_player_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("enemy"):
		enemy_attack_range = true

func _on_player_hitbox_body_exited(body: Node2D) -> void:
	if body.has_method("enemy"):
		enemy_attack_range = false
#--------------------------------------------------------------------------



# TIMER
func _on_attacked_cooldown_timeout() -> void:
	$attacked_cooldown.stop()
	enemy_attack_cooldown = true

func _on_attack_timer_timeout() -> void:
	$attack_timer.stop()
	global.player_attack = false
	attack_ip = false

func _on_health_reg_timer_timeout() -> void:
	if player_health <= 100:
		player_health += 15
		if player_health >=100:
			player_health = 100
	elif player_health <= 0:
		player_health = 0
#--------------------------------------------------------------------------
