extends Node

var state = "idle"
var camera_zoom = 2
var start_pos = Vector2i(64+16, 32+16)
var prev_pos = Vector2i(64+16, 32+16)

var hp = 5
var damage = 1
var xp = 0
var xp_needed = 1
var level = 1

var current_cards: Array[Card]
var current_enemies : Array

func _ready() -> void:
	current_cards.append(AttackCard.new())
	current_cards.append(DefendCard.new())
	current_cards.append(AbilityCard.new())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
