extends Control

@onready var progress_bar = $ProgressBar

var target_scene_path: String = ""
var progress: Array = []

func _ready():
	# Получаем путь к сцене, которую нужно загрузить, из глобального синглтона
	target_scene_path = lm.target_scene
	
	if target_scene_path == "":
		push_error("Путь к целевой сцене не задан!")
		return
		
	# Запускаем фоновую потоковую загрузку сцены
	ResourceLoader.load_threaded_request(target_scene_path)

func _process(_delta):
	# Проверяем статус загрузки
	var status = ResourceLoader.load_threaded_get_status(target_scene_path, progress)
	
	match status:
		ResourceLoader.THREAD_LOAD_IN_PROGRESS:
			# Обновляем ProgressBar (progress[0] возвращает значение от 0.0 до 1.0)
			progress_bar.value = progress[0] * 100
			
		ResourceLoader.THREAD_LOAD_LOADED:
			# Сцена полностью загружена! Извлекаем её из памяти
			var new_scene = ResourceLoader.load_threaded_get(target_scene_path)
			# Меняем текущую сцену на загруженную
			get_tree().change_scene_to_packed(new_scene)
			
		ResourceLoader.THREAD_LOAD_FAILED:
			push_error("Ошибка при загрузке сцены: " + target_scene_path)
			set_process(false)
			
		ResourceLoader.THREAD_LOAD_INVALID_RESOURCE:
			push_error("Неверный ресурс или путь: " + target_scene_path)
			set_process(false)
