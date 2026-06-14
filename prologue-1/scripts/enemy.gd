extends CharacterBody2D

# VARIABLE
var speed = 50
var health = 100
var enemy_alive = true

var is_chasing = false
var player = null
var vector_chase = Vector2.ZERO

var idle = true
var idle_speed = 20
var rand_dir = Vector2.ZERO
var idle_walking = false
var idle_stop = true

var player_attack_range = false
var can_take_damege = true
#--------------------------------------------------------------------------

# BASIC
func _ready() -> void:
	is_chasing = false
	$AnimatedSprite2D.play("idle_front")

func _physics_process(delta: float) -> void:
	deal_with_demage()
	update_health()
	enemy_death()
	
	rand_direction()
	idle_animate()
	idle_walk()
	
	chase_animation()
	chasing()
	
	move_and_slide()
#--------------------------------------------------------------------------

# CHASE
func chasing():
	if is_chasing and enemy_alive:
		var distance = position.distance_to(player.position)
		if distance >= 12:
			vector_chase = (player.position - position).normalized()
			velocity = vector_chase * speed
#--------------------------------------------------------------------------

# DEMAGE
func deal_with_demage():
	if player_attack_range and global.player_attack and global.enemy_well_placed and enemy_alive:
		if can_take_damege:
			$attacked_cooldown.start()
			can_take_damege = false
			
			health -= 35
			print("enemy hp:", health)
#--------------------------------------------------------------------------

# DEATH
func enemy_death():
	if health <= 0 and enemy_alive:
		velocity = Vector2.ZERO
		var sp = $AnimatedSprite2D
		sp.play("death")
		#await sp.animation_finished
		enemy_alive = false
		$timer_death.start()
		print("enemy died")
#--------------------------------------------------------------------------

# HEALTH
func update_health():
	var hb = $HealthBar
	hb.value = health
	
	if hb.value >= 100:
		hb.visible = false
	else :
		hb.visible = true
#--------------------------------------------------------------------------

# IDLE WALK
func rand_direction():
	if idle and not idle_walking and enemy_alive:
		var rd_time = randf_range(1,3)
		$timer_direction.wait_time = rd_time + randf_range(1,3)
		$timer_walk.wait_time = rd_time
		$timer_direction.start()
		$timer_walk.start()
		rand_dir = Vector2(randf_range(-10,10),randf_range(-10,10)).normalized()
		idle_walking = true
		idle_stop = false
		#print("there")

func idle_walk():
	if idle and not idle_stop and enemy_alive:
		velocity = rand_dir * idle_speed
	else :
		velocity = Vector2.ZERO
#--------------------------------------------------------------------------


# ANIMATE
func idle_animate():
	if not is_chasing and enemy_alive:
		if abs(rand_dir.x) > abs(rand_dir.y):
			$AnimatedSprite2D.play("walk_side")
			if rand_dir.x < 0 :
				$AnimatedSprite2D.flip_h = true
			else:
				$AnimatedSprite2D.flip_h = false
		
		if abs(rand_dir.x) < abs(rand_dir.y):
			if rand_dir.y < 0 :
				$AnimatedSprite2D.play("walk_back")
			else:
				$AnimatedSprite2D.play("walk_front")

func chase_animation():
	if is_chasing and enemy_alive:
		if abs(vector_chase.x) > abs(vector_chase.y):
			if $AnimatedSprite2D.animation != "run_side":
				$AnimatedSprite2D.play("run_side")
			if vector_chase.x < 0 :
				$AnimatedSprite2D.flip_h = true
			else:
				$AnimatedSprite2D.flip_h = false
		
		if abs(vector_chase.x) < abs(vector_chase.y):
			if vector_chase.y < 0 :
				if $AnimatedSprite2D.animation != "run_back":
					$AnimatedSprite2D.play("run_back")
			else:
				if $AnimatedSprite2D.animation != "run_front":
					$AnimatedSprite2D.play("run_front")
#--------------------------------------------------------------------------


# MARK
func enemy():
	pass
#--------------------------------------------------------------------------


# SIGNAL
func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player = body
		is_chasing = true

func _on_detection_area_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		player = null
		is_chasing = false

func _on_player_attack_range_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player_attack_range = true

func _on_player_attack_range_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		player_attack_range = false

#--------------------------------------------------------------------------

# TIMER
func _on_attacked_cooldown_timeout() -> void:
	$attacked_cooldown.stop()
	can_take_damege = true

func _on_timer_direction_timeout() -> void:
	idle_walking = false

func _on_timer_walk_timeout() -> void:
	idle_stop = true

func _on_timer_death_timeout() -> void:
	self.queue_free()
#--------------------------------------------------------------------------
