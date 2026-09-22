class_name AttackCard extends Card

var damage = 3 + gm.damage_cat
var card_path = "attack_card.tscn"
var icon_path = "claw_card.png"
var tool_tip_text = ""
var card_name = settings.card_text_cat.get("attack_name")
var card_description = settings.card_text_cat.get("attack_desc")
var rarity = "common"

func _ready() -> void:
	element = "might"
	shake = 0.1
	description_rect.scale = Vector2(1, 0)
	description_label.text = card_description
	
	state_modifier = "_attack"
	type = "attack"
	$Energy/Label.text = str(energy_cost)
	$Label.text = settings.card_text_cat.get("attack_name")

func _process(delta: float) -> void:
	if gm.current_energy_cat < energy_cost:
		$Energy/Label.add_theme_color_override("font_color", colors.card_too_expensive)
	elif energy_cost < init_energy_cost:
		$Energy/Label.add_theme_color_override("font_color", colors.card_too_cheap)
	else:
		$Energy/Label.add_theme_color_override("font_color", Color.WHITE)
