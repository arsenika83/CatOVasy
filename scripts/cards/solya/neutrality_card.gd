class_name NeutralityCard extends Card

var card_path = "neutrality_card.tscn"
var icon_path = "neutrality_card.png"
var tool_tip_text = ""
var card_name = "Нейтралитет"
var card_description = "Удача ВСЕХ существ на поле боя равна нулю. Расходуется"
var rarity = "epic"

func _ready() -> void:
	element = "life"
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
	gm.current_energy_human -= energy_cost
	
	get_parent().get_parent().get_parent().get_parent().log_messages.append(
		str("- [color=#fdd14d]Нейтралитет[/color]: удача ВСЕХ существ теперь равна нулю!\n"))
	
	for enemy in get_parent().get_parent().get_parent().get_parent().current_enemies:
		if enemy.state != "dead":
			enemy.current_luck = 0
			enemy.luck = 0
			
			enemy.luck_particles.amount = 1
			enemy.luck_particles.restart()
			
			enemy.unluck_particles.amount = 1
			enemy.unluck_particles.restart()
	
	gm.current_luck_cat = 0
	gm.current_luck_human = 0
	get_parent().get_parent().get_parent().get_parent().human.audio_neutrality.play()
	get_parent().get_parent().get_parent().get_parent().human.neutrality_particles.emitting = true
	get_parent().get_parent().get_parent().get_parent().human.luck_particles.amount = 1
	get_parent().get_parent().get_parent().get_parent().human.luck_particles.restart()
	
	get_parent().get_parent().get_parent().get_parent().human.unluck_particles.amount = 1
	get_parent().get_parent().get_parent().get_parent().human.unluck_particles.restart()
	
	get_parent().get_parent().get_parent().get_parent().giant.luck_particles.amount = 1
	get_parent().get_parent().get_parent().get_parent().giant.luck_particles.restart()
	
	get_parent().get_parent().get_parent().get_parent().giant.unluck_particles.amount = 1
	get_parent().get_parent().get_parent().get_parent().giant.unluck_particles.restart()
	
	get_parent().get_parent().get_parent().get_parent().human.idle_animation_timer.start(0.6)
	
func use_up() -> void:
	pass
