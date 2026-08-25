class_name AttackCard extends Card

var damage = 2
var card_path = "attack_card.tscn"
var icon_path = "claw_card.png"
var tool_tip_text = "Наносит урон, \nравный вашему \nбазовому"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	state_modifier = "_attack"
	$Label.text = str("Урон: ", gm.damage)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
