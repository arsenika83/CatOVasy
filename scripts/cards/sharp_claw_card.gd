class_name AttackSharpClaw extends Card

var damage = 3
var card_path = "sharp_claw_card.tscn"
var icon_path = "sharp_claw_card.png"
var tool_tip_text = ""
var card_name = "Острый коготь"
var card_description = "Наносит 3 урона"
var rarity = "common"

func _ready() -> void:
	description_rect.scale = Vector2(1, 0)
	description_label.text = card_description
	
	energy_cost = 0
	type = "attack"
	state_modifier = "_attack"
	$Energy/Label.text = str(energy_cost)

func _process(delta: float) -> void:
	pass
