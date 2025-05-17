class_name Level
extends Node2D

@export var escena_jugador: PackedScene
@export var spawner_jugador: MultiplayerSpawner
@onready var world: Level = $Level

#func _ready() -> void:
#	spawner_jugador.spawn_function = spawnear_jugador

func spawnear_jugador(authority_pid: int) -> void:
	#autorithy add here of what player model can the user manage
	spawner_jugador.spawn(authority_pid)

func _ms_jugador(authority_pid: int) -> Player:
	var jugador = escena_jugador.instantiate()
	jugador.name = str(authority_pid)
	
	return jugador


func _on_creado() -> void:
	world.spawn_player(1)
	multiplayer.peer_connected.connect(
		func(pid) -> void:
			world.spawn_player(pid)
	)
