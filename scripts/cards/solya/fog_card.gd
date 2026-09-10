class_name FogCard extends Card

var card_path = "fog_card.tscn"
var icon_path = "fog_card.png"
var tool_tip_text = ""
var card_name = "Туман"
var card_description = "Снижает точность ВСЕХ врагов на 35% в этом бою. Расходуется"
var rarity = "unbelievable"

func _ready() -> void:
	description_rect.scale = Vector2(1, 0)
	description_label.text = card_description
	energy_cost = 2
	everybody_attack = true
	
	state_modifier = "_ability"
	$Energy/Label.text = str(energy_cost)
	type = "debuff"

func _process(delta: float) -> void:
	if gm.current_energy_human < energy_cost:
		$Energy/Label.add_theme_color_override("font_color", Color(0.98, 0.077, 0.078))
	else:
		$Energy/Label.add_theme_color_override("font_color", Color.WHITE)

func on_play() -> void:
	gm.current_energy_human -= energy_cost
	
	for enemy in get_parent().get_parent().get_parent().get_parent().current_enemies:
		if enemy.state != "dead":
			enemy.current_accuracy -= 35
			enemy.accuracy -= 35

	get_parent().get_parent().get_parent().get_parent().human.create_fog()
	
func use_up() -> void:
	pass
