class_name DontHitCard extends Card

var card_path = "dont_hit_card.tscn"
var icon_path = "dont_hit_card.png"
var tool_tip_text = ""
var card_name = "Не бейте пожалуйста!"
var card_description = "Дает 7 защиты. Стоит на 1 энергию меньше"
var rarity = "common"
var defence = 7

func _ready() -> void:
	description_rect.scale = Vector2(1, 0)
	description_label.text = card_description
	energy_cost = 2
	
	state_modifier = "_defend"
	$Energy/Label.text = str(energy_cost)
	type = "defend"
	print("TEST READY CARD")

func on_play() -> void:
	#gm.current_energy_human -= energy_cost
		
	get_parent().get_parent().get_parent().get_parent().human.defend(gm.defend_animation_time_human)
	
	if energy_cost > 0:
		energy_cost -= 1
		$Energy/Label.text = str(energy_cost)
