extends Area2D

class_name PickUp

const GROUP_NAME: String = "PickUp"

@onready var sonido: AudioStreamPlayer2D = $Sound

func _enter_tree() -> void:
	add_to_group(GROUP_NAME)

func _on_body_entered(cuerpo: Node2D) -> void:
	set_deferred("monitoring", false)
	hide()
	sonido.play()
	SignalHub.emit_on_pickup_collected()

func _on_sound_finished() -> void:
	queue_free()
