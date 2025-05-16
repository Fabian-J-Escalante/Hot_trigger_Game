extends Node

const ESCENA_PRINCIPAL = preload("res://Scenes/Main/Main.tscn")
const ESCENA_NIVEL = preload("res://Scenes/Level/Level.tscn")

func cargar_escena_principal() -> void:
	get_tree().change_scene_to_packed(ESCENA_PRINCIPAL)

func cargar_escena_nivel() -> void:
	get_tree().change_scene_to_packed(ESCENA_NIVEL)
