extends Node

var state = "idle"
var prev_state = "idle"
var camera_zoom = 2
var start_pos = Vector2i(64+16, 32+16)
var prev_pos = Vector2i(64+16, 32+16)

var battle_x : int
var battle_y : int

var hp = 30
var max_hp = 30

var damage = 1
var current_damage = damage

var defence = 3
var current_defence = 0
var max_defence = 5
var defended = false

var accuracy = 80
var current_accuracy = accuracy
var luck = 10
var current_luck = luck

var energy = 2
var max_energy = 2

var xp = 0
var xp_needed = 1
var level = 1

var current_target : Enemy
var current_cards: Array[Card]
var current_enemies : Array

var attack_animation_time = 0.3

func _ready() -> void:
	current_cards.append(AttackCard.new())
	current_cards.append(DefendCard.new())
	current_cards.append(AbilityCard.new())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
