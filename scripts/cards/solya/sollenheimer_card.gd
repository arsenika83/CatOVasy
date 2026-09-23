class_name SollenheimerCard extends Card

var damage = 50 + gm.damage_human
var card_path = "sollenheimer_card.tscn"
var icon_path = "sollenheimer_card.png"
var tool_tip_text = ""
var card_name = "СОЛЛЕНГЕЙМЕР"
var card_description = "Наносит ВСЕМ врагам 50 урона + базовый урон Соли. Котик теряет 5 ОЗ. Не может промахнуться"
var rarity = "epic"

func _ready() -> void:
	element = "fire"
	everybody_attack = true
	shake = 0.01
	description_rect.scale = Vector2(1, 0)
	description_label.text = card_description
	
	state_modifier = "_attack"
	type = "attack"
	init_energy_cost = 2
	energy_cost = 2
	$Energy/Label.text = str(energy_cost)

func _process(delta: float) -> void:
	if gm.current_energy_human < energy_cost:
		$Energy/Label.add_theme_color_override("font_color", colors.card_too_expensive)
	elif energy_cost < init_energy_cost:
		$Energy/Label.add_theme_color_override("font_color", colors.card_too_cheap)
	else:
		$Energy/Label.add_theme_color_override("font_color", Color.WHITE)

func on_play() -> void:
	get_parent().get_parent().get_parent().get_parent().giant.take_damage(5, 0.5)

func explode() -> void:
	pass

func cant_miss():
	pass
