shader_type canvas_item;

// --- Ajustes editables ---
uniform float coverage : hint_range(0.0, 1.0) = 0.5;        // 0 = nada, 1 = toda la pantalla
uniform vec4 noise_color : source_color = vec4(1.0);
uniform float noise_opacity : hint_range(0.0, 1.0) = 0.3;   // fuerza del ruido
uniform float edge_softness : hint_range(0.05, 1.0) = 0.5;  // difuminado del borde del círculo
uniform float vignette_strength : hint_range(0.0, 1.0) = 0.6; // oscurecimiento en la zona del ruido (0 = sin viñeta)
uniform float aspect_ratio = 1.0;                           // ancho/alto del rect (1.778 para 16:9 = círculo perfecto)
uniform float grain_size : hint_range(0.001, 0.05) = 0.005;
uniform float update_interval : hint_range(0.01, 0.5) = 0.163;

const float WOBBLE = 0.015;

float generate_random_static(float size, float interval, vec2 uv) {
	float time_step = mod(TIME - mod(TIME, interval), 1000.0);
	vec2 uv_step = uv - mod(uv, size);
	return fract(sin(dot(uv_step, vec2(12.0278 * sin(time_step), 15.0905))) * 43758.5453);
}

vec4 layer(vec4 front, vec4 back) {
	float a = front.a + back.a * (1.0 - front.a);
	vec3 rgb = (front.rgb * front.a + back.rgb * back.a * (1.0 - front.a)) / max(a, 0.0001);
	return vec4(rgb, a);
}

void fragment() {
	// Coordenadas polares desde el centro (corregidas por proporción de pantalla)
	vec2 pos = (UV - vec2(0.5)) * vec2(aspect_ratio, 1.0);
	float r = length(pos);
	float theta = atan(pos.y, pos.x);

	// Radio hasta la esquina: con coverage = 0 el borde queda fuera de la pantalla
	float max_r = length(vec2(0.5 * aspect_ratio, 0.5));

	// El borde del ruido avanza desde fuera de la pantalla hasta pasar el centro
	float start = mix(max_r + WOBBLE, -edge_softness - WOBBLE, coverage);
	float edge = start - WOBBLE * cos(4.0 * theta);
	float mask = smoothstep(edge, edge + edge_softness, r);

	// Ruido tintado, visible solo donde la máscara lo permite
	float n = generate_random_static(grain_size, update_interval, UV);
	vec4 noise = vec4(noise_color.rgb * n, noise_opacity * noise_color.a * mask);

	// Viñeta oscura que crece con la misma máscara
	vec4 vignette = vec4(0.0, 0.0, 0.0, vignette_strength * mask);

	COLOR = layer(noise, vignette);
}