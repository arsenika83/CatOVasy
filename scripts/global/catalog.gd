extends Node

var all_card_names : Array[String] = ["ability", "attack", "attack_double_claw"]
var all_card_names_common : Array[String]
var all_card_names_rare : Array[String]
var all_card_names_epic : Array[String]
var all_card_names_unbelievable : Array[String]

var all_artifact_names : Array[String] = ["ball", "blue_ball", "heart_shaped_pillow"]

var all_stat_names : Array[String] = ["base_damage_1", "base_damage_3", "base_damage_5",
"defence_2", "defence_4", "defence_7", "max_defence_3", "max_defence_6", "max_defence_12",
"accuracy_1", "accuracy_3", "accuracy_5", "luck_2", "luck_4", "luck_7", "hp_5", "hp_10", "hp_20",
"energy_1"]
var all_stat_names_common : Array[String] = ["defence_2", "max_defence_3",
"accuracy_1", "luck_2", "hp_2"]
var all_stat_names_rare : Array[String] = ["base_damage_1", "defence_4", "max_defence_6",
"accuracy_3", "luck_4", "hp_5"]
var all_stat_names_epic : Array[String] = ["base_damage_3", "defence_7", "max_defence_12",
"accuracy_5", "luck_7", "hp_10"]
var all_stat_names_unbelievable : Array[String] = ["base_damage_5", "hp_20", "energy_1"]

var all_stat_names_legendary : Array[String] = ["hp_50", "energy_2"]

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass
