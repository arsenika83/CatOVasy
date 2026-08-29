class_name BigEnemy extends Enemy

func _ready() -> void:
	is_big = true
	enemy_scene_path = "big_enemy.tscn"
	enemy_name = "Big"
	enemy_name_rus = "Большой враг"
	
	z_index += 10
	
	attack_animation_time = 0.2
	
	max_hp = 100
	hp = 100
	
	xp_gives = 100
	
	damage = 3
	current_damage = 3
	
	accuracy = 60
	current_accuracy = accuracy
	
	luck = 20
	current_luck = 20
	
	current_energy = 1
	energy = 1
	max_energy = 1
	
	move_set = ["deal_damage", "buff"]
	buff_set = [["strength", 5, 2]]
	
	status_fx.play("found_you")
	battle_x = get_parent().get_parent().find_child("TileMapLayerBlack").local_to_map(position).x
	battle_y = get_parent().get_parent().find_child("TileMapLayerBlack").local_to_map(position).y
	
	positions.append(Vector2(battle_x, battle_y))
	positions.append(Vector2(battle_x+1, battle_y))
	
	print(positions.get(0))
	print(positions.get(1))
