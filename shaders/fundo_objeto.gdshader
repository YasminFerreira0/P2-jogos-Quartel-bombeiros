// Recorte de fundo do atlas de cenário, com auxílio do Codex.
shader_type canvas_item;

void fragment() {
	vec4 cor = COLOR;
	vec3 fundo = vec3(22.0, 24.0, 29.0) / 255.0;
	cor.a *= smoothstep(0.029, 0.065, distance(cor.rgb, fundo));
	COLOR = cor;
}
