extends Node2D
class_name mundo

@export var jugador_escena: PackedScene
@export var jugador_spawner: MultiplayerSpawner

func _ready() -> void:
	jugador_spawner.spawn_function = _multijugador_spawner

func spawnear_jugador(authority_pid: int) -> void:
	jugador_spawner.spawn(authority_pid)

func _multijugador_spawner(authority_pid: int) -> Player:
	var jugador = jugador_escena.instantiate()
	jugador.name = str(authority_pid)
	
	return jugador
