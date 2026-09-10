shader_type canvas_item;

uniform float rotation_speed : hint_range(-10.0, 10.0) = 1.0; // Скорость (отрицательная — в другую сторону)

void fragment() {
    // 1. Сдвигаем центр координат в середину текстуры (0.5, 0.5)
    vec2 uv = UV - 0.5;
    
    // 2. Вычисляем текущий угол на основе времени и скорости
    float angle = TIME * rotation_speed;
    
    // 3. Матрица поворота
    float sin_a = sin(angle);
    float cos_a = cos(angle);
    mat2 rotation_matrix = mat2(vec2(cos_a, -sin_a), vec2(sin_a, cos_a));
    
    // 4. Поворачиваем координаты и возвращаем центр на место
    uv = rotation_matrix * uv;
    uv += 0.5;
    
    // 5. Отрезаем пиксели, которые вышли за границы текстуры (чтобы не было эффекта "повторения")
    if (uv.x < 0.0 || uv.x > 1.0 || uv.y < 0.0 || uv.y > 1.0) {
        discard; // Делает пиксель полностью прозрачным
    }
    
    // 6. Выводим повернутую текстуру
    COLOR = texture(TEXTURE, uv);
}