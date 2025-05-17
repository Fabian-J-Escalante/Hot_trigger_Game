extends Node2D

func _ready() -> void:
	pass # Reemplazar con el cuerpo de la función.

func _physics_process(delta: float) -> void:
	position.x += delta * 10.0
