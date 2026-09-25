extends Node

var rare_card_chance : Array = [2, 5, 5, 10, 15, 15, 20, 20, 25, 35, 
40, 40, 40, 45, 45, 50, 50, 50, 50, 50,
55, 55, 60, 60, 60, 60, 65, 70, 70, 70,
70, 75, 80, 80, 80, 85, 85, 85, 85, 85,
90, 90, 95, 95, 95, 95, 95, 95, 95, 95]

var epic_card_chance : Array = [0, 0, 0, 0, 0, 5, 5, 5, 10, 10, 
10, 10, 10, 15, 15, 15, 20, 20, 20, 20,
25, 25, 30, 30, 30, 30, 35, 50, 60, 80,
70, 75, 80, 80, 80, 85, 85, 85, 85, 85,
90, 90, 95, 95, 95, 95, 95, 95, 95, 95]

var unbelievable_card_chance : Array = [0, 0, 0, 0, 0, 0, 0, 0, 2, 2, 
5, 5, 10, 10, 10, 15, 15, 15, 15, 15,
15, 15, 15, 15, 20, 20, 20, 20, 20, 20,
25, 25, 30, 30, 30, 40, 50, 50, 50, 60,
70, 70, 80, 80, 90, 90, 90, 95, 95, 95]

var all_card_names : Array[String] = ["ability", "attack", "double_claw", "sharp_claw", "got_you",
"cooked_meat"]
var all_card_names_common : Array[String]
var all_card_names_rare : Array[String]
var all_card_names_epic : Array[String]
var all_card_names_unbelievable : Array[String]

var all_card_names_cat : Array[String] = ["double_claw", "sharp_claw", "got_you",
"shashlyck", "inferno", "revenge", "cattenheimer", "lick_wounds", "compensation", "eclipse", "dinner", "bite",
"great_unluck"]
var all_card_names_common_cat : Array[String] = ["sharp_claw", "shashlyck"]
var all_card_names_rare_cat : Array[String] = ["double_claw", "lick_wounds", "compensation"]
var all_card_names_epic_cat : Array[String] = ["inferno", "revenge", "cattenheimer", "bite", "great_unluck"]
var all_card_names_unbelievable_cat : Array[String] = ["eclipse", "dinner"]



var all_card_names_human : Array[String] = ["little_fire", "boredom", "give_strength", "sollenheimer",
"wind_of_change", "fortune_wheel", "dont_hit", "fog", "big_fire", "burn_down", "sand_in_the_eyes",
"lucky_spear", "neutrality", "wish_you_luck", "wind_shield", "armageddon", "change_of_wind", "selfless",
"strong_wind"]
var all_card_names_common_human : Array[String] = ["give_strength",
"wind_of_change", "dont_hit","big_fire", "sand_in_the_eyes", "change_of_wind", "selfless"]
var all_card_names_rare_human : Array[String] = ["boredom", "fortune_wheel", "lucky_spear", "wish_you_luck",
"strong_wind"]
var all_card_names_epic_human : Array[String] = ["sollenheimer", "neutrality"]
var all_card_names_unbelievable_human : Array[String] = ["fog", "burn_down", "armageddon"]


var all_artifact_names : Array = ["red_ball", "blue_ball", "heart_shaped_pillow", "cat_food",
"old_bandage", "spinner", "boomerang", "regen_ring", "candy", "portrait_of_the_unknown", "fork",
"lucky_collar", "toy_cat", "rocky", "tomato_cross", "lucky_coin", "med_kit", "rainbow_pot", "discount",
"dice", "motivational_poster"]

var all_artifact_names_common : Array = ["red_ball", "old_bandage", "candy", "lucky_collar", "rocky", "fork"]
var all_artifact_names_rare : Array = ["blue_ball", "spinner", "boomerang", 
"portrait_of_the_unknown", "lucky_coin", "med_kit", "rainbow_pot", "discount"]
var all_artifact_names_epic : Array = ["heart_shaped_pillow", "toy_cat", "tomato_cross", "dice",
"motivational_poster"]
var all_artifact_names_unbelievable : Array = ["regen_ring"]




var all_stat_names : Array[String] = ["base_damage_rare", "base_damage_epic", "base_damage_unbelievable",
"defence_common", "defence_rare", "defence_epic", "max_defence_common", "max_defence_rare", "max_defence_epic",
"accuracy_common", "accuracy_rare", "accuracy_epic", "luck_common", "luck_rare", "luck_epic", "hp_common",
"hp_rare", "hp_epic", "hp_unbelievable", "energy_unbelievable"]
var all_stat_names_common : Array[String] = ["defence_common", "max_defence_common",
"accuracy_common", "luck_common", "hp_common"]
var all_stat_names_rare : Array[String] = ["base_damage_rare", "defence_rare", "max_defence_rare",
"accuracy_rare", "luck_rare", "hp_rare"]
var all_stat_names_epic : Array[String] = ["base_damage_epic", "defence_epic", "max_defence_epic",
"accuracy_epic", "luck_epic", "hp_epic"]
var all_stat_names_unbelievable : Array[String] = ["base_damage_unbelievable", "hp_unbelievable", "energy_unbelievable"]

var all_stat_names_legendary : Array[String] = ["hp_legendary", "energy_legendary"]

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass
