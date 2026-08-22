extends SubViewport


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Ждем один кадр, чтобы главная сцена успела загрузиться в дерево
	await get_tree().process_frame
	
	# Берем мир от главного окна игры и отдаем его нашему вьюпорту
	var main_world = get_tree().root.get_viewport().find_world_2d()
	if main_world:
		self.world_2d = main_world


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
