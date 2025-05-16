extends Node
class_name MultiplayerSpawner

# PackedScene exportada desde el editor
@export var player_scene: PackedScene

func spawn_function(authority_id: int) -> void:
	var jugador = player_scene.instantiate()
	jugador.name = str(authority_id)
	jugador.set_multiplayer_authority(authority_id)
	add_child(jugador)

func _ready() -> void:
	# Cuando se conecte un peer, ejecuta spawn_function
	if multiplayer.has_multiplayer_peer() and is_multiplayer_authority():
		multiplayer.peer_connected.connect(spawn_function)
		# Añade host local con id=1
		spawn_function(1)
