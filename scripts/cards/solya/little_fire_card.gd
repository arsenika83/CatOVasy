class_name LittleFireCard extends Card

var damage = 1 + gm.damage_human
var card_path = "little_fire_card.tscn"
var icon_path = "little_fire_card.png"
var tool_tip_text = ""
var card_name = "Огонёк"
var card_description = "Наносит урон, равный\n1 + базовый урон Соли"
var rarity = "common"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	state_modifier = "_attack"
	type = "attack"
	energy_cost = 0
	$Label.text = str("Урон: ", damage)
	$Energy/Label.text = str(energy_cost)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
