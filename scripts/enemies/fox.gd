class_name Fox extends Enemy

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	enemy_scene_path = "fox.tscn"
	enemy_name = "Fox"
	enemy_name_rus = "Лиса"
	
	attack_animation_time = 0.4
	
	max_hp = 30
	hp = 30
	
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

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	check_hp()
	
	match state:
		"idle":
			pass
		"dead":
			area_xp.monitoring = true
			area.monitoring = false
			
	move_and_slide()
