class_name Enemy extends CharacterBody2D

@export var damage_indicator_scene: PackedScene

var positions : Array[Vector2]

@export var is_leader = false

@export var hp = 5
@export var max_hp = 5

var taken_damage = 0
@export var damage = 2
var current_damage = damage
var max_damage = damage

@export var defence = 1
var current_defence = 0
@export var max_defence = 3
var defended = false

@export var accuracy = 60
var current_accuracy = accuracy

@export var luck = 15
var current_luck = luck

var energy = 1
var current_energy = energy
var max_energy = 1

@export var xp_gives = 1
@export var money_gives = 5

var gave_xp = false
var state = "idle"

var is_flying = false
var is_big = false

var shake = 0.1

var enemy_type = "enemy"
var enemy_name = "enemy"
var enemy_scene_path = "enemy.tscn"
var enemy_name_rus = "Враг"

var follow_radius = 1
var is_following = false

var standard_move_path : Array[Vector2] = [Vector2(-32, 0), Vector2(0, -32), Vector2(32, 0), Vector2(0, 32), Vector2(0, 0)]
@export var step_count = 0

var move_set : Array = ["deal_damage", "defend", "deal_damage", "buff"]

var debuff_set : Array = [["weakness", 1, 2], ["undefend", 100, 2], ["inaccuracy", 10, 2], \
["unluck", 5, 2], ["low_energy", 1, 2]]

var buff_set : Array = [["strength", 1, 2], ["defend", 1, 2], ["accuracy", 10, 2], \
["luck", 5, 2], ["high_energy", 1, 2]]

var just_missed = false
var player_just_missed = false
var is_hit_lucky = false
var is_hit_unlucky = false
var dealt_damage_to_human = false

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

@export var fire_resistance: float = 0
@export var wind_resistance: float = 0
@export var might_resistance: float = 0
@export var death_resistance: float = 0
@export var life_resistance: float = 0
@export var luck_resistance: float = 0
@export var unluck_resistance: float = 0
@export var inaccuracy_resistance: float = 0

var element = "might"

var follow_step_count = 0
var follow_distance = 5

var battle_x = 0
var battle_y = 0

var current_target : CharacterBody2D
var attack_animation_time = 0.3
var defend_animation_time = 0.3
var debuff_animation_time = 0.3
var buff_animation_time =   0.3

@onready var my_turn = $MyTurn
@onready var sprite = $AnimatedSprite2D
@onready var area = $Area2D
@onready var area_xp = $Area2DXP

@onready var cursor = $Cursor

@onready var audio_follow = $AudioFollow
@onready var audio_hit = $AudioHit
@onready var audio_hit_lucky = $AudioHitLucky
@onready var audio_hurt = $AudioHurt
@onready var audio_fall = $AudioFall
@onready var audio_miss = $AudioMiss
@onready var audio_defend = $AudioDefend
@onready var audio_debuff = $AudioDebuff
@onready var audio_xp = $AudioXP

@onready var idle_animation_timer = $IdleAnimationTimer
@onready var deal_damage_timer = $DealDamageTimer
@onready var take_damage_timer = $TakeDamageTimer
@onready var miss_damage_timer = $MissDamageTimer
@onready var defend_timer = $DefendTimer
@onready var debuff_timer = $DebuffTimer

@onready var xp_orb = $XpOrb
@onready var status_fx = $StatusFX
@onready var defence_sprite = $DefenceSprite
@onready var defence_label = $DefenceSprite/DefenceLabel
@onready var hp_bar = $HPBar

@onready var luck_particles = $LuckParticles
@onready var unluck_particles = $UnluckParticles

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hp_bar.max_value = max_hp
	defence_sprite.visible = false
	status_fx.play("found_you")
	battle_x = get_parent().get_parent().find_child("TileMapLayerBlack").local_to_map(position).x
	battle_y = get_parent().get_parent().find_child("TileMapLayerBlack").local_to_map(position).y
	
	positions.append(Vector2(battle_x, battle_y))
	check_team()

func _process(delta: float) -> void:
	if current_defence > 0 and state != "dead":
		defence_sprite.visible = true
		defence_label.text = str(current_defence)
	else:
		defence_sprite.visible = false
	
	hp_bar.value = float(hp)
	if hp_bar.value < max_hp:
		hp_bar.visible = true
	else:	
		hp_bar.visible = false
	
	check_hp()
	#check_team()
	
	match state:
		"idle":
			pass
		"dead":
			hp_bar.visible = false
			area_xp.monitoring = true
			area.monitoring = false

func check_team() -> void:
	if not is_leader:
		return
	
	if get_parent().get_parent().name != "Game":
		return
		
	for enemy in get_parent().get_children():
		if enemy.position == self.position:
			if not enemy.is_leader:
				enemy.visible = false
			else:
				enemy.visible = true

func move(g_pos : Vector2, e_pos : Vector2) -> void:
	if state == "idle":
		check_team()
		var diff_x = g_pos.x - e_pos.x
		var diff_y = g_pos.y - e_pos.y
		status_fx.visible = true
		status_fx.play("found_you")
		
		if abs(diff_x) > follow_radius or abs(diff_y) > follow_radius:
			status_fx.visible = false
			
			var next_step = Vector2(self.position.x + standard_move_path.get(step_count).x, self.position.y + standard_move_path.get(step_count).y)
			var allowed_to_move = true
			
			for edge_pos in gm.current_level_edge_positions:
				if next_step.x == edge_pos.x and next_step.y == edge_pos.y:
					allowed_to_move = false
					break
			
			if allowed_to_move:
				if standard_move_path.get(step_count).x > 0:
					sprite.flip_h = true
				elif standard_move_path.get(step_count).x < 0:
					sprite.flip_h = false
					
				var tween = create_tween()
				tween.tween_property(self, "position", next_step, 0.2)
				
			step_count += 1
			if step_count >= standard_move_path.size():
				step_count = 0
				
			return
		
		if (follow_step_count == follow_distance):
			follow_step_count = 0
			status_fx.visible = true
			is_following = false
			status_fx.play("lost_you")
			gm.enemies_following -= 1
			return
		
		if not is_following:
			gm.enemies_following += 1
			is_following = true
		
		audio_follow.volume_db = 0 - (gm.enemies_following * 4)
		audio_follow.play()
		if (diff_x == 0) and diff_y < 0:
			var tween = create_tween()
			tween.tween_property(self, "position", Vector2(self.position.x, self.position.y - 32), 0.2)
		elif diff_x > 0 and diff_y < 0:
			sprite.flip_h = true
			var tween = create_tween()
			tween.tween_property(self, "position", Vector2(self.position.x + 32, self.position.y - 32), 0.2)
		elif diff_x > 0 and (diff_y == 0):
			sprite.flip_h = true
			var tween = create_tween()
			tween.tween_property(self, "position", Vector2(self.position.x + 32, self.position.y), 0.2)
		elif diff_x > 0 and diff_y > 0:
			sprite.flip_h = true
			var tween = create_tween()
			tween.tween_property(self, "position", Vector2(self.position.x + 32, self.position.y + 32), 0.2)
		elif (diff_x == 0) and diff_y > 0:
			var tween = create_tween()
			tween.tween_property(self, "position", Vector2(self.position.x, self.position.y + 32), 0.2)
		elif diff_x < 0 and diff_y > 0:
			sprite.flip_h = false
			var tween = create_tween()
			tween.tween_property(self, "position", Vector2(self.position.x - 32, self.position.y + 32), 0.2)
		elif diff_x < 0 and (diff_y == 0):
			sprite.flip_h = false
			var tween = create_tween()
			tween.tween_property(self, "position", Vector2(self.position.x - 32, self.position.y), 0.2)
		elif diff_x < 0 and diff_y < 0:
			sprite.flip_h = false
			var tween = create_tween()
			tween.tween_property(self, "position", Vector2(self.position.x - 32, self.position.y - 32), 0.2)	
		
		follow_step_count += 1

func check_giant_position(g_pos : Vector2, e_pos : Vector2) -> void:
	if state == "idle":
		var diff_x = g_pos.x - e_pos.x
		var diff_y = g_pos.y - e_pos.y
		
		if (abs(diff_x) <= follow_radius) and (abs(diff_y) <= follow_radius):
			var tween = create_tween()
			tween.tween_property(status_fx, "modulate:a", 1.0, 0.2)
			status_fx.play("found_you")


func _on_area_2d_area_entered(area: Area2D) -> void:
	if gm.state == "leveling_up":
		return
		
	gm.current_enemies.append(self)
	if not gm.state == "battle":
		gm.state = "battle"
		
		get_parent().get_parent().start_battle()
		
		audio_hit.pitch_scale = randf_range(0.8, 1.2)
		audio_hit.play()

func _on_area_2dxp_area_entered(area: Area2D) -> void:
	print(str("NOW: ", gm.state))
	if gm.state == "idle" or gm.state == "walking" or gm.state == "leveling_up":
		if not gave_xp:
			xp_orb.visible = false
			gave_xp = true
			gm.xp += xp_gives
			audio_xp.play()
			#get_parent().get_parent().find_child("Giant").check_xp()

func check_hp() -> void:
	if not state == "dead":
		if hp <= 0:
			hp = 0
			state = "dead"
			
			if is_following:
				is_following = false
				gm.enemies_following -= 1

func deal_damage(target : CharacterBody2D) -> void:
	var success : bool = randf_range(0.0, 1.0) * 100 <= accuracy
	just_missed = false
	is_hit_lucky = false
	is_hit_unlucky = false
	current_target = target
	
	if current_luck > 0:
		is_hit_lucky = randf_range(0.0, 1.0) * 100 <= current_luck
	elif current_luck < 0:
		is_hit_unlucky = randf_range(0.0, 1.0) * 100 <= abs(current_luck)	
	
	var tween2 = create_tween()
	tween2.tween_property(sprite, "position:x", sprite.position.x - 4, 0.1)
	
	var tween1 = create_tween()
	tween1.tween_property(sprite, "scale", Vector2(1.2, 1.2), 0.1)
	tween1.tween_property(sprite, "scale", Vector2(1, 1), 0.1)
	
	if success:
		if target.character_name == "solya":
			dealt_damage_to_human = true
		if is_hit_lucky:
			status_fx.scale = Vector2(0, 0)
			status_fx.play("lucky")
			status_fx.visible = true
			
			var tween = create_tween()
			tween.tween_property(status_fx, "scale", Vector2(1, 1), 0.2)
			
			current_damage = damage * 2
		elif is_hit_unlucky:
			current_damage = damage / 2
	else:
		just_missed = true
		print("MISS! ")
	
	sprite.play("deal_damage")
	deal_damage_timer.start(attack_animation_time)

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
		player_just_missed = false
		take_damage_timer.start(time)
	else:
		if defended:
			player_just_missed = false
			
			audio_defend.play()
			status_fx.play("defended")
			status_fx.visible = true
			
			var tween = create_tween()
			tween.tween_property(status_fx, "scale", Vector2(1, 1), 0.2)
		
			defended = false
		else:
			audio_miss.play()
			player_just_missed = true
		miss_damage_timer.start(time)
		
func defend() -> void:
	current_defence += defence
	
	var defend_diff = defence
	
	if current_defence > max_defence:
		#defend_diff = max_defence - current_defence
		current_defence = max_defence
		
		get_parent().get_parent().log_messages.append(str("- [color=#1ca8fd]", enemy_name_rus, "[/color]: +", defend_diff,
			" защиты. Максимальная броня!\n"))
	else:
		get_parent().get_parent().log_messages.append(str("- [color=#1ca8fd]", enemy_name_rus, "[/color]: +", defend_diff,
			" защиты\n"))
	
	status_fx.scale = Vector2(0, 0)
	status_fx.play("defend")
	status_fx.visible = true
	
	var tween = create_tween()
	tween.tween_property(status_fx, "scale", Vector2(1, 1), 0.2)
	
	if damage > 0:
		defend_timer.start(defend_animation_time)
	else:
		defend_timer.start(defend_animation_time)
		
func give_debuff(target : CharacterBody2D, type : String, power : int, turns : int) -> void:
	
	current_target = target
	status_fx.scale = Vector2(0, 0)
	status_fx.play("debuff")
	status_fx.visible = true
	var tween = create_tween()
	tween.tween_property(status_fx, "scale", Vector2(1, 1), 0.2)
	current_target.status_fx.play("debuff_" + type)
	
	match type:
		"weakness":
			current_target.has_debuff_weakness = true
			current_target.turns_debuff_weakness += turns
			gm.current_damage -= power
			if gm.current_damage < gm.min_damage:
				gm.current_damage = gm.min_damage
		"undefend":
			current_target.has_debuff_undefend = true
			current_target.turns_debuff_undefend += turns
			gm.current_defence -= power
			if gm.current_defence < 0:
				gm.current_defence = 0
		"inaccuracy":
			current_target.has_debuff_inaccuracy = true
			current_target.turns_debuff_inaccuracy += turns
			gm.current_accuracy -= power
			if gm.current_accuracy < gm.min_accuracy:
				gm.current_accuracy = gm.min_accuracy
		"unluck":
			current_target.has_debuff_unluck = true
			current_target.turns_debuff_unluck += turns
			gm.current_luck -= power
			if gm.current_luck < gm.min_luck:
				gm.current_luck = gm.min_luck
		"low_energy":
			current_target.has_debuff_low_energy = true
			current_target.turns_debuff_low_energy += turns
			gm.energy -= power
			if gm.energy < 0:
				gm.energy = 0
	
	status_fx.visible = true
	var tween3 = create_tween()
	tween3.tween_property(current_target.status_fx, "scale", Vector2(1, 1), 0.2)
	
	debuff_timer.start(debuff_animation_time)
	
	
func give_buff(target : CharacterBody2D, type : String, power : int, turns : int) -> void:
	current_target = target
	status_fx.scale = Vector2(0, 0)
	status_fx.play("buff")
	status_fx.visible = true
	var tween = create_tween()
	tween.tween_property(status_fx, "scale", Vector2(1, 1), 0.2)
	current_target.status_fx.play("buff_" + type)
	
	match type:
		"strength":
			current_target.has_buff_strength = true
			current_target.turns_buff_strength += turns
			current_target.current_damage += power
			current_target.damage += power
		"defend":
			current_target.has_buff_defend = true
			current_target.turns_buff_defend += turns
			current_target.current_defence += power
			if current_target.current_defence <= 0:
				current_target.current_defence = 0
		"accuracy":
			current_target.has_buff_accuracy = true
			current_target.turns_buff_accuracy += turns
			current_target.current_accuracy += power
			if current_target.current_accuracy > 100:
				current_target.current_accuracy = 100
		"luck":
			current_target.has_buff_luck = true
			current_target.turns_buff_luck += turns
			current_target.current_luck += power
			if current_target.current_luck > 100:
				current_target.current_luck = 100
		"high_energy":
			current_target.has_buff_high_energy = true
			current_target.turns_buff_high_energy += turns
			current_target.energy += power
	
	status_fx.visible = true
	var tween3 = create_tween()
	tween3.tween_property(current_target.status_fx, "scale", Vector2(1, 1), 0.2)
	
	debuff_timer.start(debuff_animation_time)
	
func display_damage(dmg) -> void:
	if damage_indicator_scene:
		var indicator = damage_indicator_scene.instantiate()
		var spawn_pos = global_position + Vector2(0, -2)
		
		add_child(indicator)
		indicator.display_damage(dmg, spawn_pos)
	
func turn_tick() -> void:
	current_defence = 0
	if has_debuff_weakness:
		turns_debuff_weakness -= 1
		if turns_debuff_weakness == 0:
			current_damage = max_damage
			has_debuff_weakness = false
			
	if has_debuff_undefend:
		turns_debuff_undefend -= 1
		if turns_debuff_undefend == 0:
			current_defence = defence
			has_debuff_undefend = false
			
	if has_debuff_inaccuracy:
		turns_debuff_inaccuracy -= 1
		if turns_debuff_inaccuracy == 0:
			current_accuracy = accuracy
			has_debuff_inaccuracy = false
			
	if has_debuff_unluck:
		turns_debuff_unluck -= 1
		if turns_debuff_unluck == 0:
			current_luck = luck
			has_debuff_unluck = false
			
	if has_debuff_low_energy:
		turns_debuff_low_energy -= 1
		if turns_debuff_low_energy == 0:
			energy = max_energy
			has_debuff_low_energy = false


	if has_buff_strength:
		turns_buff_strength -= 1
		if turns_buff_strength == 0:
			current_damage = max_damage
			has_buff_strength = false
			
	if has_buff_defend:
		turns_buff_defend -= 1
		if turns_buff_defend == 0:
			current_defence = defence
			has_buff_defend = false
			
	if has_buff_accuracy:
		turns_buff_accuracy -= 1
		if turns_buff_accuracy == 0:
			current_accuracy = accuracy
			has_buff_accuracy = false
			
	if has_buff_luck:
		turns_buff_luck -= 1
		if turns_buff_luck == 0:
			current_luck = luck
			has_buff_luck = false
			
	if has_buff_high_energy:
		turns_buff_high_energy -= 1
		if turns_buff_high_energy == 0:
			energy = max_energy
			has_buff_high_energy = false

func die() -> void:
		audio_fall.play()
		sprite.play("dead")
		hp_bar.visible = false
		
		if get_parent().get_parent().name == "Battle":
			get_parent().get_parent().log_messages.append(str("- [color=#1ca8fd]", enemy_name_rus, "[/color] [color=#fc4e52]МЕРТВ[/color]\n"))
		

func after_battle_update() -> void:
	match state:
		"dead":
			xp_orb.material.set_shader_parameter("time_offset", position.x)
			xp_orb.visible = true
			status_fx.visible = false
			sprite.play("dead")

func _on_idle_animation_timer_timeout() -> void:
	sprite.play("idle")

func _on_take_damage_timer_timeout() -> void:
	hp -= taken_damage
	check_hp()
	$HPParticles.restart()
	
	display_damage(taken_damage)
	
	if not state == "dead":
		sprite.play("take_damage")
		audio_hurt.play()
		idle_animation_timer.start(0.2)
		
		var tween1 = create_tween()
		tween1.tween_property(sprite, "position:x", sprite.position.x + 4, 0.1)
		tween1.tween_property(sprite, "position:x", sprite.position.x, 0.1)
		
		var tween2 = create_tween()
		tween2.tween_property(sprite, "scale:y", 0.8, 0.1)
		tween2.tween_property(sprite, "scale:y", 1, 0.1)
		#get_parent().get_parent().end_turn()
		
		if gm.has_portrait_of_the_unknown:
			luck -= 3
			current_luck -= 3
			get_parent().get_parent().log_messages.append(str("- [color=#e9920a]Портрет неизвестной[/color]: удача существа [color=#1ca8fd]", enemy_name_rus, "[/color] падает на 3%\n"))
	else:
		die()

func _on_miss_damage_timer_timeout() -> void:
	var tween = create_tween()
	tween.tween_property(status_fx, "scale", Vector2(0, 0), 0.2)
	
	display_damage(0)
	
	if gm.has_boomerang:
		take_damage(1, attack_animation_time)
		return
	
	#get_parent().get_parent().end_turn()
	

func _on_defend_timer_timeout() -> void:
	audio_defend.play()
	#idle_animation_timer.start(0.2)
	var tween = create_tween()
	tween.tween_property(status_fx, "scale", Vector2(0, 0), 0.2)
	
	get_parent().get_parent().end_turn()

func _on_deal_damage_timer_timeout() -> void:
	var tween1 = create_tween()
	tween1.tween_property(sprite, "position:x", sprite.position.x + 4, 0.1)
	
	if is_hit_lucky:
		if gm.has_rainbow_pot: #ГОРШОЧЕК РАДУГИ
			get_parent().get_parent().human.rainbow_defend(2)
		
		luck_particles.restart()
		
		get_parent().get_parent().player_camera.apply_shake(0.2 + shake)
		audio_hit_lucky.play()
		var tween = create_tween()
		tween.tween_property(status_fx, "scale", Vector2(0, 0), 0.2)
		
		get_parent().get_parent().claw_fx.scale = Vector2(2, 2)
	elif is_hit_unlucky:
		unluck_particles.restart()
		$AudioStreamPlayerHitUnlucky.play()
		get_parent().get_parent().player_camera.apply_shake(0.1)
	else:
		get_parent().get_parent().player_camera.apply_shake(shake)
		audio_hit.play()
		
		get_parent().get_parent().claw_fx.scale = Vector2(1, 1)
		
	get_parent().get_parent().claw_fx.position = current_target.position
	get_parent().get_parent().claw_fx.play("hit")
	
	if just_missed:
		current_damage = 0
		just_missed = false
	
	if current_target == get_parent().get_parent().giant:
		if element == "might":
			current_damage = int(current_damage * (1.0 - gm.current_might_resistance_cat))
		elif element == "fire":
			current_damage = int(current_damage * (1.0 - gm.current_fire_resistance_cat))
		elif element == "wind":
			current_damage = int(current_damage * (1.0 - gm.current_wind_resistance_cat))
		elif element == "luck":
			current_damage = int(current_damage * (1.0 - gm.current_luck_resistance_cat))
		elif element == "death":
			current_damage = int(current_damage * (1.0 - gm.current_death_resistance_cat))
		elif element == "life":
			current_damage = int(current_damage * (1.0 - gm.current_life_resistance_cat))
	elif current_target == get_parent().get_parent().human:
		if element == "might":
			current_damage = int(current_damage * (1.0 - gm.current_might_resistance_human))
		elif element == "fire":
			current_damage = int(current_damage * (1.0 - gm.current_fire_resistance_human))
		elif element == "wind":
			current_damage = int(current_damage * (1.0 - gm.current_wind_resistance_human))
		elif element == "luck":
			current_damage = int(current_damage * (1.0 - gm.current_luck_resistance_human))
		elif element == "death":
			current_damage = int(current_damage * (1.0 - gm.current_death_resistance_human))
		elif element == "life":
			current_damage = int(current_damage * (1.0 - gm.current_life_resistance_human))
	
	if current_damage == 0:
		get_parent().get_parent().log_messages.append(str("- [color=#1ca8fd]", enemy_name_rus, "[/color] атакует существо [color=#1ca8fd]", 
			current_target.character_name_display, "[/color]. Промах!\n"))
	else:
		if is_hit_lucky:
			get_parent().get_parent().log_messages.append(str("- [color=#8bc882]Удача![/color] [color=#1ca8fd]", enemy_name_rus, "[/color] наносит [color=#fc4e52]", current_damage, 
			" урона[/color] существу [color=#1ca8fd]", current_target.character_name_display, "[/color]\n"))
		else:
			get_parent().get_parent().log_messages.append(str("- [color=#1ca8fd]", enemy_name_rus, "[/color] наносит [color=#fc4e52]", current_damage, 
				" урона[/color] существу [color=#1ca8fd]", current_target.character_name_display, "[/color]\n"))
			
	current_target.take_damage(current_damage, attack_animation_time)
	
	current_damage = damage
	idle_animation_timer.start(0.2)

func _on_debuff_timer_timeout() -> void:
	var tween = create_tween()
	tween.tween_property(status_fx, "scale", Vector2(0, 0), 0.2)
	var tween1 = create_tween()
	tween1.tween_property(current_target.status_fx, "scale", Vector2(0, 0), 0.2)
	
	get_parent().get_parent().end_turn()
