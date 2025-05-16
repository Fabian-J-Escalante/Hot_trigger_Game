class_name ConnectionManager
extends Control

signal hostear
signal unirse

@export var enet: ENetConnectionManager

func _ready() -> void:
	enet.server_creado.connect(_hostear_handle)
	enet.server_creado.connect(_unirse_handle)

func _hostear_handle() -> void:
	hostear.emit()
	
func _unirse_handle() -> void:
	unirse.emit()
