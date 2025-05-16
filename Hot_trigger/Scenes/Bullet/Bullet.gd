extends Area2D

const ESCENA_EXPLOSION = preload("res://Scenes/Boom/Boom.tscn")
const VELOCIDAD: float = 250.0

var _direccion: Vector2 = Vector2.ZERO

func _ready() -> void:
	var jugador = get_tree().get_first_node_in_group(Player.GROUP_NAME)
	if jugador == null:
		queue_free()
	else:
		_direccion = global_position.direction_to(jugador.global_position) * VELOCIDAD
		look_at(jugador.global_position)

func _process(delta: float) -> void:
	global_position += _direccion * delta

func generar_explosion() -> void:
	var explosion = ESCENA_EXPLOSION.instantiate()
	explosion.global_position = global_position
	get_tree().current_scene.call_deferred("add_child", explosion)

func _on_body_entered(cuerpo: Node2D) -> void:
	generar_explosion()
	if cuerpo is Player:
		SignalHub.emit_on_player_died()
	queue_free()

func _on_screen_notifier_screen_exited() -> void:
	queue_free()
