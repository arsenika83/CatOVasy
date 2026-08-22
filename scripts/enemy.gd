class_name Enemy extends Node2D

@export var hp = 2
@export var max_hp = 2

@export var damage = 1
var current_damage = damage

@export var defence = 1
var current_defence = 0
@export var max_defence = 3
var defended = false

@export var accuracy = 60
var current_accuracy = accuracy

@export var luck = 15
var current_luck = luck

var energy = 2
var current_energy = energy
var max_energy = 2

@export var xp_gives = 1

var gave_xp = false
var state = "idle"

var enemy_type = "enemy"
var enemy_name = "enemy"
var enemy_scene_path = "enemy.tscn"
var enemy_name_rus = "Враг"

var follow_radius = 1
var standard_move_path : Array[Vector2] = [Vector2(-32, 0), Vector2(0, -32), Vector2(32, 0), Vector2(0, 32), Vector2(0, 0)]
@export var step_count = 0

var move_set : Array = ["deal_damage", "defend", "debuff"]
var debuff_set : Array = [["weakness", 1, 1], ["undefend", 100, 1], ["inaccuracy", 10, 1], ["unluck", 5, 1], ["low_energy", 1, 1]]

var has_debuff_unluck = false
var has_debuff_inaccuracy = false
var has_debuff_weakness = false
var has_debuff_undefend = false
var has_debuff_low_energy = false

var follow_step_count = 0
var follow_distance = 5

var battle_x = 0
var battle_y = 0

var current_target : Giant
var attack_animation_time = 0.3
var defend_animation_time = 0.3
var debuff_animation_time = 0.3
var buff_animation_time = 0.3

@onready var sprite = $AnimatedSprite2D
@onready var area = $Area2D
@onready var area_xp = $Area2DXP

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
	print(str(battle_x, " ", battle_y))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	check_hp()
	
	match state:
		"idle":
			pass
		"dead":
			area_xp.monitoring = true
			area.monitoring = false

func move(g_pos : Vector2, e_pos : Vector2) -> void:
	if state == "idle":
		var diff_x = g_pos.x - e_pos.x
		var diff_y = g_pos.y - e_pos.y
		status_fx.visible = true
		status_fx.play("found_you")
		
		if abs(diff_x) > follow_radius or abs(diff_y) > follow_radius:
			status_fx.visible = false
			
			var next_step = Vector2(self.position.x + standard_move_path.get(step_count).x, self.position.y + standard_move_path.get(step_count).y)
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
			status_fx.play("lost_you")
			
			return
		
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
	if not gave_xp:
		xp_orb.visible = false
		gave_xp = true
		gm.xp += xp_gives
		get_parent().get_parent().find_child("Giant").check_xp()

func check_hp() -> void:
	if hp <= 0:
		hp = 0
		state = "dead"

func deal_damage(target : Giant) -> void:
	var success : bool = randf_range(0.0, 1.0) * 100 <= accuracy
	var luck_success : bool = randf_range(0.0, 1.0) * 100 <= luck
	current_target = target
	
	if success:
		if luck_success:
			status_fx.scale = Vector2(0, 0)
			status_fx.play("lucky")
			var tween1 = create_tween()
			tween1.tween_property(status_fx, "modulate:a", 1.0, 0.1)
			
			var tween = create_tween()
			tween.tween_property(status_fx, "scale", Vector2(1, 1), 0.2)
			
			current_damage = damage * 2
	else:
		current_damage = 0
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
	
	if dmg > 0:
		hp -= dmg
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
	current_defence += defence
	
	if current_defence > max_defence:
		current_defence = max_defence
	
	status_fx.scale = Vector2(0, 0)
	status_fx.play("defend")
	var tween1 = create_tween()
	tween1.tween_property(status_fx, "modulate:a", 1.0, 0.1)
	
	var tween = create_tween()
	tween.tween_property(status_fx, "scale", Vector2(1, 1), 0.2)
	
	if damage > 0:
		defend_timer.start(time)
	else:
		defend_timer.start(time)
		
func give_debuff(target : Giant, type : String, power : int, turns : int) -> void:
	
	current_target = target
	status_fx.scale = Vector2(0, 0)
	status_fx.play("debuff")
	var tween1 = create_tween()
	tween1.tween_property(status_fx, "modulate:a", 1.0, 0.1)
	var tween = create_tween()
	tween.tween_property(status_fx, "scale", Vector2(1, 1), 0.2)
	current_target.status_fx.play("debuff_" + type)
	
	match type:
		"weakness":
			gm.has_debuff_weakness = true
			
			gm.current_damage -= power
			if gm.current_damage <= 0:
				gm.current_damage = 0
		"undefend":
			gm.has_debuff_undefend = true
			
			gm.current_defence -= power
			if gm.current_defence <= 0:
				gm.current_defence = 0
		"inaccuracy":
			gm.has_debuff_inaccuracy = true
			gm.current_accuracy -= power
			if gm.current_accuracy <= 10:
				gm.current_accuracy = 10
		"unluck":
			gm.has_debuff_unluck = true
			gm.current_luck -= power
			if gm.current_luck <= -100:
				gm.current_luck  = -100
		"low_energy":
			gm.has_debuff_low_energy = true
			gm.energy -= power
			if gm.energy <= 0:
				gm.energy  = 0
	
	var tween2 = create_tween()
	tween2.tween_property(current_target.status_fx, "modulate:a", 1.0, 0.1)		
	var tween3 = create_tween()
	tween3.tween_property(current_target.status_fx, "scale", Vector2(1, 1), 0.2)	
	debuff_timer.start(gm.debuff_animation_time)	
	
	debuff_timer.start(debuff_animation_time)

func after_battle_update() -> void:
	match state:
		"dead":
			xp_orb.material.set_shader_parameter("time_offset", position.x)
			xp_orb.visible = true
			var tween = create_tween()
			tween.tween_property(status_fx, "modulate:a", 0.0, 0.1)
			sprite.play("dead")

func _on_idle_animation_timer_timeout() -> void:
	sprite.play("idle")

func _on_take_damage_timer_timeout() -> void:
	check_hp()
	
	if not state == "dead":
		sprite.play("take_damage")
		audio_hurt.play()
		idle_animation_timer.start(0.2)
		get_parent().get_parent().end_turn()
	else:
		print("DEAD CHECK")
		audio_fall.play()
		sprite.play("dead")
		
		get_parent().get_parent().end_turn()

func _on_miss_damage_timer_timeout() -> void:
	var tween = create_tween()
	tween.tween_property(status_fx, "scale", Vector2(0, 0), 0.2)
	get_parent().get_parent().end_turn()
	

func _on_defend_timer_timeout() -> void:
	audio_defend.play()
	#idle_animation_timer.start(0.2)
	var tween = create_tween()
	tween.tween_property(status_fx, "scale", Vector2(0, 0), 0.2)
	
	get_parent().get_parent().end_turn()

func _on_deal_damage_timer_timeout() -> void:
	if current_damage > damage:
		audio_hit_lucky.play()
		var tween = create_tween()
		tween.tween_property(status_fx, "scale", Vector2(0, 0), 0.2)
	else:	
		audio_hit.play()
	get_parent().get_parent().claw_fx.position = current_target.position
	get_parent().get_parent().claw_fx.play("hit")
	
	current_target.take_damage(current_damage, attack_animation_time)
	idle_animation_timer.start(0.2)

func _on_debuff_timer_timeout() -> void:
	var tween = create_tween()
	tween.tween_property(status_fx, "scale", Vector2(0, 0), 0.2)
	var tween1 = create_tween()
	tween1.tween_property(current_target.status_fx, "scale", Vector2(0, 0), 0.2)
	
	get_parent().get_parent().end_turn()
