extends CharacterBody2D

# VARIABLE
var speed = 50
var health = 100

var is_chasing = false
var player = null

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
	#chasing()
	deal_with_deamge()
	update_health()
	rand_direction()
	idle_walk()
	idle_animate()
#--------------------------------------------------------------------------

# BEHAVIOR
func chasing():
	if is_chasing:
		#print("player chase")
		position += (player.position - position) / speed
		if player.position.x - position.x < 0 :
			$AnimatedSprite2D.flip_h = true
		else :
			$AnimatedSprite2D.flip_h = false
		$AnimatedSprite2D.play("walk_side")
			
	else :
		#print("idle")
		$AnimatedSprite2D.flip_h = false
		$AnimatedSprite2D.play("idle_front")
	
	move_and_slide()

func deal_with_deamge():
	if player_attack_range and global.player_attack:
		if can_take_damege:
			$attacked_cooldown.start()
			can_take_damege = false
			
			health -= 35
			print("enemy hp:", health)
			if health <=0:
				$AnimatedSprite2D.play("died")
				self.queue_free()

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
	if idle:
		rand_dir = Vector2(randf_range(-10,10),randf_range(-10,10)).normalized()
		idle_walking = true

func idle_walk():
	if idle and not idle_stop:
		velocity = rand_dir * idle_speed
	else :
		velocity = Vector2.ZERO
#--------------------------------------------------------------------------


# ANIMATE
func idle_animate():
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
		player_attack_range = true

#--------------------------------------------------------------------------

# TIMER
func _on_attacked_cooldown_timeout() -> void:
	$attacked_cooldown.stop()
	can_take_damege = true
#--------------------------------------------------------------------------
