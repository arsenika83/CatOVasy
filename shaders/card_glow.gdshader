shader_type canvas_item;

// Настройки сияния в Инспекторе
uniform vec4 glow_color : source_color = vec4(0.2, 0.6, 1.0, 1.0); // Цвет сияния
uniform float glow_intensity : hint_range(0.0, 5.0) = 2.0;         // Базовая яркость
uniform float glow_size : hint_range(0.0, 20.0) = 5.0;            // Толщина/радиус ауры
uniform float pulse_speed : hint_range(0.0, 10.0) = 2.5;          // Скорость пульсации
uniform bool is_active = true;                                    // Вкл/Выкл эффект

void fragment() {
    vec4 texture_color = texture(TEXTURE, UV);
    
    if (is_active) {
        // Создаем эффект пульсации от времени
        float pulse = sin(TIME * pulse_speed) * 0.3 + 0.7; // колеблется от 0.4 до 1.0
        vec2 size = TEXTURE_PIXEL_SIZE * glow_size * pulse;
        
        float alpha_sum = 0.0;
        
        // Размытие по сетке для получения мягкой ауры (считываем альфа-канал соседей)
        for (float x = -2.0; x <= 2.0; x += 1.0) {
            for (float y = -2.0; y <= 2.0; y += 1.0) {
                vec2 offset = vec2(x, y) * size;
                alpha_sum += texture(TEXTURE, UV + offset).a;
            }
        }
        
        // Усредняем полученную прозрачность
        float aura_alpha = alpha_sum / 25.0;
        
        // Убираем свечение там, где уже есть сама карта, чтобы не портить рисунок
        aura_alpha = max(0.0, aura_alpha - texture_color.a);
        
        // Смешиваем цвет карты и цвет сияния
        vec4 glow = glow_color * aura_alpha * glow_intensity;
        COLOR = texture_color + glow;
    } else {
        COLOR = texture_color;
    }
}