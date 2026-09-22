class_name FireProtectionCard extends Card

var card_path = "fire_protection_card.tscn"
var icon_path = "fire_protection_card.png"
var tool_tip_text = ""
var card_name = "Защита от огня"
var card_description = "Дает 20% сопротивления огню на 3 хода. Расходуется"
var rarity = "common"

func _ready() -> void:
	element = "fire"
	description_rect.scale = Vector2(1, 0)
	description_label.text = card_description
	energy_cost = 1
	init_energy_cost = 1
	
	state_modifier = "_ability"
	$Energy/Label.text = str(energy_cost)
	$Label.text = "Защита от огня"
	type = "buff"

func _process(delta: float) -> void:
	if gm.current_energy_human < energy_cost:
		$Energy/Label.add_theme_color_override("font_color", colors.card_too_expensive)
	elif energy_cost < init_energy_cost:
		$Energy/Label.add_theme_color_override("font_color", colors.card_too_cheap)
	else:
		$Energy/Label.add_theme_color_override("font_color", Color.WHITE)

func on_play() -> void:
	gm.current_energy_human -= energy_cost
	
	get_parent().get_parent().get_parent().get_parent().log_messages.append(
		str("- [color=#fdd14d]Защита от огня:[/color] [color=#1ca8fd]Соля[/color] получает 20% защиты от огня на 2 хода\n"))
	 
	get_parent().get_parent().get_parent().get_parent().human.idle_animation_timer.start(0.6)
