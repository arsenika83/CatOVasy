class_name StrongWindCard extends Card

var card_path = "strong_wind_card.tscn"
var icon_path = "strong_wind_card.png"
var tool_tip_text = ""
var card_name = "Сильный ветер"
var card_description = "Снижает скорость ВСЕХ врагов на 15 на 2 хода. Расходуется"
var rarity = "rare"
var debuff = "slowness"
var power = 15
var turns = 2

func _ready() -> void:
	element = "wind"
	description_rect.scale = Vector2(1, 0)
	description_label.text = card_description
	energy_cost = 1
	init_energy_cost = 1
	everybody_attack = true
	
	state_modifier = "_ability"
	$Energy/Label.text = str(energy_cost)
	type = "debuff"

func _process(delta: float) -> void:
	if gm.current_energy_human < energy_cost:
		$Energy/Label.add_theme_color_override("font_color", colors.card_too_expensive)
	elif energy_cost < init_energy_cost:
		$Energy/Label.add_theme_color_override("font_color", colors.card_too_cheap)
	else:
		$Energy/Label.add_theme_color_override("font_color", Color.WHITE)

func on_play() -> void:
	#get_parent().get_parent().get_parent().get_parent().log_messages.append(
		#str("- [color=#ff93c1]ТУМАН[/color]: все враги теряют 35% точности\n"))
	
	for enemy in get_parent().get_parent().get_parent().get_parent().current_enemies:
		if enemy.state != "dead":
			get_parent().get_parent().get_parent().get_parent().human.give_debuff([enemy], debuff, power, turns)

	
func use_up() -> void:
	pass
