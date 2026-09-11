class_name DoubleClawCard extends Card

var damage = (3 + gm.damage_cat)
var card_path = "double_claw_card.tscn"
var icon_path = "double_claw_card.png"
var tool_tip_text = ""
var card_name = settings.card_text_cat.get("double_claw_name")
var card_description = settings.card_text_cat.get("double_claw_desc")
var rarity = "rare"

func _ready() -> void:
	description_rect.scale = Vector2(1, 0)
	description_label.text = card_description
	
	energy_cost = 1
	type = "attack"
	state_modifier = "_attack"
	rarity = "rare"
	$Energy/Label.text = str(energy_cost)
	$Label.text = settings.card_text_cat.get("double_claw_name")

func _process(delta: float) -> void:
	if gm.current_energy_cat < energy_cost:
		$Energy/Label.add_theme_color_override("font_color", Color(0.98, 0.077, 0.078))
	else:
		$Energy/Label.add_theme_color_override("font_color", Color.WHITE)

func on_play() -> void:
	#gm.current_energy_cat -= energy_cost
	get_parent().get_parent().get_parent().get_parent().giant.deal_damage(gm.current_targets)
