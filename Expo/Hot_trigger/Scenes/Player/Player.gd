extends CharacterBody2D

class_name Player

const VELOCIDAD: float = 170.0
const GROUP_NAME: String = "player"

func _enter_tree() -> void:
	add_to_group(GROUP_NAME)

func obtener_entrada() -> Vector2:
	var direccion: Vector2 = Vector2.ZERO
	direccion.x = Input.get_axis("izquierda", "derecha")
	direccion.y = Input.get_axis("arriba", "abajo")
	var mouse = get_global_mouse_position()
	look_at(mouse)
	return direccion.normalized()

func _physics_process(delta: float) -> void:
	velocity = obtener_entrada() * VELOCIDAD
	move_and_slide()
	if velocity.length() > 0:
		rotation = velocity.angle()
	else:
		look_at(get_global_mouse_position())
