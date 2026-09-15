class_name SandInTheEyesCard extends Card

var damage = 3
var card_path = "sand_in_the_eyes_card.tscn"
var icon_path = "sand_in_the_eyes_card.png"
var tool_tip_text = ""
var card_name = "Песок в глаза"
var card_description = "Наносит 3 урона ВСЕМ врагам. Понижает их точность на 2% в этом бою"
var rarity = "common"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	shake = 0.05
	everybody_attack = true
	description_rect.scale = Vector2(1, 0)
	description_label.text = card_description
	
	state_modifier = "_attack"
	type = "attack"
	energy_cost = 1
	$Energy/Label.text = str(energy_cost)

func _process(delta: float) -> void:
	if gm.current_energy_human < energy_cost:
		$Energy/Label.add_theme_color_override("font_color", Color(0.98, 0.077, 0.078))
	else:
		$Energy/Label.add_theme_color_override("font_color", Color.WHITE)
		
func on_play() -> void:
	for enemy in gm.current_targets:
		enemy.current_accuracy -= 2
		enemy.accuracy -= 2
