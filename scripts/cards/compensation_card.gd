class_name CompensationCard extends Card

var card_path = "compensation_card.tscn"
var icon_path = "compensation_card.png"
var tool_tip_text = ""
var card_name = settings.card_text_cat.get("compensation_name")
var card_description =  settings.card_text_cat.get("compensation_desc")
var rarity = "rare"

func _ready() -> void:
	description_rect.scale = Vector2(1, 0)
	description_label.text = card_description
	energy_cost = 1
	state_modifier = "_ability"
	$Energy/Label.text = str(energy_cost)
	$Label.text = settings.card_text_cat.get("compensation_name")
	type = "buff"

func _process(delta: float) -> void:
	if gm.current_energy_cat < energy_cost:
		$Energy/Label.add_theme_color_override("font_color", Color(0.98, 0.077, 0.078))
	else:
		$Energy/Label.add_theme_color_override("font_color", Color.WHITE)

func on_play() -> void:
	gm.current_energy_cat -= energy_cost
	
	get_parent().get_parent().get_parent().get_parent().log_messages.append(settings.card_text_cat.get("compensation_log"))
	
	gm.current_luck_cat -= 40
	gm.current_accuracy_cat += 20

func use_up() -> void:
	pass
