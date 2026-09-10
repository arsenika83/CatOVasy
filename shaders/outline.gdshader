shader_type canvas_item;

// Настройки, доступные из инспектора и кода
uniform vec4 outline_color : source_color = vec4(1.0, 1.0, 1.0, 1.0); // Цвет обводки
uniform float outline_thickness : hint_range(0.0, 10.0) = 1.0;       // Толщина в пикселях
uniform bool is_hovered = false;                                      // Переключатель эффекта

void fragment() {
    vec4 current_color = texture(TEXTURE, UV);
    
    // Если наведение включено и текущий пиксель прозрачный, ищем края
    if (is_hovered && current_color.a == 0.0) {
        vec2 size = TEXTURE_PIXEL_SIZE * outline_thickness;
        float alpha = 0.0;
        
        // Проверяем 4 соседних пикселя (крестом) для пиксельной точности
        alpha += texture(TEXTURE, UV + vec2(size.x, 0.0)).a;
        alpha += texture(TEXTURE, UV + vec2(-size.x, 0.0)).a;
        alpha += texture(TEXTURE, UV + vec2(0.0, size.y)).a;
        alpha += texture(TEXTURE, UV + vec2(0.0, -size.y)).a;
        
        // Если рядом есть непрозрачные пиксели персонажа — красим этот пиксель в цвет обводки
        if (alpha > 0.0) {
            COLOR = outline_color;
        } else {
            COLOR = current_color;
        }
    } else {
        COLOR = current_color;
    }
}