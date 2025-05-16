extends Area2D

func _ready() -> void:
	hide()
	SignalHub.on_show_exit.connect(al_mostrar_salida)

func al_mostrar_salida() -> void:
	set_deferred("monitoring", true)
	show()

func _on_body_entered(cuerpo: Node2D) -> void:
	if cuerpo is Player:
		SignalHub.emit_on_exit()
