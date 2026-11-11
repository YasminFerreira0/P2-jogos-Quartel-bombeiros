# Navegação e dano baseados no roteiro da aula 10, com auxílio do Codex.
extends CharacterBody2D

signal apagada
@export var velocidade := 85.0
@export var vida := 1
@onready var agente: NavigationAgent2D = $NavigationAgent2D

func _physics_process(_delta: float) -> void:
	var jogador := get_tree().get_first_node_in_group("player") as Node2D
	if jogador == null:
		return
	agente.target_position = jogador.global_position
	if agente.is_navigation_finished():
		velocity = Vector2.ZERO
	else:
		velocity = global_position.direction_to(agente.get_next_path_position()) * velocidade
	move_and_slide()

func levar_golpe() -> void:
	if vida <= 0:
		return
	vida -= 1
	if vida <= 0:
		apagada.emit()
		queue_free()
