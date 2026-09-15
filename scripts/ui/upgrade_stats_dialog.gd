extends Control

@onready var stats = $Stats
@onready var audio = $AudioStreamPlayer

@onready var hp_bar = $TextureRectTop/HP
@onready var hp_label = $TextureRectTop/HPLabel
@onready var stats_label = $TextureRectTop/StatsLabel

@onready var cat_icon = $TextureRectTop/CatIcon
@onready var human_icon = $TextureRectTop/HumanIcon

var character = "cat"

func _ready() -> void:
	for child in stats.get_children():
		child.action = "base_damage_rare"
		if child.has_signal("stat_selected"):
			child.stat_selected.connect(_on_stat_selected)

func _process(delta: float) -> void:
	pass
	
func set_hp_bar(value : float) -> void:
	if character == "cat":
		hp_bar.material.set_shader_parameter("current_color", Color.from_string("#fc4e52", Color.WHITE))
	else:
		hp_bar.material.set_shader_parameter("current_color", Color.from_string("#4dbcfd", Color.WHITE))
	hp_bar.material.set_shader_parameter("fill_ratio", value)
	
func update_stats_on_screen() -> void:
	if character == "cat":
		$TextureRectTop/CatIcon.visible = true
		$TextureRectTop/HumanIcon.visible = false
		hp_label.text = str(gm.hp_cat, " / ", gm.max_hp_cat)
		set_hp_bar(float(gm.hp_cat) / float(gm.max_hp_cat))
				
		var stats = str(gm.damage_cat)
		stats += 	str("\n", gm.defence_cat, " (", gm.max_defence_cat, ")")
		stats += 	str("\n", gm.accuracy_cat, "%")
		stats += 	str("\n", gm.luck_cat, "%")
		stats += 	str("\n", gm.max_energy_cat)
		stats_label.text = stats
	else:
		$TextureRectTop/CatIcon.visible = false
		$TextureRectTop/HumanIcon.visible = true
		hp_label.text = str(gm.hp_human, " / ", gm.max_hp_human)
		set_hp_bar(float(gm.hp_human) / float(gm.max_hp_human))
				
		var stats = str(gm.damage_human)
		stats += 	str("\n", gm.defence_human, " (", gm.max_defence_human, ")")
		stats += 	str("\n", gm.accuracy_human, "%")
		stats += 	str("\n", gm.luck_human, "%")
		stats += 	str("\n", gm.max_energy_human)
		stats_label.text = stats
	
func swap_characters() -> void:
	if character == "cat":
		character = "human"
	else:
		character = "cat"

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
				child.rarity = rarity
				child.loaded = false
			"rare":
				var stat_index = randi_range(0, catalog.all_stat_names_rare.size()-1)
				child.action = catalog.all_stat_names_rare[stat_index]
				child.rarity = rarity
				child.loaded = false
			"epic":
				var stat_index = randi_range(0, catalog.all_stat_names_epic.size()-1)
				child.action = catalog.all_stat_names_epic[stat_index]
				child.rarity = rarity
				child.loaded = false
			"unbelievable":
				var stat_index = randi_range(0, catalog.all_stat_names_unbelievable.size()-1)
				child.action = catalog.all_stat_names_unbelievable[stat_index]
				child.rarity = rarity
				child.loaded = false
			"legendary":
				var stat_index = randi_range(0, catalog.all_stat_names_legendary.size()-1)
				child.action = catalog.all_stat_names_legendary[stat_index]
				child.rarity = rarity
				child.loaded = false	

func _on_stat_selected(stat : Control) -> void:
	audio.pitch_scale = randf_range(0.8, 1.1)
	audio.play()
	match character:
		"cat":
			match stat.action:
				"base_damage_rare":
					gm.damage_cat += 1
				"base_damage_epic":
					gm.damage_cat += 3
				"base_damage_5":
					gm.damage_cat += 5
				"defence_common":
					gm.defence_cat += 1
				"defence_rare":
					gm.defence_cat += 2
				"defence_epic":
					gm.defence_cat += 4
				"max_defence_common":
					gm.max_defence_cat += 3
				"max_defence_rare":
					gm.max_defence_cat += 5
				"max_defence_epic":
					gm.max_defence_cat+= 7
				"accuracy_common":
					gm.accuracy_cat += 1
				"accuracy_rare":
					gm.accuracy_cat += 3
				"accuracy_epic":
					gm.accuracy_cat += 5
				"luck_common":
					gm.luck_cat += 2
				"luck_rare":
					gm.luck_cat += 4
				"luck_epic":
					gm.luck_cat += 7
				"hp_common":
					gm.max_hp_cat += 2
					gm.hp_cat += 2	
				"hp_rare":
					gm.max_hp_cat += 5
					gm.hp_cat += 5
				"hp_epic":
					gm.max_hp_cat += 10
					gm.hp_cat += 10
				"hp_unbelievable":
					gm.max_hp_cat += 20
					gm.hp_cat += 20
				"hp_legendary":
					gm.max_hp_cat += 50
					gm.hp_cat += 50
				"energy_unbelievable":
					gm.max_energy_cat += 1
					gm.energy_cat += 1
				"energy_legendary":
					gm.max_energy_cat += 2
					gm.energy_cat += 2
		"human":
			match stat.action:
				"base_damage_rare":
					gm.damage_human += 1
				"base_damage_epic":
					gm.damage_human += 3
				"base_damage_unbelievable":
					gm.damage_human += 5
				"defence_common":
					gm.defence_human += 1
				"defence_rare":
					gm.defence_human += 2
				"defence_epic":
					gm.defence_human += 4
				"max_defence_common":
					gm.max_defence_human += 3
				"max_defence_rare":
					gm.max_defence_human += 5
				"max_defence_epic":
					gm.max_defence_human += 7
				"accuracy_common":
					gm.accuracy_human += 1
				"accuracy_rare":
					gm.accuracy_human += 3
				"accuracy_epic":
					gm.accuracy_human += 5
				"luck_common":
					gm.luck_human += 2
				"luck_rare":
					gm.luck_human += 4
				"luck_epic":
					gm.luck_human += 7
				"hp_common":
					gm.max_hp_human += 2
					gm.hp_human += 2	
				"hp_rare":
					gm.max_hp_human += 5
					gm.hp_human += 5
				"hp_epic":
					gm.max_hp_human += 10
					gm.hp_human += 10
				"hp_unbelievable":
					gm.max_hp_human += 20
					gm.hp_human += 20
				"hp_legendary":
					gm.max_hp_human += 50
					gm.hp_human += 50
				"energy_unbelievable":
					gm.max_energy_human += 1
					gm.energy_human += 1
				"energy_legendary":
					gm.max_energy_human += 2
					gm.energy_human += 2
	
	gm.state = "idle"
	if get_parent().get_parent().level_up_dialog.current_character == "human":
		get_parent().get_parent().draw_level_up("cat")
	else:	
		if get_parent().get_parent().giant.check_xp():
			get_parent().get_parent().draw_level_up("human")
	
	visible = false
	position.x = -1500		
	get_parent().get_parent().bg.color = Color(0, 0, 0, 0)
	#gm.state = "idle"


func _on_mouse_entered() -> void:
	gm.state = "leveling_up"
