class_name DefendCard extends Card

var defence = 3 + gm.defence_cat
var card_path = "defend_card.tscn"
var icon_path = "defend_card.png"
var tool_tip_text = ""
var card_name = "Защита"
var card_description = "Дает защиту"
var rarity = "common"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	state_modifier = "_defend"
	type = "defend"
	$Energy/Label.text = str(energy_cost)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
