shader_type canvas_item;

// Переменные для настройки прямо из Инспектора
uniform float speed : hint_range(0.0, 10.0) = 2.0;       // Скорость покачивания
uniform float amplitude : hint_range(0.0, 200.0) = 20.0; // Высота полета (в пикселях)
uniform float time_offset : hint_range(0.0, 10.0) = 0.0;

uniform float flash_intensity : hint_range(0.0, 1.0) = 0.0;

void vertex() {
    // Добавляем time_offset внутрь синуса, чтобы сдвинуть фазу времени
    VERTEX.y += sin((TIME * speed) + time_offset) * amplitude;
}

void fragment() {
    vec4 color = texture(TEXTURE, UV);
    // Смешиваем обычный цвет текстуры с белым цветом в зависимости от flash_inten
    COLOR = vec4(mix(color.rgb, vec3(253, 78, 81), flash_intensity * 0.3), color.a);
}