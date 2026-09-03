extends Node2D

var cursor_pos
var cursor_map_pos

var turn_count = 0

var creature_dialog_on_screen = false
var inventory_on_screen = false

@onready var giant = $Giant
@onready var map = $TileMapLayerBlack
@onready var player_camera = $Giant/Camera2D
@onready var cursor = $Cursor

@onready var enemies = $Enemies
@onready var audio = $AudioStreamPlayerMusic
@onready var battle_start_timer = $BattleStartTimer

@onready var creature_check_dialog = $UI/CreatureAdventureDialog
@onready var inventory = $UI/Inventory
@onready var level_up_dialog = $UI/LevelUpDialog
@onready var upgrade_stats_dialog = $UI/UpgradeStatsDialog
@onready var artifact_dialog = $UI/ArtifactDialog
@onready var menu = $UI/Menu
@onready var inventory_button = $UI/InventoryButton

@onready var foregroundFX = $Effects/ColorRect

const BATTLE_SCENE = preload("res://scenes/levels/battle_level.tscn")

func _ready() -> void:
	scene_transitioner.change_scene_back()
	
	audio.play(gm.current_music_position)
	creature_check_dialog.visible = false
	player_camera.zoom = Vector2(gm.camera_zoom, gm.camera_zoom)
	
	inventory.position.x = 1500
	inventory.visible = true
	inventory.update_cards(inventory.state)
	
	level_up_dialog.visible = true
	level_up_dialog.position.x = -1500
	
	upgrade_stats_dialog.visible = true
	upgrade_stats_dialog.position.x = -1500
	
	artifact_dialog.visible = true
	artifact_dialog.position.x = -1500
	
	gm.enemies_following = 0
	
	gm.current_level_edge_positions.clear()
	for edge in find_child("Edges").get_children():
		gm.current_level_edge_positions.append(edge.position)


func _process(delta: float) -> void:
	if gm.state == "battle":
		pass
	
	cursor_pos = get_global_mouse_position()
	cursor_map_pos = map.local_to_map(cursor_pos)
		
	check_hp()
	
	if Input.is_action_just_pressed("ui_menu"):
		if menu.menu_on_screen:
			gm.state = gm.prev_state
			menu.hide_menu()
		else:	
			menu.show_menu()
	
	if inventory_on_screen:
		update_inventory()
	
	match gm.state:
		"idle":
			draw_cursor()
			if Input.is_action_just_pressed("ui_lmb"):
				move_to_map_pos()
				giant.walk()
				
			if map.local_to_map(giant.position) == cursor_map_pos:
				if Input.is_action_just_pressed("ui_rmb"):
					draw_inventory()
				
			if Input.is_action_pressed("ui_rmb"):
				creature_dialog_on_screen = true
				check_creature_stats() 
			else:
				if(creature_dialog_on_screen == true):
					var tween = create_tween()
					tween.tween_property(creature_check_dialog, "position:x", -500, 0.25)
					cursor.visible = true
					creature_dialog_on_screen = false	
					
				if Input.is_action_just_pressed("ui_scale_up") and gm.camera_zoom <= 3:
					gm.camera_zoom += 1
					smooth_camera_zoom(":zoom:x", gm.camera_zoom)
					smooth_camera_zoom(":zoom:y", gm.camera_zoom)
				elif Input.is_action_just_pressed("ui_scale_down") and gm.camera_zoom >= 3:
					gm.camera_zoom -= 1
					smooth_camera_zoom(":zoom:x", gm.camera_zoom)
					smooth_camera_zoom(":zoom:y", gm.camera_zoom)
		"checking_inventory":
			cursor.visible = false
			update_inventory()
		"checking_menu":
			cursor.visible = false

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
	cursor.visible = true
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
	pass

func enemy_turn() -> void:
	var g_pos = map.local_to_map(giant.position)
	
	for enemy in enemies.get_children():
		var e_pos = map.local_to_map(enemy.position)
		enemy.move(g_pos, e_pos)
			
	
func check_creature_stats() -> void:
	var cursor_grid_pos = map.local_to_map(get_global_mouse_position())
	var target_local_pos = map.map_to_local(cursor_grid_pos)
	
	var enemy_amount = 0
	var total_xp = 0
	var last_target : Enemy
	var is_dead = false
	
	for i in range(0, find_child("Enemies").get_child_count()):
		var target = find_child("Enemies").get_child(i)
		
		var e_map_pos = map.local_to_map(target.position)
			
		if e_map_pos.x == cursor_grid_pos.x and e_map_pos.y == cursor_grid_pos.y:
			if target.state == "dead":
				continue
				
			enemy_amount += 1
			total_xp += target.xp_gives
			last_target = target
		else:
			creature_check_dialog.visible = false
			
	if enemy_amount > 0:
		cursor.visible = false
		creature_check_dialog.position.x = -500
		var tween = create_tween()
		tween.tween_property(creature_check_dialog, "position:x", 20, 0.1)
		
		creature_check_dialog.find_child("SubViewportContainer").find_child("SubViewport").find_child("Camera2D").target_position = target_local_pos
		creature_check_dialog.visible = true
					
		if enemy_amount > 1:
			creature_check_dialog.find_child("NameLabel").text = "Отряд врагов"
		else:			
			creature_check_dialog.find_child("NameLabel").text = last_target.enemy_name_rus
					
		var stats = ""
		stats += 	str("ОПЫТ ЗА ПОБЕДУ:     ", total_xp)
		stats += 	str("\nКОЛИЧЕСТВО ВРАГОВ:  ", enemy_amount)
		creature_check_dialog.find_child("StatsLabel").text = stats

func draw_inventory() -> void:
	if inventory_on_screen:
		var tween = create_tween()
		tween.tween_property(inventory, "position:x", 1500, 0.3)
		inventory.artifact_check_dialog.visible = false
		inventory.card_check_dialog.visible = false
			
		inventory_on_screen = false
	else:
		inventory.hp_label.text = str(gm.hp, " / ", gm.max_hp)
			
		var stats = str(gm.damage)
		stats += 	str("\n", gm.defence, " (", gm.max_defence, ")")
		stats += 	str("\n", gm.accuracy, "%")
		stats += 	str("\n", gm.luck, "%")
		stats += 	str("\n", gm.max_energy_cat)
		stats += 	str("\n")
		stats += 	str("\n", gm.level)
		stats += 	str("\n", gm.xp, "/", gm.xp_needed)
		inventory.find_child("StatsLabel").text = stats
			
		var tween = create_tween()
		tween.tween_property(inventory, "position:x", 828, 0.3)
				
		inventory_on_screen = true

func update_inventory() -> void:
	inventory.hp_label.text = str(gm.hp, " / ", gm.max_hp)
	
	var stats = str(gm.damage)
	stats += 	str("\n", gm.defence, " (", gm.max_defence, ")")
	stats += 	str("\n", gm.accuracy, "%")
	stats += 	str("\n", gm.luck, "%")
	stats += 	str("\n", gm.max_energy_cat)
	stats += 	str("\n")
	stats += 	str("\n", gm.level)
	stats += 	str("\n", gm.xp, "/", gm.xp_needed)
	inventory.find_child("StatsLabel").text = stats
	
	inventory.update_cards(inventory.state)
	inventory.update_artifacts(inventory.state)
	inventory.set_hp_bar(float(gm.hp) / float(gm.max_hp))

func draw_level_up() -> void:
	level_up_dialog.visible = true
	level_up_dialog.position.x = 352
	level_up_dialog.scale = Vector2(0, 0)
	level_up_dialog.update_cards()
	level_up_dialog.level_label.text = str(gm.level-1, " → ", gm.level)
	gm.state = "leveling_up"
	
	var tween = create_tween()
	tween.tween_property(level_up_dialog, "scale", Vector2(1, 1), 0.5)
	
func draw_upgrade_stats(rarity : String) -> void:
	upgrade_stats_dialog.visible = true
	upgrade_stats_dialog.position.x = 320
	upgrade_stats_dialog.scale = Vector2(0, 0)
	upgrade_stats_dialog.update_stats(rarity)
	
	gm.state = "leveling_up"
	
	var tween = create_tween()
	tween.tween_property(upgrade_stats_dialog, "scale", Vector2(1, 1), 0.3)
	
func draw_artifact_dialog() -> void:
	artifact_dialog.visible = true
	artifact_dialog.position.x = 512
	artifact_dialog.scale = Vector2(0, 0)
	artifact_dialog.update_artifact()
	artifact_dialog.audio_appear.play()

	gm.state = "leveling_up"
	
	var tween = create_tween()
	tween.tween_property(artifact_dialog, "scale", Vector2(1, 1), 0.5)	

func start_battle() -> void:
	if not find_child("BattleNode").find_child("Battle") or gm.state == "battle":
		gm.current_music_position = audio.get_playback_position()
		audio.stop()
		$UI.visible = false
		
		$AudioStreamPlayerBattleStart.play()
		scene_transitioner.change_scene_to()
		battle_start_timer.start()
	
func end_battle() -> void:
	gm.state = "idle"
	gm.energy_cat = gm.max_energy_cat
	gm.energy_human = gm.max_energy_human
	gm.current_energy = gm.max_energy_human
	gm.current_damage = gm.damage
	gm.current_defence = gm.defence
	gm.current_accuracy = gm.accuracy
	gm.current_luck = gm.luck

	audio.play(gm.current_music_position)
	$Effects.visible = true
	$CanvasModulate.visible = true
	$UI.visible = true
	player_camera.enabled = true
	player_camera.zoom = Vector2(gm.camera_zoom, gm.camera_zoom)
	giant.light.enabled = true
	
	if gm.has_cat_food:
		giant.heal(2)

func _on_battle_start_timer_timeout() -> void:
	scene_transitioner.change_scene_back()
	
	gm.state = "idle"
	gm.energy_cat = gm.max_energy_cat
	gm.energy_human = gm.max_energy_human
	gm.current_energy = gm.max_energy_human
	gm.current_damage = gm.damage
	gm.current_defence = 0
	gm.current_accuracy = gm.accuracy
	gm.current_luck = gm.luck
	
	gm.state = "battle"
	gm.prev_state = gm.state
	
	if gm.has_old_bandage:
		gm.current_defence = 5
	
	giant.light.enabled = false
	inventory.position.x = 1500
	inventory_on_screen = false

	player_camera.enabled = false
	var battle = BATTLE_SCENE.instantiate()
	$CanvasModulate.visible = false
	$BattleNode.add_child(battle)
	$Effects.visible = false

func _on_inventory_button_mouse_entered() -> void:
	draw_inventory()
