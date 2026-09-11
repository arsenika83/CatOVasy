class_name CattenheimerCard extends Card

var damage = 40 + gm.damage_cat
var card_path = "cattenheimer_card.tscn"
var icon_path = "cattenheimer_card.png"
var tool_tip_text = ""
var card_name = "КОТТЕНГЕЙМЕР"
var card_description = "Наносит ВСЕМ врагам 40 урона + базовый урон кота. Котик теряет 4 ОЗ"
var rarity = "epic"

func _ready() -> void:
	everybody_attack = true
	shake = 0.01
	description_rect.scale = Vector2(1, 0)
	description_label.text = card_description
	
	state_modifier = "_attack"
	type = "attack"
	energy_cost = 3
	$Energy/Label.text = str(energy_cost)

func _process(delta: float) -> void:
	if gm.current_energy_cat < energy_cost:
		$Energy/Label.add_theme_color_override("font_color", Color(0.98, 0.077, 0.078))
	else:
		$Energy/Label.add_theme_color_override("font_color", Color.WHITE)

func on_play() -> void:
	gm.hp_cat -= 4
	
	get_parent().get_parent().get_parent().get_parent().log_messages.append(settings.card_text_cat.get("cattenheimer_log"))
	
	if gm.hp_cat <= 0:
		gm.hp_cat = 0
		gm.state = "dead"

func explode() -> void:
	pass
