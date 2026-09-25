class_name BiteCard extends Card

var damage = 1
var default_damage = 1
var card_path = "bite_card.tscn"
var icon_path = "bite_card.png"
var tool_tip_text = ""
var card_name = settings.card_text_cat.get("bite_name")
var card_description = settings.card_text_cat.get("bite_desc")
var rarity = "epic"

func _ready() -> void:
	element = "energy"
	shake = 0.1
	description_rect.scale = Vector2(1, 0)
	description_label.text = card_description
	
	state_modifier = "_attack"
	type = "attack"
	energy_cost = 1
	init_energy_cost = 1
	$Energy/Label.text = str(energy_cost)
	$Label.text = settings.card_text_cat.get("bite_name")

func _process(delta: float) -> void:
	if gm.current_energy_cat < energy_cost:
		$Energy/Label.add_theme_color_override("font_color", colors.card_too_expensive)
	elif energy_cost < init_energy_cost:
		$Energy/Label.add_theme_color_override("font_color", colors.card_too_cheap)
	else:
		$Energy/Label.add_theme_color_override("font_color", Color.WHITE)

func on_play() -> void:
	pass
func cant_miss() -> void:
	pass

func use_up():
	pass
	
func energy_steal():
	get_parent().get_parent().get_parent().get_parent().giant.current_energy += roundi(gm.current_targets[0].current_energy * (1 - gm.current_targets[0].current_energy_resistance))
	
	
	get_parent().get_parent().get_parent().get_parent().energy_steal_particles.position = gm.current_targets[0].position
	get_parent().get_parent().get_parent().get_parent().energy_steal_particles.amount = roundi(gm.current_targets[0].current_energy * (1 - gm.current_targets[0].current_energy_resistance))
	get_parent().get_parent().get_parent().get_parent().energy_steal_particles.restart()
	
	gm.current_targets[0].current_energy -= roundi(gm.current_targets[0].current_energy * (1 - gm.current_targets[0].current_energy_resistance))
