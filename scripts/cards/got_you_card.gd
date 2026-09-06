class_name GotYouCard extends Card

var damage = 5
var card_path = "got_you_card.tscn"
var icon_path = "got_you_card.png"
var tool_tip_text = ""
var card_name = "ПОПАЛИСЬ!"
var card_description = "Наносит 5 урона ВСЕМ врагам"
var rarity = "rare"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	description_rect.scale = Vector2(1, 0)
	description_label.text = card_description
	
	shake = 0.3
	state_modifier = "_attack"
	type = "attack"
	everybody_attack = true
	$Energy/Label.text = str(energy_cost)
