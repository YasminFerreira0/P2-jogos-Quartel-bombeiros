# Movimento e dano baseados nos roteiros das aulas 08 e 09, com auxílio do Codex.
extends CharacterBody2D

signal vida_alterada(vida_atual: int)
signal morreu

@export var velocidade: float = 150.0
@export var vida: int = 3
var invencivel := false
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var hurtbox: Area2D = $Hurtbox

func _physics_process(_delta: float) -> void:
	var direcao := Input.get_vector("left", "right", "up", "down")
	velocity = direcao * velocidade
	move_and_slide()
	if not invencivel and hurtbox.has_overlapping_bodies():
		levar_dano()
	if direcao == Vector2.ZERO:
		anim.stop()
		return
	if abs(direcao.x) > abs(direcao.y):
		anim.play("direita" if direcao.x > 0 else "esquerda")
	else:
		anim.play("baixo" if direcao.y > 0 else "cima")

func levar_dano() -> void:
	if invencivel or vida <= 0:
		return
	vida -= 1
	vida_alterada.emit(vida)
	if vida <= 0:
		morreu.emit()
		return
	invencivel = true
	anim.modulate.a = 0.4
	await get_tree().create_timer(1.0).timeout
	anim.modulate.a = 1.0
	invencivel = false
