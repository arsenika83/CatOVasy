class_name SolyaAbilityCard extends Card

var damage = 1 + gm.damage
var card_path = "solya_ability_card.tscn"
var icon_path = "solya_ability_card.png"
var tool_tip_text = ""
var card_name = "Способность Соли"
var card_description = "Соля наносит урон, равный 1 + её базовый"
var rarity = "common"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	state_modifier = "_attack"
	type = "attack"
	$Label.text = str("Урон: ", damage)
	$Energy/Label.text = str(energy_cost)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
