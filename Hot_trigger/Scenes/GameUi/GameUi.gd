extends Control

@onready var etiqueta_puntuacion: Label = $MC/ScoreLabel
@onready var etiqueta_tiempo: Label = $MC/TimeLabel
@onready var etiqueta_salida: Label = $MC/ExitLabel
@onready var etiqueta_mensaje: Label = $ColorRect/GoLabel
@onready var rectangulo_color: ColorRect = $ColorRect

var _tiempo: float = 0.0
var _cantidad_coleccionables: int = 0
var _recogidos: int = 0

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("salir"):
		GameManager.cargar_escena_principal()

func _ready() -> void:
	get_tree().paused = false
	SignalHub.on_pickup_collected.connect(al_recoger_elemento)
	SignalHub.on_player_died.connect(al_jugador_muerto)
	SignalHub.on_exit.connect(al_salir)
	_cantidad_coleccionables = get_tree().get_nodes_in_group(PickUp.GROUP_NAME).size()
	actualizar_puntuacion()

func _process(delta: float) -> void:
	_tiempo += delta
	etiqueta_tiempo.text = "%.1fs" % _tiempo

func actualizar_puntuacion() -> void:
	etiqueta_puntuacion.text = "%s / %s" % [_recogidos, _cantidad_coleccionables]

func detener_juego() -> void:
	rectangulo_color.show()
	get_tree().paused = true
	set_process(false)

func al_jugador_muerto() -> void:
	etiqueta_mensaje.text = "Moriste!"
	detener_juego()

func al_salir() -> void:
	etiqueta_mensaje.text = "Bien hecho! Has tardado %.1f segundos" % _tiempo
	detener_juego()

func al_recoger_elemento() -> void:
	_recogidos += 1
	actualizar_puntuacion()
	if _recogidos == _cantidad_coleccionables:
		SignalHub.emit_on_show_exit()
		etiqueta_salida.show()
