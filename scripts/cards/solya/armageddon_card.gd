class_name ArmageddonCard extends Card

var damage = 250
var card_path = "armageddon_card.tscn"
var icon_path = "armageddon_card.png"
var tool_tip_text = ""
var card_name = "АРМАГЕДДОН"
var card_description = "Наносит ВСЕМ врагам 250 урона. Здоровье Соли и кота равно 1.\nНе может промахнуться.\nРасходуется"
var rarity = "unbelievable"

func _ready() -> void:
	element = "fire"
	everybody_attack = true
	shake = 3.0
	description_rect.scale = Vector2(1, 0)
	description_label.text = card_description
	
	state_modifier = "_attack"
	type = "attack"
	energy_cost = 3
	$Energy/Label.text = str(energy_cost)

func _process(delta: float) -> void:
	if gm.current_energy_human < energy_cost:
		$Energy/Label.add_theme_color_override("font_color", Color(0.98, 0.077, 0.078))
	else:
		$Energy/Label.add_theme_color_override("font_color", Color.WHITE)

func on_play() -> void:
	get_parent().get_parent().get_parent().get_parent().giant.take_damage((gm.hp_cat - 1) * (1-gm.fire_resistance_cat), gm.attack_animation_time_cat)
	get_parent().get_parent().get_parent().get_parent().human.take_damage((gm.hp_human - 1) * (1-gm.fire_resistance_human), gm.attack_animation_time_human)
	
	get_parent().get_parent().get_parent().get_parent().armageddon_fx.big_particles.restart()
	get_parent().get_parent().get_parent().get_parent().armageddon_fx.little_particles.restart()

func cant_miss():
	pass

func use_up():
	pass	
