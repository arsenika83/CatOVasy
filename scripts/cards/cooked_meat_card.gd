class_name CookedMeatCard extends Card

var damage = 1 + gm.damage_cat
var card_path = "cooked_meat_card.tscn"
var icon_path = "cooked_meat_card.png"
var tool_tip_text = ""
var card_name = "Шашлык"
var card_description = "Наносит урон, равный 1 + базовый. Удар проходит цель насквозь"
var rarity = "common"

func _ready() -> void:
	description_rect.scale = Vector2(1, 0)
	description_label.text = card_description
	
	shake = 0.1
	state_modifier = "_attack"
	type = "attack"
	behind_attack = true
	$Energy/Label.text = str(energy_cost)

func _process(delta: float) -> void:
	pass
