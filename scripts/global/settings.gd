extends Node

var master_volume: float = 1.0
var music_volume: float = 1.0
var sound_fx_volume: float = 1.0
var animation_speed: float = 1.0

var path = "res://saves/saved_settings.txt"

func _ready() -> void:
	read_settings_from_file()
	apply_audio_settings()

func _process(delta: float) -> void:
	pass
		
func apply_audio_settings() -> void:
	if master_volume <= 0.05:
		AudioServer.set_bus_mute(0, true)
	else:
		AudioServer.set_bus_mute(0, false)
		var db_value = linear_to_db(master_volume)
		AudioServer.set_bus_volume_db(0, db_value)
		
	if music_volume <= 0.05:
		AudioServer.set_bus_mute(1, true)
	else:
		AudioServer.set_bus_mute(1, false)
		var db_value = linear_to_db(music_volume)
		AudioServer.set_bus_volume_db(1, db_value)
		
	if sound_fx_volume <= 0.05:
		AudioServer.set_bus_mute(2, true)
	else:
		AudioServer.set_bus_mute(2, false)
		var db_value = linear_to_db(sound_fx_volume)
		AudioServer.set_bus_volume_db(2, db_value)
		
func read_settings_from_file() -> void:
	var file = FileAccess.open(path, FileAccess.READ)
	if file:
		master_volume = float(file.get_line())
		music_volume = float(file.get_line())
		sound_fx_volume = float(file.get_line())
		
	file.close()
	
func save_settings_to_file() -> void:
	var text_content = ""
	text_content += str(master_volume)
	text_content += "\n"
	text_content += str(music_volume)
	text_content += "\n"
	text_content += str(sound_fx_volume)
	text_content += "\n"
	
	var file = FileAccess.open(path, FileAccess.WRITE)
	
	if file:
		file.store_string(text_content)
		file.close()                 
		print("Файл успешно сохранен!")
	else:
		print("Ошибка открытия файла для записи: ", FileAccess.get_open_error())
