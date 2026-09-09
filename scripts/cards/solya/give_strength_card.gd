class_name GiveStrengthCard extends Card

var card_path = "give_strength_card.tscn"
var icon_path = "give_strength_card.png"
var tool_tip_text = ""
var card_name = "Подбодрить"
var card_description = "Кот наносит +2 урона. Длительность 2 хода"
var rarity = "common"
var strength = 2
var turns = 2
var target = "cat"
var buff_type = "strength"

func _ready() -> void:
	description_rect.scale = Vector2(1, 0)
	description_label.text = card_description
	
	state_modifier = "_ability"
	$Energy/Label.text = str(energy_cost)
	type = "buff"

func on_play() -> void:
	get_parent().get_parent().get_parent().get_parent().log_messages.append(
		str("- [color=#1ca8fd]Соля[/color] [color=#fdd14d]подбадривает[/color] [color=#1ca8fd]Кота[/color]. Он получает +2 к урону\n"))
	
	
	var targets : Array[CharacterBody2D] = [get_parent().get_parent().get_parent().get_parent().giant]
	get_parent().get_parent().get_parent().get_parent().human.give_buff(targets, buff_type, strength, turns)
