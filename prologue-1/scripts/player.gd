extends CharacterBody2D

# VARIABLE
var player_health = 100
var player_alive = true

var enemy_attack_cooldown = true
var enemy_attack_range = false

var attack_ip = false
var attack_dir_R = false
var attack_dir_L = false
var attack_dir_D = false
var attack_dir_U = false
var mashroom_attack_dir_R = false
var mashroom_attack_dir_L = false
var mashroom_attack_dir_D = false
var mashroom_attack_dir_U = false

const speed = 80
const attack_speed = 20
var current_dir = "none"
#--------------------------------------------------------------------------

# BASIC FUNCTION
func _ready() -> void:
	$AnimatedSprite2D.play("idle_front")
	$animated_sprite.visible = false
	current_camera()

func _physics_process(delta: float) -> void:
	plyer_movement(delta)
	attack()
	attack_dir()
	mashroom_attack_dir()
	enemy_attack()
	update_health()
	player_death()
	move_and_slide()
	
	#print(current_dir)
#--------------------------------------------------------------------------

# ATTACK
func attack():
	var dir = current_dir
	if Input.is_action_pressed("attack") and player_alive:
		global.player_attack = true
		attack_ip = true
		
		if dir == "right":
			$AnimatedSprite2D.flip_h = false
			$AnimatedSprite2D.play("attack_side")
			if velocity.x == speed:
				velocity.x = attack_speed
			$attack_timer.start()
		elif dir == "left":
			$AnimatedSprite2D.flip_h = true
			$AnimatedSprite2D.play("attack_side")
			if velocity.x == -speed:
				velocity.x = -attack_speed
			$attack_timer.start()
		elif dir == "down":
			#$AnimatedSprite2D.flip_h = false
			$AnimatedSprite2D.play("attack_front")
			if velocity.y == speed:
				velocity.y = attack_speed
			$attack_timer.start()
		elif dir == "up":
			#$AnimatedSprite2D.flip_h = false
			$AnimatedSprite2D.play("attack_back")
			if velocity.y == -speed:
				velocity.y = -attack_speed
			$attack_timer.start()
		else :
			#print("there2")
			$AnimatedSprite2D.play("attack_front")
			if velocity.y == speed:
				velocity.y = attack_speed
			$attack_timer.start()
#--------------------------------------------------------------------------

# ATTACK DIRECTION
func attack_dir():
	if attack_ip:
		if current_dir == "right" and attack_dir_R:
			global.enemy_well_placed = true
			#print("there")
		elif current_dir == "left" and attack_dir_L:
			global.enemy_well_placed = true
		elif current_dir == "down" and attack_dir_D:
			global.enemy_well_placed = true
		elif current_dir == "up" and attack_dir_U:
			global.enemy_well_placed = true
		else :
			global.enemy_well_placed = false
#--------------------------------------------------------------------------

# MASHROOM ATTACK DIRECTION
func mashroom_attack_dir():
	if attack_ip:
		if current_dir == "right" and mashroom_attack_dir_R:
			global.mashroom_well_placed = true
			#print("there")
		elif current_dir == "left" and mashroom_attack_dir_L:
			global.mashroom_well_placed = true
		elif current_dir == "down" and mashroom_attack_dir_D:
			global.mashroom_well_placed = true
		elif current_dir == "up" and mashroom_attack_dir_U:
			global.mashroom_well_placed = true
		else :
			global.mashroom_well_placed = false
#--------------------------------------------------------------------------

# MOVE
func plyer_movement(delta):
	if not attack_ip and player_alive:
		if Input.is_action_pressed("ui_right"):
			current_dir ="right"
			play_anim(1)
			velocity.x = speed
			velocity.y = 0
		elif Input.is_action_pressed("ui_left"):
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
			#print("there")
			velocity.x = 0
			velocity.y = 0
#--------------------------------------------------------------------------

# ATTACKED
func enemy_attack():
	if enemy_attack_range and enemy_attack_cooldown :
		player_health -= 25
		#print("en att:",player_health)
		enemy_attack_cooldown = false
		$attacked_cooldown.start()
#--------------------------------------------------------------------------

# DEATH
func player_death():
	if player_health <= 0 and player_alive:
		player_health = 0
		player_alive = false
		
		var p = $AnimatedSprite2D
		velocity = Vector2.ZERO
		p.play("death")
		#await p.animation_finished
		$timer_death.start()
		print("you died!")
#--------------------------------------------------------------------------


# HEALTH
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

# ANIMATION
func play_anim(movement):
	var dir = current_dir
	var anim = $AnimatedSprite2D
	
	if not attack_ip and player_alive:
		if dir == "right":
			anim.flip_h = false
			if movement == 1:
				anim.play("walk_side")
			else :
				anim.play("idle_side")
		elif dir == "left":
			anim.flip_h = true
			if movement == 1:
				anim.play("walk_side")
			else :
				anim.play("idle_side")
		elif dir == "down":
			#anim.flip_h = false
			if movement == 1:
				anim.play("walk_front")
			else :
				anim.play("idle_front")
		elif dir == "up":
			#anim.flip_h = false
			if movement == 1:
				anim.play("walk_back")
			else :
				anim.play("idle_back")
		else :
				anim.play("idle_front")
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
		#print("there")

func _on_hitbox_right_body_entered(body: Node2D) -> void:
	if body.has_method("enemy"):
		attack_dir_R = true
	if body.has_method("mashroom"):
		mashroom_attack_dir_R = true

func _on_hitbox_right_body_exited(body: Node2D) -> void:
	if body.has_method("enemy"):
		attack_dir_R = false
	if body.has_method("mashroom"):
		mashroom_attack_dir_R = false

func _on_hitbox_left_body_entered(body: Node2D) -> void:
	if body.has_method("enemy"):
		attack_dir_L = true
	if body.has_method("mashroom"):
		mashroom_attack_dir_L = true

func _on_hitbox_left_body_exited(body: Node2D) -> void:
	if body.has_method("enemy"):
		attack_dir_L = false
	if body.has_method("mashroom"):
		mashroom_attack_dir_L = false

func _on_hitbox_down_body_entered(body: Node2D) -> void:
	if body.has_method("enemy"):
		attack_dir_D = true
	if body.has_method("mashroom"):
		mashroom_attack_dir_D = true

func _on_hitbox_down_body_exited(body: Node2D) -> void:
	if body.has_method("enemy"):
		attack_dir_D = false
	if body.has_method("mashroom"):
		mashroom_attack_dir_D = false

func _on_hitbox_up_body_entered(body: Node2D) -> void:
	if body.has_method("enemy"):
		attack_dir_U = true
	if body.has_method("mashroom"):
		mashroom_attack_dir_U = true

func _on_hitbox_up_body_exited(body: Node2D) -> void:
	if body.has_method("enemy"):
		attack_dir_U = false
	if body.has_method("mashroom"):
		mashroom_attack_dir_U = false
#--------------------------------------------------------------------------



# TIMER
func _on_attacked_cooldown_timeout() -> void:
	$attacked_cooldown.stop()
	enemy_attack_cooldown = true

func _on_attack_timer_timeout() -> void:
	$attack_timer.stop()
	global.player_attack = false
	attack_ip = false
	#print("attack fin")

func _on_health_reg_timer_timeout() -> void:
	if player_health <= 100 and player_alive:
		player_health += 15
		if player_health >=100:
			player_health = 100
	elif player_health <= 0:
		player_health = 0

func _on_timer_death_timeout() -> void:
	self.queue_free()
#--------------------------------------------------------------------------
