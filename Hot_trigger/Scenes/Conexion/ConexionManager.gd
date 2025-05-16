class_name ENetConnectionManager
extends PanelContainer

signal server_creado
signal server_unido


@export var host_ip: LineEdit
@export var host_port: LineEdit

var peer = ENetMultiplayerPeer.new()

func _on_button_2_pressed() -> void:
	peer.create_server(int(host_port.text))
	multiplayer.multiplayer_peer = peer
	
	multiplayer.peer_connected.connect(
		func(pid) -> void:
			print(str(pid) + " se conecto")
	)
	
	server_creado.emit()


func _on_button_pressed() -> void:
	peer.create_client(host_ip.text, int(host_port.text))
	multiplayer.multiplayer_peer = peer
	
	server_unido.emit()
