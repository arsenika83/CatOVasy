class_name HumanCharacter extends CharacterBody2D

var creature_name = "solya"
var character_name_display = "Соля"
@export var damage_indicator_scene: PackedScene
@onready var area = $Area2D
@onready var sprite = $Sprite
@onready var my_turn = $MyTurn
@onready var cursor = $Cursor
@onready var status_fx = $StatusFX
@onready var artifact_sprite = $ArtifactSprite
@onready var defence_sprite = $DefenceSprite
@onready var defence_label = $DefenceSprite/DefenceLabel
@onready var hp_bar = $HPBar

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
@onready var audio_neutrality = $AudioNeutrality

@onready var light = $PointLight2D

@onready var luck_particles = $LuckParticles
@onready var unluck_particles = $UnluckParticles
@onready var sand_particles = $SandParticles
@onready var neutrality_particles = $NeutralityParticles

var enemy_name_rus = "Соля"
var state = "battle"

var hp = 5
var max_hp = hp

var damage = 2
var current_damage = damage
var max_damage = damage

var defence = 1
var current_defence = 0
var max_defence = 3

var accuracy = 60
var current_accuracy = accuracy

var luck = 15
var current_luck = luck

var speed = 70
var current_speed = speed

var energy = 1
var current_energy = energy
var max_energy = 1

var fire_resistance: float = 0
var wind_resistance: float = 0
var might_resistance: float = 0
var death_resistance: float = 0
var life_resistance: float = 0
var luck_resistance: float = 0
var unluck_resistance: float = 0
var inaccuracy_resistance: float = 0

var current_fire_resistance: float = 0
var current_wind_resistance: float = 0
var current_might_resistance: float = 0
var current_death_resistance: float = 0
var current_life_resistance: float = 0
var current_luck_resistance: float = 0
var current_unluck_resistance: float = 0
var current_inaccuracy_resistance: float = 0

var current_heal = 0
var attack_count = 0
var taken_damage = 0
var last_damage_dealt = 0
var defended = false
var is_hit_lucky = false
var is_hit_unlucky = false
var just_missed = false
var is_self_damage = false

var next_strike_lucky = false

var current_buffs : Dictionary[String, Array]
var current_debuffs : Dictionary[String, Array]

func _ready() -> void:
	hp_bar.max_value = gm.max_hp_human
	sprite.play("battle")
	scale = Vector2(0, 0)
	spawn()
	
	hp = gm.hp_human
	max_hp = gm.max_hp_human

	damage = gm.damage_human
	current_damage = damage

	defence = gm.defence_human
	current_defence = 0
	max_defence = gm.max_defence_human

	accuracy = gm.accuracy_human
	current_accuracy = accuracy

	luck = gm.luck_human
	current_luck = luck

	energy = gm.energy_human
	current_energy = energy
	max_energy = gm.max_energy_human

	fire_resistance = gm.fire_resistance_human
	wind_resistance = gm.wind_resistance_human
	might_resistance = gm.might_resistance_human
	death_resistance = gm.death_resistance_human
	life_resistance = gm.life_resistance_human
	luck_resistance = gm.luck_resistance_human
	unluck_resistance = gm.unluck_resistance_human
	inaccuracy_resistance = gm.inaccuracy_resistance_human

	current_fire_resistance = fire_resistance
	current_wind_resistance = wind_resistance
	current_might_resistance = might_resistance
	current_death_resistance = death_resistance
	current_life_resistance = life_resistance
	current_luck_resistance = luck_resistance
	current_unluck_resistance = unluck_resistance
	current_inaccuracy_resistance = inaccuracy_resistance


func _process(delta: float) -> void:
	gm.current_energy_human = current_energy
	
	hp_bar.value = float(hp)
	if int(hp_bar.value) < max_hp:
		hp_bar.visible = true
	else:	
		hp_bar.visible = false	
	
	check_fall(delta)
	check_hp()
	#print(gm.prev_state_human)
	#print(gm.state_human)
	
	if current_defence > 0 and gm.state_human != "dead":
		defence_sprite.visible = true
		defence_label.text = str(current_defence)
	else:
		defence_sprite.visible = false	

	match gm.state_human:
		"idle":
			sprite.play("idle")
		"resting":
			sprite.play("resting")
		"walking":
			if Input.is_action_just_pressed("ui_lmb"):
				audio_walk.play()
		"falling":
			sprite.play("falling")
		"dead":
			sprite.play("dead")
		"battle":
			pass
			#sprite.play("battle")
		"battle_boredom":
			sprite.play("battle_boredom")	
		"battle_attack":
			pass
			#sprite.play("battle_attack")
		"battle_defend":
			pass
			#sprite.play("battle_defend")
		"battle_ability":
			pass
			#sprite.play("battle_ability")
			
	#move_and_slide()

func spawn() -> void:
	match gm.state_human:
		"idle":
			var tween = create_tween()
			tween.tween_property(self, "scale", Vector2(1, 1), 0.5)
		"battle":
			scale = Vector2(1, 1)
			sprite.flip_h = true

func respawn() -> void:
	gm.state_human = "idle"
	global_position = gm.prev_pos
	gm.hp_human -= 10

func fall() -> void:
	if not gm.state_human == "falling":
		gm.state_human = "falling"
		respawn_timer.start()
		audio_fall.play()

func walk() -> void:
	gm.state_human = "walking"
	walk_timer.start()

func heal(hp : int) -> void:
	gm.prev_state_human = gm.state_human
	gm.state_human = "healing"
	
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
	is_hit_unlucky = false
	just_missed = false
	is_self_damage = false
	
	#var energy_cost = gm.current_card.energy_cost
	#if current_energy - energy_cost < 0:
	#	return
	#current_energy -= energy_cost
	
	var tween2 = create_tween()
	tween2.tween_property(sprite, "position:x", sprite.position.x + 4, 0.1)
	
	var tween1 = create_tween()
	tween1.tween_property(sprite, "scale", Vector2(1.2, 1.2), 0.1)
	tween1.tween_property(sprite, "scale", Vector2(1, 1), 0.1)
	#gm.current_targets = targets
	audio_hit.play()
	
	sprite.play("deal_damage")
	attack_count += 1
	
	deal_damage_timer.start(gm.attack_animation_time_human)

func take_damage(dmg : int, time : float) -> void:
	if current_defence - dmg >= 0:
		current_defence -= dmg
		if dmg > 0:
			defended = true
		dmg = 0
	else:
		dmg -= current_defence
		current_defence = 0
	
	taken_damage = dmg
	
	if dmg > 0:
		take_damage_timer.start(time)
	else:
		if defended:
			audio_defend.play()
			status_fx.play("defended")
			var tween1 = create_tween()
			tween1.tween_property(status_fx, "modulate:a", 1.0, 0.1)
			
			var tween = create_tween()
			tween.tween_property(status_fx, "scale", Vector2(1, 1), 0.2)
		
			defended = false
		else:
			audio_miss.play()
		
		miss_damage_timer.start(time)

func defend(time : float) -> void:
	var energy_cost = gm.current_card.energy_cost
	#if current_energy - energy_cost < 0:
	#	return
	
	#current_energy -= gm.current_card.energy_cost
	current_defence += gm.current_card.defence
	
	var defend_diff = gm.current_card.defence
	
	if current_defence > max_defence:
		#defend_diff = gm.current_defence_human - gm.max_defence_human
		current_defence = max_defence
		
		get_parent().log_messages.append(str("- [color=#1ca8fd]Соля[/color]: +", defend_diff,
			" защиты. Максимальная броня!\n"))
	else:
		get_parent().log_messages.append(str("- [color=#1ca8fd]Соля[/color]: +", defend_diff,
			" защиты\n"))
	
	status_fx.scale = Vector2(0, 0)
	status_fx.play("defend")
	status_fx.visible = true
	
	var tween2 = create_tween()
	tween2.tween_property(status_fx, "scale", Vector2(1, 1), 0.2)
	
	if damage > 0:
		defend_timer.start(time)
	else:
		defend_timer.start(time)

func give_debuff(targets : Array[CharacterBody2D], type : String, power : int, turns : int) -> void:
	var energy_cost = gm.current_card.energy_cost
	#if current_energy - energy_cost < 0:
	#	return
	
	#current_energy -= energy_cost
	
	status_fx.scale = Vector2(0, 0)
	status_fx.play("debuff")

	status_fx.visible = true
	var tween = create_tween()
	tween.tween_property(status_fx, "scale", Vector2(1, 1), 0.2)
	#gm.current_targets = targets
	
	gm.current_targets[0].status_fx.play("debuff_" + type)
	
	gm.current_targets[0].status_fx.visible = true
	#get_parent().find_child("UI").find_child("CardContainer").replace_current_card("ability")
	var tween3 = create_tween()
	tween3.tween_property(gm.current_targets[0].status_fx, "scale", Vector2(1, 1), 0.2)	
	debuff_timer.start(gm.debuff_animation_time)

func give_buff(targets : Array, type : String, power : int, turns : int) -> void:
	#current_target = target
	status_fx.scale = Vector2(0, 0)
	status_fx.play("buff_" + type)
	status_fx.visible = true
	var tween = create_tween()
	for target in targets:
		target.status_fx.visible = true
		tween.tween_property(target.status_fx, "scale", Vector2(1, 1), 0.4)
		tween.tween_property(target.status_fx, "scale", Vector2(0, 0), 0.4)
		
		target.status_fx.play("buff_" + type)
		
		var current_power = -1000
		if target.current_buffs.get(type) != null:
			current_power = target.current_buffs.get(type).get(0)
					
			if current_power > power:
				break
			elif current_power == power:
				var current_turns = target.current_buffs.get(type).get(1)
				target.current_buffs.get(type).set(1, current_turns + turns)
		
		match type:
			"strength":
				if current_power < power and current_power > 0:
					target.current_damage -= current_power
					target.current_buffs.erase(type)
						
				target.current_damage += power
			"accuracy":
				if current_power < power and current_power > 0:
					target.current_accuracy -= current_power
					target.current_buffs.erase(type)
						
				target.current_accuracy += power
			"luck":
				if current_power < power and current_power > 0:
					target.current_luck -= current_power
					target.current_buffs.erase(type)
						
				target.current_luck += power
			"fire_resistance":
				if current_power < power and current_power != -1000:
					target.current_fire_resistance -= float(current_power) / 100
					target.current_buffs.erase(type)
				
				target.current_fire_resistance += float(power) / 100
			"wind_resistance":
				if current_power < power and current_power != -1000:
					target.current_wind_resistance -= float(current_power) / 100
					target.current_buffs.erase(type)
				
				target.current_wind_resistance += float(power) / 100
			"luck_resistance":
				if current_power < power and current_power != -1000:
					target.current_luck_resistance -= float(current_power) / 100
					target.current_buffs.erase(type)
				
				target.current_luck_resistance += float(power) / 100
			"unluck_resistance":
				if current_power < power and current_power != -1000:
					target.current_unluck_resistance -= float(current_power) / 100
					target.current_buffs.erase(type)
				
				target.current_unluck_resistance += float(power) / 100
			"inaccuracy_resistance":
				if current_power < power and current_power != -1000:
					target.current_inaccuracy_resistance -= float(current_power) / 100
					target.current_buffs.erase(type)
				
				target.current_inaccuracy_resistance += float(power) / 100
			"death_resistance":
				if current_power < power and current_power != -1000:
					target.current_death_resistance -= float(current_power) / 100
					target.current_buffs.erase(type)
				
				target.current_death_resistance += float(power) / 100
			"life_resistance":
				if current_power < power and current_power != -1000:
					target.current_life_resistance -= float(current_power) / 100
					target.current_buffs.erase(type)
				
				target.current_life_resistance += float(power) / 100
				
		if target.current_buffs.get(type) == null:
			target.current_buffs.set(type, [power, turns])
			
			
	#current_energy -= gm.current_card.energy_cost
	
	targets[0].sprite.play("battle_buffed")
	targets[0].idle_animation_timer.start(gm.buff_animation_time_human)
	if get_parent().team_positions[0] == "human":
		sprite.flip_h = true
	sprite.play("battle_buff_cat")
	z_index += 1
	$AudioStreamPlayerBuff.play()
	
	if damage_indicator_scene:
		var indicator = damage_indicator_scene.instantiate()
		var spawn_pos = global_position + Vector2(0, -2)
		
		add_child(indicator)
		indicator.display_damage("МУР", targets[0].position)

	idle_animation_timer.start(gm.buff_animation_time_human)

func display_damage(dmg) -> void:
	if damage_indicator_scene:
		var indicator = damage_indicator_scene.instantiate()
		var spawn_pos = global_position + Vector2(0, -2)
		
		add_child(indicator)
		indicator.display_damage(dmg, spawn_pos)

func turn_tick() -> void:
	#gm.current_defence_human = 0
	for buff in current_buffs:
		var turns = current_buffs.get(buff).get(1)
		current_buffs.get(buff).set(1, turns-1)
		
		print(str(buff, ": ", current_buffs.get(buff).get(1), " ходов"))
		
		if current_buffs.get(buff).get(1) == 0:
			print(str(buff, ": кончился"))
			current_buffs.erase(buff)
	
	if current_buffs.get("strength") == null:
		current_damage = damage
	if current_buffs.get("luck") == null:
		current_luck = luck
	if current_buffs.get("accuracy") == null:
		current_accuracy = accuracy
	if current_buffs.get("fire_resistance") == null and current_debuffs.get("fire_mark") == null:
		current_fire_resistance = fire_resistance
	if current_buffs.get("wind_resistance") == null and current_debuffs.get("wind_mark") == null:
		current_wind_resistance = wind_resistance
	if current_buffs.get("luck_resistance") == null and current_debuffs.get("luck_mark") == null: 
		current_luck_resistance = luck_resistance
	if current_buffs.get("unluck_resistance") == null and current_debuffs.get("unluck_mark") == null:
		current_unluck_resistance = unluck_resistance
	if current_buffs.get("inaccuracy_resistance") == null and current_debuffs.get("inaccuracy_mark") == null:
		current_inaccuracy_resistance = inaccuracy_resistance
	if current_buffs.get("death_resistance") == null and current_debuffs.get("death_mark") == null:
		current_death_resistance = death_resistance
	if current_buffs.get("life_resistance") == null and current_debuffs.get("life_mark") == null:
		current_life_resistance = life_resistance
			
	for debuff in current_debuffs:
		var turns = current_debuffs.get(debuff).get(1)
		current_debuffs.get(debuff).set(1, turns-1)
		
		if current_debuffs.get(debuff).get(1) == 0:
			current_debuffs.erase(debuff)
	
	if current_debuffs.get("weakness") == null:
		current_damage = damage
	if current_debuffs.get("unluck") == null:
		current_luck = luck
	if current_debuffs.get("inaccuracy") == null:
		current_luck = luck
	if current_debuffs.get("laziness") == null:
		current_energy = energy


func create_fog() -> void:
	get_parent().fog_fx.visible = true
	
	var tween = create_tween()
	tween.tween_property(get_parent().fog_fx.material, "shader_parameter/alpha", 0.7, 3)
	
	sprite.play("fog")
	idle_animation_timer.start(3)
	
	get_parent().fog_summon_fx.position = position + Vector2(0, -64)
	get_parent().fog_summon_fx.play("hit")
	get_parent().fog_summon_fx.audio.play()
	get_parent().wind_fx.audio.play()
	get_parent().player_camera.apply_shake(1)
	
	var tween1 = create_tween()
	tween1.tween_property(get_parent().audio_music, "volume_db", -15.0, 1)
	tween1.tween_property(get_parent().audio_music, "volume_db", 0, 5)

func ignite(pos : Vector2) -> void:
	get_parent().ignite_fx.position = pos
	get_parent().ignite_fx.play("hit")
	get_parent().ignite_fx.audio.play()
	
	
func rainbow_defend(def : int) -> void:
	shine_artifact("rainbow_pot")
	
	current_defence += def
	if current_defence > max_defence:
		current_defence = max_defence
	$RainbowDefendParticles.restart()
	audio_defend.play()	
	get_parent().log_messages.append(str("- [color=#1ca8fd]Соля[/color] +", def,
		" защиты. [color=#c20303]Р[/color][color=#e17120]А[/color][color=#e5c306]Д[/color][color=#88dc1c]У[/color][color=#63c1e9]Г[/color][color=#2f62e1]А[/color][color=#7516dc]![/color]\n"))
	

func check_fall(delta: float) -> void:
	if gm.state_human == "falling":
		z_index = -1
		#velocity.y += gravity * delta * 0.5
			
		scale.x -= 0.02
		scale.y -= 0.02
		
		rotation_degrees += 10
		if scale.x <= 0:
			scale.x = 0
			scale.y = 0
	elif gm.state_human == "idle":
		z_index = 3
		rotation_degrees = 0
		#velocity.y = 0
		scale.x += 0.04
		scale.y += 0.04
		
		if scale.x >= 1:
			scale.x = 1
			scale.y = 1

func check_hp() -> void:
	if not gm.state_human == "dead":
		if hp <= 0:
			hp = 0
			gm.state_human = "dead"

func update_gm() -> void:
	gm.hp_human = hp
	gm.max_hp_human = max_hp
		
func shine_artifact(art : String) -> void:
	var i = 1
	for artifact in gm.current_artifacts_human.values():
		if artifact.path == art:
			get_parent().find_child("UI").find_child("BattleArtifacts").artifact_slots_human.get(i-1).shine()
			break
		i += 1

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
	if gm.state_human == "walking":
		gm.state_human = "idle"

func _on_take_damage_timer_timeout() -> void:
	$HPParticles.restart()
	gm.state_human = "taking_damage"
	hp -= taken_damage
	
	check_hp()
	
	display_damage(taken_damage)
	
	if not gm.state_human == "dead":
		var tween1 = create_tween()
		tween1.tween_property(sprite, "position:x", sprite.position.x - 4, 0.1)
		tween1.tween_property(sprite, "position:x", sprite.position.x, 0.1)
		
		#gm.prev_state_human = gm.state_human

		sprite.play("taking_damage")
		audio_meow.play()
		idle_animation_timer.start(0.2)
		
		if not is_self_damage:
			get_parent().end_turn()
			
	else:
		if get_parent().name == "Battle":
			get_parent().log_messages.append(str("- [color=#1ca8fd]", character_name_display, "[/color] [color=#fc4e52]МЕРТВА[/color]\n"))
			if get_parent().current_creature_turn == get_parent().human:
				gm.current_energy_human = -1000
				get_parent().progress_turn()
				get_parent().end_turn()
			else:
				get_parent().on_creature_action()
				get_parent().end_turn()
			
		audio_fall.play()
		sprite.play("dead")
	
	is_self_damage = false	

func _on_idle_animation_timer_timeout() -> void:
	#if gm.prev_state_human == "playing_a_card" or gm.prev_state_human == "taking_damage":
	gm.prev_state_human = "battle"
	
	gm.state_human = gm.prev_state_human
	
	sprite.play(gm.state_human)
	sprite.flip_h = false
	#get_parent().fire_fx.visible = true

func _on_miss_damage_timer_timeout() -> void:
	display_damage(0)
	
	var tween = create_tween()
	tween.tween_property(status_fx, "scale", Vector2(0, 0), 0.2)
	get_parent().end_turn()

func _on_deal_damage_timer_timeout() -> void:
	last_damage_dealt = 0
	
	var tween1 = create_tween()
	tween1.tween_property(sprite, "position:x", sprite.position.x - 4, 0.1)
	
	var tween = create_tween()
	tween.tween_property(status_fx, "scale", Vector2(0, 0), 0.2)
	
	var success : bool = randf_range(0.0, 1.0) * 100 <= current_accuracy
	if current_luck > 0:
		is_hit_lucky = randf_range(0.0, 1.0) * 100 <= current_luck
	elif current_luck < 0:
		is_hit_unlucky = randf_range(0.0, 1.0) * 100 <= abs(current_luck)
	
	if next_strike_lucky:
		next_strike_lucky = false
		is_hit_lucky = true
		is_hit_unlucky = false
	
	if gm.has_dice:
		shine_artifact("dice")
		is_hit_lucky = true
		is_self_damage = randi_range(0, 100) < 15
		
	if is_hit_lucky:
		#$LuckyHitTimer.start(gm.attack_animation_time_human)
		
		if gm.has_rainbow_pot: #ГОРШОЧЕК РАДУГИ
			get_parent().human.rainbow_defend(2)
		
		luck_particles.restart()
		
		get_parent().player_camera.apply_shake(0.1 + gm.current_card.shake)
		audio_hit_lucky.play()
		
		get_parent().fire_fx.scale = Vector2(2, 2)
		status_fx.scale = Vector2(0, 0)
		status_fx.play("lucky")
		status_fx.visible = true
				
		var tween2 = create_tween()
		tween2.tween_property(status_fx, "scale", Vector2(1, 1), 0.2)
		tween2.tween_property(status_fx, "scale", Vector2(0, 0), 0.2)
	elif is_hit_unlucky:
		unluck_particles.restart()
		
		get_parent().player_camera.apply_shake(0.1)
		get_parent().fire_fx.scale = Vector2(1, 1)
		$AudioStreamPlayerHitUnlucky.play()
	else:
		get_parent().player_camera.apply_shake(gm.current_card.shake)
		
		get_parent().fire_fx.scale = Vector2(1, 1)
	
	if is_self_damage:
		gm.current_targets = [self]
	
	get_parent().fire_fx.position = position + Vector2(22, -24)
	var tween2 = create_tween()
	tween2.tween_property(get_parent().fire_fx, "position", gm.current_targets[0].position, gm.attack_animation_time_human)
	get_parent().fire_fx.play("hit")
	
	for target in gm.current_targets:
		success = randf_range(0.0, 1.0) * 100 <= gm.current_accuracy_human
		
		if is_hit_lucky and gm.has_lucky_coin:
			shine_artifact("lucky_coin")
			success = true
			$LuckyCoinParticles.restart()
			$AudioCoin.play()
			
		if gm.current_card.has_method("cant_miss"):
			success = true
		
		if success:
			current_damage = gm.current_card.damage
		else:
			just_missed = true
			current_damage = 0
			
		if is_hit_lucky:
			current_damage *= 2
		elif is_hit_unlucky:
			current_damage /= 2
		
		var damage_dealt = 0
		if not target == self:
			damage_dealt = current_damage - target.current_defence
			if damage_dealt < 0:
				damage_dealt = 0
			if damage_dealt > target.hp:
				damage_dealt = target.hp
			
		last_damage_dealt += damage_dealt
		

		if gm.current_card != null:
			if gm.current_card.element == "might":
				current_damage = int(current_damage * (1.0 - target.current_might_resistance))
			elif gm.current_card.element == "fire":
				current_damage = int(current_damage * (1.0 - target.current_fire_resistance))
			elif gm.current_card.element == "wind":
				current_damage = int(current_damage * (1.0 - target.current_wind_resistance))
			elif gm.current_card.element == "luck":
				current_damage = int(current_damage * (1.0 - target.current_luck_resistance))
			elif gm.current_card.element == "death":
				current_damage = int(current_damage * (1.0 - target.current_death_resistance))
			elif gm.current_card.element == "life":
				current_damage = int(current_damage * (1.0 - target.current_life_resistance))	

		if current_damage == 0:
			get_parent().log_messages.append(str("- [color=#1ca8fd]Соля[/color] атакует существо [color=#1ca8fd]", 
			target.enemy_name_rus, "[/color]. Промах!\n"))
			
			if gm.has_boomerang:
				get_parent().log_messages.append(str("- [color=#e9920a]Бумеранг[/color] наносит [color=#fc4e52]1 урона[/color] существу [color=#1ca8fd]", target.enemy_name_rus, "[/color]\n"))
		else:
			if is_hit_lucky:
				get_parent().log_messages.append(str("- [color=#8bc882]Удача![/color] [color=#1ca8fd]Соля[/color] наносит [color=#fc4e52]", gm.current_damage_human, 
				" урона[/color] существу [color=#1ca8fd]", target.enemy_name_rus, "[/color]\n"))
			else:
				get_parent().log_messages.append(str("- [color=#1ca8fd]Соля[/color] наносит [color=#fc4e52]", gm.current_damage_human, 
				" урона[/color] существу [color=#1ca8fd]", target.enemy_name_rus, "[/color]\n"))
		
		target.take_damage(current_damage, gm.attack_animation_time_human)
		
	current_damage = damage
	
	#ВЗРЫВ
	if gm.current_card.has_method("explode"):
		get_parent().fire_fx.scale = Vector2(0, 0)
		get_parent().giant.display_damage(5)

		$ExplodeTimer.start(gm.attack_animation_time_human)
			
		get_parent().cat_fx.position = get_parent().giant.position
		get_parent().cat_fx.rotation_degrees = 720
		get_parent().giant.sprite.visible = false
			
		var tween3 = create_tween()
		tween3.tween_property(get_parent().cat_fx, "position", gm.current_targets[0].position, gm.attack_animation_time_human)
			
		var tween4 = create_tween()
		tween4.tween_property(get_parent().cat_fx, "rotation_degrees", 0, 0.3)
		get_parent().cat_fx.play("hit")
		
	#Песок
	if gm.current_card.has_method("sand"):
		get_parent().fire_fx.scale = Vector2(0, 0)
			
			
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
	
	if gm.current_card.has_method("on_after_play"):
		gm.current_card.on_after_play()
	idle_animation_timer.start(0.4)


func _on_defend_timer_timeout() -> void:
	audio_defend.play()
	idle_animation_timer.start(0.2)
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
	hp += current_heal
	if hp > max_hp:
		hp = max_hp
	
	gm.prev_state_human = "battle"
	gm.state_human = gm.prev_state_human
	sprite.play(gm.state_human)
	display_damage(-current_heal)


func _on_explode_timer_timeout() -> void:
	get_parent().giant_explosion_fx.position = gm.current_targets[0].position
	if gm.state != "dead":
		get_parent().giant_explosion_fx.play("hit")
	else:
		#gm.current_card.element = "death"
		get_parent().giant_explosion_fx.play("dead_hit")
	get_parent().player_camera.apply_shake(3)
	$AudioExplode.play()
	get_parent().giant.sprite.visible = true
	


func _on_lucky_hit_timer_timeout() -> void:
	if Engine.time_scale == 1.0:
		Engine.time_scale = 0.5
		$LuckyHitTimer.start(gm.attack_animation_time_human)
		
		gm.camera_prev_position = get_parent().player_camera.position
		
		var tween = create_tween()
		tween.tween_property(get_parent().player_camera, "position", gm.current_targets[0].position - Vector2(32, 0), 0.05)
		
		var tween1 = create_tween()
		tween1.tween_property(get_parent().player_camera, "zoom", Vector2(5, 5), 0.05)
	else:
		Engine.time_scale = 1.0
		
		var tween = create_tween()
		tween.tween_property(Engine, "time_scale", 1.0, 0.2)
		
		var tween1 = create_tween()
		tween1.tween_property(get_parent().player_camera, "position", gm.camera_prev_position, 0.2)
		
		var tween2 = create_tween()
		tween2.tween_property(get_parent().player_camera, "zoom", Vector2(gm.camera_zoom, gm.camera_zoom), 0.2)
