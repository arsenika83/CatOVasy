class_name DefendCard extends Card

var defence = 50
var card_path = "defend_card.tscn"
var card_name = "Защита"
var card_description = "Дает защиту"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	state_modifier = "_defend"
	type = "defend"
	$Label.text = str("+", gm.defence, " брони")
	$Energy/Label.text = str(energy_cost)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
