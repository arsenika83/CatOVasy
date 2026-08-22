extends Node2D

var cursor_pos
var cursor_map_pos

var turn_count = 0

@onready var giant = $Giant
@onready var map = $TileMapLayerBlack
@onready var player_camera = $Giant/Camera2D
@onready var cursor = $Cursor

@onready var enemies = $Enemies
@onready var audio = $AudioStreamPlayer
@onready var battle_start_timer = $BattleStartTimer

@onready var health_bar = $UI/Container/HealthBar
@onready var life1 = $UI/Container/HealthBar/Life1
@onready var life2 = $UI/Container/HealthBar/Life2
@onready var life3 = $UI/Container/HealthBar/Life3
@onready var life4 = $UI/Container/HealthBar/Life4
@onready var life5 = $UI/Container/HealthBar/Life5

@onready var foregroundFX = $Effects/ColorRect

const BATTLE_SCENE = preload("res://scenes/levels/battle_level.tscn")

func _ready() -> void:
	player_camera.zoom.x = gm.camera_zoom
	player_camera.zoom.y = gm.camera_zoom


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if gm.state == "battle":
		pass
	
	cursor_pos = get_global_mouse_position()
	cursor_map_pos = map.local_to_map(cursor_pos)
	
	var diff_x = abs(cursor_map_pos.x - map.local_to_map(giant.position).x)
	var diff_y = abs(cursor_map_pos.y - map.local_to_map(giant.position).y)
	
	draw_cursor()
	check_hp()
	
	if gm.state == "idle":
		if Input.is_action_just_pressed("ui_lmb"):
			move_to_map_pos()
			giant.walk()
		
	if Input.is_action_just_pressed("ui_scale_up") and gm.camera_zoom <= 3:
		gm.camera_zoom += 1
		smooth_camera_zoom(":zoom:x", gm.camera_zoom)
		smooth_camera_zoom(":zoom:y", gm.camera_zoom)
	elif Input.is_action_just_pressed("ui_scale_down") and gm.camera_zoom >= 3:
		gm.camera_zoom -= 1
		smooth_camera_zoom(":zoom:x", gm.camera_zoom)
		smooth_camera_zoom(":zoom:y", gm.camera_zoom)	

func smooth_camera_zoom(value1, value2) -> void:
	var tween = create_tween()
	tween.tween_property(player_camera, str(value1), value2, 0.5)	
	
func move_to_map_pos() -> void:
	var map_pos = map.local_to_map(cursor_pos)
	
	var diff_x = map_pos.x - map.local_to_map(giant.position).x
	var diff_y = map_pos.y - map.local_to_map(giant.position).y
	
	if turn_count > 0:
		gm.prev_pos = giant.position
	turn_count += 1
	
	if abs(diff_x) <= 1 and abs(diff_y) <= 1:
		var tween = create_tween()
		tween.tween_property(giant, "position", map.map_to_local(map_pos), 0.2)
	
	if (diff_x == 0) and diff_y < 0:
		var tween = create_tween()
		tween.tween_property(giant, "position", Vector2(giant.position.x, giant.position.y - 32), 0.2)
	elif diff_x > 0 and diff_y < 0:
		giant.sprite.flip_h = true
		var tween = create_tween()
		tween.tween_property(giant, "position", Vector2(giant.position.x + 32, giant.position.y - 32), 0.2)
	elif diff_x > 0 and (diff_y == 0):
		giant.sprite.flip_h = true
		var tween = create_tween()
		tween.tween_property(giant, "position", Vector2(giant.position.x + 32, giant.position.y), 0.2)
	elif diff_x > 0 and diff_y > 0:
		giant.sprite.flip_h = true
		var tween = create_tween()
		tween.tween_property(giant, "position", Vector2(giant.position.x + 32, giant.position.y + 32), 0.2)
	elif (diff_x == 0) and diff_y > 0:
		var tween = create_tween()
		tween.tween_property(giant, "position", Vector2(giant.position.x, giant.position.y + 32), 0.2)
	elif diff_x < 0 and diff_y > 0:
		giant.sprite.flip_h = false
		var tween = create_tween()
		tween.tween_property(giant, "position", Vector2(giant.position.x - 32, giant.position.y + 32), 0.2)
	elif diff_x < 0 and (diff_y == 0):
		giant.sprite.flip_h = false
		var tween = create_tween()
		tween.tween_property(giant, "position", Vector2(giant.position.x - 32, giant.position.y), 0.2)
	elif diff_x < 0 and diff_y < 0:
		giant.sprite.flip_h = false
		var tween = create_tween()
		tween.tween_property(giant, "position", Vector2(giant.position.x - 32, giant.position.y - 32), 0.2)
		
	enemy_turn()
	
func draw_cursor() -> void:
	var map_pos = map.local_to_map(cursor_pos)
	
	var diff_x = map_pos.x - map.local_to_map(giant.position).x
	var diff_y = map_pos.y - map.local_to_map(giant.position).y
	
	if abs(diff_x) <= 1 and abs(diff_y) <= 1:
		cursor.global_position = map.map_to_local(cursor_map_pos)
	
	if (diff_x == 0) and diff_y < 0:
		cursor.global_position = Vector2(giant.position.x, giant.position.y - 32)
	elif diff_x > 0 and diff_y < 0:
		cursor.global_position = Vector2(giant.position.x + 32, giant.position.y - 32)
	elif diff_x > 0 and (diff_y == 0):
		cursor.global_position = Vector2(giant.position.x + 32, giant.position.y)
	elif diff_x > 0 and diff_y > 0:
		cursor.global_position = Vector2(giant.position.x + 32, giant.position.y + 32)
	elif (diff_x == 0) and diff_y > 0:
		cursor.global_position = Vector2(giant.position.x, giant.position.y + 32)
	elif diff_x < 0 and diff_y > 0:
		cursor.global_position = Vector2(giant.position.x - 32, giant.position.y + 32)
	elif diff_x < 0 and (diff_y == 0):
		cursor.global_position = Vector2(giant.position.x - 32, giant.position.y)
	elif diff_x < 0 and diff_y < 0:
		cursor.global_position = Vector2(giant.position.x - 32, giant.position.y - 32)
	
func check_hp() -> void:
	if gm.hp == 5:
		life5.visible = true
		life4.visible = true
		life3.visible = true
		life2.visible = true
		life1.visible = true
	elif gm.hp == 4:
		life5.visible = false
		life4.visible = true
		life3.visible = true
		life2.visible = true
		life1.visible = true
	elif gm.hp == 3:
		life5.visible = false
		life4.visible = false
		life3.visible = true
		life2.visible = true
		life1.visible = true
	elif gm.hp == 2:
		life5.visible = false
		life4.visible = false
		life3.visible = false
		life2.visible = true
		life1.visible = true
	elif gm.hp == 1:
		life5.visible = false
		life4.visible = false
		life3.visible = false
		life2.visible = false
		life1.visible = true
	else:
		life5.visible = false
		life4.visible = false
		life3.visible = false
		life2.visible = false
		life1.visible = false

func enemy_turn() -> void:
	var g_pos = map.local_to_map(giant.position)
	
	for enemy in enemies.get_children():
		var e_pos = map.local_to_map(enemy.position)
		enemy.move(g_pos, e_pos)
	

func start_battle() -> void:
	if not find_child("BattleNode").find_child("Battle") or gm.state == "battle":
		battle_start_timer.start()
	
func end_battle() -> void:
	gm.state = "idle"
	gm.energy = gm.max_energy
	gm.current_damage = gm.damage
	gm.current_defence = gm.defence
	gm.current_accuracy = gm.accuracy
	gm.current_luck = gm.luck
	#giant.position = gm.prev_pos
	audio.play()
	$Effects.visible = true
	$CanvasModulate.visible = true
	player_camera.enabled = true

func _on_battle_start_timer_timeout() -> void:
	gm.state = "battle"
	gm.prev_state = gm.state
	audio.stop()
	player_camera.enabled = false
	var battle = BATTLE_SCENE.instantiate()
	$CanvasModulate.visible = false
	$BattleNode.add_child(battle)
	$Effects.visible = false
