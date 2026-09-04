class_name GiveStrengthCard extends Card

var card_path = "give_strength_card.tscn"
var icon_path = "give_strength_card.png"
var tool_tip_text = ""
var card_name = "Подбодрить"
var card_description = "В этом ходу кот наносит +1 урона"
var rarity = "common"
var strength = 1
var turns = 1

func _ready() -> void:
	state_modifier = "_ability"
	$Energy/Label.text = str(energy_cost)
	type = "strength"

func _process(delta: float) -> void:
	pass
