extends Node

var state = "idle"
var prev_state = "idle"
var camera_zoom = 2
var start_pos = Vector2i(64+16, 32+16)
var prev_pos = Vector2i(64+16, 32+16)

var current_chest_rarity = ""

var enemies_following = 0
var current_level_edge_positions : Array[Vector2]
var current_music_position : float = 0.0

var battle_x : int
var battle_y : int

var hp = 30
var max_hp = 30

var damage = 2
var min_damage = -3
var current_damage = damage

var defence = 3
var current_defence = 0
var max_defence = 5
var defended = false

var speed = 100
var current_speed = speed

var accuracy = 70
var min_accuracy = 0
var current_accuracy = accuracy

var luck = 10
var min_luck = -100
var current_luck = luck

var energy = 2
var current_energy = energy
var max_energy = 2

var xp = 0
var xp_needed = 1
var level = 1

var current_targets : Array[CharacterBody2D]
var current_cards: Array[Card]
var current_card: Card

var current_attack_cards: Dictionary[int, Card]
var current_defend_cards: Dictionary[int, Card]
var current_ability_cards: Dictionary[int, Card]

var current_artifacts: Dictionary[int, Artifact]
var has_artifacts: Array[int]

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
	
	current_attack_cards.set(0, AttackCard.new())
	current_attack_cards.set(1, AttackCard.new())
	current_attack_cards.set(2, AttackDoubleClaw.new())
	
	current_defend_cards.set(1, DefendCard.new())
	
	current_ability_cards.set(1, AbilityCard.new())

func _process(delta: float) -> void:
	pass

func add_attack_card(index : int, card : Card) -> void:
	var card_resource = load("res://scenes/cards/" + card.card_path)
	var added_card = card_resource.instantiate()
	current_attack_cards.set(index, added_card)
	
func add_ability_card(index : int, card : Card) -> void:
	var card_resource = load("res://scenes/cards/" + card.card_path)
	var added_card = card_resource.instantiate()
	current_ability_cards.set(index, added_card)
	
func add_artifact(index : int, artifact : Artifact) -> void:
	var artifact_resource = load("res://scenes/artifacts/" + artifact.path + ".tscn")
	var added_artifact = artifact_resource.instantiate()
	current_artifacts.set(index, added_artifact)	

var has_cat_food = false
var has_old_bandage = false
var has_spinner = false
var has_boomerang = false
var has_regen_ring = false
var has_portrait_of_the_unknown = false
var has_fork = false
var has_heart_shaped_pillow = false
var has_toy_cat = false
var has_rocky = false
var has_mrs_rocky = false
var has_tomato_cross = false
