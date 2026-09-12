class_name BurnDownCard extends Card

var card_path = "burn_down_card.tscn"
var icon_path = "burn_down_card.png"
var tool_tip_text = ""
var card_name = "Сожжение"
var card_description = "Сжигает врага. Снижает текущие ОЗ босса наполовину. Расходуется"
var rarity = "unbelievable"

func _ready() -> void:
	only_one_target = true
	description_rect.scale = Vector2(1, 0)
	description_label.text = card_description
	energy_cost = 2
	
	state_modifier = "_ability"
	$Energy/Label.text = str(energy_cost)
	type = "debuff"
	$Label.text = "Сожжение"

func _process(delta: float) -> void:
	if gm.current_energy_human < energy_cost:
		$Energy/Label.add_theme_color_override("font_color", Color(0.98, 0.077, 0.078))
	else:
		$Energy/Label.add_theme_color_override("font_color", Color.WHITE)

func on_play() -> void:
	gm.current_energy_human -= energy_cost
	
	var enemy = gm.current_targets.get(0)

	get_parent().get_parent().get_parent().get_parent().log_messages.append(str("- [color=#ff93c1]СОЖЖЕНИЕ[/color]: [color=#1ca8fd]", enemy.enemy_name_rus, "[/color] сжигается\n"))

	enemy.hp = 0
	enemy.check_hp()
	enemy.die()
	
	var tween = create_tween()
	tween.tween_property(enemy.sprite, "scale", Vector2(0, 0), 0.2)
	
func use_up() -> void:
	pass
