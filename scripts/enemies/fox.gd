class_name Fox extends Enemy

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	enemy_scene_path = "fox.tscn"
	creature_name = "fox"
	enemy_name_rus = "Лиса"
	
	attack_animation_time = 0.4
	
	luck_resistance = 1.0
	unluck_resistance = 1.0
	max_hp = 30
	hp = 30
	
	hp_bar.max_value = max_hp
	hp_bar.value = float(hp)
	
	xp_gives = 10
	
	damage = 3
	current_damage = 3
	
	accuracy = 70
	current_accuracy = accuracy
	
	luck = 40
	current_luck = 40
	
	current_energy = 2
	energy = 2
	max_energy = 2
	
	move_set = ["deal_damage", "buff"]
	buff_set = [["luck", 10, 2]]
	
	status_fx.play("found_you")
	battle_x = get_parent().get_parent().find_child("TileMapLayerBlack").local_to_map(position).x
	battle_y = get_parent().get_parent().find_child("TileMapLayerBlack").local_to_map(position).y
	
	positions.append(Vector2(battle_x, battle_y))
	check_team()

# Called every frame. 'delta' is the elapsed time since the previous frame.
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
			
