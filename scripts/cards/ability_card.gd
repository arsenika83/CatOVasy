class_name AbilityCard extends Card

var card_path = "ability_card.tscn"
var icon_path = "ability_card.png"
var tool_tip_text = "Какая-то активная способность"
var card_name = "Способность"
var card_description = "Накладывает случайный негативный эффект на врага"

func _ready() -> void:
	state_modifier = "_ability"
	$Energy/Label.text = str(energy_cost)
	type = "ability"


func _process(delta: float) -> void:
	pass
