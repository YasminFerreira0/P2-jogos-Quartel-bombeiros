# Horda, coleta e fim de partida baseados no roteiro da aula 09, com auxílio do Codex.
extends Node2D

const CENA_CHAMA := preload("res://entities/chama.tscn")
const CENA_CHAMA_LONGA := preload("res://entities/chama_longa.tscn")
const CENA_CHAMA_FAIXA := preload("res://entities/chama_faixa.tscn")
const CENA_ITEM := preload("res://entities/item.tscn")
const META := 20
const ITENS_POR_CURA := 5
const ATLAS_EFEITOS := preload("res://sprites/atlas-efeitos.png")
const EFEITO_COLETA := Rect2(105, 925, 92, 85)
const EFEITO_AGUA := Rect2(291, 805, 135, 108)
const EFEITO_DANO := Rect2(109, 1006, 116, 91)
const MAX_ITENS := 3
const MAX_CHAMAS := 48
const EFEITO_VAPOR := Rect2(62, 533, 88, 166)
const ORIGEM_INCENDIO := Vector2(386, 1160)
# Limites dos quadros das chamas já com a escala e o deslocamento do sprite.
const VISUAL_CHAMA := Rect2(-48, -52, 96, 88)
const VISUAL_CHAMA_LONGA := Rect2(-72, -52, 144, 94)

var coletados := 0
var abates := 0
var pontos_ocupados: Dictionary = {}
var terminou := false

@onready var tamanho_arena: Vector2 = Vector2($chao.get_used_rect().size * $chao.tile_set.tile_size)
@onready var jogador: CharacterBody2D = $Bombeiro
@onready var pontos_itens: Node2D = $PontosItens
@onready var timer_horda: Timer = $TimerHorda
@onready var hud: CanvasLayer = $HUD
var tipos_restantes: Array[int] = []
var areas_visuais_protegidas: Array[Rect2] = []

func _ready() -> void:
	hud.configurar_vida(jogador.VIDA_MAXIMA)
	jogador.vida_alterada.connect(hud.atualizar_vida)
	jogador.sofreu_dano.connect(_mostrar_dano)
	jogador.jato_disparado.connect(_mostrar_jato)
	hud.reiniciar.connect(_reiniciar)
	jogador.morreu.connect(perder)
	hud.atualizar_vida(jogador.vida)
	_atualizar_itens()
	_atualizar_abates()
	_registrar_areas_visuais()
	_criar_item(pontos_itens.get_node("Tutorial"))
	call_deferred("_iniciar_incendio")

func _mostrar_dano() -> void:
	_efeito(jogador.global_position, EFEITO_DANO, 0.42)

func _atualizar_itens() -> void:
	hud.atualizar_itens(coletados, META)

func _atualizar_abates() -> void:
	hud.atualizar_chamas(abates)

func _ao_apagar_chama(chama: Node2D) -> void:
	_efeito(chama.global_position, EFEITO_VAPOR, 0.5, 0.55)
	abates += 1
	_atualizar_abates()

func _registrar_areas_visuais() -> void:
	var sprites := $Cenario.find_children("*", "Sprite2D")
	sprites.append($PredioQuartel)
	for no in sprites:
		var sprite := no as Sprite2D
		if sprite.is_visible_in_tree() and sprite.texture != null:
			var area: Rect2 = sprite.global_transform * sprite.get_rect()
			areas_visuais_protegidas.append(area.grow(3.0))

# Os primeiros focos ficam no chão perto do quartel.
func _iniciar_incendio() -> void:
	if _local_livre(Vector2(740, 1135), true):
		_criar_chama(Vector2(740, 1135), true, true)
	if _local_livre(Vector2(245, 1190), true):
		_criar_chama(Vector2(245, 1190), true)
	if _local_livre(Vector2(535, 1170)):
		_criar_chama(Vector2(535, 1170))

func _spawn_chama() -> void:
	if terminou or $Inimigos.get_child_count() >= MAX_CHAMAS:
		return
	var existentes := $Inimigos.get_children()
	var longa := randf() < 0.30
	for tentativa in range(16):
		var posicao: Vector2
		# Algumas chamas surgem adiante de quem está andando.
		if jogador.velocity.length() > 1.0 and randf() < 0.35:
			var direcao := jogador.velocity.normalized().rotated(randf_range(-0.65, 0.65))
			posicao = jogador.global_position + direcao * randf_range(175.0, 280.0)
		else:
			var origem := ORIGEM_INCENDIO
			if not existentes.is_empty():
				var chama_origem: Node2D = existentes.pick_random()
				origem = chama_origem.global_position
			posicao = origem + Vector2.RIGHT.rotated(randf_range(0.0, TAU)) * randf_range(90.0, 210.0)
		if _local_livre(posicao, longa):
			_criar_chama(posicao, longa)
			break
	timer_horda.wait_time = maxf(1.05, timer_horda.wait_time * 0.97)

func _local_livre(posicao: Vector2, longa: bool = false) -> bool:
	var margem_x := 110.0 if longa else 70.0
	if posicao.x < margem_x or posicao.x > tamanho_arena.x - margem_x or posicao.y < 65 or posicao.y > tamanho_arena.y - 65.0:
		return false
	if posicao.distance_to(jogador.global_position) < (140.0 if longa else 120.0):
		return false
	for item in $Coletaveis.get_children():
		if not item.is_queued_for_deletion() and posicao.distance_to(item.global_position) < (120.0 if longa else 75.0):
			return false
	# A colisão da árvore fica no tronco. A copa também precisa ficar livre de fogo.
	var visual := VISUAL_CHAMA_LONGA if longa else VISUAL_CHAMA
	visual.position += posicao
	for area in areas_visuais_protegidas:
		if visual.intersects(area):
			return false
	var forma := RectangleShape2D.new()
	forma.size = Vector2(145, 72) if longa else Vector2(60, 60)
	var consulta := PhysicsShapeQueryParameters2D.new()
	consulta.shape = forma
	consulta.transform = Transform2D(0, posicao)
	consulta.collision_mask = 1 | 4
	return get_world_2d().direct_space_state.intersect_shape(consulta, 1).is_empty()

func _criar_chama(posicao: Vector2, longa: bool = false, faixa: bool = false) -> void:
	var cena := CENA_CHAMA
	if longa:
		cena = CENA_CHAMA_FAIXA if faixa or randf() < 0.5 else CENA_CHAMA_LONGA
	var chama := cena.instantiate() as CharacterBody2D
	chama.apagada.connect(_ao_apagar_chama.bind(chama))
	chama.position = posicao
	$Inimigos.add_child(chama)

func _spawn_item() -> void:
	if terminou or pontos_ocupados.size() >= MAX_ITENS:
		return
	var livres: Array[Node] = []
	for ponto in pontos_itens.get_children():
		if pontos_ocupados.has(ponto):
			continue
		var livre := true
		for chama in $Inimigos.get_children():
			if not chama.is_queued_for_deletion() and ponto.global_position.distance_to(chama.global_position) < (120.0 if chama.is_in_group("chama_longa") else 75.0):
				livre = false
				break
		if livre:
			livres.append(ponto)
	if livres.is_empty():
		return
	_criar_item(livres.pick_random())

func _criar_item(ponto: Node2D) -> void:
	var item := CENA_ITEM.instantiate() as Area2D
	if tipos_restantes.is_empty():
		for tipo in range(item.ICONES.size()):
			tipos_restantes.append(tipo)
		tipos_restantes.shuffle()
	item.tipo = tipos_restantes.pop_back()
	item.position = ponto.position
	pontos_ocupados[ponto] = item
	item.coletado.connect(_ao_coletar.bind(ponto))
	$Coletaveis.add_child(item)

func _ao_coletar(item: Area2D, ponto: Node2D) -> void:
	if terminou:
		return
	pontos_ocupados.erase(ponto)
	_efeito(item.global_position, EFEITO_COLETA, 0.54)
	coletados += 1
	_atualizar_itens()
	if coletados >= META:
		vencer()
	elif coletados % ITENS_POR_CURA == 0:
		jogador.recuperar_vida()

func vencer() -> void:
	_encerrar(true)

func perder() -> void:
	_encerrar(false)

func _encerrar(venceu: bool) -> void:
	if terminou:
		return
	terminou = true
	hud.mostrar_resultado(venceu, coletados, META, abates)
	get_tree().paused = true

func _reiniciar() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()

func _mostrar_jato(posicao: Vector2) -> void:
	_efeito(posicao, EFEITO_AGUA, 0.78)

func _efeito(posicao: Vector2, regiao: Rect2, escala: float, duracao: float = 0.32) -> void:
	var sprite := Sprite2D.new()
	sprite.texture = ATLAS_EFEITOS
	sprite.region_enabled = true
	sprite.region_rect = regiao
	sprite.region_filter_clip_enabled = true
	sprite.z_index = 3
	sprite.position = posicao
	sprite.scale = Vector2.ONE * escala
	add_child(sprite)
	var animacao := sprite.create_tween().set_parallel()
	animacao.tween_property(sprite, "position:y", posicao.y - 24.0, duracao)
	animacao.tween_property(sprite, "modulate:a", 0.0, duracao)
	animacao.chain().tween_callback(sprite.queue_free)
