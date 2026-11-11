# Horda, coleta e fim de partida baseados no roteiro da aula 09, com auxílio do Codex.
extends Node2D

const CENA_CHAMA := preload("res://entities/chama.tscn")
const CENA_ITEM := preload("res://entities/item.tscn")
const META := 20
const MAX_ITENS := 3
var coletados := 0
var abates := 0
var pontos_ocupados: Dictionary = {}
var terminou := false

@onready var jogador: CharacterBody2D = $Bombeiro
@onready var pontos_itens: Node2D = $PontosItens
@onready var nascedouros: Node2D = $Nascedouros
@onready var timer_horda: Timer = $TimerHorda
@onready var texto_vida: Label = $HUD/Painel/Conteudo/Vida
@onready var texto_abates: Label = $HUD/Painel/Conteudo/Abates
@onready var texto_itens: Label = $HUD/Painel/Conteudo/Itens
@onready var fim: Control = $HUD/Fim
@onready var texto_fim: Label = $HUD/Fim/Caixa/Texto

func _ready() -> void:
	jogador.vida_alterada.connect(_atualizar_vida)
	jogador.morreu.connect(perder)
	_atualizar_vida(jogador.vida)
	_atualizar_itens()
	_atualizar_abates()
	_spawn_item()

func _atualizar_vida(vida: int) -> void:
	texto_vida.text = "Vida: %d" % vida

func _atualizar_itens() -> void:
	texto_itens.text = "Itens: %d / %d" % [coletados, META]

func _atualizar_abates() -> void:
	texto_abates.text = "Chamas apagadas: %d" % abates

func _ao_apagar_chama() -> void:
	abates += 1
	_atualizar_abates()

func _spawn_chama() -> void:
	if terminou:
		return
	var pontos := nascedouros.get_children()
	var ponto: Node2D = pontos.pick_random()
	var chama := CENA_CHAMA.instantiate() as CharacterBody2D
	chama.apagada.connect(_ao_apagar_chama)
	chama.position = ponto.position
	$Inimigos.add_child(chama)
	timer_horda.wait_time = maxf(0.7, timer_horda.wait_time * 0.96)

func _spawn_item() -> void:
	if terminou or pontos_ocupados.size() >= MAX_ITENS:
		return
	var livres: Array[Node] = []
	for ponto in pontos_itens.get_children():
		if not pontos_ocupados.has(ponto):
			livres.append(ponto)
	if livres.is_empty():
		return
	var ponto: Node2D = livres.pick_random()
	var item := CENA_ITEM.instantiate() as Area2D
	item.position = ponto.position
	pontos_ocupados[ponto] = item
	item.coletado.connect(_ao_coletar.bind(ponto))
	$Coletaveis.add_child(item)

func _ao_coletar(_item: Area2D, ponto: Node2D) -> void:
	if terminou:
		return
	pontos_ocupados.erase(ponto)
	coletados += 1
	_atualizar_itens()
	if coletados >= META:
		vencer()

func vencer() -> void:
	_encerrar("Você venceu!\nColetou os 20 equipamentos.")

func perder() -> void:
	_encerrar("Você perdeu!\nAs chamas alcançaram o bombeiro.")

func _encerrar(mensagem: String) -> void:
	if terminou:
		return
	terminou = true
	texto_fim.text = mensagem
	fim.show()
	get_tree().paused = true

func _reiniciar() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()
