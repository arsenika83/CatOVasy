class_name CookedMeatCard extends Card

var damage = 1 + gm.damage
var card_path = "cooked_meat_card.tscn"
var icon_path = "cooked_meat_card.png"
var tool_tip_text = ""
var card_name = "Шашлык"
var card_description = "Наносит урон, равный 1 + базовый. Удар проходит цель насквозь"
var rarity = "common"

func _ready() -> void:
	state_modifier = "_attack"
	type = "attack"
	behind_attack = true
	$Label.text = str("Урон: ", damage, "\n<Сквозной удар>")
	$Energy/Label.text = str(energy_cost)

func _process(delta: float) -> void:
	pass
