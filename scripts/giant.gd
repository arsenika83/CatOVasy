class_name Giant extends CharacterBody2D

var speed = 320
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var area = $Area2D
@onready var sprite = $Sprite

@onready var respawn_timer = $RespawnTimer
@onready var fall_timer = $FallTimer
@onready var walk_timer = $WalkTimer
@onready var take_damage_timer = $TakeDamageTimer
@onready var miss_damage_timer = $MissDamageTimer
@onready var idle_animation_timer = $IdleAnimationTimer

@onready var audio_meow = $AudioStreamPlayerMeow
@onready var audio_fall = $AudioStreamPlayerFall
@onready var audio_miss = $AudioStreamPlayerMiss
@onready var audio_resting = $AudioStreamPlayerResting

@onready var light = $PointLight2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	scale = Vector2(0, 0)
	spawn()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	check_fall(delta)
	check_hp()
	
	match gm.state:
		"idle":
			sprite.play("idle")
		"walking":
			if Input.is_action_just_pressed("ui_lmb"):
				audio_meow.pitch_scale = randf_range(0.7, 1.3)
				audio_meow.play()		
		"resting":
			sprite.play("resting")
		"falling":
			sprite.play("falling")
		"dead":
			sprite.play("dead")
		"battle":
			sprite.play("idle")
		"battle_attack":
			sprite.play("battle_attack")
		"battle_defend":
			sprite.play("battle_defend")
		"battle_ability":
			sprite.play("battle_ability")
			
	
	move_and_slide()

func spawn() -> void:
	match gm.state:
		"idle":
			var tween = create_tween()
			tween.tween_property(self, "scale", Vector2(1, 1), 0.5)
		"battle":
			var tween = create_tween()
			tween.tween_property(self, "scale", Vector2(1, 1), 0.5)
			sprite.flip_h = true

func respawn() -> void:
	gm.state = "idle"
	global_position = gm.prev_pos
	gm.hp -= 1

func fall() -> void:
	if not gm.state == "falling":
		gm.state = "falling"
		respawn_timer.start()
		audio_fall.play()

func walk() -> void:
	gm.state = "walking"
	walk_timer.start()

func go_downstairs() -> void:
	audio_fall.play()
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(0, 0), 0.5)

func deal_damage(target : Enemy, time : float) -> void:
	var success : bool = randf_range(0.0, 1.0) * 100 <= gm.accuracy
	
	if success:
		target.take_damage(gm.damage, time)
	else:
		target.take_damage(0, time)
		print("GIANT MISS! ")
		
func take_damage(damage : int, time : float) -> void:
	gm.hp -= damage
	
	if damage > 0:
		take_damage_timer.start(time)
	else:
		miss_damage_timer.start(time)

func check_fall(delta: float) -> void:
	if gm.state == "falling":
		z_index = -1
		#velocity.y += gravity * delta * 0.5
			
		scale.x -= 0.02
		scale.y -= 0.02
		
		rotation_degrees += 10
		if scale.x <= 0:
			scale.x = 0
			scale.y = 0
	elif gm.state == "idle":
		z_index = 3
		rotation_degrees = 0
		#velocity.y = 0
		scale.x += 0.04
		scale.y += 0.04
		
		if scale.x >= 1:
			scale.x = 1
			scale.y = 1

func check_hp() -> void:
	if gm.hp <= 0:
		gm.state = "dead"

func check_xp() -> void:
	$AudioStreamPlayerPickUpXP.pitch_scale = randf_range(0.8, 1.2)
	$AudioStreamPlayerPickUpXP.play()
	
	if gm.xp >= gm.xp_needed:
		gm.level += 1
		gm.xp = gm.xp - gm.xp_needed
		gm.xp_needed += 1
		
		gm.damage += 1
		$AudioStreamPlayerLevelUp.play()
		

func _on_area_2d_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	#fall_timer.start()
	pass

func _on_respawn_timer_timeout() -> void:
	respawn()

func _on_fall_timer_timeout() -> void:
	fall()

func _on_restart_timer_timeout() -> void:
	pass # Replace with function body.

func _on_walk_timer_timeout() -> void:
	if gm.state == "walking":
		gm.state = "idle"

func _on_take_damage_timer_timeout() -> void:
	check_hp()
	
	if not gm.state == "dead":
		gm.prev_state = gm.state
		gm.state = "taking_damage"
		sprite.play("take_damage")
		audio_meow.play()
		idle_animation_timer.start(0.2)
		get_parent().end_turn()
	else:
		audio_fall.play()
		sprite.play("dead")

func _on_idle_animation_timer_timeout() -> void:
	gm.state = gm.prev_state


func _on_miss_damage_timer_timeout() -> void:
	audio_miss.play()
	get_parent().end_turn()
