extends Node2D

var cursor_pos
var cursor_map_pos

var creature_dialog_on_screen = false

@onready var cursor = $Cursor
@onready var map = $TileMapLayerBlack
@onready var player_camera = $Giant/Camera2D
@onready var giant = $Giant
@onready var claw_fx = $ClawFX

@onready var end_battle_button = $UI/EndBattleButton
@onready var creature_check_dialog = $UI/CreatureDialog

var turn_count = 1

var won = false
var defeated = false

var current_selected_card: Control = null
var current_creature_turn = -1

var enemy_positions : Array[Vector2] = [Vector2(208, 112), Vector2(208, 144), Vector2(208, 80), Vector2(240, 112), Vector2(240, 144), Vector2(240, 80)]
var current_enemies : Array

func _ready() -> void:
	creature_check_dialog.visible = false
	end_battle_button.visible = false
	
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
		
	if Input.is_action_pressed("ui_rmb"):
		creature_dialog_on_screen = true
		check_creature_stats()
	else:
		if(creature_dialog_on_screen == true):
			var tween = create_tween()
			tween.tween_property(creature_check_dialog, "position:x", -500, 0.25)
		creature_dialog_on_screen = false
		
	if Input.is_action_just_pressed("ui_lmb"):
		if current_creature_turn == -1:
			match gm.state:
				"battle_attack":
					choose_target("deal_damage")
				"battle_defend":
					choose_target("defend")
				"battle_ability":
					choose_target("debuff")

func smooth_camera_zoom(value1, value2) -> void:
	var tween = create_tween()
	tween.tween_property(player_camera, str(value1), value2, 0.5)	

func init() -> void:
	giant.light.enabled = false
	gm.battle_x = map.local_to_map(giant.position).x
	gm.battle_y = map.local_to_map(giant.position).y
	
	var enemy_count = 0
	
	for e in gm.current_enemies:
		var enemy_scene = load("res://scenes/enemies/" + e.enemy_scene_path)
		var enemy = enemy_scene.instantiate()
		enemy.position = enemy_positions.get(enemy_count)
		enemy.z_index = 32
		enemy.battle_x = map.local_to_map(enemy.position).x
		enemy.battle_y = map.local_to_map(enemy.position).y
		enemy.state = "battle"
		
		$Enemies.add_child(enemy)
		current_enemies.append(enemy)
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
		
		if target.battle_x == cursor_grid_pos.x and target.battle_y == cursor_grid_pos.y:
			if not target.state == "dead":
				match action:
					"deal_damage":
						source.deal_damage(target)
					"debuff":
						var type_number = randi_range(0, gm.debuff_set.size()-1)
						var type = gm.debuff_set.get(type_number).get(0)
						var power = gm.debuff_set.get(type_number).get(1)
						var turns = gm.debuff_set.get(type_number).get(2)
						source.give_debuff(target, type, power, turns)	
	
	
	#BUFFS
	if gm.battle_x == cursor_grid_pos.x and gm.battle_y == cursor_grid_pos.y:
		if not gm.state == "dead":
			match action:
				"defend":
					var defend_duration : float = 0.4
					source.defend(defend_duration)
				
				
func enemy_turn() -> void:
	if current_creature_turn == -1:
		return
		
	var source = current_enemies.get(current_creature_turn)
		
	if not source.state == "dead":
		if gm.state == "dead":
			current_creature_turn = -1
			return
			
		var action_number = randi_range(0, source.move_set.size()-1)
		var action = source.move_set.get(action_number)
		
		match action:
			"deal_damage":
				source.deal_damage(giant)
			"defend":
				var defend_duration : float = 0.4
				source.defend(defend_duration)
			"debuff":
				var type_number = randi_range(0, source.debuff_set.size()-1)
				var type = source.debuff_set.get(type_number).get(0)
				var power = source.debuff_set.get(type_number).get(1)
				var turns = source.debuff_set.get(type_number).get(2)
				source.give_debuff(giant, type, power, turns)

		return
	else:
		end_turn()

func end_turn() -> void:
	
	if current_creature_turn == -1:
		gm.current_energy -= 1
		
		if gm.current_energy <= 0:
			gm.current_energy = 0
			
			current_creature_turn += 1
		
		enemy_turn()
	else:
		current_enemies.get(current_creature_turn).current_energy -= 1
	
		if current_enemies.get(current_creature_turn).current_energy <= 0:
			current_enemies.get(current_creature_turn).current_energy = 0
			
			current_creature_turn += 1
			
			if current_creature_turn == current_enemies.size():
				gm.current_energy = gm.energy
				turn_count += 1
				current_creature_turn = -1
				
				for e in current_enemies:
					e.current_energy = e.energy
			
		enemy_turn()

func check_creature_stats() -> void:
	var cursor_grid_pos = map.local_to_map(get_global_mouse_position())
	var target_local_pos = map.map_to_local(cursor_grid_pos)
	
	creature_check_dialog.debuff_weakness.visible = false
	creature_check_dialog.debuff_undefend.visible = false
	creature_check_dialog.debuff_inaccuracy.visible = false
	creature_check_dialog.debuff_unluck.visible = false
	creature_check_dialog.debuff_low_energy.visible = false
	
	if (gm.battle_x == cursor_grid_pos.x and gm.battle_y == cursor_grid_pos.y):
		creature_check_dialog.position.x = -500
		creature_check_dialog.find_child("SubViewportContainer").find_child("SubViewport").find_child("Camera2D").target_position = target_local_pos
		var tween = create_tween()
		tween.tween_property(creature_check_dialog, "position:x", 40, 0.2)
					
		creature_check_dialog.visible = true
		creature_check_dialog.find_child("NameLabel").text = "Гигант"
					
		var stats =   str("ОЗ:       ", gm.hp, "/", gm.max_hp)
		stats += 	str("\nУРОН:     ", gm.current_damage)
		stats += 	str("\nЗАЩИТА:   ", gm.current_defence, "/", gm.max_defence)
		stats += 	str("\nТОЧНОСТЬ: ", gm.current_accuracy, "%")
		stats += 	str("\nУДАЧА:    ", gm.current_luck, "%")
		stats += 	str("\nЭНЕРГИЯ:  ", gm.current_energy, "/", gm.max_energy)
		stats += 	str("\n")
		stats += 	str("\nУРОВЕНЬ:  ", gm.level)
		stats += 	str("\nОПЫТ:     ", gm.xp, "/", gm.xp_needed)
		creature_check_dialog.find_child("StatsLabel").text = stats
		
		if gm.has_debuff_weakness:
			creature_check_dialog.debuff_weakness.visible = true
		if gm.has_debuff_undefend:
			creature_check_dialog.debuff_undefend.visible = true
		if gm.has_debuff_inaccuracy:
			creature_check_dialog.debuff_inaccuracy.visible = true
		if gm.has_debuff_unluck:
			creature_check_dialog.debuff_unluck.visible = true
		if gm.has_debuff_low_energy:
			creature_check_dialog.debuff_low_energy.visible = true
					
		return
	else:
		for i in range(0, find_child("Enemies").get_child_count()):
			var target = find_child("Enemies").get_child(i)
			
			if (target.battle_x == cursor_grid_pos.x and target.battle_y == cursor_grid_pos.y):
					creature_check_dialog.position.x = -500
					var tween = create_tween()
					tween.tween_property(creature_check_dialog, "position:x", 40, 0.2)
					
					creature_check_dialog.find_child("SubViewportContainer").find_child("SubViewport").find_child("Camera2D").target_position = target_local_pos
					creature_check_dialog.visible = true
					
					if target.has_debuff_weakness:
						creature_check_dialog.debuff_weakness.visible = true
					if target.has_debuff_undefend:
						creature_check_dialog.debuff_undefend.visible = true
					if target.has_debuff_inaccuracy:
						creature_check_dialog.debuff_inaccuracy.visible = true
					if target.has_debuff_unluck:
						creature_check_dialog.debuff_unluck.visible = true
					if target.has_debuff_low_energy:
						creature_check_dialog.debuff_low_energy.visible = true	
						
					creature_check_dialog.find_child("NameLabel").text = target.enemy_name_rus
					
					var stats =   str("ОЗ:       ", target.hp, "/", target.max_hp)
					stats += 	str("\nУРОН:     ", target.current_damage)
					stats += 	str("\nЗАЩИТА:   ", target.current_defence, "/", target.max_defence)
					stats += 	str("\nТОЧНОСТЬ: ", target.current_accuracy, "%")
					stats += 	str("\nУДАЧА:    ", target.current_luck, "%")
					stats += 	str("\nЭНЕРГИЯ:  ", target.current_energy, "/", target.max_energy)
					stats += 	str("\n")
					stats += 	str("\nУРОВЕНЬ:  -")
					stats += 	str("\nОПЫТ:     ", target.xp_gives)
					creature_check_dialog.find_child("StatsLabel").text = stats
					
					return
			else:
				creature_check_dialog.visible = false
				#print("NO TARGET ON THIS TILE: ", cursor_grid_pos.x, "_", cursor_grid_pos.y)

func check_enemy_army() -> void:
	var dead_count = 0
	
	for i in range(0, find_child("Enemies").get_child_count()):
		var enemy = find_child("Enemies").get_child(i)
		
		if enemy.state == "dead":
			dead_count += 1

	if dead_count >= current_enemies.size():
		won = true

func check_battle_status() -> void:
	check_enemy_army()
	
	if won or defeated:
		end_battle_button.visible = true
		end_battle_button.disabled = false
		

func _on_end_battle_button_pressed() -> void:
	if won:
		for enemy in gm.current_enemies:
			enemy.state = "dead"
			enemy.after_battle_update()
			
		gm.current_enemies.clear()
		print("ПОБЕДА")
		get_parent().get_parent().end_battle()
		queue_free()
