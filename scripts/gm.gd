extends Node

var state = "idle"
var prev_state = "idle"
var camera_zoom = 2
var start_pos = Vector2i(64+16, 32+16)
var prev_pos = Vector2i(64+16, 32+16)
var current_level_edge_positions : Array[Vector2]

var current_music_position : float = 0.0

var battle_x : int
var battle_y : int

var hp = 30
var max_hp = 30

var damage = 5
var current_damage = damage

var defence = 3
var current_defence = 0
var max_defence = 5
var defended = false

var speed = 100
var current_speed = speed

var accuracy = 80
var current_accuracy = accuracy
var luck = 10
var current_luck = luck

var energy = 2
var current_energy = energy
var max_energy = 2

var xp = 0
var xp_needed = 1
var level = 1

var current_targets : Array[CharacterBody2D]
var current_cards: Array[Card]
var current_enemies : Array

var debuff_set : Array = [["weakness", 1, 1], ["undefend", 100, 1], ["inaccuracy", 10, 1],\
 ["unluck", 5, 1], ["low_energy", 1, 1]]

var buff_set : Array = [["strength", 1, 1], ["defend", 100, 1], ["accuracy", 10, 1],\
 ["luck", 5, 1], ["high_energy", 1, 1]]

var attack_animation_time = 0.3
var defend_animation_time = 0.3
var debuff_animation_time = 0.6
var buff_animation_time = 0.6

func _ready() -> void:
	current_cards.append(AttackCard.new())
	current_cards.append(DefendCard.new())
	current_cards.append(AbilityCard.new())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
