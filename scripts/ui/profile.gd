extends Control

@export var id = 0
var room_number = 0
var path = "res://saves/profiles/profile_1.json"
var button_text = ""
var json

func _ready() -> void:
	path = str("res://saves/profiles/profile_", id, ".json")
	
	json = load_json(path)
	if json.is_empty():
		button_text = "ПУСТО"
	else:	
		button_text += str("ПРОФИЛЬ ", id, "\n\n")
		button_text += str(json.get("name"), "\n")
		button_text += str(json.get("game_time"), "\n")
	
	$Button.text = button_text

func _process(delta: float) -> void:
	pass
	
func save_to_file() -> void:

	var file = FileAccess.open(path, FileAccess.WRITE)
	
	if file:
		file.store_string("")
		file.close()                 
		print("Файл успешно сохранен!")
	else:
		print("Ошибка открытия файла для записи: ", FileAccess.get_open_error())


func load_json(path: String) -> Dictionary:
	if not FileAccess.file_exists(path):
		print("Файл профиля не найден!")
		return {}
		
	var file = FileAccess.open(path, FileAccess.READ)
	if not file:
		print("Не удалось открыть файл для чтения.")
		return {}
		
	var json_text = file.get_as_text()
	file.close()
	
	var parsed_data = JSON.parse_string(json_text)
	
	if parsed_data == null:
		print("Ошибка чтения JSON: Файл поврежден или имеет неверный синтаксис!")
		return {}
		
	return parsed_data

func _on_button_pressed() -> void:
	$Timer.start()
	scene_transitioner.change_scene_to()

func _on_timer_timeout() -> void:
	get_tree().change_scene_to_file(str("res://scenes/levels/level", room_number, ".tscn"))
