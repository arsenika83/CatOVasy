class_name GotYouCard extends Card

var damage = 5
var card_path = "got_you_card.tscn"
var icon_path = "got_you_card.png"
var tool_tip_text = ""
var card_name = settings.card_text_cat.get("got_you_name")
var card_description = settings.card_text_cat.get("got_you_desc")
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
	$Label.text = settings.card_text_cat.get("got_you_name")

func _process(delta: float) -> void:
	if gm.current_energy_cat < energy_cost:
		$Energy/Label.add_theme_color_override("font_color", Color(0.98, 0.077, 0.078))
	else:
		$Energy/Label.add_theme_color_override("font_color", Color.WHITE)
