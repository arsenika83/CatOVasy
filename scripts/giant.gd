class_name Giant extends CharacterBody2D

@onready var area = $Area2D
@onready var sprite = $Sprite
@onready var status_fx = $StatusFX

@onready var respawn_timer = $RespawnTimer
@onready var fall_timer = $FallTimer
@onready var walk_timer = $WalkTimer
@onready var deal_damage_timer = $DealDamageTimer
@onready var take_damage_timer = $TakeDamageTimer
@onready var miss_damage_timer = $MissDamageTimer
@onready var idle_animation_timer = $IdleAnimationTimer
@onready var defend_timer = $DefendTimer
@onready var debuff_timer = $DebuffTimer

@onready var audio_meow = $AudioStreamPlayerMeow
@onready var audio_fall = $AudioStreamPlayerFall
@onready var audio_miss = $AudioStreamPlayerMiss
@onready var audio_resting = $AudioStreamPlayerResting
@onready var audio_defend = $AudioStreamPlayerDefend
@onready var audio_hit = $AudioStreamPlayerHit
@onready var audio_hit_lucky = $AudioStreamPlayerHitLucky
@onready var audio_debuff = $AudioStreamPlayerDebuff

@onready var light = $PointLight2D


func _ready() -> void:
	scale = Vector2(0, 0)
	spawn()

func _process(delta: float) -> void:
	check_fall(delta)
	check_hp()
	
	match gm.state:
		"idle":
			sprite.play("idle")
		"walking":
			if Input.is_action_just_pressed("ui_lmb"):
				var do_meow = randf_range(0.0, 1.0) <= 0.2
				if do_meow:
					audio_meow.pitch_scale = randf_range(0.7, 0.9)
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
			pass
			#sprite.play("battle_attack")
		"battle_defend":
			pass
			#sprite.play("battle_defend")
		"battle_ability":
			pass
			#sprite.play("battle_ability")
			
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

func deal_damage(target : Enemy) -> void:
	var success : bool = randf_range(0.0, 1.0) * 100 <= gm.current_accuracy
	var luck_success : bool = randf_range(0.0, 1.0) * 100 <= gm.current_luck
	gm.current_target = target
	
	if success:
		if luck_success:
			status_fx.scale = Vector2(0, 0)
			status_fx.play("lucky")
			var tween1 = create_tween()
			status_fx.visible = true
			
			var tween = create_tween()
			tween.tween_property(status_fx, "scale", Vector2(1, 1), 0.2)
			
			gm.current_damage = gm.damage * 2
	else:
		gm.current_damage = 0
		print("MISS! ")
	
	sprite.play("deal_damage")
	deal_damage_timer.start(gm.attack_animation_time)

func take_damage(dmg : int, time : float) -> void:
	if gm.current_defence - dmg >= 0:
		gm.current_defence -= dmg
		if dmg > 0:
			gm.defended = true
		dmg = 0
	else:
		dmg -= gm.current_defence
		gm.current_defence = 0
		
	gm.hp -= dmg
	
	if dmg > 0:
		take_damage_timer.start(time)
	else:
		if gm.defended:
			audio_defend.play()
			status_fx.play("defended")
			var tween1 = create_tween()
			tween1.tween_property(status_fx, "modulate:a", 1.0, 0.1)
			
			var tween = create_tween()
			tween.tween_property(status_fx, "scale", Vector2(1, 1), 0.2)
		
			gm.defended = false
		else:
			audio_miss.play()
		
		miss_damage_timer.start(time)

func defend(time : float) -> void:
	gm.current_defence += gm.defence
	
	if gm.current_defence > gm.max_defence:
		gm.current_defence = gm.max_defence
	
	status_fx.scale = Vector2(0, 0)
	status_fx.play("defend")
	status_fx.visible = true
	
	var tween2 = create_tween()
	tween2.tween_property(status_fx, "scale", Vector2(1, 1), 0.2)
	
	if gm.damage > 0:
		defend_timer.start(time)
	else:
		defend_timer.start(time)

func give_debuff(target : Enemy, type : String, power : int, turns : int) -> void:
	status_fx.scale = Vector2(0, 0)
	status_fx.play("debuff")
	var tween1 = create_tween()
	tween1.tween_property(status_fx, "modulate:a", 1.0, 0.1)
	var tween = create_tween()
	tween.tween_property(status_fx, "scale", Vector2(1, 1), 0.2)
	gm.current_target = target
	
	gm.current_target.status_fx.play("debuff_" + type)
	
	match type:
		"weakness":
			gm.current_target.has_debuff_weakness = true
			
			gm.current_target.current_damage -= power
			if gm.current_target.current_damage <= 0:
				gm.current_target.current_damage = 0
		"undefend":
			gm.current_target.has_debuff_undefend = true
			
			gm.current_target.current_defence -= power
			if gm.current_target.current_defence <= 0:
				gm.current_target.current_defence = 0
		"inaccuracy":
			gm.current_target.has_debuff_inaccuracy = true
			gm.current_target.current_accuracy -= power
			if gm.current_target.current_accuracy  <= 10:
				gm.current_target.current_accuracy  = 10
		"unluck":
			gm.current_target.has_debuff_unluck = true
			gm.current_target.current_luck -= power
			if gm.current_target.current_luck <= -100:
				gm.current_target.current_luck  = -100
		"low_energy":
			gm.current_target.has_debuff_low_energy = true
			gm.current_target.energy -= power
			if gm.current_target.energy <= 0:
				gm.current_target.energy = 0
		
	var tween2 = create_tween()
	tween2.tween_property(gm.current_target.status_fx, "modulate:a", 1.0, 0.1)		
	var tween3 = create_tween()
	tween3.tween_property(gm.current_target.status_fx, "scale", Vector2(1, 1), 0.2)	
	debuff_timer.start(gm.debuff_animation_time)	

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
	print(gm.state, " -> ", gm.prev_state)
	gm.state = gm.prev_state
	sprite.play(gm.state)

func _on_miss_damage_timer_timeout() -> void:
	var tween = create_tween()
	tween.tween_property(status_fx, "scale", Vector2(0, 0), 0.2)
	get_parent().end_turn()

func _on_deal_damage_timer_timeout() -> void:
	if gm.current_damage > gm.damage:
		audio_hit_lucky.play()
		var tween = create_tween()
		tween.tween_property(status_fx, "scale", Vector2(0, 0), 0.2)
	else:
		audio_hit.play()
	get_parent().claw_fx.position = gm.current_target.position
	get_parent().claw_fx.play("hit")
	
	gm.current_target.take_damage(gm.current_damage, gm.attack_animation_time)
	gm.current_damage = gm.damage
	idle_animation_timer.start(0.2)

func _on_defend_timer_timeout() -> void:
	audio_defend.play()
	#idle_animation_timer.start(0.2)
	var tween = create_tween()
	tween.tween_property(status_fx, "scale", Vector2(0, 0), 0.2)
	
	get_parent().end_turn()

func _on_debuff_timer_timeout() -> void:
	var tween = create_tween()
	tween.tween_property(status_fx, "scale", Vector2(0, 0), 0.2)
	var tween1 = create_tween()
	tween1.tween_property(gm.current_target.status_fx, "scale", Vector2(0, 0), 0.2)
	get_parent().end_turn()
