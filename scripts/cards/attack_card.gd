class_name AttackCard extends Card

var damage = 3 + gm.damage_cat
var card_path = "attack_card.tscn"
var icon_path = "claw_card.png"
var tool_tip_text = ""
var card_name = "Удар"
var card_description = "Наносит урон, равный 3 + базовый"
var rarity = "common"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	description_rect.scale = Vector2(1, 0)
	description_label.text = card_description
	
	state_modifier = "_attack"
	type = "attack"
	$Energy/Label.text = str(energy_cost)

func _process(delta: float) -> void:
	if gm.current_energy_cat < energy_cost:
		$Energy/Label.add_theme_color_override("font_color", Color(0.98, 0.077, 0.078))
	else:
		$Energy/Label.add_theme_color_override("font_color", Color.WHITE)
