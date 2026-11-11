# Movimento e dano baseados nos roteiros das aulas 08 e 09, com auxílio do Codex.
extends CharacterBody2D

signal vida_alterada(vida_atual: int)
signal morreu

@export var velocidade: float = 150.0
@export var vida: int = 3
var invencivel := false
var pode_atacar := true
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var hurtbox: Area2D = $Hurtbox
@onready var area_ataque: Area2D = $Ataque
@onready var efeito_ataque: Polygon2D = $Ataque/Efeito

func _physics_process(_delta: float) -> void:
	var direcao := Input.get_vector("left", "right", "up", "down")
	velocity = direcao * velocidade
	move_and_slide()
	if not invencivel and hurtbox.has_overlapping_bodies():
		levar_dano()
	if pode_atacar and Input.is_action_just_pressed("atacar"):
		atacar()
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

# Ataque da aula 10: atinge as chamas próximas e tem intervalo de 0,4 segundo.
func atacar() -> void:
	if not pode_atacar or vida <= 0:
		return
	pode_atacar = false
	for inimigo in area_ataque.get_overlapping_bodies():
		if inimigo.is_in_group("inimigo") and inimigo.has_method("levar_golpe"):
			inimigo.levar_golpe()
	efeito_ataque.show()
	await get_tree().create_timer(0.1).timeout
	efeito_ataque.hide()
	await get_tree().create_timer(0.3).timeout
	pode_atacar = true
