# Coleta ao tocar o jogador baseada no roteiro da aula 09, com auxílio do Codex.
extends Area2D
signal coletado(item: Area2D)
var recolhido := false

func _on_body_entered(body: Node2D) -> void:
	if recolhido or not body.is_in_group("player"):
		return
	recolhido = true
	set_deferred("monitoring", false)
	coletado.emit(self)
	queue_free()
