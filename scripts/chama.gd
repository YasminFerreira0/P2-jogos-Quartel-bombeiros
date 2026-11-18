# Foco de fogo da arena; implementação com auxílio do Codex (OpenAI).
extends CharacterBody2D

signal apagada
const MATERIAL_BRASAS := preload("res://effects/brasas.tres")
@export var vida := 1

func _ready() -> void:
	$Fogo.play("queimando")
	# Desencontrar levemente as chamas evita que todas pisquem juntas.
	$Fogo.frame = randi() % $Fogo.sprite_frames.get_frame_count("queimando")

	var luz: PointLight2D = $LuzFogo
	var energia := luz.energy
	var ritmo := randf_range(0.22, 0.42)
	var pulsar := luz.create_tween().set_loops().set_trans(Tween.TRANS_SINE)
	pulsar.tween_property(luz, "energy", energia * 0.88, ritmo)
	pulsar.tween_property(luz, "energy", energia * 1.03, ritmo * 1.4)

	var brasas := CPUParticles2D.new()
	brasas.position = Vector2(0, -12)
	brasas.amount = 8 if is_in_group("chama_longa") else 5
	brasas.lifetime = 0.83
	brasas.randomness = 0.55
	brasas.direction = Vector2.UP
	brasas.spread = 23.0
	brasas.gravity = Vector2(4, -22)
	brasas.initial_velocity_min = 24.0
	brasas.initial_velocity_max = 49.0
	brasas.scale_amount_min = 1.5
	brasas.scale_amount_max = 3.0
	brasas.emission_shape = CPUParticles2D.EMISSION_SHAPE_RECTANGLE
	brasas.emission_rect_extents = Vector2(40 if is_in_group("chama_longa") else 15, 5)
	brasas.material = MATERIAL_BRASAS
	brasas.color_ramp = Gradient.new()
	brasas.color_ramp.colors = PackedColorArray([Color("#ffbd64"), Color(1, 0.22, 0.06, 0)])
	add_child(brasas)

func levar_golpe() -> void:
	if vida <= 0:
		return
	vida -= 1
	if vida > 0:
		# O brilho indica que a chama maior foi atingida, mas ainda não apagou.
		$Fogo.modulate = Color(0.55, 0.8, 1.0)
		var efeito := create_tween()
		efeito.tween_property($Fogo, "modulate", Color.WHITE, 0.18)
	if vida <= 0:
		apagada.emit()
		queue_free()
