extends Control

@onready var stats = $Stats
@onready var audio = $AudioStreamPlayer

func _ready() -> void:
	for child in stats.get_children():
		child.action = "base_damage_1"
		if child.has_signal("stat_selected"):
			child.stat_selected.connect(_on_stat_selected)

func _process(delta: float) -> void:
	pass

func update_stats(rarity : String) -> void:
	for child in stats.get_children():
		match rarity:
			"common":
				var rare_chance = randi_range(1, 100) < 5
				if rare_chance:
					rarity = "rare"
					
			"rare":
				var epic_chance = randi_range(1, 100) < 2
				if epic_chance:
					rarity = "epic"
					
			"epic":
				var unbelievable_chance = randi_range(1, 100) < 2
				if unbelievable_chance:
					rarity = "unbelievable"
					
			"unbelievable":
				var legendary_chance = randi_range(1, 100) < 3
				if legendary_chance:
					rarity = "legendary"
					
				
		match rarity:
			"common":
				var stat_index = randi_range(0, catalog.all_stat_names_common.size()-1)
				child.action = catalog.all_stat_names_common[stat_index]
				child.loaded = false
			"rare":
				var stat_index = randi_range(0, catalog.all_stat_names_rare.size()-1)
				child.action = catalog.all_stat_names_rare[stat_index]
				child.loaded = false
			"epic":
				var stat_index = randi_range(0, catalog.all_stat_names_epic.size()-1)
				child.action = catalog.all_stat_names_epic[stat_index]
				child.loaded = false
			"unbelievable":
				var stat_index = randi_range(0, catalog.all_stat_names_unbelievable.size()-1)
				child.action = catalog.all_stat_names_unbelievable[stat_index]
				child.loaded = false
			"legendary":
				var stat_index = randi_range(0, catalog.all_stat_names_legendary.size()-1)
				child.action = catalog.all_stat_names_legendary[stat_index]
				child.loaded = false	

func _on_stat_selected(stat : Control) -> void:
	audio.pitch_scale = randf_range(0.8, 1.1)
	audio.play()
	match stat.action:
		"base_damage_1":
			gm.damage += 1
		"base_damage_3":
			gm.damage += 3
		"base_damage_5":
			gm.damage += 5
		"defence_2":
			gm.defence += 2
		"defence_4":
			gm.defence += 4
		"defence_7":
			gm.defence += 7
		"max_defence_3":
			gm.max_defence += 3
		"max_defence_6":
			gm.max_defence += 6
		"max_defence_12":
			gm.max_defence += 12
		"accuracy_1":
			gm.accuracy += 1
		"accuracy_3":
			gm.accuracy += 3
		"accuracy_5":
			gm.accuracy += 5
		"luck_2":
			gm.luck += 2
		"luck_4":
			gm.luck += 4
		"luck_7":
			gm.luck += 7
		"hp_2":
			gm.max_hp += 2
			gm.hp += 2	
		"hp_5":
			gm.max_hp += 5
			gm.hp += 5
		"hp_10":
			gm.max_hp += 10
			gm.hp += 10
		"hp_20":
			gm.max_hp += 20
			gm.hp += 20
		"hp_50":
			gm.max_hp += 50
			gm.hp += 50
		"energy_1":
			gm.max_energy += 1
			gm.energy += 1
		"energy_2":
			gm.max_energy += 2
			gm.energy += 2
	
	if get_parent().get_parent().giant.check_xp():
		get_parent().get_parent().draw_level_up()
	
	visible = false
	position.x = -1500		
	gm.state = "idle"


func _on_mouse_entered() -> void:
	gm.state = "leveling_up"
