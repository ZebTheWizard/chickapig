extends Node

var address = "127.0.0.1"
var port = 8080
var compression_algorithm = ENetConnection.COMPRESS_RANGE_CODER
var max_clients = 4
var current_tint:int = 0
var username = ""

func _ready() -> void:
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)
	multiplayer.connected_to_server.connect(_on_connected_to_server)
	multiplayer.connection_failed.connect(_on_connection_failed)
	
func _on_peer_connected(id):
	print(str("peer connected id: ", id))
	
func _on_peer_disconnected(id):
	print(str("peer disconnected id: ", id))
	
func _on_connected_to_server():
	print("Connected to server!")
	send_player_details.rpc_id(1, self.username)
	
func _on_connection_failed():
	print("Connection failed!")
	
func host(username):
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(port, max_clients)
	if error != OK:
		print(str('cannot host: ', error))
		return
		
	peer.host.compress(compression_algorithm)
	multiplayer.multiplayer_peer = peer
	send_player_details(username)
	print("waiting for players")

func join(username):
	self.username = username
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_client(address, port)
	if error != OK:
		print(str("cannot connect to host: ", error))
	peer.host.compress(compression_algorithm)
	multiplayer.multiplayer_peer = peer
	

@rpc("any_peer","call_local")
func _start():
	GameController.game.start()
	print("started game")
	
func start():
	_start.rpc()
	
@rpc("any_peer")
func send_player_details(name):
	var sender := multiplayer.get_remote_sender_id()
	if multiplayer.is_server():
		print(str(sender, ":", name))
		var tints:Array[Enum.Tint] = []
		for i in 4 / max_clients:
			current_tint += 1
			tints.append(current_tint)
		GameController.game.add_player(tints, name, sender)
		
		for player:Player in GameController.game.players.values():
			receive_player_details.rpc(player.tints, player.name, player.server_id)
		
		
@rpc("authority", "reliable")
func receive_player_details(tints:Array[Enum.Tint], name:String, sender:int):
	print(str("receiving player details", name, sender))
	GameController.game.add_player(tints, name, sender)
