class_name Giant extends CharacterBody2D

@export var damage_indicator_scene: PackedScene
@onready var area = $Area2D
@onready var sprite = $Sprite
@onready var status_fx = $StatusFX
@onready var my_turn = $MyTurn
@onready var artifact_sprite = $ArtifactSprite

@onready var respawn_timer = $RespawnTimer
@onready var fall_timer = $FallTimer
@onready var walk_timer = $WalkTimer
@onready var deal_damage_timer = $DealDamageTimer
@onready var take_damage_timer = $TakeDamageTimer
@onready var miss_damage_timer = $MissDamageTimer
@onready var idle_animation_timer = $IdleAnimationTimer
@onready var defend_timer = $DefendTimer
@onready var debuff_timer = $DebuffTimer

@onready var audio_walk = $AudioStreamPlayerWalk
@onready var audio_meow = $AudioStreamPlayerMeow
@onready var audio_fall = $AudioStreamPlayerFall
@onready var audio_miss = $AudioStreamPlayerMiss
@onready var audio_resting = $AudioStreamPlayerResting
@onready var audio_defend = $AudioStreamPlayerDefend
@onready var audio_hit = $AudioStreamPlayerHit
@onready var audio_hit_lucky = $AudioStreamPlayerHitLucky
@onready var audio_debuff = $AudioStreamPlayerDebuff

@onready var light = $PointLight2D

var current_heal = 0
var attack_count = 0
var taken_damage = 0
var is_hit_lucky = false
var just_missed = false

var has_debuff_weakness = false
var has_debuff_undefend = false
var has_debuff_inaccuracy = false
var has_debuff_unluck = false
var has_debuff_low_energy = false

var turns_debuff_weakness = 0
var turns_debuff_undefend = 0
var turns_debuff_inaccuracy = 0
var turns_debuff_unluck = 0
var turns_debuff_low_energy = 0

var has_buff_strength = false
var has_buff_defend = false
var has_buff_accuracy = false
var has_buff_luck = false
var has_buff_high_energy = false

var turns_buff_strength = 0
var turns_buff_defend = 0
var turns_buff_accuracy = 0
var turns_buff_luck = 0
var turns_buff_high_energy = 0

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
				var do_meow = randf_range(0.0, 1.0) <= 0.05
				if do_meow:
					audio_meow.pitch_scale = randf_range(0.7, 0.9)
					audio_meow.play()
				audio_meow.pitch_scale = randf_range(0.8, 1.2)
				audio_walk.play()	
		"resting":
			sprite.play("resting")
		"falling":
			sprite.play("falling")
		"dead":
			sprite.play("dead")
		#"battle":
			#sprite.play("idle")
		"battle_attack":
			pass
			#sprite.play("battle_attack")
		"battle_defend":
			pass
			#sprite.play("battle_defend")
		"battle_ability":
			pass
			#sprite.play("battle_ability")
			

func spawn() -> void:
	match gm.state:
		"idle":
			var tween = create_tween()
			tween.tween_property(self, "scale", Vector2(1, 1), 0.5)
		"battle":
			scale = Vector2(1, 1)
			sprite.flip_h = true

func respawn() -> void:
	gm.state = "idle"
	global_position = gm.prev_pos
	gm.hp_cat -= 10

func fall() -> void:
	if not gm.state == "falling":
		gm.state = "falling"
		respawn_timer.start()
		audio_fall.play()

func walk() -> void:
	gm.state = "walking"
	walk_timer.start()

func heal(hp : int) -> void:
	gm.prev_state = gm.state
	gm.state = "healing"
	
	if gm.has_heart_shaped_pillow:
		hp += 1
	
	current_heal = hp
	sprite.play("healing")
	audio_resting.play()
	$HealTimer.start()

func go_downstairs() -> void:
	audio_fall.play()
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(0, 0), 0.5)

func deal_damage(targets : Array[CharacterBody2D]) -> void:
	is_hit_lucky = false
	just_missed = false
	var energy_cost = gm.current_card.energy_cost
	if gm.current_energy_cat - energy_cost < 0:
		return
	gm.current_energy_cat -= energy_cost
	
	var tween2 = create_tween()
	tween2.tween_property(sprite, "position:x", sprite.position.x + 4, 0.1)
	gm.current_targets = targets
	
	for target in targets:
		var success : bool = randf_range(0.0, 1.0) * 100 <= gm.current_accuracy_cat
		var luck_success : bool = randf_range(0.0, 1.0) * 100 <= gm.current_luck_cat
		
		if success:
			gm.current_damage_cat = gm.current_card.damage
			
			if gm.has_toy_cat and attack_count < 2:
				gm.current_damage_cat *= 2
				print("TOY CAAAAAAT")
				
			if luck_success:
				is_hit_lucky = true
				status_fx.scale = Vector2(0, 0)
				status_fx.play("lucky")
				var tween1 = create_tween()
				status_fx.visible = true
				
				var tween = create_tween()
				tween.tween_property(status_fx, "scale", Vector2(1, 1), 0.2)
				
				gm.current_damage_cat *= 2
		else:
			just_missed = true
			gm.current_damage_cat = 0
			print("GIANT MISS! ")
	
	#get_parent().find_child("UI").find_child("CardContainer").replace_current_card("attack")
	sprite.play("deal_damage")
	
	attack_count += 1
	
	deal_damage_timer.start(gm.attack_animation_time_cat)

func take_damage(dmg : int, time : float) -> void:
	if gm.current_defence_cat - dmg >= 0:
		gm.current_defence_cat -= dmg
		if dmg > 0:
			gm.defended_cat = true
		dmg = 0
	else:
		dmg -= gm.current_defence_cat
		gm.current_defence_cat = 0
	
	taken_damage = dmg
	
	if dmg > 0:
		take_damage_timer.start(time)
	else:
		if gm.defended_cat:
			audio_defend.play()
			status_fx.play("defended")
			var tween1 = create_tween()
			tween1.tween_property(status_fx, "modulate:a", 1.0, 0.1)
			
			var tween = create_tween()
			tween.tween_property(status_fx, "scale", Vector2(1, 1), 0.2)
		
			gm.defended_cat = false
		else:
			audio_miss.play()
		
		miss_damage_timer.start(time)

func defend(time : float) -> void:
	var energy_cost = gm.current_card.energy_cost
	if gm.current_energy_cat - energy_cost < 0:
		return
	
	gm.current_energy_cat -= energy_cost
	
	gm.current_defence_cat += gm.defence_cat
	
	if gm.current_defence_cat > gm.max_defence_cat:
		gm.current_defence_cat = gm.max_defence_cat
	
	status_fx.scale = Vector2(0, 0)
	status_fx.play("defend")
	status_fx.visible = true
	
	var tween2 = create_tween()
	tween2.tween_property(status_fx, "scale", Vector2(1, 1), 0.2)
	
	if gm.damage_cat > 0:
		defend_timer.start(time)
	else:
		defend_timer.start(time)

func give_debuff(targets : Array[CharacterBody2D], type : String, power : int, turns : int) -> void:
	var energy_cost = gm.current_card.energy_cost
	if gm.current_energy_cat - energy_cost < 0:
		return
	
	gm.current_energy_cat -= energy_cost
	
	status_fx.scale = Vector2(0, 0)
	status_fx.play("debuff")

	status_fx.visible = true
	var tween = create_tween()
	tween.tween_property(status_fx, "scale", Vector2(1, 1), 0.2)
	gm.current_targets = targets
	
	gm.current_targets[0].status_fx.play("debuff_" + type)
	
	match type:
		"weakness":
			gm.current_targets[0].has_debuff_weakness = true
			gm.current_targets[0].turns_debuff_weakness += turns
			gm.current_targets[0].current_damage -= power
			if gm.current_targets[0].current_damage <= 0:
				gm.current_targets[0].current_damage = 0
		"undefend":
			gm.current_targets[0].has_debuff_undefend = true
			gm.current_targets[0].turns_debuff_undefend += turns
			gm.current_targets[0].current_defence -= power
			if gm.current_targets[0].current_defence <= 0:
				gm.current_targets[0].current_defence = 0
		"inaccuracy":
			gm.current_targets[0].has_debuff_inaccuracy = true
			gm.current_targets[0].turns_debuff_inaccuracy += turns
			gm.current_targets[0].current_accuracy -= power
			if gm.current_targets[0].current_accuracy  <= 10:
				gm.current_targets[0].current_accuracy  = 10
		"unluck":
			gm.current_targets[0].has_debuff_unluck = true
			gm.current_targets[0].turns_debuff_unluck += turns
			gm.current_targets[0].current_luck -= power
			if gm.current_targets[0].current_luck <= -100:
				gm.current_targets[0].current_luck  = -100
		"low_energy":
			gm.current_targets[0].has_debuff_low_energy = true
			gm.current_targets[0].turns_debuff_low_energy += turns
			gm.current_targets[0].energy -= power
			if gm.current_targets[0].energy <= 0:
				gm.current_targets[0].energy = 0
		
	gm.current_targets[0].status_fx.visible = true
	#get_parent().find_child("UI").find_child("CardContainer").replace_current_card("ability")
	var tween3 = create_tween()
	tween3.tween_property(gm.current_targets[0].status_fx, "scale", Vector2(1, 1), 0.2)	
	debuff_timer.start(gm.debuff_animation_time)

func turn_tick() -> void:
	#gm.current_defence /= 2
	if has_debuff_weakness:
		turns_debuff_weakness -= 1
		if turns_debuff_weakness == 0:
			gm.current_damage = gm.damage
			has_debuff_weakness = false
			
	if has_debuff_undefend:
		turns_debuff_undefend -= 1
		if turns_debuff_undefend == 0:
			gm.current_defence = gm.defence
			has_debuff_undefend = false
			
	if has_debuff_inaccuracy:
		turns_debuff_inaccuracy -= 1
		if turns_debuff_inaccuracy == 0:
			gm.current_accuracy = gm.accuracy
			has_debuff_inaccuracy = false
			
	if has_debuff_unluck:
		turns_debuff_unluck -= 1
		if turns_debuff_unluck == 0:
			gm.current_luck = gm.luck
			has_debuff_unluck = false
			
	if has_debuff_low_energy:
		turns_debuff_low_energy -= 1
		if turns_debuff_low_energy == 0:
			gm.energy = gm.max_energy
			has_debuff_low_energy = false


	if has_buff_strength:
		turns_buff_strength -= 1
		if turns_buff_strength == 0:
			gm.current_damage_cat = gm.damage_cat
			has_buff_strength = false
			
	if has_buff_defend:
		turns_buff_defend -= 1
		if turns_buff_defend == 0:
			gm.current_defence = gm.defence
			has_buff_defend = false
			
	if has_buff_accuracy:
		turns_buff_accuracy -= 1
		if turns_buff_accuracy == 0:
			gm.current_accuracy = gm.accuracy
			has_buff_accuracy = false
			
	if has_buff_luck:
		turns_buff_luck -= 1
		if turns_buff_luck == 0:
			gm.current_luck = gm.luck
			has_buff_luck = false
			
	if has_buff_high_energy:
		turns_buff_high_energy -= 1
		if turns_buff_high_energy == 0:
			gm.energy = gm.max_energy
			has_buff_high_energy = false

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
	if gm.hp_cat <= 0:
		gm.hp_cat = 0
		gm.state = "dead"

func check_xp() -> bool:
	$AudioStreamPlayerPickUpXP.pitch_scale = randf_range(0.8, 1.2)
	$AudioStreamPlayerPickUpXP.play()
	
	if gm.xp >= gm.xp_needed:
		gm.level += 1
		gm.xp = gm.xp - gm.xp_needed
		gm.xp_needed += 1
		get_parent().draw_level_up()
		
		$AudioStreamPlayerLevelUp.play()
		return true
		
	return false
		

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
	
	if damage_indicator_scene:
		var indicator = damage_indicator_scene.instantiate()
		var spawn_pos = global_position + Vector2(0, -2)
		
		add_child(indicator)
		indicator.display_damage(taken_damage, spawn_pos)
	
	if not gm.state == "dead":
		gm.prev_state = gm.state
		gm.state = "taking_damage"
		gm.hp_cat -= taken_damage
		sprite.play("taking_damage")
		audio_meow.play()
		idle_animation_timer.start(0.2)
		get_parent().end_turn()
	else:
		audio_fall.play()
		sprite.play("dead")

func _on_idle_animation_timer_timeout() -> void:
	gm.state = gm.prev_state
	sprite.play(gm.state)

func _on_miss_damage_timer_timeout() -> void:
	var tween = create_tween()
	tween.tween_property(status_fx, "scale", Vector2(0, 0), 0.2)
	get_parent().end_turn()

func _on_deal_damage_timer_timeout() -> void:
	var tween1 = create_tween()
	tween1.tween_property(sprite, "position:x", sprite.position.x - 4, 0.1)
	
	var tween = create_tween()
	tween.tween_property(status_fx, "scale", Vector2(0, 0), 0.2)
	
	if is_hit_lucky:
		get_parent().player_camera.apply_shake(0.1 + gm.current_card.shake)
		audio_hit_lucky.play()
		
		get_parent().claw_fx.scale = Vector2(2, 2)
	else:
		get_parent().player_camera.apply_shake(gm.current_card.shake)
		audio_hit.play()
		
		get_parent().claw_fx.scale = Vector2(1, 1)
	
	get_parent().claw_fx.position = gm.current_targets[0].position
	get_parent().claw_fx.play("hit")
	for target in gm.current_targets:
		target.take_damage(gm.current_damage_cat, gm.attack_animation_time_cat)
	gm.current_damage_cat = gm.damage_cat
	
	if just_missed:
		if gm.has_boomerang:
			#var boomerang = get_parent().find_child("FX").find_child("BoomerangProjectile")
			if gm.current_card.everybody_attack:
				get_parent().boomerang_projectile.scale = Vector2(3, 3)
			else:
				get_parent().boomerang_projectile.scale = Vector2(1, 1)
			
			get_parent().boomerang_projectile.audio.play()
			get_parent().boomerang_projectile.position.x = -1000 
			get_parent().boomerang_projectile.position.y = randi_range(-10, 10)
			
			var tween_boomerang = create_tween()
			tween_boomerang.tween_property(get_parent().boomerang_projectile, "position", gm.current_targets[0].position + Vector2(600, +32), 1)
	
	idle_animation_timer.start(0.2)

func _on_defend_timer_timeout() -> void:
	audio_defend.play()
	#idle_animation_timer.start(0.2)
	var tween = create_tween()
	tween.tween_property(status_fx, "scale", Vector2(0, 0), 0.2)
	
	#get_parent().end_turn()

func _on_debuff_timer_timeout() -> void:
	var tween = create_tween()
	tween.tween_property(status_fx, "scale", Vector2(0, 0), 0.2)
	var tween1 = create_tween()
	tween1.tween_property(gm.current_targets[0].status_fx, "scale", Vector2(0, 0), 0.2)
	#get_parent().end_turn()


func _on_heal_timer_timeout() -> void:
	gm.hp_cat += current_heal
	if gm.hp_cat > gm.max_hp_cat:
		gm.hp_cat = gm.max_hp_cat
	
	gm.state = gm.prev_state
	sprite.play(gm.state)
		
		
