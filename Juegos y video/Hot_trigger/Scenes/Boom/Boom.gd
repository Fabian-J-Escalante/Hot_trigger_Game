extends Node2D

func _on_animation_player_animation_finished(nombre_anim: StringName) -> void:
	queue_free()
