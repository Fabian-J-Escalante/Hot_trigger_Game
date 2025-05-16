class_name ConexionManager
extends Control

signal creado
signal unido

@export var enet: ENetConnectionManager

func _ready() -> void:
	enet.server_creado.connect(_wachador_host)
	enet.server_creado.connect(_wachador_usuario)

func _wachador_host() -> void:
	creado.emit()

func _wachador_usuario() -> void:
	unido.emit()
