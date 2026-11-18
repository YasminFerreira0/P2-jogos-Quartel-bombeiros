# Interface de partida com recortes do atlas do HUD, com auxílio do Codex.
extends CanvasLayer

signal reiniciar

const ATLAS := preload("res://sprites/hud.png")
const COR_AZUL := Color("#6dd9ff")
const COR_VIDA := Color("#ff6267")
const COR_DOURADA := Color("#ffce7b")
const COR_TEXTO := Color("#adbed5")

var linha_vida: HBoxContainer
var coracoes: Array[TextureRect] = []
var barra: ProgressBar
var progresso: Label
var chamas: Label
var retorno_vida: ColorRect
var fim: ColorRect
var titulo: Label
var descricao: Label
var resultado: Label
var icone_resultado: TextureRect
var botao: Button
var flash: Tween
var vida_anterior := -1

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	var painel := _painel(COR_AZUL)
	painel.position = Vector2(22, 22)
	add_child(painel)
	var coluna := _coluna(painel, 8)
	_rotulo(coluna, "QUARTEL EM CHAMAS", 20, COR_DOURADA)
	linha_vida = HBoxContainer.new()
	linha_vida.add_theme_constant_override("separation", 8)
	coluna.add_child(linha_vida)
	_rotulo(linha_vida, "VIDA", 15, COR_TEXTO)
	progresso = _rotulo(coluna, "", 20, COR_AZUL)
	barra = ProgressBar.new()
	barra.show_percentage = false
	barra.custom_minimum_size = Vector2(248, 8)
	barra.add_theme_stylebox_override("background", _estilo(Color("#23354c"), Color("#23354c"), 0))
	barra.add_theme_stylebox_override("fill", _estilo(COR_AZUL, COR_AZUL, 0))
	coluna.add_child(barra)
	chamas = _rotulo(coluna, "", 16, COR_DOURADA)
	_rotulo(coluna, "WASD / setas · Espaço para apagar", 14, COR_TEXTO)

	retorno_vida = ColorRect.new()
	retorno_vida.color = Color(0.9, 0.06, 0.08, 0.0)
	retorno_vida.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(retorno_vida)
	retorno_vida.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

	fim = ColorRect.new()
	fim.color = Color(0.025, 0.04, 0.07, 0.85)
	add_child(fim)
	fim.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var centro := CenterContainer.new()
	fim.add_child(centro)
	centro.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var cartao := _painel(COR_AZUL)
	cartao.custom_minimum_size.x = 420
	centro.add_child(cartao)
	var final_coluna := _coluna(cartao, 13)
	icone_resultado = _icone(final_coluna, Rect2(840, 226, 198, 136), 76)
	titulo = _rotulo(final_coluna, "", 36, COR_AZUL)
	descricao = _rotulo(final_coluna, "", 19, Color.WHITE)
	resultado = _rotulo(final_coluna, "", 17, COR_TEXTO)
	for rotulo in [titulo, descricao, resultado]:
		rotulo.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	botao = Button.new()
	botao.add_theme_font_size_override("font_size", 19)
	botao.custom_minimum_size.y = 46
	botao.pressed.connect(func() -> void: reiniciar.emit())
	final_coluna.add_child(botao)
	fim.hide()

func configurar_vida(maximo: int) -> void:
	for i in range(maximo):
		coracoes.append(_icone(linha_vida, Rect2(58, 204, 89, 90), 25))

func atualizar_vida(vida: int) -> void:
	for i in range(coracoes.size()):
		coracoes[i].modulate = Color.WHITE if i < vida else Color(0.34, 0.37, 0.45, 0.68)
	if vida_anterior >= 0 and vida != vida_anterior:
		if flash:
			flash.kill()
		if vida > vida_anterior:
			retorno_vida.color = Color(0.16, 0.93, 0.48, 0.20)
		else:
			retorno_vida.color = Color(0.9, 0.06, 0.08, 0.35)
		flash = create_tween()
		flash.tween_property(retorno_vida, "color:a", 0.0, 0.42)
	vida_anterior = vida

func atualizar_itens(total: int, meta: int) -> void:
	progresso.text = "EQUIPAMENTOS   %02d / %02d" % [total, meta]
	barra.max_value = meta
	barra.value = total

func atualizar_chamas(total: int) -> void:
	chamas.text = "Focos apagados   %02d" % total

func mostrar_resultado(venceu: bool, itens: int, meta: int, focos: int) -> void:
	var destaque := Color("#83edaf") if venceu else COR_VIDA
	titulo.text = "Missão cumprida" if venceu else "Missão interrompida"
	titulo.modulate = destaque
	descricao.text = "Todos os equipamentos foram recuperados." if venceu else "O bombeiro ficou sem vida."
	resultado.text = "%d / %d equipamentos   ·   %d focos apagados" % [itens, meta, focos]
	icone_resultado.texture = _recorte(Rect2(59, 432, 100, 122) if venceu else Rect2(840, 226, 198, 136))
	botao.text = "Jogar novamente" if venceu else "Tentar novamente"
	botao.add_theme_stylebox_override("normal", _estilo(destaque.darkened(0.66), destaque, 5))
	botao.add_theme_stylebox_override("hover", _estilo(destaque.darkened(0.48), destaque, 5))
	fim.show()
	botao.grab_focus()

func _estilo(fundo: Color, borda: Color, raio: int) -> StyleBoxFlat:
	var estilo := StyleBoxFlat.new()
	estilo.bg_color = fundo
	estilo.border_color = borda
	estilo.set_border_width_all(1)
	estilo.set_corner_radius_all(raio)
	return estilo

func _painel(borda: Color) -> PanelContainer:
	var painel := PanelContainer.new()
	painel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var estilo := _estilo(Color(0.04, 0.075, 0.13, 0.95), borda.darkened(0.38), 9)
	for lado in [SIDE_LEFT, SIDE_TOP, SIDE_RIGHT, SIDE_BOTTOM]:
		estilo.set_content_margin(lado, 16)
	painel.add_theme_stylebox_override("panel", estilo)
	return painel

func _coluna(pai: Control, separacao: int) -> VBoxContainer:
	var coluna := VBoxContainer.new()
	coluna.add_theme_constant_override("separation", separacao)
	pai.add_child(coluna)
	return coluna

func _rotulo(pai: Control, texto: String, tamanho: int, cor: Color) -> Label:
	var rotulo := Label.new()
	rotulo.text = texto
	rotulo.add_theme_font_size_override("font_size", tamanho)
	rotulo.add_theme_color_override("font_color", cor)
	pai.add_child(rotulo)
	return rotulo

func _icone(pai: Control, regiao: Rect2, tamanho: float) -> TextureRect:
	var icone := TextureRect.new()
	icone.texture = _recorte(regiao)
	icone.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icone.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	icone.custom_minimum_size = Vector2.ONE * tamanho
	icone.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	pai.add_child(icone)
	return icone

func _recorte(regiao: Rect2) -> AtlasTexture:
	var textura := AtlasTexture.new()
	textura.atlas = ATLAS
	textura.region = regiao
	textura.filter_clip = true
	return textura
