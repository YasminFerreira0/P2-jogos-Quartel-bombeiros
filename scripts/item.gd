# Coleta ao tocar o jogador baseada no roteiro da aula 09, com auxílio do Codex.
extends Area2D
signal coletado(item: Area2D)
const ATLAS := preload("res://sprites/grade-icones.png")
const ICONES := [
	Rect2(28, 130, 234, 208), Rect2(290, 55, 180, 295),
	Rect2(740, 119, 249, 237), Rect2(992, 132, 249, 198),
	Rect2(40, 372, 246, 272), Rect2(550, 370, 145, 280),
	Rect2(748, 373, 231, 286), Rect2(1010, 411, 219, 240),
	Rect2(265, 696, 206, 221), Rect2(1012, 955, 216, 240),
]
var tipo := 0
var recolhido := false

func _ready() -> void:
	var recorte := AtlasTexture.new()
	recorte.atlas = ATLAS
	recorte.region = ICONES[tipo]
	recorte.filter_clip = true
	$Icone.texture = recorte
	$Icone.scale = Vector2.ONE * (36.0 / maxf(recorte.region.size.x, recorte.region.size.y))
	var flutuar := create_tween().set_loops().set_trans(Tween.TRANS_SINE)
	flutuar.tween_property($Icone, "position:y", -7.0, 0.75)
	flutuar.tween_property($Icone, "position:y", 0.0, 0.75)


func _on_body_entered(body: Node2D) -> void:
	if recolhido or not body.is_in_group("player"):
		return
	recolhido = true
	set_deferred("monitoring", false)
	coletado.emit(self)
	queue_free()
