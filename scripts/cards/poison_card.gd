class_name PoisonCard extends Card

var card_path = "poison_card.tscn"
var icon_path = "poison_card.png"
var tool_tip_text = "Накладывает эффект яда на врага (3 хода)"
var card_name = "Яд"
var card_description = "Накладывает эффект 3 ЯДА на врага (длительность 2 хода)"
var rarity = "common"

func _ready() -> void:
	state_modifier = "_ability"
	energy_cost = 0
	$Energy/Label.text = str(energy_cost)
	type = "ability"
	rarity = "unbelievable"

func _process(delta: float) -> void:
	pass
