extends Control

@onready var mundo: mundo = $Mundo

func _on_conexion_hostear() -> void:
	mundo.spawnear_jugador(1)
	
	multiplayer.peer_connected.connect(
		func(pid) -> void:
			pass
	)
