class_name PainCurseCard extends Card

var card_path = "pain_curse_card.tscn"
var icon_path = "pain_curse_card.png"
var tool_tip_text = ""
var card_name = "Боль"
var card_description = "Когда попадает в руку, наносит 4 урона элементом смерти. Расходуется"
var rarity = "common"

func _ready() -> void:
	element = "death"
	description_rect.scale = Vector2(1, 0)
	description_label.text = card_description
	
	state_modifier = "_ability"
	type = "buff"
	energy_cost = 1
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

func on_hand() -> void:
	var tween = create_tween()
	tween.tween_property(self, "scale:y", 1.5, 0.2)
	tween.tween_property(self, "scale:y", 1, 0.2)
	
	if get_parent().get_parent().get_parent().get_parent().current_creature_turn == get_parent().get_parent().get_parent().get_parent().human:
		var dmg = int(4 * (1 - get_parent().get_parent().get_parent().get_parent().human.current_death_resistance))
		
		get_parent().get_parent().get_parent().get_parent().human.is_self_damage = true
		get_parent().get_parent().get_parent().get_parent().human.take_damage(dmg, 0.3)
	elif get_parent().get_parent().get_parent().get_parent().current_creature_turn == get_parent().get_parent().get_parent().get_parent().giant:
		var dmg = int(4 * (1 - get_parent().get_parent().get_parent().get_parent().giant.current_death_resistance))
		
		get_parent().get_parent().get_parent().get_parent().giant.is_self_damage = true
		get_parent().get_parent().get_parent().get_parent().giant.take_damage(4, 0.3)

func use_up():
	pass
	
func curse():
	pass	
