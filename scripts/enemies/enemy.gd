class_name Enemy extends CharacterBody2D

@export var damage_indicator_scene: PackedScene

@export var hp = 2
@export var max_hp = 2

var taken_damage = 0
@export var damage = 1
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

var gave_xp = false
var state = "idle"

var enemy_type = "enemy"
var enemy_name = "enemy"
var enemy_scene_path = "enemy.tscn"
var enemy_name_rus = "Враг"

var follow_radius = 1
var is_following = false

var standard_move_path : Array[Vector2] = [Vector2(-32, 0), Vector2(0, -32), Vector2(32, 0), Vector2(0, 32), Vector2(0, 0)]
@export var step_count = 0

var move_set : Array = ["deal_damage", "defend", "debuff", "buff"]

var debuff_set : Array = [["weakness", 1, 2], ["undefend", 100, 2], ["inaccuracy", 10, 2], \
["unluck", 5, 2], ["low_energy", 1, 2]]

var buff_set : Array = [["strength", 1, 2], ["defend", 1, 2], ["accuracy", 10, 2], \
["luck", 5, 2], ["high_energy", 1, 2]]

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

var follow_step_count = 0
var follow_distance = 5

var battle_x = 0
var battle_y = 0

var current_target : CharacterBody2D
var attack_animation_time = 0.3
var defend_animation_time = 0.3
var debuff_animation_time = 0.3
var buff_animation_time =   0.3

@onready var sprite = $AnimatedSprite2D
@onready var area = $Area2D
@onready var area_xp = $Area2DXP

@onready var audio_follow = $AudioStreamPlayerFollow
@onready var audio_hit = $AudioStreamPlayerHit
@onready var audio_hit_lucky = $AudioStreamPlayerHitLucky
@onready var audio_hurt = $AudioStreamPlayerHurt
@onready var audio_fall = $AudioStreamPlayerFall
@onready var audio_miss = $AudioStreamPlayerMiss
@onready var audio_defend = $AudioStreamPlayerDefend
@onready var audio_debuff = $AudioStreamPlayerDebuff

@onready var idle_animation_timer = $IdleAnimationTimer
@onready var deal_damage_timer = $DealDamageTimer
@onready var take_damage_timer = $TakeDamageTimer
@onready var miss_damage_timer = $MissDamageTimer
@onready var defend_timer = $DefendTimer
@onready var debuff_timer = $DebuffTimer

@onready var xp_orb = $XpOrb
@onready var status_fx = $StatusFX

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	status_fx.play("found_you")
	battle_x = get_parent().get_parent().find_child("TileMapLayerBlack").local_to_map(position).x
	battle_y = get_parent().get_parent().find_child("TileMapLayerBlack").local_to_map(position).y

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	check_hp()
	
	match state:
		"idle":
			pass
		"dead":
			area_xp.monitoring = true
			area.monitoring = false
			
	move_and_slide()

func move(g_pos : Vector2, e_pos : Vector2) -> void:
	if state == "idle":
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
	gm.current_enemies.append(self)
	if not gm.state == "battle":
		gm.state = "battle"
		
		get_parent().get_parent().start_battle()
		
		audio_hit.pitch_scale = randf_range(0.8, 1.2)
		audio_hit.play()

func _on_area_2dxp_area_entered(area: Area2D) -> void:
	if not gave_xp and not gm.state == "battle":
		xp_orb.visible = false
		gave_xp = true
		gm.xp += xp_gives
		get_parent().get_parent().find_child("Giant").check_xp()

func check_hp() -> void:
	if hp <= 0:
		hp = 0
		state = "dead"
		
		if is_following:
			is_following = false
			gm.enemies_following -= 1

func deal_damage(target : Giant) -> void:
	var success : bool = randf_range(0.0, 1.0) * 100 <= accuracy
	var luck_success : bool = randf_range(0.0, 1.0) * 100 <= luck
	current_target = target
	
	var tween1 = create_tween()
	tween1.tween_property(self, "position:x", position.x - 4, 0.1)
	
	if success:
		if luck_success:
			status_fx.scale = Vector2(0, 0)
			status_fx.play("lucky")
			status_fx.visible = true
			
			var tween = create_tween()
			tween.tween_property(status_fx, "scale", Vector2(1, 1), 0.2)
			
			current_damage = damage * 2
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
		hp -= dmg
		take_damage_timer.start(time)
	else:
		if defended:
			audio_defend.play()
			status_fx.play("defended")
			status_fx.visible = true
			
			var tween = create_tween()
			tween.tween_property(status_fx, "scale", Vector2(1, 1), 0.2)
		
			defended = false
		else:
			audio_miss.play()
		miss_damage_timer.start(time)
		
func defend() -> void:
	current_defence += defence
	
	if current_defence > max_defence:
		current_defence = max_defence
	
	status_fx.scale = Vector2(0, 0)
	status_fx.play("defend")
	status_fx.visible = true
	
	var tween = create_tween()
	tween.tween_property(status_fx, "scale", Vector2(1, 1), 0.2)
	
	if damage > 0:
		defend_timer.start(defend_animation_time)
	else:
		defend_timer.start(defend_animation_time)
		
func give_debuff(target : Giant, type : String, power : int, turns : int) -> void:
	
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
			if gm.current_damage <= 0:
				gm.current_damage = 0
		"undefend":
			current_target.has_debuff_undefend = true
			current_target.turns_debuff_undefend += turns
			gm.current_defence -= power
			if gm.current_defence <= 0:
				gm.current_defence = 0
		"inaccuracy":
			current_target.has_debuff_inaccuracy = true
			current_target.turns_debuff_inaccuracy += turns
			gm.current_accuracy -= power
			if gm.current_accuracy <= 10:
				gm.current_accuracy = 10
		"unluck":
			current_target.has_debuff_unluck = true
			current_target.turns_debuff_unluck += turns
			gm.current_luck -= power
			if gm.current_luck <= -100:
				gm.current_luck  = -100
		"low_energy":
			current_target.has_debuff_low_energy = true
			current_target.turns_debuff_low_energy += turns
			gm.energy -= power
			if gm.energy <= 0:
				gm.energy  = 0
	
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
	
func turn_tick() -> void:
	#current_defence /= 2
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
	check_hp()
	
	if damage_indicator_scene:
		var indicator = damage_indicator_scene.instantiate()
		var spawn_pos = global_position + Vector2(0, -2)
		
		add_child(indicator)
		indicator.display_damage(taken_damage, spawn_pos)
	
	if not state == "dead":
		sprite.play("take_damage")
		audio_hurt.play()
		idle_animation_timer.start(0.2)
		get_parent().get_parent().end_turn()
	else:
		audio_fall.play()
		sprite.play("dead")
		
		get_parent().get_parent().end_turn()

func _on_miss_damage_timer_timeout() -> void:
	var tween = create_tween()
	tween.tween_property(status_fx, "scale", Vector2(0, 0), 0.2)
	if damage_indicator_scene:
		var indicator = damage_indicator_scene.instantiate()
		var spawn_pos = global_position + Vector2(0, -2)
		
		add_child(indicator)
		indicator.display_damage(0, spawn_pos)
	
	get_parent().get_parent().end_turn()
	

func _on_defend_timer_timeout() -> void:
	audio_defend.play()
	#idle_animation_timer.start(0.2)
	var tween = create_tween()
	tween.tween_property(status_fx, "scale", Vector2(0, 0), 0.2)
	
	get_parent().get_parent().end_turn()

func _on_deal_damage_timer_timeout() -> void:
	var tween1 = create_tween()
	tween1.tween_property(self, "position:x", position.x + 4, 0.1)
	
	if current_damage > damage:
		audio_hit_lucky.play()
		var tween = create_tween()
		tween.tween_property(status_fx, "scale", Vector2(0, 0), 0.2)
	else:
		audio_hit.play()
	get_parent().get_parent().claw_fx.position = current_target.position
	get_parent().get_parent().claw_fx.play("hit")
	
	if just_missed:
		current_damage = 0
		just_missed = false
	
	current_target.take_damage(current_damage, attack_animation_time)
	
	current_damage = damage
	idle_animation_timer.start(0.2)

func _on_debuff_timer_timeout() -> void:
	var tween = create_tween()
	tween.tween_property(status_fx, "scale", Vector2(0, 0), 0.2)
	var tween1 = create_tween()
	tween1.tween_property(current_target.status_fx, "scale", Vector2(0, 0), 0.2)
	
	get_parent().get_parent().end_turn()
