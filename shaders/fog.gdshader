shader_type canvas_item;

// Настройки тумана в инспекторе
uniform vec4 fog_color : source_color = vec4(0.5, 0.6, 0.7, 0.3); // Цвет и прозрачность
uniform float speed : hint_range(0.0, 1.0) = 0.05;                // Скорость движения
uniform float density : hint_range(0.1, 5.0) = 1.0;              // Плотность шума
uniform float alpha : hint_range(0.0, 1.0) = 0.0;    

// Простая функция генерации шума (генерация псевдослучайных плавных волн)
float noise(vec2 uv) {
    return fract(sin(dot(uv, vec2(127.1, 311.7))) * 43758.5453123);
}

float smooth_noise(vec2 uv) {
    vec2 lv = fract(uv);
    vec2 id = floor(uv);
    lv = lv * lv * (3.0 - 2.0 * lv);
    
    float bl = noise(id);
    float br = noise(id + vec2(1.0, 0.0));
    float tl = noise(id + vec2(0.0, 1.0));
    float tr = noise(id + vec2(1.0, 1.0));
    
    float b = mix(bl, br, lv.x);
    float t = mix(tl, tr, lv.x);
    return mix(b, t, lv.y);
}

void fragment() {
    // Двигаем текстурные координаты со временем
    vec2 moving_uv = UV * density + vec2(TIME * speed, TIME * speed * 0.2);
    
    // Создаем многослойный шум (fbm) для мягкого эффекта дыма
    float n = smooth_noise(moving_uv);
    n += smooth_noise(moving_uv * 2.0) * 0.5;
    n += smooth_noise(moving_uv * 4.0) * 0.25;
    n /= 1.75;
    
    // Применяем цвет и прозрачность на основе шума
    vec4 final_color = fog_color;
	final_color.a = alpha;
    final_color.a *= n;
    
    COLOR = final_color;
}