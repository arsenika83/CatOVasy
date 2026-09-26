extends Node

var path = "res://saves/save_1.json"
var save : Dictionary

var player_pos: Vector2

var level_number: int = 1
var current_level_name = "level0"

var creatures_killed: int = 0
var total_damage_cat: int = 0
var total_damage_human: int = 0

var gold_mine_count: int = 0

var state = "idle"
var prev_state = "idle"

var state_human = "idle"
var prev_state_human = "idle"

var camera_zoom = 2
var camera_prev_position: Vector2
var start_pos = Vector2i(64+16, 32+16)
var prev_pos = Vector2i(64+16, 32+16)

var match_amount: int = 5
var money: int = 100

var current_chest_rarity = ""

var enemies_following: int = 0
var current_level_edge_positions : Array[Vector2]
var current_music_position : float = 0.0

var battle_x_cat : int
var battle_y_cat : int

var hp_cat: int = 30
var max_hp_cat: int = 30

var damage_cat: int = 0
var min_damage_cat: int = -3
var current_damage_cat: int = damage_cat

var defence_cat: int = 3
var current_defence_cat: int = 0
var max_defence_cat: int = 5
var defended_cat = false

var accuracy_cat: int = 70
var min_accuracy_cat: int = 5
var max_accuracy_cat: int = 99
var current_accuracy_cat: int = accuracy_cat

var luck_cat: int = 10
var min_luck_cat: int = -100
var max_luck_cat: int = 100
var current_luck_cat: int = luck_cat

var speed_cat: int = 60
var current_speed_cat = speed_cat

var energy_cat: int = 3
var current_energy_cat: int = energy_cat
var max_energy_cat: int = 3

var current_hand_size_cat: int = 5
var hand_size_cat: int = 5

var might_resistance_cat: float = 0.2
var fire_resistance_cat: float = 0
var wind_resistance_cat: float = 0.0
var death_resistance_cat: float = 0
var life_resistance_cat: float = 0
var luck_resistance_cat: float = 0.0
var unluck_resistance_cat: float = 0.0
var inaccuracy_resistance_cat: float = 0.0
var energy_resistance_cat: float = 0.0

var current_might_resistance_cat: float = 0.2
var current_fire_resistance_cat: float = 0
var current_wind_resistance_cat: float = 0.0
var current_death_resistance_cat: float = 0
var current_life_resistance_cat: float = 0
var current_luck_resistance_cat: float = 0.0
var current_unluck_resistance_cat: float = 0.0
var current_inaccuracy_resistance_cat: float = 0.0
var current_energy_resistance_cat: float = 0
#==============================================================================================
var battle_x_human : int
var battle_y_human : int

var hp_human: int = 25
var max_hp_human: int = 25

var damage_human: int = 0
var min_damage_human: int = -3
var current_damage_human: int = damage_human

var defence_human: int = 3
var current_defence_human: int = 0
var max_defence_human: int = 7
var defended_human = false

var accuracy_human: int = 65
var min_accuracy_human: int = 5
var max_accuracy_human: int = 99
var current_accuracy_human: int = accuracy_human

var luck_human: int = 15
var min_luck_human: int = -100
var max_luck_human: int = 100
var current_luck_human: int = luck_human

var speed_human: int = 70
var current_speed_human = speed_human

var energy_human: int = 2
var current_energy_human: int = energy_human
var max_energy_human: int = 2

var current_hand_size_human: int = 4
var hand_size_human: int = 4

var xp_needed_array: Array[int] = [1, 5, 8, 9, 10, 10, 12, 12, 12, 13,
13, 14, 14, 14, 15, 15, 15, 17, 18, 18,
20, 20, 20, 22, 25, 30, 33, 35, 38, 40,
45, 50, 55, 60, 65, 70, 75, 80, 90, 100,
110, 120, 130, 140, 150, 160, 170, 180, 190, 200,
10000, 999999999999]
var xp: int = 0
var xp_needed: int = 1
var level: int = 1

var max_hand_size: int = 8

var fire_resistance_human: float = 0.25
var wind_resistance_human: float = 0.0
var might_resistance_human: float = 0.0
var death_resistance_human: float = 0
var life_resistance_human: float = 0
var luck_resistance_human: float = 0.0
var unluck_resistance_human: float = 0.0
var inaccuracy_resistance_human: float = 0.0
var energy_resistance_human: float = 0

var current_fire_resistance_human: float = 0.25
var current_wind_resistance_human: float = 0.0
var current_might_resistance_human: float = 0.0
var current_death_resistance_human: float = 0
var current_life_resistance_human: float = 0
var current_luck_resistance_human: float = 0.0
var current_unluck_resistance_human: float = 0.0
var current_inaccuracy_resistance_human: float = 0.0
var current_energy_resistance_human: float = 0
#============================================================================

var current_cards_cat: Dictionary[int, Card]
var current_cards_human: Dictionary[int, Card]

var current_targets : Array[CharacterBody2D]
var current_card: Card

var current_artifacts_cat: Dictionary[int, Artifact]
var current_artifacts_human: Dictionary[int, Artifact]
var has_artifacts: Array[int]

var current_enemies : Array

var attack_animation_time_cat = 0.3
var defend_animation_time_cat = 0.3
var debuff_animation_time_cat = 0.6
var buff_animation_time_cat = 0.6

var attack_animation_time_human = 0.3
var defend_animation_time_human = 0.3
var debuff_animation_time_human = 0.6
var buff_animation_time_human = 1.3

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass
		
func save_game() -> void:
	var card_names_cat: Dictionary
	for card in current_cards_cat:
		card_names_cat.set(card, current_cards_cat.get(card).card_path)
	
	var card_names_human: Dictionary
	for card in current_cards_human:
		card_names_human.set(card, current_cards_human.get(card).card_path)
	
	var artifact_names_cat: Dictionary
	for art in current_artifacts_cat:
		artifact_names_cat.set(art, current_artifacts_cat.get(art).path)
	
	var artifact_names_human: Dictionary
	for art in current_artifacts_human:
		artifact_names_human.set(art, current_artifacts_human.get(art).path)
	
	var save_data = {
		"level_number": level_number,
		"current_level_name": current_level_name,
		"camera_zoom": camera_zoom,
		
		"match_amount": match_amount,
		
		"hp_cat": hp_cat,
		"max_hp_cat": max_hp_cat,
		"damage_cat": damage_cat,
		"min_damage_cat": min_damage_cat,
		"current_damage_cat": current_damage_cat,
		
		"defence_cat": defence_cat,
		"current_defence_cat": current_defence_cat,
		"max_defence_cat": max_defence_cat,
		
		"accuracy_cat": accuracy_cat,
		"min_accuracy_cat": min_accuracy_cat,
		"max_accuracy_cat": max_accuracy_cat,
		"current_accuracy_cat": current_accuracy_cat,
		
		"luck_cat": luck_cat,
		"min_luck_cat": min_luck_cat,
		"max_luck_cat": max_luck_cat,
		"current_luck_cat": current_luck_cat,

		"energy_cat": energy_cat,
		"current_energy_cat": current_energy_cat,
		"max_energy_cat": max_energy_cat,

		"current_hand_size_cat": current_hand_size_cat,
		"hand_size_cat": hand_size_cat,
		
		"hp_human": hp_human,
		"max_hp_human": max_hp_human,

		"damage_human": damage_human,
		"min_damage_human": min_damage_human,
		"current_damage_human": current_damage_human,

		"defence_human": defence_human,
		"current_defence_human": current_defence_human,
		"max_defence_human": max_defence_human,

		"accuracy_human": accuracy_human,
		"min_accuracy_human": min_accuracy_human,
		"max_accuracy_human": max_accuracy_human,
		"current_accuracy_human": current_accuracy_human,

		"luck_human": luck_human,
		"min_luck_human": min_luck_human,
		"max_luck_human": max_luck_human,
		"current_luck_human": current_luck_human,

		"energy_human": energy_human,
		"current_energy_human": current_energy_human,
		"max_energy_human": max_energy_human,

		"current_hand_size_human": current_hand_size_human,
		"hand_size_human": hand_size_human,
		
		"level": level,
		"xp": xp,
		"xp_needed": xp_needed,
		
		"max_hand_size": max_hand_size,
		
		"current_cards_cat": card_names_cat,
		"current_cards_human": card_names_human,
		
		"current_artifacts_cat": artifact_names_cat,
		"current_artifacts_human": artifact_names_human,
		
		"has_cat_food" : has_cat_food,
		"has_spinner" : has_spinner,
		"has_boomerang" : has_boomerang,
		"has_fork" : has_fork,
		"has_heart_shaped_pillow" : has_heart_shaped_pillow,
		"has_toy_cat" : has_toy_cat,
		"has_rocky" : has_rocky,
		"has_mrs_rocky" : has_mrs_rocky,
		"has_tomato_cross" : has_tomato_cross,
		"has_motivational_poster" : has_motivational_poster,

		"has_regen_ring" : has_regen_ring,
		"has_portrait_of_the_unknown" : has_portrait_of_the_unknown,
		"has_old_bandage" : has_old_bandage,
		"has_rainbow_pot" : has_rainbow_pot,
		"has_lucky_coin": has_lucky_coin,
		"has_discount" : has_discount,
		"has_dice" : has_dice,
	}
	sm.save_data = save_data
	sm.save_game()


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
var has_cat_food = true
var has_spinner = false
var has_boomerang = false
var has_fork = false
var has_heart_shaped_pillow = false
var has_toy_cat = false
var has_rocky = false
var has_mrs_rocky = false
var has_tomato_cross = false
var has_motivational_poster = false

#HUMAN
var has_regen_ring = false
var has_portrait_of_the_unknown = false
var has_old_bandage = false
var has_rainbow_pot = false
var has_lucky_coin = false
var has_discount = false
var has_dice = false
