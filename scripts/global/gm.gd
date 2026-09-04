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

var battle_x_cat : int
var battle_y_cat : int

var hp_cat = 30
var max_hp_cat = 30

var damage_cat = 0
var min_damage_cat = -3
var current_damage_cat = damage_cat

var defence_cat = 3
var current_defence_cat = 0
var max_defence_cat = 5
var defended_cat = false

var accuracy_cat = 70
var min_accuracy_cat = 0
var current_accuracy_cat = accuracy_cat

var luck_cat = 10
var min_luck_cat = -100
var current_luck_cat = luck_cat

var battle_x_human : int
var battle_y_human : int

var hp_human = 25
var max_hp_human = 25

var damage_human = 0
var min_damage_human = -3
var current_damage_human = damage_human

var defence_human = 3
var current_defence_human = 0
var max_defence_human = 7
var defended_human = false

var accuracy_human = 70
var min_accuracy_human = 0
var current_accuracy_human = accuracy_human

var luck_human = 20
var min_luck_human = -100
var current_luck_human = luck_human

var energy_cat = 3
var energy_human = 2
var current_energy = energy_human

var max_energy_cat = 3
var max_energy_human = 2

var xp = 0
var xp_needed = 1
var level = 1

var current_cards_cat: Dictionary[int, Card]
var current_cards_human: Dictionary[int, Card]

var current_targets : Array[CharacterBody2D]
var current_card: Card

var current_artifacts_cat: Dictionary[int, Artifact]
var current_artifacts_human: Dictionary[int, Artifact]
var has_artifacts: Array[int]

var current_enemies : Array

var debuff_set : Array = [["weakness", 1, 1], ["undefend", 100, 1], ["inaccuracy", 10, 1],\
 ["unluck", 5, 1], ["low_energy", 1, 1]]

var buff_set : Array = [["strength", 1, 1], ["defend", 100, 1], ["accuracy", 10, 1],\
 ["luck", 5, 1], ["high_energy", 1, 1]]

var attack_animation_time_cat = 0.3
var defend_animation_time_cat = 0.3
var debuff_animation_time_cat = 0.6
var buff_animation_time_cat = 0.6

var attack_animation_time_human = 0.3
var defend_animation_time_human = 0.3
var debuff_animation_time_human = 0.6
var buff_animation_time_human = 0.6

func _ready() -> void:
	current_cards_cat.set(1, AttackCard.new())
	current_cards_cat.set(2, AttackCard.new())
	current_cards_cat.set(3, AttackCard.new())
	current_cards_cat.set(4, DefendCard.new())
	current_cards_cat.set(5, DefendCard.new())
	current_cards_cat.set(6, DefendCard.new())
	current_cards_cat.set(7, AbilityCard.new())
	current_cards_cat.set(8, LunchCard.new())
	current_cards_cat.set(9, LunchCard.new())
	current_cards_cat.set(10, LunchCard.new())
	
	current_cards_human.set(1, GiveStrengthCard.new())
	current_cards_human.set(2, GiveStrengthCard.new())
	current_cards_human.set(3, GiveStrengthCard.new())
	current_cards_human.set(4, LittleFireCard.new())
	current_cards_human.set(5, LittleFireCard.new())
	

func _process(delta: float) -> void:
	pass

func add_card_cat(index : int, card : Card) -> void:
	var card_resource = load("res://scenes/cards/" + card.card_path)
	var added_card = card_resource.instantiate()
	current_cards_cat.set(index, added_card)
	
func add_card_human(index : int, card : Card) -> void:
	var card_resource = load("res://scenes/cards/" + card.card_path)
	var added_card = card_resource.instantiate()
	current_cards_human.set(index, added_card)	
	
func add_artifact_cat(index : int, artifact : Artifact) -> void:
	var artifact_resource = load("res://scenes/artifacts/" + artifact.path + ".tscn")
	var added_artifact = artifact_resource.instantiate()
	current_artifacts_cat.set(index, added_artifact)

func add_artifact_human(index : int, artifact : Artifact) -> void:
	var artifact_resource = load("res://scenes/artifacts/" + artifact.path + ".tscn")
	var added_artifact = artifact_resource.instantiate()
	current_artifacts_human.set(index, added_artifact)

#CAT
var has_cat_food = false
var has_spinner = false
var has_boomerang = false
var has_fork = false
var has_heart_shaped_pillow = false
var has_toy_cat = false
var has_rocky = false
var has_mrs_rocky = false
var has_tomato_cross = false

#HUMAN
var has_regen_ring = false
var has_portrait_of_the_unknown = false
var has_old_bandage = false
