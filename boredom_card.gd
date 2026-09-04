class_name BoredomCard extends Card

var card_path = "boredom_card.tscn"
var icon_path = "boredom_card.png"
var tool_tip_text = ""
var card_name = "Скука"
var card_description = "В этом ходу кот наносит +1 урона"
var rarity = "common"
var strength = 1
var turns = 1

func _ready() -> void:
	energy_cost = 0
	state_modifier = "_ability"
	$Energy/Label.text = str(energy_cost)
	type = "skip_turn"

func _process(delta: float) -> void:
	pass

func on_play() -> void:
	gm.current_energy_cat += gm.current_energy_human
	gm.current_energy_human = -1000
	get_parent().get_parent().get_parent().get_parent().end_turn()
	print("END TURN BOREDOM")
