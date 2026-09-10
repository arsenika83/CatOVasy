class_name DefendCard extends Card

var defence = 3 + gm.defence_cat
var card_path = "defend_card.tscn"
var icon_path = "defend_card.png"
var tool_tip_text = ""
var card_name = "Защита"
var card_description = "Дает защиту, равную 3 + защита кота"
var rarity = "common"

func _ready() -> void:
	description_rect.scale = Vector2(1, 0)
	description_label.text = card_description
	
	state_modifier = "_defend"
	type = "defend"
	$Energy/Label.text = str(energy_cost)

func _process(delta: float) -> void:
	if gm.current_energy_cat < energy_cost:
		$Energy/Label.add_theme_color_override("font_color", Color(0.98, 0.077, 0.078))
	else:
		$Energy/Label.add_theme_color_override("font_color", Color.WHITE)
		
func on_play() -> void:
	get_parent().get_parent().get_parent().get_parent().giant.defend(gm.defend_animation_time_cat)
