extends CanvasLayer

@onready var name_label: Label = $Panel/Label
@onready var text_label: RichTextLabel = $Panel/Text
@onready var icon = $Panel/Icon
@onready var blip_sound: AudioStreamPlayer = $BlipSound

# Массив с текстом диалога (можно передавать динамически из файла)
var dialogue_data: Array = [
	{"icon" : "solya_what" ,"name": "Соля", "text": "Как ты себя чувствуешь?"},
	{"icon" : "cat_default" ,"name": "Кот", "text": "Мяу мяу мяу... МЯУ [color=red]МЯУ[/color]?"},
	{"icon" : "solya_sad" ,"name": "Соля", "text": "Скоро мы вернёмся домой..."}
]

var current_line: int = 0
var is_typing: bool = false
var tween: Tween

func _ready() -> void:
	start_dialogue()

func start_dialogue() -> void:
	current_line = 0
	show_line()

func show_line() -> void:
	if current_line >= dialogue_data.size():
		end_dialogue()
		return
		
	is_typing = true
	var data = dialogue_data[current_line]
	
	icon.texture = load(str("res://assets/images/characters/", data["icon"], ".png"))
	name_label.text = data["name"]
	text_label.text = data["text"]
	
	# Эффект пишущей машинки: анимируем видимый процент текста от 0 до 1
	text_label.visible_ratio = 0.0
	
	if tween: tween.kill()
	tween = create_tween()
	
	# Скорость печати: 0.03 секунды на один символ
	var duration = data["text"].length() * 0.03
	tween.tween_property(text_label, "visible_ratio", 1.0, duration)
	
	# Воспроизводим звук во время печати текста
	_play_typing_sounds(duration)
	
	tween.finished.connect(func(): is_typing = false)

func _play_typing_sounds(duration: float) -> void:
	var timer = get_tree().create_timer(duration)
	while is_typing and timer.time_left > 0:
		if blip_sound: blip_sound.play()
		await get_tree().create_timer(0.06).timeout # Звук на каждую вторую букву

func _unhandled_input(event: InputEvent) -> void:
	# Если игрок нажал ЛКМ или Enter/Space
	if event.is_action_pressed("ui_accept") or (event is InputEventMouseButton and event.pressed):
		if is_typing:
			# Если текст еще печатается — мгновенно отображаем его полностью
			if tween: tween.kill()
			text_label.visible_ratio = 1.0
			is_typing = false
		else:
			# Если текст завершен — переходим к следующей строчке
			current_line += 1
			show_line()

func end_dialogue() -> void:
	queue_free() # Удаляем окно диалога с экрана
