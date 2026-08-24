shader_type canvas_item;

// Переменные для настройки прямо из Инспектора
uniform float speed : hint_range(0.0, 10.0) = 2.0;       // Скорость покачивания
uniform float amplitude : hint_range(0.0, 200.0) = 20.0; // Высота полета (в пикселях)
uniform float time_offset : hint_range(0.0, 10.0) = 0.0;

void vertex() {
    // Добавляем time_offset внутрь синуса, чтобы сдвинуть фазу времени
    VERTEX.y += sin((TIME * speed) + time_offset) * amplitude;
}