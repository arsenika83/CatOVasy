class_name WindOfChangeCard extends Card

var card_path = "wind_of_change_card.tscn"
var icon_path = "wind_of_change_card.png"
var tool_tip_text = ""
var card_name = "Ветер перемен"
var card_description = "Следующие 2 замены карт будут бесплатными"
var rarity = "common"

func _ready() -> void:
	description_rect.scale = Vector2(1, 0)
	description_label.text = card_description
	energy_cost = 1
	
	state_modifier = "_ability"
	$Energy/Label.text = str(energy_cost)
	type = "ability"


func on_play() -> void:
	gm.current_energy_human -= energy_cost
	get_parent().get_parent().free_changes += 2
