class_name InfernoCard extends Card

var damage = 15 + gm.damage_cat
var card_path = "inferno_card.tscn"
var icon_path = "inferno_card.png"
var tool_tip_text = ""
var card_name = "Инферно"
var card_description = "Наносит 15 урона + базовый. Крестообразная атака"
var rarity = "epic"

func _ready() -> void:
	cross_attack = true
	shake = 0.4
	description_rect.scale = Vector2(1, 0)
	description_label.text = card_description
	
	state_modifier = "_attack"
	type = "attack"
	energy_cost = 1
	$Energy/Label.text = str(energy_cost)

func _process(delta: float) -> void:
	if gm.current_energy_cat < energy_cost:
		$Energy/Label.add_theme_color_override("font_color", Color(0.98, 0.077, 0.078))
	else:
		$Energy/Label.add_theme_color_override("font_color", Color.WHITE)

func on_play() -> void:
	pass

func inferno() -> void:
	pass
