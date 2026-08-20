class_name Enemy extends Node2D

@export var hp = 2
@export var max_hp = 2

@export var damage = 1
@export var defence = 0
@export var accuracy = 50
@export var luck = 5
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

var follow_step_count = 0
var follow_distance = 5

var battle_x = 0
var battle_y = 0

@onready var sprite = $AnimatedSprite2D
@onready var area = $Area2D
@onready var area_xp = $Area2DXP

@onready var audio_hit = $AudioStreamPlayerHit
@onready var audio_fall = $AudioStreamPlayerFall
@onready var audio_miss = $AudioStreamPlayerMiss

@onready var idle_animation_timer = $IdleAnimationTimer
@onready var take_damage_timer = $TakeDamageTimer
@onready var miss_damage_timer = $MissDamageTimer

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
		print("CHECK 1")
		var diff_x = g_pos.x - e_pos.x
		print(str("diff_x ", diff_x))
		var diff_y = g_pos.y - e_pos.y
		print(str("diff_y ", diff_y))
		
		if (abs(diff_x) <= follow_radius) and (abs(diff_y) <= follow_radius):
			print("CHECK 2")
			status_fx.visible = true
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

func deal_damage(target : Giant, time : float) -> void:
	var success : bool = randf_range(0.0, 1.0) * 100 <= accuracy
	
	if success:
		target.take_damage(damage, time)
	else:
		target.take_damage(0, time)
		print("MISS! ")

func take_damage(damage : int, time : float) -> void:
	hp -= damage
	
	if damage > 0:
		take_damage_timer.start(time)
	else:
		miss_damage_timer.start(time)

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
	
	if not state == "dead":
		sprite.play("take_damage")
		audio_hit.play()
		idle_animation_timer.start(0.2)
		get_parent().get_parent().end_turn()
	else:
		print("DEAD CHECK")
		audio_fall.play()
		sprite.play("dead")
		
		get_parent().get_parent().end_turn()

func _on_miss_damage_timer_timeout() -> void:
	audio_miss.play()
	get_parent().get_parent().end_turn()
