class_name DontHitCard extends Card

var card_path = "dont_hit_card.tscn"
var icon_path = "dont_hit_card.png"
var tool_tip_text = ""
var card_name = "Не бейте пожалуйста!"
var card_description = "Дает Соле 7 защиты"
var rarity = "common"
var defence = 7
var current_energy : int = 1000

func _ready() -> void:
	description_rect.scale = Vector2(1, 0)
	description_label.text = card_description
	if current_energy != 1000:
		energy_cost = current_energy
	else:	
		energy_cost = 2
	
	state_modifier = "_defend"
	$Energy/Label.text = str(energy_cost)
	
	type = "defend"
	print("TEST READY CARD")

func _process(delta: float) -> void:
	if gm.current_energy_human < energy_cost:
		$Energy/Label.add_theme_color_override("font_color", Color(0.98, 0.077, 0.078))
	else:
		$Energy/Label.add_theme_color_override("font_color", Color.WHITE)

func change_energy_cost():
	pass

func on_play() -> void:
	#gm.current_energy_human -= energy_cost
		
	get_parent().get_parent().get_parent().get_parent().human.defend(gm.defend_animation_time_human)
	
	if energy_cost > 0:
		energy_cost -= 1
		$Energy/Label.text = str(energy_cost)
