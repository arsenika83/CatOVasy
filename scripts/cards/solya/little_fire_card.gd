class_name LittleFireCard extends Card

var damage = 2 + gm.damage_human
var card_path = "little_fire_card.tscn"
var icon_path = "little_fire_card.png"
var tool_tip_text = ""
var card_name = "Огонёк"
var card_description = "Наносит урон, равный\n2 + базовый урон Соли. Не может промахнуться"
var rarity = "common"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	element = "fire"
	shake = 0.1
	description_rect.scale = Vector2(1, 0)
	description_label.text = card_description
	
	state_modifier = "_attack"
	type = "attack"
	init_energy_cost = 0
	energy_cost = 0
	$Energy/Label.text = str(energy_cost)

func _process(delta: float) -> void:
	if gm.current_energy_human < energy_cost:
		$Energy/Label.add_theme_color_override("font_color", colors.card_too_expensive)
	elif energy_cost < init_energy_cost:
		$Energy/Label.add_theme_color_override("font_color", colors.card_too_cheap)
	else:
		$Energy/Label.add_theme_color_override("font_color", Color.WHITE)
		
func cant_miss():
	pass		
