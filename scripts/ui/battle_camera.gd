extends Camera2D

# Максимальное смещение по осям X и Y в пикселях при максимальной силе тряски
@export var max_offset: Vector2 = Vector2(10, 10)

var shake_strength: float = 0.0 # Текущая сила тряски (от 0.0 до 1.0)
var shake_decay: float = 5.0     # Скорость затухания тряски (чем выше, тем быстрее затихнет)

func _process(delta: float) -> void:
	if shake_strength > 0.0:
		# Плавно уменьшаем силу тряски со временем
		shake_strength = lerp(shake_strength, 0.0, shake_decay * delta)
		
		# Если сила стала совсем незаметной, сбрасываем камеру в центр
		if shake_strength < 0.01:
			shake_strength = 0.0
			offset = Vector2.ZERO
		else:
			# Вызываем саму тряску
			_execute_shake()

func _execute_shake() -> void:
	# Выбираем случайное направление и умножаем на текущую силу и максимальное смещение
	offset.x = randf_range(-1.0, 1.0) * max_offset.x * shake_strength
	offset.y = randf_range(-1.0, 1.0) * max_offset.y * shake_strength

# Главная функция, которую мы будем вызывать при ударе
func apply_shake(intensity: float = 1.0) -> void:
	# Устанавливаем силу тряски (значение зажимаем между 0.0 и 1.0 для безопасности)
	shake_strength = clamp(intensity, 0.0, 3.0)
