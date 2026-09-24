class_name WindlessCurseCard extends Card

var card_path = "windless_curse_card.tscn"
var icon_path = "windless_curse_card.png"
var tool_tip_text = ""
var card_name = "Штиль"
var card_description = "Пока находится в руке, смена карт стоит 2 энергии. Расходуется"
var rarity = "epic"

func _ready() -> void:
	element = "death"
	description_rect.scale = Vector2(1, 0)
	description_label.text = card_description
	
	state_modifier = "_ability"
	type = "buff"
	energy_cost = 3
	$Energy/Label.text = str(energy_cost)

func _process(delta: float) -> void:
	if gm.current_energy_human < energy_cost:
		$Energy/Label.add_theme_color_override("font_color", Color(0.98, 0.077, 0.078))
	else:
		$Energy/Label.add_theme_color_override("font_color", Color.WHITE)

func on_play():
	if get_parent().get_parent().get_parent().get_parent().current_creature_turn == get_parent().get_parent().get_parent().get_parent().human:
		#gm.current_energy_human -= energy_cost
		get_parent().get_parent().get_parent().get_parent().human.idle_animation_timer.start()
	elif get_parent().get_parent().get_parent().get_parent().current_creature_turn == get_parent().get_parent().get_parent().get_parent().giant:
		#gm.current_energy_cat -= energy_cost
		get_parent().get_parent().get_parent().get_parent().giant.idle_animation_timer.start()
	
	get_parent().get_parent().has_windless = false

func on_hand() -> void:
	var tween = create_tween()
	tween.tween_property(self, "scale:y", 1.5, 0.2)
	tween.tween_property(self, "scale:y", 1, 0.2)
	
	get_parent().get_parent().has_windless = true

func use_up():
	pass

func curse():
	pass
