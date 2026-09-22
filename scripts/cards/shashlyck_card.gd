class_name CookedMeatCard extends Card

var damage = 2 + gm.damage_cat
var card_path = "shashlyck_card.tscn"
var icon_path = "shashlyck_card.png"
var tool_tip_text = ""
var card_name = settings.card_text_cat.get("shashlyck_name")
var card_description = settings.card_text_cat.get("shashlyck_desc")
var rarity = "common"

func _ready() -> void:
	element = "food"
	description_rect.scale = Vector2(1, 0)
	description_label.text = card_description
	
	shake = 0.1
	state_modifier = "_attack"
	type = "attack"
	behind_attack = true
	$Energy/Label.text = str(energy_cost)

func _process(delta: float) -> void:
	if gm.current_energy_cat < energy_cost:
		$Energy/Label.add_theme_color_override("font_color", colors.card_too_expensive)
	elif energy_cost < init_energy_cost:
		$Energy/Label.add_theme_color_override("font_color", colors.card_too_cheap)
	else:
		$Energy/Label.add_theme_color_override("font_color", Color.WHITE)
		
func on_after_play() -> void:
	var heal_amount = gm.current_targets.size()
	
	if gm.has_fork:
		heal_amount *= damage
	get_parent().get_parent().get_parent().get_parent().giant.heal(heal_amount)
