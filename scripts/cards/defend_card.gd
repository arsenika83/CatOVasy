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
