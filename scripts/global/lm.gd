extends Node

# Путь к вашей сцене загрузочного экрана (укажите ваш путь!)
const LOADING_SCREEN_PATH = "res://scenes/ui/loading_screen.tscn"

# Сюда мы временно записываем путь до уровня, который хотим открыть
var target_scene: String = ""

# Главная функция для смены сцен через загрузочный экран
func change_scene_with_loading(to_scene_path: String):
	scene_transitioner.change_scene_back()
	target_scene = to_scene_path
	# Сначала мгновенно переключаемся на сцену загрузочного экрана
	get_tree().change_scene_to_file(LOADING_SCREEN_PATH)
