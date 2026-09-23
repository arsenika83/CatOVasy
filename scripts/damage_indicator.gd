extends RichTextLabel


func display_damage(amount, start_position: Vector2) -> void:
	scale = Vector2(1, 1)
	var scale_mult = 1.3 + (int(amount) / 100)
	
	if scale_mult > 2:
		scale_mult = 2
	
	if int(amount) < 0: 
		text = str("[outline_size=4][outline_color=#2f94cf][color=#4dbcfd]+ ", -amount, " [/color][/outline_color][/outline_size]")
	elif int(amount) == 0: 
		text = str("[outline_size=4][outline_color=#000000][color=#FFFFFF]", amount, " [/color][/outline_color][/outline_size]")
	elif int(amount) > 0 and int(amount) <= 10:
		text = str("[outline_size=4][outline_color=#930609][color=#d90206]", amount, " [/color][/outline_color][/outline_size]")
	elif int(amount) > 10 and int(amount) <= 100:
		text = str("[outline_size=4][outline_color=#a00b57][color=#e10374]", amount, " [/color][/outline_color][/outline_size]")	
	else:
		text = str("[outline_size=4][outline_color=#9c9c9c][color=#ae19ff]", amount, " [/color][/outline_color][/outline_size]")
	global_position = start_position
	
	# Генерируем небольшое случайное смещение по горизонтали, 
	# чтобы цифры не вылетали строго в одну точку, если ударов много
	var random_x = randf_range(-10.0, 10.0)
	# Целевая позиция: подкидываем текст вверх и немного вбок
	var target_position = start_position + Vector2(random_x, -80.0)
	
	# Настраиваем Tween для плавной анимации
	var tween = create_tween().set_parallel(true) # Включаем параллельное выполнение анимаций
	
	# 1. Плавный взлет вверх
	tween.tween_property(self, "global_position", target_position, 3).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		
	# 2. Эффект "подпрыгивания" (в начале текст резко увеличивается, затем уменьшается)
	scale = Vector2.ZERO
	var scale_tween = create_tween()
	scale_tween.tween_property(self, "scale", Vector2(scale_mult, scale_mult), 0.15)
	scale_tween.tween_property(self, "scale", Vector2(scale_mult-0.3, scale_mult-0.3), 0.1)
	
	# 3. Плавное исчезновение (Fade out) ближе к концу анимации
	tween.tween_property(self, "modulate:a", 0.0, 1.5).set_delay(0.3)
	
	# Автоматически удаляем узел из памяти после завершения всех анимаций
	tween.chain().tween_callback(queue_free)
