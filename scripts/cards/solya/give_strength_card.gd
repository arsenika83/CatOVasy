class_name GiveStrengthCard extends Card

var card_path = "give_strength_card.tscn"
var icon_path = "give_strength_card.png"
var tool_tip_text = ""
var card_name = "Подбодрить"
var card_description = "Кот наносит +3 урона. Длительность 2 хода"
var rarity = "common"
var strength = 3
var turns = 2
var target = "cat"
var buff_type = "strength"

func _ready() -> void:
	element = "might"
	description_rect.scale = Vector2(1, 0)
	description_label.text = card_description
	
	state_modifier = "_ability"
	$Energy/Label.text = str(energy_cost)
	type = "buff"

func _process(delta: float) -> void:
	if gm.current_energy_human < energy_cost:
		$Energy/Label.add_theme_color_override("font_color", colors.card_too_expensive)
	elif energy_cost < init_energy_cost:
		$Energy/Label.add_theme_color_override("font_color", colors.card_too_cheap)
	else:
		$Energy/Label.add_theme_color_override("font_color", Color.WHITE)

func on_play() -> void:
	get_parent().get_parent().get_parent().get_parent().log_messages.append(
		str("- [color=#1ca8fd]Соля[/color] [color=#fdd14d]подбадривает[/color] [color=#1ca8fd]Кота[/color]. Он получает +2 к урону\n"))
	
	
	var targets : Array[CharacterBody2D] = [get_parent().get_parent().get_parent().get_parent().giant]
	get_parent().get_parent().get_parent().get_parent().human.give_buff(targets, buff_type, strength, turns)
