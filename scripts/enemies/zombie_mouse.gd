class_name ZombieMouse extends Enemy

func _ready() -> void:
	enemy_scene_path = "zombie_mouse.tscn"
	enemy_name = "Zombie mouse"
	enemy_name_rus = "Мышь-зомби"
	defence_sprite.visible = false
	
	attack_animation_time = 0.4
	
	element = "death"
	death_resistance = 0.75
	
	max_hp = 10
	hp = 10
	
	hp_bar.max_value = max_hp
	hp_bar.value = float(hp)
	
	xp_gives = 3
	
	damage = 3
	current_damage = 3
	
	accuracy = 65
	current_accuracy = accuracy
	
	luck = 0
	current_luck = 0
	
	current_energy = 5
	energy = 5
	max_energy = 5
	
	move_set = ["deal_damage"]
	
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
			
