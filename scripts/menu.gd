extends Control

@export var arena: PackedScene
@onready var botao: Button = $Centro/Cartao/Conteudo/Jogar

func _ready() -> void:
	botao.grab_focus()

func _jogar() -> void:
	botao.disabled = true
	var erro := get_tree().change_scene_to_packed(arena)
	if erro != OK:
		botao.disabled = false
		$Centro/Cartao/Conteudo/Erro.show()
