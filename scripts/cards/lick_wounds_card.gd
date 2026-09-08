class_name LickWoundsCard extends Card

var card_path = "lick_wounds_card.tscn"
var icon_path = "lick_wounds_card.png"
var tool_tip_text = ""
var card_name = "Зализать раны"
var card_description = "Восстанавливает 2 ОЗ. Соля получает 3 защиты. Соля и кот меняются местами"
var rarity = "rare"

func _ready() -> void:
	description_rect.scale = Vector2(1, 0)
	description_label.text = card_description
	energy_cost = 1
	state_modifier = "_ability"
	$Energy/Label.text = str(energy_cost)
	type = "buff"


func on_play() -> void:
	get_parent().get_parent().get_parent().get_parent().swap_characters()
	gm.current_defence_human += 3
	
	get_parent().get_parent().get_parent().get_parent().giant.heal(2)
