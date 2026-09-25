class_name DontHitCard extends Card

var card_path = "dont_hit_card.tscn"
var icon_path = "dont_hit_card.png"
var tool_tip_text = ""
var card_name = "Не бейте пожалуйста!"
var card_description = "Дает Соле 7 защиты"
var rarity = "common"
var defence = 7

func _ready() -> void:
	element = "might"
	description_rect.scale = Vector2(1, 0)
	description_label.text = card_description

	energy_cost = 1
	init_energy_cost = 1
	
	state_modifier = "_defend"
	$Energy/Label.text = str(energy_cost)
	
	type = "defend"

func _process(delta: float) -> void:
	if gm.current_energy_human < energy_cost:
		$Energy/Label.add_theme_color_override("font_color", colors.card_too_expensive)
	elif energy_cost < init_energy_cost:
		$Energy/Label.add_theme_color_override("font_color", colors.card_too_cheap)
	else:
		$Energy/Label.add_theme_color_override("font_color", Color.WHITE)

func change_energy_cost():
	pass

func on_play() -> void:
	#gm.current_energy_human -= energy_cost
		
	get_parent().get_parent().get_parent().get_parent().human.defend(0.6)
	
