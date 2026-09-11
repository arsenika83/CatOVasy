class_name LickWoundsCard extends Card

var card_path = "lick_wounds_card.tscn"
var icon_path = "lick_wounds_card.png"
var tool_tip_text = ""
var card_name = settings.card_text_cat.get("lick_wounds_name")
var card_description = settings.card_text_cat.get("lick_wounds_desc")
var rarity = "rare"

func _ready() -> void:
	description_rect.scale = Vector2(1, 0)
	description_label.text = card_description
	energy_cost = 1
	state_modifier = "_ability"
	$Energy/Label.text = str(energy_cost)
	$Label.text = settings.card_text_cat.get("lick_wounds_name")
	type = "buff"

func _process(delta: float) -> void:
	if gm.current_energy_cat < energy_cost:
		$Energy/Label.add_theme_color_override("font_color", Color(0.98, 0.077, 0.078))
	else:
		$Energy/Label.add_theme_color_override("font_color", Color.WHITE)

func on_play() -> void:
	gm.current_energy_cat -= energy_cost
	
	get_parent().get_parent().get_parent().get_parent().log_messages.append(settings.card_text_cat.get("lick_wounds_log"))
	
	get_parent().get_parent().get_parent().get_parent().swap_characters()
	gm.current_defence_human += 3
	
	get_parent().get_parent().get_parent().get_parent().giant.heal(2)
