extends Node2D

var cursor_pos
var cursor_map_pos

var creature_dialog_on_screen = false
var battle_ended = false

@onready var cursor = $Cursor
@onready var map = $TileMapLayerBlack
@onready var player_camera = $Giant/Camera2D
@onready var giant = $Giant
@onready var claw_fx = $ClawFX

@onready var end_battle_button = $UI/EndBattleButton
@onready var creature_check_dialog = $UI/CreatureDialog
@onready var card_container = $UI/CardContainer
@onready var current_creature_stats : CharacterBody2D

@onready var check_dialog_timer = $CheckStatsDialogHoldTimer
var is_check_dialog_holding = false

var turn_count = 1

var won = false
var defeated = false

var current_selected_card: Control = null
var current_creature_turn = -1

var enemy_positions : Array[Vector2] = [Vector2(208, 112), Vector2(208, 144), Vector2(208, 80), \
Vector2(240, 112), Vector2(240, 144), Vector2(240, 80), \
Vector2(208, 176), Vector2(208, 48), Vector2(240, 176), Vector2(240, 48)]
var current_enemies : Array

func _ready() -> void:
	creature_check_dialog.visible = false
	end_battle_button.visible = false
	
	player_camera.zoom.x = gm.camera_zoom
	player_camera.zoom.y = gm.camera_zoom
	init()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not battle_ended:
		check_battle_status()
	
	cursor_pos = map.get_global_mouse_position()
	cursor_map_pos = map.local_to_map(cursor_pos)
	cursor.global_position = map.map_to_local(cursor_map_pos)
	
	draw_cursor()
	display_cursor_label() 
	
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
		check_dialog_timer.start()
	if Input.is_action_just_released("ui_rmb"):
		if is_check_dialog_holding:
			check_creature_stats()
		
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

func display_cursor_label() -> void:
	var cursor_grid_pos = map.local_to_map(get_global_mouse_position())
	var target_local_pos = map.map_to_local(cursor_grid_pos)
	var cursor_label = cursor.find_child("Label")
	cursor_label.visible = false
	var cursor_icon = cursor.find_child("Icon")
	cursor_icon.visible = false
	
	for i in range(0, find_child("Enemies").get_child_count()):
		var targets : Array[CharacterBody2D] = [find_child("Enemies").get_child(i)]
		
		match gm.state:
			"battle_attack":
				for e_pos in targets.get(0).positions:
					if e_pos.x == cursor_grid_pos.x and e_pos.y == cursor_grid_pos.y:
						if not targets.get(0).state == "dead":
							
							cursor_label.visible = true
							cursor_icon.visible = true
							cursor_label.text = str(card_container.current_selected.damage - targets.get(0).current_defence)
				

func find_enemy_by_position(battle_x : int, battle_y : int) -> Enemy:
	for enemy in find_child("Enemies").get_children():
		if enemy.battle_x == battle_x and enemy.battle_y == battle_y:
			return enemy
	return null

func draw_cursor() -> void:	
	for enemy in find_child("Enemies").get_children():
		enemy.cursor.visible = false
	
	var cursor_grid_pos = map.local_to_map(get_global_mouse_position())
	var target_local_pos = map.map_to_local(cursor_grid_pos)
	
	for i in range(0, find_child("Enemies").get_child_count()):
		var targets : Array[CharacterBody2D] = [find_child("Enemies").get_child(i)]
			
		if gm.current_card != null: #ВЫБОР ЦЕЛЕЙ
			if gm.current_card.behind_attack:
				var target_2 = find_enemy_by_position(targets[0].battle_x + 1, targets[0].battle_y)
				if target_2 != null:
					if target_2.state != "dead":
						targets.append(target_2)
							
			elif gm.current_card.row_attack_3:
				var target_2 = find_enemy_by_position(targets[0].battle_x, targets[0].battle_y + 1)
				if target_2 != null:
					if target_2.state != "dead":
						targets.append(target_2)
				var target_3 = find_enemy_by_position(targets[0].battle_x, targets[0].battle_y - 1)
				if target_3 != null:
					if target_3.state != "dead":
						targets.append(target_3)
							
			elif gm.current_card.row_attack_5:
				var target_2 = find_enemy_by_position(targets[0].battle_x, targets[0].battle_y + 1)
				if target_2 != null:
					if target_2.state != "dead":
						targets.append(target_2)
				var target_3 = find_enemy_by_position(targets[0].battle_x, targets[0].battle_y - 1)
				if target_3 != null:
					if target_3.state != "dead":
						targets.append(target_3)
				var target_4 = find_enemy_by_position(targets[0].battle_x, targets[0].battle_y + 2)
				if target_4 != null:
					if target_4.state != "dead":
						targets.append(target_4)
				var target_5 = find_enemy_by_position(targets[0].battle_x, targets[0].battle_y - 2)
				if target_5 != null:
					if target_5.state != "dead":
						targets.append(target_5)			
							
			elif gm.current_card.cross_attack:
				var target_2 = find_enemy_by_position(targets[0].battle_x + 1, targets[0].battle_y)
				if target_2 != null:
					if target_2.state != "dead":
						targets.append(target_2)
				var target_3 = find_enemy_by_position(targets[0].battle_x - 1, targets[0].battle_y)
				if target_3 != null:
					if target_3.state != "dead":
						targets.append(target_3)
				var target_4 = find_enemy_by_position(targets[0].battle_x, targets[0].battle_y + 1)
				if target_4 != null:
					if target_4.state != "dead":
						targets.append(target_4)
				var target_5 = find_enemy_by_position(targets[0].battle_x, targets[0].battle_y - 1)
				if target_5 != null:
					if target_5.state != "dead":
						targets.append(target_5)
				
			elif gm.current_card.everybody_attack:
				for enemy in find_child("Enemies").get_children():
						targets.append(enemy)
		for e_pos in targets.get(0).positions:
			if e_pos.x == cursor_grid_pos.x and e_pos.y == cursor_grid_pos.y:
				if not targets.get(0).state == "dead":
					for t in targets:
						t.cursor.visible = true
					
func choose_target(action : String) -> void:
	var cursor_grid_pos = map.local_to_map(get_global_mouse_position())
	var target_local_pos = map.map_to_local(cursor_grid_pos)
	
	var source = find_child("Giant", true, false)
	
	for i in range(0, find_child("Enemies").get_child_count()):
		var targets : Array[CharacterBody2D] = [find_child("Enemies").get_child(i)]
		
		if gm.current_card != null: #ВЫБОР ЦЕЛЕЙ
			if gm.current_card.behind_attack:
				var target_2 = find_enemy_by_position(targets[0].battle_x + 1, targets[0].battle_y)
				if target_2 != null:
					if target_2.state != "dead":
						targets.append(target_2)
						
			elif gm.current_card.row_attack_3:
				var target_2 = find_enemy_by_position(targets[0].battle_x, targets[0].battle_y + 1)
				if target_2 != null:
					if target_2.state != "dead":
						targets.append(target_2)
				var target_3 = find_enemy_by_position(targets[0].battle_x, targets[0].battle_y - 1)
				if target_3 != null:
					if target_3.state != "dead":
						targets.append(target_3)
						
			elif gm.current_card.row_attack_5:
				var target_2 = find_enemy_by_position(targets[0].battle_x, targets[0].battle_y + 1)
				if target_2 != null:
					if target_2.state != "dead":
						targets.append(target_2)
				var target_3 = find_enemy_by_position(targets[0].battle_x, targets[0].battle_y - 1)
				if target_3 != null:
					if target_3.state != "dead":
						targets.append(target_3)
				var target_4 = find_enemy_by_position(targets[0].battle_x, targets[0].battle_y + 2)
				if target_4 != null:
					if target_4.state != "dead":
						targets.append(target_4)
				var target_5 = find_enemy_by_position(targets[0].battle_x, targets[0].battle_y - 2)
				if target_5 != null:
					if target_5.state != "dead":
						targets.append(target_5)			
						
			elif gm.current_card.cross_attack:
				var target_2 = find_enemy_by_position(targets[0].battle_x + 1, targets[0].battle_y)
				if target_2 != null:
					if target_2.state != "dead":
						targets.append(target_2)
				var target_3 = find_enemy_by_position(targets[0].battle_x - 1, targets[0].battle_y)
				if target_3 != null:
					if target_3.state != "dead":
						targets.append(target_3)
				var target_4 = find_enemy_by_position(targets[0].battle_x, targets[0].battle_y + 1)
				if target_4 != null:
					if target_4.state != "dead":
						targets.append(target_4)
				var target_5 = find_enemy_by_position(targets[0].battle_x, targets[0].battle_y - 1)
				if target_5 != null:
					if target_5.state != "dead":
						targets.append(target_5)
			
			elif gm.current_card.everybody_attack:
				for enemy in find_child("Enemies").get_children():
					targets.append(enemy)
					
		for e_pos in targets.get(0).positions:
			if e_pos.x == cursor_grid_pos.x and e_pos.y == cursor_grid_pos.y:
				if not targets.get(0).state == "dead":
					match action:
						"deal_damage":
							source.deal_damage(targets)
						"debuff":
							var type_number = randi_range(0, gm.debuff_set.size()-1)
							var type = gm.debuff_set.get(type_number).get(0)
							var power = gm.debuff_set.get(type_number).get(1)
							var turns = gm.debuff_set.get(type_number).get(2)
							source.give_debuff(targets, type, power, turns)	
	
	#BUFFS
	if gm.battle_x == cursor_grid_pos.x and gm.battle_y == cursor_grid_pos.y:
		if not gm.state == "dead":
			match action:
				"defend":
					var defend_duration : float = 0.4
					source.defend(defend_duration)
				"buff":
						var type_number = randi_range(0, gm.buff_set.size()-1)
						var type = gm.buff_set.get(type_number).get(0)
						var power = gm.buff_set.get(type_number).get(1)
						var turns = gm.buff_set.get(type_number).get(2)
						#source.give_buff(target, type, power, turns)	
				
				
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
				source.defend()
			"debuff":
				var type_number = randi_range(0, source.debuff_set.size()-1)
				var type = source.debuff_set.get(type_number).get(0)
				var power = source.debuff_set.get(type_number).get(1)
				var turns = source.debuff_set.get(type_number).get(2)
				source.give_debuff(giant, type, power, turns)
			"buff":
				var target_number = randi_range(0, find_child("Enemies").get_child_count() - 1)
				var target = find_child("Enemies").get_child(target_number)
				
				var type_number = randi_range(0, source.buff_set.size()-1)
				var type = source.buff_set.get(type_number).get(0)
				var power = source.buff_set.get(type_number).get(1)
				var turns = source.buff_set.get(type_number).get(2)
				source.give_buff(target, type, power, turns)

		return
	else:
		end_turn()

func end_turn() -> void:
	if current_creature_turn == -1:
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
				giant.turn_tick()
				
				for e in current_enemies:
					e.current_energy = e.energy
					e.turn_tick()
				
				if gm.energy == 0:
					end_turn()
			
		enemy_turn()

func check_creature_stats() -> void:
	var cursor_grid_pos = map.local_to_map(get_global_mouse_position())
	var target_local_pos = map.map_to_local(cursor_grid_pos)
	var has_target = false
	
	creature_check_dialog.debuff_weakness.visible = false
	creature_check_dialog.debuff_undefend.visible = false
	creature_check_dialog.debuff_inaccuracy.visible = false
	creature_check_dialog.debuff_unluck.visible = false
	creature_check_dialog.debuff_low_energy.visible = false
	
	creature_check_dialog.buff_strength.visible = false
	creature_check_dialog.buff_defend.visible = false
	creature_check_dialog.buff_accuracy.visible = false
	creature_check_dialog.buff_luck.visible = false
	creature_check_dialog.buff_high_energy.visible = false
	
	if is_check_dialog_holding:
		current_creature_stats = null
		var tween = create_tween()
		tween.tween_property(creature_check_dialog, "position:x", -500, 0.25)
		creature_dialog_on_screen = false
		is_check_dialog_holding = false
		return
	
	if (gm.battle_x == cursor_grid_pos.x and gm.battle_y == cursor_grid_pos.y):
		if current_creature_stats == giant:
			current_creature_stats = null
			var tween = create_tween()
			tween.tween_property(creature_check_dialog, "position:x", -500, 0.25)
			creature_dialog_on_screen = false
			return
		
		has_target = true
		current_creature_stats = giant
		
		if not creature_dialog_on_screen:
			creature_check_dialog.position.x = -500
			var tween = create_tween()
			tween.tween_property(creature_check_dialog, "position:x", 40, 0.2)
					
			creature_check_dialog.visible = true
			
		creature_check_dialog.find_child("SubViewportContainer").find_child("SubViewport").find_child("Camera2D").target_position = target_local_pos	
			
		creature_dialog_on_screen = true
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
		
		if giant.has_debuff_weakness:
			creature_check_dialog.debuff_weakness.visible = true
			creature_check_dialog.label_turns_weakness.text = str(giant.turns_debuff_weakness)
		if giant.has_debuff_undefend:
			creature_check_dialog.debuff_undefend.visible = true
			creature_check_dialog.label_turns_undefend.text = str(giant.turns_debuff_undefend)
		if giant.has_debuff_inaccuracy:
			creature_check_dialog.debuff_inaccuracy.visible = true
			creature_check_dialog.label_turns_inaccuracy.text = str(giant.turns_debuff_inaccuracy)
		if giant.has_debuff_unluck:
			creature_check_dialog.debuff_unluck.visible = true
			creature_check_dialog.label_turns_unluck.text = str(giant.turns_debuff_unluck)
		if giant.has_debuff_low_energy:
			creature_check_dialog.debuff_low_energy.visible = true
			creature_check_dialog.label_turns_low_energy.text = str(giant.turns_debuff_low_energy)
			
		if giant.has_buff_strength:
			creature_check_dialog.buff_strength.visible = true
			creature_check_dialog.label_turns_strength.text = str(giant.turns_buff_strength)
		if giant.has_buff_defend:
			creature_check_dialog.buff_defend.visible = true
			creature_check_dialog.label_turns_defend.text = str(giant.turns_buff_defend)
		if giant.has_buff_accuracy:
			creature_check_dialog.buff_accuracy.visible = true
			creature_check_dialog.label_turns_accuracy.text = str(giant.turns_buff_accuracy)
		if giant.has_buff_luck:
			creature_check_dialog.buff_luck.visible = true
			creature_check_dialog.label_turns_luck.text = str(giant.turns_buff_luck)
		if giant.has_buff_high_energy:
			creature_check_dialog.buff_high_energy.visible = true	
			creature_check_dialog.label_turns_high_energy.text = str(giant.turns_buff_high_energy)
					
		return
	else:
		for i in range(0, find_child("Enemies").get_child_count()):
			var target = find_child("Enemies").get_child(i)
			
			for e_pos in target.positions:			
				if (e_pos.x == cursor_grid_pos.x and e_pos.y == cursor_grid_pos.y):
						if current_creature_stats == target:
							current_creature_stats = null
							var tween = create_tween()
							tween.tween_property(creature_check_dialog, "position:x", -500, 0.25)
							creature_dialog_on_screen = false
							return
							
						has_target = true
						current_creature_stats = target
						
						if not creature_dialog_on_screen:
							creature_check_dialog.position.x = -500
							var tween = create_tween()
							tween.tween_property(creature_check_dialog, "position:x", 40, 0.2)
							
						creature_check_dialog.find_child("SubViewportContainer").find_child("SubViewport").find_child("Camera2D").target_position = target_local_pos
						creature_check_dialog.visible = true
							
						creature_dialog_on_screen = true
						
						if target.has_debuff_weakness:
							creature_check_dialog.debuff_weakness.visible = true
							creature_check_dialog.label_turns_weakness.text = str(target.turns_debuff_weakness)
						if target.has_debuff_undefend:
							creature_check_dialog.debuff_undefend.visible = true
							creature_check_dialog.label_turns_undefend.text = str(target.turns_debuff_undefend)
						if target.has_debuff_inaccuracy:
							creature_check_dialog.debuff_inaccuracy.visible = true
							creature_check_dialog.label_turns_inaccuracy.text = str(target.turns_debuff_inaccuracy)
						if target.has_debuff_unluck:
							creature_check_dialog.debuff_unluck.visible = true
							creature_check_dialog.label_turns_unluck.text = str(target.turns_debuff_unluck)
						if target.has_debuff_low_energy:
							creature_check_dialog.debuff_low_energy.visible = true
							creature_check_dialog.label_turns_low_energy.text = str(target.turns_debuff_low_energy)
							
						if target.has_buff_strength:
							creature_check_dialog.buff_strength.visible = true
							creature_check_dialog.label_turns_strength.text = str(target.turns_buff_strength)
						if target.has_buff_defend:
							creature_check_dialog.buff_defend.visible = true
							creature_check_dialog.label_turns_defend.text = str(target.turns_buff_defend)
						if target.has_buff_accuracy:
							creature_check_dialog.buff_accuracy.visible = true
							creature_check_dialog.label_turns_accuracy.text = str(target.turns_buff_accuracy)
						if target.has_buff_luck:
							creature_check_dialog.buff_luck.visible = true
							creature_check_dialog.label_turns_luck.text = str(target.turns_buff_luck)
						if target.has_buff_high_energy:
							creature_check_dialog.buff_high_energy.visible = true
							creature_check_dialog.label_turns_high_energy.text = str(target.turns_buff_high_energy)
							
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
				
	if not has_target:
		var tween = create_tween()
		tween.tween_property(creature_check_dialog, "position:x", -500, 0.25)
		creature_dialog_on_screen = false

func check_enemy_army() -> void:
	var dead_count = 0
	
	for i in range(0, find_child("Enemies").get_child_count()):
		var enemy = find_child("Enemies").get_child(i)
		
		if enemy.state == "dead":
			dead_count += 1

	if dead_count >= current_enemies.size():
		won = true
		
func check_giant_army() -> void:
	if gm.state == "dead":
		defeated = true		

func check_battle_status() -> void:
	check_enemy_army()
	check_giant_army()
	
	if won:
		battle_ended = true
		$WinTimer.start()
	elif defeated:
		battle_ended = true
		$WinTimer.start()	
		

func _on_end_battle_button_pressed() -> void:
	if won:
		for enemy in gm.current_enemies:
			enemy.state = "dead"
			enemy.after_battle_update()
			
		gm.current_enemies.clear()
		print("ПОБЕДА")
		get_parent().get_parent().end_battle()
		queue_free()
	elif defeated:
		get_tree().quit()	


func _on_check_stats_dialog_hold_timer_timeout() -> void:
	if Input.is_action_pressed("ui_rmb"):
		is_check_dialog_holding = true
	else:
		is_check_dialog_holding = false


func _on_win_timer_timeout() -> void:
		var tween = create_tween()
		tween.tween_property($AudioStreamPlayerMusic, "volume_db", -15, 0.3)
		
		$AudioStreamPlayerWin.play()
		end_battle_button.visible = true
		end_battle_button.disabled = false
