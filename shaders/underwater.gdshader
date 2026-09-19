shader_type canvas_item;

// Считываем текущую текстуру экрана
uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;

// Настройки воды в инспекторе
uniform vec4 water_color : source_color = vec4(0.0, 0.4, 0.6, 0.15); // Оттенок воды и его плотность
uniform float wave_speed : hint_range(0.0, 10.0) = 2.0;              // Скорость течения волн
uniform float wave_frequency : hint_range(0.0, 50.0) = 15.0;         // Частота/количество волн
uniform float wave_amplitude : hint_range(0.0, 0.1) = 0.005;          // Сила искажения (не ставьте много!)

void fragment() {
    // 1. Создаем волновое смещение по осям X и Y на основе времени
    vec2 wave_offset;
    wave_offset.x = sin(SCREEN_UV.y * wave_frequency + TIME * wave_speed) * wave_amplitude;
    wave_offset.y = cos(SCREEN_UV.x * wave_frequency + TIME * wave_speed) * wave_amplitude;
    
    // 2. Берем пиксель с экрана с учетом волнового сдвига
    vec4 scene_color = texture(screen_texture, SCREEN_UV + wave_offset);
    
    // 3. Накладываем цвет воды поверх искаженной картинки
    vec3 final_rgb = mix(scene_color.rgb, water_color.rgb, water_color.a);
    
    COLOR = vec4(final_rgb, scene_color.a);
}