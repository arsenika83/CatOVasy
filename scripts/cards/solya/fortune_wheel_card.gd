class_name FortuneWheelCard extends Card

var card_path = "fortune_wheel_card.tscn"
var icon_path = "fortune_wheel_card.png"
var tool_tip_text = ""
var card_name = "Колесо фортуны"
var card_description = "Дает Соле и коту 7 удачи на 2 хода"
var rarity = "rare"
var luck = 7
var turns = 2

func _ready() -> void:
	description_rect.scale = Vector2(1, 0)
	description_label.text = card_description
	energy_cost = 1
	
	state_modifier = "_ability"
	$Energy/Label.text = str(energy_cost)
	type = "luck"


func on_play() -> void:
	var targets : Array[CharacterBody2D] = [get_parent().get_parent().get_parent().get_parent().giant, get_parent().get_parent().get_parent().get_parent().human]
	get_parent().get_parent().get_parent().get_parent().human.give_buff(targets, type, luck, turns)
	
