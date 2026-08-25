class_name AttackDoubleClaw extends Card

var damage = gm.damage * 2
var card_path = "attack_double_claw_card.tscn"
var icon_path = "double_claw_card.png"
var tool_tip_text = "Наносит урон, \nравный вашему \nбазовому x2"

func _ready() -> void:
	energy_cost = 1
	state_modifier = "_attack"
	$Label.text = str("Урон: ", gm.damage, " x 2")
	$Energy/Label.text = str(energy_cost)

func _process(delta: float) -> void:
	pass
