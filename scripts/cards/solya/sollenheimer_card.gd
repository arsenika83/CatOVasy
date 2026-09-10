class_name SollenheimerCard extends Card

var damage = 50 + gm.damage_human
var card_path = "sollenheimer_card.tscn"
var icon_path = "sollenheimer_card.png"
var tool_tip_text = ""
var card_name = "СОЛЛЕНГЕЙМЕР"
var card_description = "Наносит ВСЕМ врагам 50 урона + базовый урон Соли. Котик теряет 5 ОЗ"
var rarity = "epic"

func _ready() -> void:
	everybody_attack = true
	shake = 0.01
	description_rect.scale = Vector2(1, 0)
	description_label.text = card_description
	
	state_modifier = "_attack"
	type = "attack"
	energy_cost = 2
	$Energy/Label.text = str(energy_cost)

func _process(delta: float) -> void:
	if gm.current_energy_human < energy_cost:
		$Energy/Label.add_theme_color_override("font_color", Color(0.98, 0.077, 0.078))
	else:
		$Energy/Label.add_theme_color_override("font_color", Color.WHITE)

func on_play() -> void:
	gm.hp_cat -= 5
	
	if gm.hp_cat <= 0:
		gm.hp_cat = 0
		gm.state = "dead"

func explode() -> void:
	pass
