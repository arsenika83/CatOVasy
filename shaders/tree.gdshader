shader_type canvas_item;
// Настройки ветра
uniform float speed : hint_range(0.0, 10.0) = 2.0;       // Скорость покачивания
uniform float min_strength : hint_range(0.0, 5.0) = 0.05; // Минимальное смещение
uniform float max_strength : hint_range(0.0, 5.0) = 0.2;  // Максимальный порыв ветра
uniform float wind_decay : hint_range(0.0, 1.0) = 0.1;    // Влияние высоты (0.0 - гнется все, 1.0 - только верхушка)

void vertex() {
	// UV.y идет от 0.0 (верх текстуры) до 1.0 (низ текстуры).
	// Инвертируем, чтобы получить маску высоты: 1.0 вверху, 0.0 у корня дерева.
	float height_mask = 1.0 - UV.y;
	
	// Ограничиваем маску, чтобы нижняя часть ствола вообще не двигалась
	height_mask = smoothstep(wind_decay, 1.0, height_mask);
	
	// Создаем сложную волну синуса времени для имитации случайных порывов ветра
	float time = TIME * speed;
	float wave = sin(time) + sin(time * 0.5) * 0.3 + sin(time * 2.0) * 0.1;
	
	// Рассчитываем силу смещения на основе маски высоты
	float current_strength = mix(min_strength, max_strength, (wave + 1.0) * 0.5);
	
	// Сдвигаем вершины по оси X (вправо-влево)
	VERTEX.x += wave * current_strength * height_mask * 100.0;
}