class_name RevengeCard extends Card

var damage = 10 + gm.damage_cat
var default_damage = 10 + gm.damage_cat
var card_path = "revenge_card.tscn"
var icon_path = "revenge_card.png"
var tool_tip_text = ""
var card_name = settings.card_text_cat.get("revenge_name")
var card_description = settings.card_text_cat.get("revenge_desc")
var rarity = "epic"

func _ready() -> void:
	shake = 0.1
	description_rect.scale = Vector2(1, 0)
	description_label.text = card_description
	
	state_modifier = "_attack"
	type = "attack"
	energy_cost = 2
	$Energy/Label.text = str(energy_cost)
	$Label.text = settings.card_text_cat.get("revenge_name")

func _process(delta: float) -> void:
	if gm.current_energy_cat < energy_cost:
		$Energy/Label.add_theme_color_override("font_color", Color(0.98, 0.077, 0.078))
	else:
		$Energy/Label.add_theme_color_override("font_color", Color.WHITE)

func on_play() -> void:
	for target in gm.current_targets:
		if target.dealt_damage_to_human:
			damage = default_damage * 4
			break
		else:
			damage = default_damage
			
func revenge() -> int:
	return default_damage * 4
