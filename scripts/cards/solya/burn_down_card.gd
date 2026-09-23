class_name BurnDownCard extends Card

var card_path = "burn_down_card.tscn"
var icon_path = "burn_down_card.png"
var tool_tip_text = ""
var card_name = "Сожжение"
var card_description = "Сжигает врага. Снижает текущие ОЗ босса наполовину. Расходуется"
var rarity = "unbelievable"

func _ready() -> void:
	element = "fire"
	only_one_target = true
	description_rect.scale = Vector2(1, 0)
	description_label.text = card_description
	energy_cost = 2
	init_energy_cost = 2
	
	state_modifier = "_ability"
	$Energy/Label.text = str(energy_cost)
	type = "debuff"
	$Label.text = "Сожжение"

func _process(delta: float) -> void:
	if gm.current_energy_human < energy_cost:
		$Energy/Label.add_theme_color_override("font_color", colors.card_too_expensive)
	elif energy_cost < init_energy_cost:
		$Energy/Label.add_theme_color_override("font_color", colors.card_too_cheap)
	else:
		$Energy/Label.add_theme_color_override("font_color", Color.WHITE)

func on_play() -> void:
	var enemy = gm.current_targets.get(0)

	get_parent().get_parent().get_parent().get_parent().log_messages.append(str("- [color=#ff93c1]СОЖЖЕНИЕ[/color]: [color=#1ca8fd]", enemy.enemy_name_rus, "[/color] сжигается\n"))

	get_parent().get_parent().get_parent().get_parent().human.ignite(enemy.position)
	enemy.hp = 0
	enemy.check_hp()
	enemy.die()
	
	get_parent().get_parent().get_parent().get_parent().human.idle_animation_timer.start(0.6)
	
	var tween = create_tween()
	tween.tween_property(enemy.sprite, "scale", Vector2(1, 1), 0.2)
	tween.tween_property(enemy.sprite, "scale", Vector2(0, 0), 0.3)
	
func use_up() -> void:
	pass
