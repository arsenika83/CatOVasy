shader_type canvas_item;

// =============================
// original:https://www.shadertoy.com/view/tsXBzS
//adaptation: GerardoLCDF
// =============================

uniform float u_speed = 1.0; 


uniform vec3 u_palette_color1 : source_color = vec3(0.2, 0.7, 0.9);
uniform vec3 u_palette_color2 : source_color = vec3(1.0, 0.0, 1.0);

uniform float u_glow_intensity = 30.0; 

uniform bool u_draw_background = true;
uniform vec4 u_background_color : source_color = vec4(0.08, 0.0, 0.08, 1.0); // Cambiado a púrpura oscuro para que coincida con la imagen

vec3 palette(float d){
	return mix(u_palette_color1, u_palette_color2, d);
}

vec2 rotate(vec2 p, float a){
	float c = cos(a);
    float s = sin(a);
    return p * mat2(vec2(c, -s), vec2(s, c)); 
}

float map(vec3 p){
    for( int i = 0; i < 8; ++i){
        float t = TIME * u_speed * 0.2; 
        
        p.xz = rotate(p.xz, t);
        p.xy = rotate(p.xy, t * 1.89);
        
        p.xz = abs(p.xz);
        p.xz -= 0.5;
	}
	return dot(sign(p), p) / 5.0;
}

vec4 rm (vec3 ro, vec3 rd, out bool hit){
    float t = 0.0;
    vec3 col = vec3(0.0);
    float d;
    
    hit = false;
    
    for(float i = 0.0; i < 64.0; i++){
        vec3 p = ro + rd * t;
        d = map(p) * 0.5; 

        if(d < 0.02){
            hit = true;
            break;
        }
        if(d > 100.0){
        	break;
        }
        
        col += palette(length(p) * 0.1) * u_glow_intensity / (400.0 * (d));
        
        t += d; 
    }
    
    if (hit) {
        return vec4(col, 1.0 / (d * 100.0));
    } 
    
    return vec4(0.0, 0.0, 0.0, 0.0);
}

void fragment()
{
    vec2 screen_size = 1.0 / SCREEN_PIXEL_SIZE;
    vec2 uv = (FRAGCOORD.xy - (screen_size / 2.0)) / screen_size.x;
    float current_time = TIME * u_speed;
    
    // --- Configuración de la Cámara ---
    vec3 ro = vec3(0.0, 0.0, -50.0); 
    ro.xz = rotate(ro.xz, current_time);
    
    vec3 cf = normalize(-ro);                    
    vec3 cs = normalize(cross(cf, vec3(0.0, 1.0, 0.0))); 
    vec3 cu = normalize(cross(cf, cs));          
    
    vec3 uuv = ro + cf * 3.0 + uv.x * cs + uv.y * cu;
    vec3 rd = normalize(uuv - ro);              
    
    // Ray Marching
    bool hit_object;
    vec4 col = rm(ro, rd, hit_object);
    
    // --- Lógica del Fondo ---
    if (!hit_object) {
        if (u_draw_background) {
            col = u_background_color;
        } else {
            col = vec4(0.0, 0.0, 0.0, 0.0);
        }
    }
    
    COLOR = col;
}