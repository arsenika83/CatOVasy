class_name AttackDoubleClaw extends Card

var damage = (2 + gm.damage_cat) * 2
var card_path = "attack_double_claw_card.tscn"
var icon_path = "double_claw_card.png"
var tool_tip_text = ""
var card_name = "Двойной удар"
var card_description = "Наносит урон, \nравный (2 + базовый урон) x2"
var rarity = "rare"

func _ready() -> void:
	energy_cost = 1
	type = "attack"
	state_modifier = "_attack"
	rarity = "rare"
	$Label.text = str("Урон: ", damage)
	$Energy/Label.text = str(energy_cost)

func _process(delta: float) -> void:
	pass
