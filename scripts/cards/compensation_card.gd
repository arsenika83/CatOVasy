class_name CompensationCard extends Card

var card_path = "compensation_card.tscn"
var icon_path = "compensation_card.png"
var tool_tip_text = ""
var card_name = "Компенсация"
var card_description = "Кот теряет 40% удачи и получает 20% точности. Расходуется"
var rarity = "rare"

func _ready() -> void:
	description_rect.scale = Vector2(1, 0)
	description_label.text = card_description
	energy_cost = 1
	state_modifier = "_ability"
	$Energy/Label.text = str(energy_cost)
	type = "buff"

func _process(delta: float) -> void:
	if gm.current_energy_cat < energy_cost:
		$Energy/Label.add_theme_color_override("font_color", Color(0.98, 0.077, 0.078))
	else:
		$Energy/Label.add_theme_color_override("font_color", Color.WHITE)

func on_play() -> void:
	gm.current_energy_cat -= energy_cost
	
	get_parent().get_parent().get_parent().get_parent().log_messages.append(
		str("- [color=#1ca8fd]Кот[/color] потерял 40% удачи. Он [color=#fdd14d]компенсирует[/color] 20% точности!\n"))
	
	gm.current_luck_cat -= 40
	gm.current_accuracy_cat += 20

func use_up() -> void:
	pass
