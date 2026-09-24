class_name SelflessCard extends Card

var card_path = "selfless_card.tscn"
var icon_path = "selfless_card.png"
var tool_tip_text = ""
var card_name = "Героизм"
var card_description = "Дает 7 защиты. Кот восстанавливает 2 ОЗ. Соля и кот меняются местами. Расходуется"
var rarity = "common"
var defence = 7

func _ready() -> void:
	element = "life"
	description_rect.scale = Vector2(1, 0)
	description_label.text = card_description
	energy_cost = 1
	init_energy_cost = 1
	
	state_modifier = "_ability"
	$Energy/Label.text = str(energy_cost)
	$Label.text = "Героизм"
	type = "buff"

func _process(delta: float) -> void:
	if gm.current_energy_human < energy_cost:
		$Energy/Label.add_theme_color_override("font_color", colors.card_too_expensive)
	elif energy_cost < init_energy_cost:
		$Energy/Label.add_theme_color_override("font_color", colors.card_too_cheap)
	else:
		$Energy/Label.add_theme_color_override("font_color", Color.WHITE)

func on_play() -> void:
	get_parent().get_parent().get_parent().get_parent().swap_characters()
	get_parent().get_parent().get_parent().get_parent().human.defend(0.6)
	get_parent().get_parent().get_parent().get_parent().giant.heal(2)

func use_up():
	pass
