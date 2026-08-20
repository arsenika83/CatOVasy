extends Node2D

var cursor_pos
var cursor_map_pos

@onready var cursor = $Cursor
@onready var map = $TileMapLayerBlack
@onready var player_camera = $Giant/Camera2D
@onready var giant = $Giant
@onready var claw_fx = $ClawFX

var turn_count = 0

var won = false
var defeated = false

var current_selected_card: Control = null

var enemy_positions : Array[Vector2] = [Vector2(208, 112), Vector2(208, 144), Vector2(208, 80), Vector2(240, 112), Vector2(240, 144), Vector2(240, 80)]

func _ready() -> void:
	player_camera.zoom.x = gm.camera_zoom
	player_camera.zoom.y = gm.camera_zoom
	init()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	check_battle_status()
	
	cursor_pos = map.get_global_mouse_position()
	cursor_map_pos = map.local_to_map(cursor_pos)
	cursor.global_position = map.map_to_local(cursor_map_pos)
	
	if Input.is_action_just_pressed("ui_scale_up") and gm.camera_zoom <= 3:
		gm.camera_zoom += 1
		smooth_camera_zoom(":zoom:x", gm.camera_zoom)
		smooth_camera_zoom(":zoom:y", gm.camera_zoom)
	elif Input.is_action_just_pressed("ui_scale_down") and gm.camera_zoom >= 3:
		gm.camera_zoom -= 1
		smooth_camera_zoom(":zoom:x", gm.camera_zoom)
		smooth_camera_zoom(":zoom:y", gm.camera_zoom)
		
	if Input.is_action_just_pressed("ui_rmb"):
		check_creature_stats()
	elif Input.is_action_just_pressed("ui_lmb"):
		match gm.state:
			"battle_attack":
				choose_target("deal_damage")

func smooth_camera_zoom(value1, value2) -> void:
	var tween = create_tween()
	tween.tween_property(player_camera, str(value1), value2, 0.5)	

func init() -> void:
	giant.light.enabled = false
	var enemy_count = 0
	
	for e in gm.current_enemies:
		print(enemy_count)
		var enemy_scene = load("res://scenes/enemies/" + e.enemy_scene_path)
		#const ENEMY_SCENE = preload("res://scenes/enemies/enemy.tscn")
		var enemy = enemy_scene.instantiate()
		enemy.position = enemy_positions.get(enemy_count)
		enemy.z_index = 32
		
		$Enemies.add_child(enemy)
		enemy_count += 1

func win() -> void:
	pass

func lose() -> void:
	pass	

func choose_target(action : String) -> void:
	var cursor_grid_pos = map.local_to_map(get_global_mouse_position())
	var target_local_pos = map.map_to_local(cursor_grid_pos)
	
	var source = find_child("Giant", true, false)
	
	for i in range(0, find_child("Enemies").get_child_count()):
		var target = find_child("Enemies").get_child(i)
		if target.name.contains("Player"):
			if target.battle_x == cursor_grid_pos.x and target.battle_y == cursor_grid_pos.y:
				if not target.dead:
					if source.healer: #HEAL
						if target.hp < target.max_hp:
							source.heal(target, source.min_damage)
							print("> ", source.name, " HEALED ", target.name)
							#end_turn()
			else:	
				print("> ", source.name, " DIDNT HEAL ", target.name)
		
		elif target.battle_x == cursor_grid_pos.x and target.battle_y == cursor_grid_pos.y: #HIT
			if not target.state == "dead":
				match action:
					"deal_damage":
						var attack_duration : float = 0.4
						source.deal_damage(target, attack_duration)
						claw_fx.position = target_local_pos
						claw_fx.play("hit")
				#end_turn()
		else: #MOVE
			var source_grid_pos = map.local_to_map(source.global_position)
			
			var move_enabled = false
			#for j in range(0, find_child("BattleCellsPlayer").get_child_count()):
				#var cell = find_child("BattleCellsPlayer").get_child(j)
				#if cell.battle_x == cursor_grid_pos.x and cell.battle_y == cursor_grid_pos.y and cell.is_free:
					#move_enabled = true
					#break
			
			if move_enabled:
				var diff_x = abs(cursor_grid_pos.x - source_grid_pos.x)
				var diff_y = abs(cursor_grid_pos.y - source_grid_pos.y)
				
				if diff_x <= source.battle_speed_current and diff_y <= source.battle_speed_current:
					source.global_position = target_local_pos
					#current_creature_indicator.global_position = target_local_pos
					#update_creature_position(source)
					#update_cell_status()
					source.battle_speed_current -= max(diff_x, diff_y)
						
					if source.battle_speed_current == 0:
						source.battle_speed_current = source.battle_speed #ВОССТАНАВЛИВАЕМ СКОРОСТЬ
						#end_turn()
						

func check_enemy_army_dead() -> void:
	var dead_count = 0
	
	for i in range(0, find_child("Enemies").get_child_count()):
		var enemy = find_child("Enemies").get_child(i)
		
		if enemy.state == "dead":
			dead_count += 1

	if dead_count == gm.current_enemies.size():
		won = true

func check_battle_status() -> void:
	check_enemy_army_dead()
	
	if won:
		for enemy in gm.current_enemies:
			enemy.state = "dead"
			enemy.after_battle_update()
			
		gm.current_enemies.clear()
		print("ПОБЕДА")
		get_parent().get_parent().end_battle()
		queue_free()
		

func check_creature_stats() -> void:
	var cursor_grid_pos = map.local_to_map(get_global_mouse_position())
	var target_local_pos = map.map_to_local(cursor_grid_pos)
	
	for i in range(0, find_child("Enemies").get_child_count()):
		var target = find_child("Enemies").get_child(i)
	
		if target.battle_x == cursor_grid_pos.x and target.battle_y == cursor_grid_pos.y:
			#creature_check_dialog.visible = true
			if target.name == "Player":
				pass
				#creature_check_dialog.find_child("PortraitCreature").texture = load(str("res://assets/creature_portraits/portrait_", target.creature_name.to_lower(), ".png"))
			else:
				pass
				#creature_check_dialog.find_child("PortraitCreature").texture = load(str("res://assets/creature_portraits/portrait_", target.creature_name.to_lower()))
		
			if target.state == "dead":
				pass
				#creature_check_dialog.find_child("PortraitDead").visible = true
			else:
				pass
				#creature_check_dialog.find_child("PortraitDead").visible = false
				
			#creature_check_dialog.find_child("Name").text = target.creature_name_rus
			
			var stats = str("ОЗ: ", target.hp, "/", target.max_hp)
			stats += 	str("\nУРОН: ", target.damage)
			print(stats)
			#creature_check_dialog.find_child("Stats").text = stats
		else:
			pass
			print("NO TARGET ON THIS TILE: ", cursor_grid_pos.x, "_", cursor_grid_pos.y)
