extends CharacterBody2D

enum EstadoEnemigo { Patrullando, Persiguiendo, Buscando }

const ESCENA_BALA = preload("res://Scenes/Bullet/Bullet.tscn")

const VELOCIDADES: Dictionary[EstadoEnemigo, float] = {
	EstadoEnemigo.Patrullando: 60.0,
	EstadoEnemigo.Persiguiendo: 90.0,
	EstadoEnemigo.Buscando: 100.0,
}

const CAMPO_VISION: Dictionary[EstadoEnemigo, float] = {
	EstadoEnemigo.Patrullando: 60.0,
	EstadoEnemigo.Persiguiendo: 120.0,
	EstadoEnemigo.Buscando: 100.0,
}

@export var patrol_points: NodePath

@onready var agente_navegacion: NavigationAgent2D = $NavAgent
@onready var etiqueta_debug: Label = $DebugLabel
@onready var rayo_deteccion_jugador: RayCast2D = $PlayerDetect
@onready var reproductor_animacion: AnimationPlayer = $AnimationPlayer
@onready var advertencia: Sprite2D = $Warning
@onready var sonido_sorpresa: AudioStreamPlayer2D = $GaspSound
@onready var sonido_laser: AudioStreamPlayer2D = $LaserSound

var _puntos: Array[Vector2] = []
var _indice_actual: int = 0
var _estado: EstadoEnemigo = EstadoEnemigo.Patrullando
var _jugador_ref: Player

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("set_target"):
		agente_navegacion.target_position = get_global_mouse_position()

func _ready() -> void:
	_jugador_ref = get_tree().get_first_node_in_group(Player.GROUP_NAME)
	if _jugador_ref == null:
		queue_free()
	inicializar_puntos()

func inicializar_puntos() -> void:
	for punto in get_node(patrol_points).get_children():
		_puntos.append(punto.global_position)

func _physics_process(delta: float) -> void:
	detectar_jugador()
	procesar_comportamiento()
	actualizar_movimiento()
	actualizar_rayo()
	actualizar_etiqueta()

func obtener_angulo_campo_vision() -> float:
	var direccion: Vector2 = global_position.direction_to(_jugador_ref.global_position)
	var angulo: float = transform.x.angle_to(direccion)
	return rad_to_deg(angulo)

func actualizar_rayo() -> void:
	rayo_deteccion_jugador.look_at(_jugador_ref.global_position)

func jugador_es_visible() -> bool:
	return rayo_deteccion_jugador.get_collider() is Player

func puede_ver_jugador() -> bool:
	return abs(obtener_angulo_campo_vision()) < CAMPO_VISION[_estado] and jugador_es_visible()

func navegar_puntos() -> void:
	if _puntos.size() == 0:
		return
	agente_navegacion.target_position = _puntos[_indice_actual]
	_indice_actual = (_indice_actual + 1) % _puntos.size()

func actualizar_movimiento() -> void:
	if agente_navegacion.is_navigation_finished():
		return
	var siguiente_pos: Vector2 = agente_navegacion.get_next_path_position()
	rotation = global_position.direction_to(siguiente_pos).angle()
	velocity = transform.x * VELOCIDADES[_estado]
	move_and_slide()

func procesar_patrullaje() -> void:
	if agente_navegacion.is_navigation_finished():
		navegar_puntos()

func procesar_persiguiendo() -> void:
	agente_navegacion.target_position = _jugador_ref.global_position

func procesar_busqueda() -> void:
	if agente_navegacion.is_navigation_finished():
		establecer_estado(EstadoEnemigo.Patrullando)

func procesar_comportamiento() -> void:
	match _estado:
		EstadoEnemigo.Patrullando:
			procesar_patrullaje()
		EstadoEnemigo.Persiguiendo:
			procesar_persiguiendo()
		EstadoEnemigo.Buscando:
			procesar_busqueda()

func establecer_estado(nuevo_estado: EstadoEnemigo) -> void:
	if nuevo_estado == _estado:
		return
	if _estado == EstadoEnemigo.Buscando:
		advertencia.hide()
	if nuevo_estado == EstadoEnemigo.Buscando:
		advertencia.show()
	elif nuevo_estado == EstadoEnemigo.Persiguiendo:
		sonido_sorpresa.play()
		reproductor_animacion.play("alert")
	elif nuevo_estado == EstadoEnemigo.Patrullando:
		reproductor_animacion.play("RESET")
	_estado = nuevo_estado

func detectar_jugador() -> void:
	if puede_ver_jugador():
		establecer_estado(EstadoEnemigo.Persiguiendo)
	elif _estado == EstadoEnemigo.Persiguiendo:
		establecer_estado(EstadoEnemigo.Buscando)

func actualizar_etiqueta() -> void:
	var texto_debug: String = "%s Fin:%s\n" % [EstadoEnemigo.keys()[_estado], agente_navegacion.is_navigation_finished()]
	texto_debug += "Vis:%s FOV:%.0f\n" % [jugador_es_visible(), obtener_angulo_campo_vision()]
	texto_debug += "CAN SEE:%s" % puede_ver_jugador()
	etiqueta_debug.text = texto_debug
	etiqueta_debug.rotation = -rotation

func disparar() -> void:
	if _estado != EstadoEnemigo.Persiguiendo:
		return
	var bala = ESCENA_BALA.instantiate()
	bala.global_position = global_position
	get_tree().current_scene.call_deferred("add_child", bala)
	sonido_laser.play()

func _on_nav_agent_velocity_computed(safe_velocity: Vector2) -> void:
	velocity = safe_velocity
	move_and_slide()

func _on_shoot_timer_timeout() -> void:
	disparar()

func _on_hit_box_body_entered(cuerpo: Node2D) -> void:
	if cuerpo is Player:
		print("el bot le pego al jugador")
		SignalHub.emit_on_player_died()
