class_name BigFireCard extends Card

var damage = 3
var card_path = "big_fire_card.tscn"
var icon_path = "big_fire_card.png"
var tool_tip_text = ""
var card_name = "Пожар"
var card_description = "Ряд врагов получает 3 урона"
var rarity = "common"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	element = "fire"
	shake = 0.2
	row_attack_3 = true
	description_rect.scale = Vector2(1, 0)
	description_label.text = card_description
	
	state_modifier = "_attack"
	type = "attack"
	energy_cost = 0
	$Energy/Label.text = str(energy_cost)

func _process(delta: float) -> void:
	if gm.current_energy_human < energy_cost:
		$Energy/Label.add_theme_color_override("font_color", Color(0.98, 0.077, 0.078))
	else:
		$Energy/Label.add_theme_color_override("font_color", Color.WHITE)
