class_name FlyingMouse extends Enemy

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	enemy_scene_path = "flying_mouse.tscn"
	creature_name = "flying_mouse"
	enemy_name_rus = "Шариковая мышь"
	defence_sprite.visible = false
	
	element = "wind"
	is_flying = true
	is_big = true
	attack_animation_time = 0.4
	
	max_hp = 7
	hp = 7
	
	hp_bar.max_value = max_hp
	hp_bar.value = float(hp)
	
	xp_gives = 2
	
	damage = 3
	current_damage = damage
	
	accuracy = 70
	current_accuracy = accuracy
	
	luck = 5
	current_luck = 5
	
	current_energy = 1
	energy = 1
	max_energy = 1
	
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
			sprite.material.set_shader_parameter("speed", 0)
			hp_bar.visible = false
			area_xp.monitoring = true
			area.monitoring = false
			
