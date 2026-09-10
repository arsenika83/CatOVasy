class_name PoisonCard extends Card

var card_path = "poison_card.tscn"
var icon_path = "poison_card.png"
var tool_tip_text = "Накладывает эффект яда на врага (3 хода)"
var card_name = "Яд"
var card_description = "Накладывает эффект 3 ЯДА на врага (длительность 2 хода)"
var rarity = "common"

func _ready() -> void:
	description_rect.scale = Vector2(1, 0)
	description_label.text = card_description
	
	state_modifier = "_ability"
	energy_cost = 0
	$Energy/Label.text = str(energy_cost)
	type = "debuff"
	rarity = "unbelievable"

func _process(delta: float) -> void:
	if gm.current_energy_cat < energy_cost:
		$Energy/Label.add_theme_color_override("font_color", Color(0.98, 0.077, 0.078))
	else:
		$Energy/Label.add_theme_color_override("font_color", Color.WHITE)
