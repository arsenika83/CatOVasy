extends Node

const SAVE_PATH = "res:///saves/save_1.json"

var current_cards_cat: Dictionary[int, Card]
var current_cards_human: Dictionary[int, Card]

var current_targets : Array[CharacterBody2D]
var current_card: Card

var current_artifacts_cat: Dictionary[int, Artifact]
var current_artifacts_human: Dictionary[int, Artifact]
var has_artifacts: Array[int]

var current_enemies : Array

var save_data = {
	"level_number": gm.level_number,
	"current_level_name": gm.current_level_name,
	"camera_zoom": gm.camera_zoom,
	
	"match_amount": gm.match_amount,
	
	"hp_cat": 30,
	"max_hp_cat": 30,
	"damage_cat": 0,
	"min_damage_cat": -3,
	"current_damage_cat": 0,
	
	"defence_cat": 3,
	"current_defence_cat": 0,
	"max_defence_cat": 5,
	
	"accuracy_cat": 70,
	"min_accuracy_cat": 5,
	"max_accuracy_cat": 99,
	"current_accuracy_cat": 70,
	
	"luck_cat": 10,
	"min_luck_cat": -100,
	"max_luck_cat": 100,
	"current_luck_cat": 10,

	"energy_cat": 3,
	"current_energy_cat": 3,
	"max_energy_cat": 3,

	"current_hand_size_cat": 5,
	"hand_size_cat": 5,
	
	
	"hp_human": 25,
	"max_hp_human": 25,

	"damage_human": 0,
	"min_damage_human": -3,
	"current_damage_human": 0,

	"defence_human": 3,
	"current_defence_human": 0,
	"max_defence_human": 7,

	"accuracy_human": 65,
	"min_accuracy_human": 5,
	"max_accuracy_human": 99,
	"current_accuracy_human": 65,

	"luck_human": 15,
	"min_luck_human": -100,
	"max_luck_human": 100,
	"current_luck_human": 15,

	"energy_human": 2,
	"current_energy_human": 2,
	"max_energy_human": 2,

	"current_hand_size_human": 4,
	"hand_size_human": 4,
	
	"level": 1,
	"xp": 0,
	"xp_needed": 1,
	
	"max_hand_size": 8,
	
	"current_cards_cat": {
		1: "attack_card.tscn",
		2: "attack_card.tscn",
		3: "attack_card.tscn",
		4: "defend_card.tscn",
		5: "defend_card.tscn",
		6: "defend_card.tscn"
	},
	
	"current_cards_human": {
		1: "little_fire_card.tscn",
		2: "little_fire_card.tscn",
		3: "little_fire_card.tscn",
		4: "wind_shield_card.tscn",
		5: "dont_hit_card.tscn",
		6: "sollenheimer_card.tscn"
	},
	
	"current_artifacts_cat": {
		1: "cat_food"
	},
	"current_artifacts_human": {
		1: "matches"
	},
	"has_cat_food" : true,
	"has_spinner" : false,
	"has_boomerang" : false,
	"has_fork" : false,
	"has_heart_shaped_pillow" : false,
	"has_toy_cat" : false,
	"has_rocky" : false,
	"has_mrs_rocky" : false,
	"has_tomato_cross" : false,
	"has_motivational_poster" : false,

	"has_regen_ring" : false,
	"has_portrait_of_the_unknown" : false,
	"has_old_bandage" : false,
	"has_rainbow_pot" : false,
	"has_lucky_coin": false,
	"has_discount" : false,
	"has_dice" : false,
	
	"all_artifact_names" : catalog.all_artifact_names,
	"all_artifact_names_common" : catalog.all_artifact_names_common,
	"all_artifact_names_rare" : catalog.all_artifact_names_rare,
	"all_artifact_names_epic" : catalog.all_artifact_names_epic,
	"all_artifact_names_unbelievable" : catalog.all_artifact_names_unbelievable,	
}

func save_file():
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file == null:
		push_error("Не удалось создать файл сохранения: " + str(FileAccess.get_open_error()))
		return
	
	var json_string = JSON.stringify(save_data)
	file.store_string(json_string)
	file.close()
	print("Игра успешно сохранена!")

func save_game():
	var card_names_cat: Dictionary
	for card in gm.current_cards_cat:
		card_names_cat.set(card, gm.current_cards_cat.get(card).card_path)
	
	var card_names_human: Dictionary
	for card in gm.current_cards_human:
		card_names_human.set(card, gm.current_cards_human.get(card).card_path)
	
	var artifact_names_cat: Dictionary
	for art in gm.current_artifacts_cat:
		artifact_names_cat.set(art, gm.current_artifacts_cat.get(art).path)
	
	var artifact_names_human: Dictionary
	for art in gm.current_artifacts_human:
		artifact_names_human.set(art, gm.current_artifacts_human.get(art).path)
	
	save_data = {
		"level_number": gm.level_number,
		"current_level_name": gm.current_level_name,
		"camera_zoom": gm.camera_zoom,
		
		"match_amount": gm.match_amount,
		
		"hp_cat": gm.hp_cat,
		"max_hp_cat": gm.max_hp_cat,
		"damage_cat": gm.damage_cat,
		"min_damage_cat": gm.min_damage_cat,
		"current_damage_cat": gm.current_damage_cat,
		
		"defence_cat": gm.defence_cat,
		"current_defence_cat": gm.current_defence_cat,
		"max_defence_cat": gm.max_defence_cat,
		
		"accuracy_cat": gm.accuracy_cat,
		"min_accuracy_cat": gm.min_accuracy_cat,
		"max_accuracy_cat": gm.max_accuracy_cat,
		"current_accuracy_cat": gm.current_accuracy_cat,
		
		"luck_cat": gm.luck_cat,
		"min_luck_cat": gm.min_luck_cat,
		"max_luck_cat": gm.max_luck_cat,
		"current_luck_cat": gm.current_luck_cat,

		"energy_cat": gm.energy_cat,
		"current_energy_cat": gm.current_energy_cat,
		"max_energy_cat": gm.max_energy_cat,

		"current_hand_size_cat": gm.current_hand_size_cat,
		"hand_size_cat": gm.hand_size_cat,
		
		"hp_human": gm.hp_human,
		"max_hp_human": gm.max_hp_human,

		"damage_human": gm.damage_human,
		"min_damage_human": gm.min_damage_human,
		"current_damage_human": gm.current_damage_human,

		"defence_human": gm.defence_human,
		"current_defence_human": gm.current_defence_human,
		"max_defence_human": gm.max_defence_human,

		"accuracy_human": gm.accuracy_human,
		"min_accuracy_human": gm.min_accuracy_human,
		"max_accuracy_human": gm.max_accuracy_human,
		"current_accuracy_human": gm.current_accuracy_human,

		"luck_human": gm.luck_human,
		"min_luck_human": gm.min_luck_human,
		"max_luck_human": gm.max_luck_human,
		"current_luck_human": gm.current_luck_human,

		"energy_human": gm.energy_human,
		"current_energy_human": gm.current_energy_human,
		"max_energy_human": gm.max_energy_human,

		"current_hand_size_human": gm.current_hand_size_human,
		"hand_size_human": gm.hand_size_human,
		
		"level": gm.level,
		"xp": gm.xp,
		"xp_needed": gm.xp_needed,
		
		"max_hand_size": gm.max_hand_size,
		
		"current_cards_cat": card_names_cat,
		"current_cards_human": card_names_human,
		
		"current_artifacts_cat": artifact_names_cat,
		"current_artifacts_human": artifact_names_human,
		
		"has_cat_food" : gm.has_cat_food,
		"has_spinner" : gm.has_spinner,
		"has_boomerang" : gm.has_boomerang,
		"has_fork" : gm.has_fork,
		"has_heart_shaped_pillow" : gm.has_heart_shaped_pillow,
		"has_toy_cat" : gm.has_toy_cat,
		"has_rocky" : gm.has_rocky,
		"has_mrs_rocky" : gm.has_mrs_rocky,
		"has_tomato_cross" : gm.has_tomato_cross,
		"has_motivational_poster" : gm.has_motivational_poster,

		"has_regen_ring" : gm.has_regen_ring,
		"has_portrait_of_the_unknown" : gm.has_portrait_of_the_unknown,
		"has_old_bandage" : gm.has_old_bandage,
		"has_rainbow_pot" : gm.has_rainbow_pot,
		"has_lucky_coin": gm.has_lucky_coin,
		"has_discount" : gm.has_discount,
		"has_dice" : gm.has_dice,
		
		"all_artifact_names" : catalog.all_artifact_names,
		"all_artifact_names_common" : catalog.all_artifact_names_common,
		"all_artifact_names_rare" : catalog.all_artifact_names_rare,
		"all_artifact_names_epic" : catalog.all_artifact_names_epic,
		"all_artifact_names_unbelievable" : catalog.all_artifact_names_unbelievable,
	}
	
	save_file()

# Функция загрузки данных с диска
func load_file():
	if not FileAccess.file_exists(SAVE_PATH):
		print("Файл сохранения не найден. Используются значения по умолчанию.")
		return # Файла нет, играем со старта
		
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file == null or file.get_as_text() == "{}":
		push_error("Не удалось открыть файл сохранения: " + str(FileAccess.get_open_error()))
		return
		
	var json_string = file.get_as_text()
	file.close()
	
	# Парсим строку JSON обратно в данные
	var json = JSON.new()
	var error = json.parse(json_string)
	
	if error == OK:
		if save_data.get("level") == null:
			return
		# Обновляем наш рабочий словарь данными из файла
		if typeof(json.data) == TYPE_DICTIONARY:
			save_data = json.data
			print("Игра успешно загружена!")
		else:
			push_error("Неверный формат данных в файле.")
	else:
		push_error("Ошибка парсинга JSON: ", json.get_error_message())

func load_game():
	load_file()
	
	gm.level_number = save_data.get("level_number")
	gm.current_level_name = save_data.get("current_level_name")

	gm.camera_zoom = save_data.get("camera_zoom")

	gm.match_amount = save_data.get("match_amount")

	gm.hp_cat = save_data.get("hp_cat")
	gm.max_hp_cat = save_data.get("max_hp_cat")

	gm.damage_cat = save_data.get("damage_cat")
	gm.min_damage_cat = save_data.get("min_damage_cat")
	gm.current_damage_cat = save_data.get("current_damage_cat")

	gm.defence_cat = save_data.get("defence_cat")
	gm.current_defence_cat = save_data.get("current_defence_cat")
	gm.max_defence_cat = save_data.get("max_defence_cat")
	gm.defended_cat = save_data.get("defended_cat")

	gm.accuracy_cat = save_data.get("accuracy_cat")
	gm.min_accuracy_cat = save_data.get("min_accuracy_cat")
	gm.max_accuracy_cat = save_data.get("max_accuracy_cat")
	gm.current_accuracy_cat = save_data.get("current_accuracy_cat")

	gm.luck_cat = save_data.get("luck_cat")
	gm.min_luck_cat = save_data.get("min_luck_cat")
	gm.max_luck_cat = save_data.get("max_luck_cat")
	gm.current_luck_cat = save_data.get("current_luck_cat")

	gm.energy_cat = save_data.get("energy_cat")
	gm.current_energy_cat = save_data.get("current_energy_cat")
	gm.max_energy_cat = save_data.get("max_energy_cat")

	gm.current_hand_size_cat = save_data.get("current_hand_size_cat")
	gm.hand_size_cat = save_data.get("hand_size_cat")

	#==============================================================================================

	gm.hp_human = save_data.get("hp_human")
	gm.max_hp_human = save_data.get("max_hp_human")

	gm.damage_human = save_data.get("damage_human")
	gm.min_damage_human = save_data.get("min_damage_human")
	gm.current_damage_human = save_data.get("current_damage_human")

	gm.defence_human = save_data.get("defence_human")
	gm.current_defence_human = save_data.get("current_defence_human")
	gm.max_defence_human = save_data.get("max_defence_human")
	gm.defended_human = save_data.get("defended_human")

	gm.accuracy_human = save_data.get("accuracy_human")
	gm.min_accuracy_human = save_data.get("min_accuracy_human")
	gm.max_accuracy_human = save_data.get("max_accuracy_human")
	gm.current_accuracy_human = save_data.get("current_accuracy_human")

	gm.luck_human = save_data.get("luck_human")
	gm.min_luck_human = save_data.get("min_luck_human")
	gm.max_luck_human = save_data.get("max_luck_human")
	gm.current_luck_human = save_data.get("current_luck_human")

	gm.energy_human = save_data.get("energy_human")
	gm.current_energy_human = save_data.get("current_energy_human")
	gm.max_energy_human = save_data.get("max_energy_human")

	gm.current_hand_size_human = save_data.get("current_hand_size_human")
	gm.hand_size_human = save_data.get("hand_size_human")

	gm.xp = save_data.get("xp")
	gm.xp_needed = save_data.get("xp_needed")
	gm.level = save_data.get("level")
	gm.max_hand_size = save_data.get("max_hand_size")
	
	#CAT
	gm.has_cat_food = save_data.get("has_cat_food")
	gm.has_spinner = save_data.get("has_spinner")
	gm.has_boomerang = save_data.get("has_boomerang")
	gm.has_fork = save_data.get("has_fork")
	gm.has_heart_shaped_pillow = save_data.get("has_heart_shaped_pillow")
	gm.has_toy_cat = save_data.get("has_toy_cat")
	gm.has_rocky = save_data.get("has_rocky")
	gm.has_mrs_rocky = save_data.get("has_mrs_rocky")
	gm.has_tomato_cross = save_data.get("has_tomato_cross")
	gm.has_motivational_poster = save_data.get("has_motivational_poster")

	#HUMAN
	gm.has_regen_ring = save_data.get("has_regen_ring")
	gm.has_portrait_of_the_unknown = save_data.get("has_portrait_of_the_unknown")
	gm.has_old_bandage = save_data.get("has_old_bandage")
	gm.has_rainbow_pot = save_data.get("has_rainbow_pot")
	gm.has_lucky_coin = save_data.get("has_lucky_coin")
	gm.has_discount = save_data.get("has_discount")
	gm.has_dice = save_data.get("has_dice")
	
	var cards_cat = save_data.get("current_cards_cat")
	gm.current_cards_cat.clear()
	for card in cards_cat:
		var card_scene = load(str("res://scenes/cards/", cards_cat.get(card)))
		var added_card = card_scene.instantiate()
		gm.current_cards_cat.set(int(card), added_card)
		
	var cards_human = save_data.get("current_cards_human")
	gm.current_cards_human.clear()
	for card in cards_human:
		var card_scene = load(str("res://scenes/cards/", cards_human.get(card)))
		var added_card = card_scene.instantiate()
		gm.current_cards_human.set(int(card), added_card)	
		
	var artifacts_cat = save_data.get("current_artifacts_cat")
	gm.current_artifacts_cat.clear()
	for art in artifacts_cat:
		var art_scene = load(str("res://scenes/artifacts/", artifacts_cat.get(art), ".tscn"))
		var added_art = art_scene.instantiate()
		gm.current_artifacts_cat.set(int(art), added_art)
	
	var artifacts_human = save_data.get("current_artifacts_human")
	gm.current_artifacts_human.clear()
	for art in artifacts_human:
		var art_scene = load(str("res://scenes/artifacts/", artifacts_human.get(art), ".tscn"))
		var added_art = art_scene.instantiate()
		gm.current_artifacts_human.set(int(art), added_art)
		
	catalog.all_artifact_names = save_data.get("all_artifact_names")
	catalog.all_artifact_names_common = save_data.get("all_artifact_names_common")
	catalog.all_artifact_names_rare = save_data.get("all_artifact_names_rare")
	catalog.all_artifact_names_epic = save_data.get("all_artifact_names_epic")
	catalog.all_artifact_names_unbelievable = save_data.get("all_artifact_names_unbelievable")
	
func clear_save():
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file == null:
		push_error("Не удалось создать файл сохранения: " + str(FileAccess.get_open_error()))
		return
	
	file.store_string("")
	file.close()
	print("Игра успешно сохранена!")	
	
