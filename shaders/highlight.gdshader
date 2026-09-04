shader_type canvas_item;

// Этот параметр появится в инспекторе. Вы сможете выбрать любой цвет.
uniform vec4 overlay_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);

// Сила наложения: 0.0 — исходная текстура, 1.0 — полностью закрашена цветом.
uniform float mix_amount : hint_range(0.0, 1.0) = 0.5;

void fragment() {
	// Считываем цвет пикселя исходной текстуры узла
	vec4 texture_color = texture(TEXTURE, UV);
	
	// Плавно смешиваем исходный цвет текстуры с цветом наложения
	vec3 mix_color = mix(texture_color.rgb, overlay_color.rgb, mix_amount);
	
	// Выводим итоговый пиксель, сохраняя оригинальную прозрачность текстуры
	COLOR = vec4(mix_color, texture_color.a);
}