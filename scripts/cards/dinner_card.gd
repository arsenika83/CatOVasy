class_name DinnerCard extends Card

var damage = 40 + gm.current_damage_human
var card_path = "dinner_card.tscn"
var icon_path = "dinner_card.png"
var tool_tip_text = ""
var card_name = "Ужин"
var card_description = "Наносит 40 урона + базовый. Восстанавливает ОЗ, равное половине нанесенного урона. Расходуется"
var rarity = "unbelievable"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	shake = 0.3
	description_rect.scale = Vector2(1, 0)
	description_label.text = card_description
	
	state_modifier = "_attack"
	type = "attack"
	energy_cost = 3
	$Energy/Label.text = str(energy_cost)

func _process(delta: float) -> void:
	if gm.current_energy_cat < energy_cost:
		$Energy/Label.add_theme_color_override("font_color", Color(0.98, 0.077, 0.078))
	else:
		$Energy/Label.add_theme_color_override("font_color", Color.WHITE)
		
func on_play() -> void:
	pass

func cant_miss():
	pass

func on_after_play() -> void:
	var heal_amount = int(get_parent().get_parent().get_parent().get_parent().giant.last_damage_dealt / 2)
	
	if gm.has_fork:
		heal_amount = damage
	get_parent().get_parent().get_parent().get_parent().giant.heal(heal_amount)
func use_up():
	pass
