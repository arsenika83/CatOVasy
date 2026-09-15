shader_type canvas_item;

// Настройки в инспекторе
uniform vec4 tint_color : source_color = vec4(1.0, 1.0, 1.0, 1.0); // Цвет наложения
uniform float tint_amount : hint_range(0.0, 1.0) = 0.5;            // Сила наложения (0.0 - нет эффекта, 1.0 - полностью закрашен)
uniform bool is_hovered = false;                                    // Переключатель

void fragment() {
    // Получаем исходный цвет пикселя спрайта
    vec4 texture_color = texture(TEXTURE, UV);
    
    if (is_hovered) {
        // Плавно смешиваем исходный RGB-цвет с цветом наложения
        vec3 mixed_rgb = mix(texture_color.rgb, tint_color.rgb, tint_amount);
        
        // Выводим результат, обязательно сохраняя оригинальную прозрачность спрайта
        COLOR = vec4(mixed_rgb, texture_color.a);
    } else {
       // COLOR = texture_color;
    }
}