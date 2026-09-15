class_name LuckySpearCard extends Card

var damage = 7 + gm.current_damage_human
var card_path = "lucky_spear_card.tscn"
var icon_path = "lucky_spear_card.png"
var tool_tip_text = ""
var card_name = "Счастливое копье"
var card_description = "Наносит 7 урона + базовый урон Соли. Сквозной удар. Следующий удар Соли будет удачным!"
var rarity = "rare"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	shake = 0.05
	behind_attack = true
	description_rect.scale = Vector2(1, 0)
	description_label.text = card_description
	
	state_modifier = "_attack"
	type = "attack"
	energy_cost = 2
	$Energy/Label.text = str(energy_cost)

func _process(delta: float) -> void:
	if gm.current_energy_human < energy_cost:
		$Energy/Label.add_theme_color_override("font_color", Color(0.98, 0.077, 0.078))
	else:
		$Energy/Label.add_theme_color_override("font_color", Color.WHITE)
		
func on_play() -> void:
	pass

func on_after_play() -> void:
	get_parent().get_parent().get_parent().get_parent().human.next_strike_lucky = true

func lucky_spear():
	pass
