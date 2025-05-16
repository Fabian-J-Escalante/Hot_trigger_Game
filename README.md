## Beta 11/04/2025

https://github.com/user-attachments/assets/2c36ea74-5fff-4e9f-9c4d-a48a81a44234

## Hot Trigger

Proyecto de ejemplo en Godot para la materia de Videojuegos en Red. Maneja conexión entre jugadores, lógica de nivel, IA básica y recolección de objetos.

---

### Estructura de Escenas

* **Main**: Pantalla inicial con botones y conexiones.
* **Conexion**: UI para crear o unirse a partida.
* **Level**: Nivel principal con tilemap, puntos de camino Waypoints, jugadores, pickups y enemigos.
* **Player**: Control del personaje.
* **Waypoint**: Puntos de ruta para IA.
* **Exit**: Zona de salida que aparece cuando recoges todo.

---

### Nodos del nivel

```
Level
├─ CanvasLayer/GameUi
├─ Tiles (Texturas 2D)
├─ Path, Path2, … (Waypoints)
├─ Player (Camera2D)
├─ Exit
├─ Pickups (Pastillas)
├─ Enemies (Npcs)
├─ Navigation (NavigationRegion2D, NavigationLink2D)
└─ Jugadores (MultiplayerSpawner)
```

---

### Resumen de Scripts

* **Level.gd** (`class_name Nivel`): Maneja instanciado de jugadores en red. Corrige `var world` para apuntar a `self` o al nodo correcto.
* **GameManager.gd**: Cambia entre escenas Main y Level.
* **GameUi.gd**: UI de puntuación, tiempo, mensajes de muerte o victoria.
* **Player.gd**: Movimiento básico, rotación hacia el ratón.
* **PickUp.gd**: Recolección de objetos y emisión de señal.
* **Exit.gd**: Aparece al recoger todos los pickups y emite señal de salida.
* **Bullet.gd** + **Boom.gd**: Balas enemigas que generan explosión al impactar.
* **Npc.gd**: IA con estados (patrulla, persecución, búsqueda) y disparo de balas.
* **ConexionManager.gd** + **Conexion.gd**: Gestión de servidor y cliente ENet.
* **SignalHub.gd**: Centraliza señales globales.

---

### Setup

1. Abrir el proyecto en Godot 4.
2. Revisar rutas de escenas en preload.
3. Ajustar export variables para IP y puerto en el nodo ConexionManager.
4. Ejecutar Main.tscn.

---

### Modificación Level.gd

Si `var world` no existe, reemplaza:

```gdscript
@onready var world: Nivel = $Level
```

por:

```gdscript
@onready var world: Nivel = self  
```


