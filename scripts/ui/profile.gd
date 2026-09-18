extends Control

@export var id = 0
var room_number = 0
var path = "res://saves/profiles/profile_1.json"
var button_text = ""
var json
var is_empty = true

var test_text = str({
	"name" : "Котик",
	"game_time" : "10:32:07"
})

func _ready() -> void:
	path = str("res://saves/profiles/profile_", id, ".json")
	
	update_profile_button()

func _process(delta: float) -> void:
	if is_empty:
		$Button.disabled = true
		$CreateButton.visible = true
		$DeleteButton.visible = false
	else:
		$Button.disabled = false
		$CreateButton.visible = false
		$DeleteButton.visible = true

func update_profile_button() -> void:
	json = load_json(path)
	if json.is_empty() or json.get("name") == null:
		button_text = "ПУСТО"
		is_empty = true
		$Button.text = button_text
	else:
		is_empty = false
		button_text = ""
		button_text += str("ПРОФИЛЬ ", id, "\n\n")
		button_text += str(json.get("name"), "\n")
		button_text += str(json.get("game_time"), "\n")	
		$Button.text = button_text
	
func save_to_file(text : String) -> void:

	var file = FileAccess.open(path, FileAccess.WRITE)
	
	if file:
		file.store_string(text)
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
		
	is_empty = false		
	return parsed_data

func _on_button_pressed() -> void:
	if not is_empty:
		$Timer.start()
		scene_transitioner.change_scene_to()
	else:
		print("Создание профиля")

func _on_timer_timeout() -> void:
	get_tree().change_scene_to_file(str("res://scenes/levels/level", room_number, ".tscn"))


func _on_create_button_pressed() -> void:
	save_to_file(test_text)
	update_profile_button()

func _on_delete_button_pressed() -> void:
	save_to_file("{}")
	update_profile_button()
