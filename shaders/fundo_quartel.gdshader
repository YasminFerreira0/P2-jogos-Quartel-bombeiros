// Transparência do fundo do atlas criada com auxílio do Codex (OpenAI).
shader_type canvas_item;

void fragment() {
	vec4 cor = texture(TEXTURE, UV);
	// O fundo do atlas é cinza-azulado, próximo de RGB (22, 24, 29).
	vec3 fundo = vec3(22.0, 24.0, 29.0) / 255.0;
	float distancia = distance(cor.rgb, fundo);
	// Restringe a remoção aos cantos superiores e às margens do recorte.
	vec2 pixel_atlas = UV * vec2(textureSize(TEXTURE, 0));
	vec2 local = (pixel_atlas - vec2(20.0, 780.0)) / vec2(395.0, 310.0);
	bool margem = local.x < 0.12 || local.x > 0.88 || local.y < 0.025 || local.y > 0.985;
	if (margem) {
		cor.a *= smoothstep(0.025, 0.065, distancia);
	}
	COLOR = cor;
}
