extends Label


func display_damage(amount: int, start_position: Vector2) -> void:

	text = str(amount)
	global_position = start_position
	
	# Генерируем небольшое случайное смещение по горизонтали, 
	# чтобы цифры не вылетали строго в одну точку, если ударов много
	var random_x = randf_range(-30.0, 30.0)
	# Целевая позиция: подкидываем текст вверх и немного вбок
	var target_position = start_position + Vector2(random_x, -60.0)
	
	# Настраиваем Tween для плавной анимации
	var tween = create_tween().set_parallel(true) # Включаем параллельное выполнение анимаций
	
	# 1. Плавный взлет вверх
	tween.tween_property(self, "global_position", target_position, 0.8).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		
	# 2. Эффект "подпрыгивания" (в начале текст резко увеличивается, затем уменьшается)
	scale = Vector2.ZERO
	var scale_tween = create_tween()
	scale_tween.tween_property(self, "scale", Vector2(1.3, 1.3), 0.15)
	scale_tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.1)
	
	# 3. Плавное исчезновение (Fade out) ближе к концу анимации
	tween.tween_property(self, "modulate:a", 0.0, 0.3).set_delay(0.3)
	
	# Автоматически удаляем узел из памяти после завершения всех анимаций
	tween.chain().tween_callback(queue_free)
