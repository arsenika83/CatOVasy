class_name EclipseCard extends Card

var card_path = "eclipse_card.tscn"
var icon_path = "eclipse_card.png"
var tool_tip_text = ""
var card_name = settings.card_text_cat.get("eclipse_name")
var card_description = "ВСЕ враги теряют 10% точности и 1 энергию в этом бою. Расходуется"
var rarity = "unbelievable"

func _ready() -> void:
	description_rect.scale = Vector2(1, 0)
	description_label.text = card_description
	energy_cost = 3
	everybody_attack = true
	state_modifier = "_ability"
	$Energy/Label.text = str(energy_cost)
	$Label.text = settings.card_text_cat.get("eclipse_name")
	type = "debuff"

func _process(delta: float) -> void:
	if gm.current_energy_cat < energy_cost:
		$Energy/Label.add_theme_color_override("font_color", Color(0.98, 0.077, 0.078))
	else:
		$Energy/Label.add_theme_color_override("font_color", Color.WHITE)

func on_play() -> void:
	gm.current_energy_cat -= energy_cost
	
	get_parent().get_parent().get_parent().get_parent().log_messages.append(
		str("- [color=#ff93c1]ЗАТМЕНИЕ[/color]: все враги теряют 10% точности и 1 энергии\n"))
	
	for enemy in get_parent().get_parent().get_parent().get_parent().current_enemies:
		if enemy.state != "dead":
			enemy.current_accuracy -= 10
			enemy.accuracy -= 10
			enemy.energy -= 1
			enemy.current_energy -= 1

	#get_parent().get_parent().get_parent().get_parent().giant.eclipse()
	
func use_up() -> void:
	pass
