extends CharacterBody2D
class_name Player

@export var velocidad: float = 260.0

func _physics_process(delta: float) -> void:
	var dir = Input.get_vector("izquierda", "derecha", "arriba", "abajo")
	velocity = dir * velocidad
	move_and_slide()
	
	var mouse = get_global_mouse_position()
	look_at(mouse)
	
