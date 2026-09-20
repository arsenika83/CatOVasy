class_name WindShieldCard extends Card

var defence = 2
var card_path = "wind_shield_card.tscn"
var icon_path = "wind_shield_card.png"
var tool_tip_text = ""
var card_name = "Щит ветра"
var card_description = "Дает 2 защиты Соле"
var rarity = "common"

func _ready() -> void:
	element = "wind"
	description_rect.scale = Vector2(1, 0)
	description_label.text = card_description
	energy_cost = 0
	
	state_modifier = "_defend"
	type = "defend"
	$Energy/Label.text = str(energy_cost)

func _process(delta: float) -> void:
	if gm.current_energy_cat < energy_cost:
		$Energy/Label.add_theme_color_override("font_color", Color(0.98, 0.077, 0.078))
	else:
		$Energy/Label.add_theme_color_override("font_color", Color.WHITE)
		
func on_play() -> void:
	get_parent().get_parent().get_parent().get_parent().human.defend(0.6)
