extends Camera2D

@export var target_position: Vector2 = Vector2(500, 300) # Координаты нужной зоны на карте

func _ready() -> void:
	# Закрепляем камеру телевизора в конкретной точке глобальной карты
	global_position = target_position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position = target_position
