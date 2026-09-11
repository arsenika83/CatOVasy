class_name TimesUpCard extends Card

var card_path = "times_up_card.tscn"
var icon_path = "times_up_card.png"
var tool_tip_text = ""
var card_name = "Время вышло"
var card_description = "Убивает врага. Снижает текущие ОЗ босса наполовину. Расходуется"
var rarity = "unbelievable"

func _ready() -> void:
	description_rect.scale = Vector2(1, 0)
	description_label.text = card_description
	energy_cost = 2
	
	state_modifier = "_ability"
	$Energy/Label.text = str(energy_cost)
	type = "debuff"

func _process(delta: float) -> void:
	if gm.current_energy_human < energy_cost:
		$Energy/Label.add_theme_color_override("font_color", Color(0.98, 0.077, 0.078))
	else:
		$Energy/Label.add_theme_color_override("font_color", Color.WHITE)

func on_play() -> void:
	gm.current_energy_human -= energy_cost
	
	var enemy = get_parent().get_parent().get_parent().get_parent().current_enemies.get(0)

	get_parent().get_parent().get_parent().get_parent().log_messages.append(str("- [color=#ff93c1]ВРЕМЯ ВЫШЛО[/color]: [color=#1ca8fd]", enemy.enemy_name_rus, "[/color] умирает\n"))

	enemy.hp = 0
	enemy.check_hp()
	enemy.die()
	
func use_up() -> void:
	pass
