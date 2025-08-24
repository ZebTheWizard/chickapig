extends Node

var address = "127.0.0.1"
var port = 8080
var compression_algorithm = ENetConnection.COMPRESS_RANGE_CODER
var max_clients = 4
var current_tint:int = 0
var username = ""
var mode = ""

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
	
func host(username, mode):
	var peer = ENetMultiplayerPeer.new()
	self.mode = mode
	match mode:
		"2-simple", "2-classic":
			max_clients = 2
		"4-classic":
			max_clients = 4
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
	
func _get_sender() -> int:
	var sender:int = multiplayer.get_remote_sender_id()
	if sender == 0:
		sender = multiplayer.get_unique_id()	
	return sender
	
	
@rpc("any_peer", "reliable")
func send_player_details(name):
	var sender:int = _get_sender()
	if multiplayer.is_server():
		var available_tints:Array[Array]
		match mode:
			"2-simple":
				available_tints = [[Enum.Tint.RED] as Array[Enum.Tint], [Enum.Tint.GREEN] as Array[Enum.Tint]]
			"2-classic":
				available_tints = [[Enum.Tint.RED, Enum.Tint.BLUE] as Array[Enum.Tint], [Enum.Tint.GREEN, Enum.Tint.YELLOW] as Array[Enum.Tint]]
			"4-classic":
				available_tints = [[Enum.Tint.RED] as Array[Enum.Tint], [Enum.Tint.BLUE] as Array[Enum.Tint], [Enum.Tint.GREEN] as Array[Enum.Tint], [Enum.Tint.YELLOW] as Array[Enum.Tint]]
		var tints:Array[Enum.Tint] = available_tints[GameController.game.players.size()]
		
		if not name:
			name = str("Player ", sender)
		GameController.game.add_player(tints, name, sender)
		
		for player:Player in GameController.game.players.values():
			receive_player_details.rpc(player.tints, player.name, player.server_id)
		
		
		
@rpc("authority", "reliable")
func receive_player_details(tints:Array[Enum.Tint], name:String, sender:int):
	print(str("receiving player details", name, sender))
	GameController.game.add_player(tints, name, sender)

@rpc("any_peer", "call_local", "reliable")
func request_die_roll(die_number=0):
	var sender = _get_sender()
	if multiplayer.is_server():
		if sender == GameController.game.player.server_id:
			print("Connected peers before die roll: ", multiplayer.get_peers())
			if not die_number:
				die_number = GameController.game.roll_die()
			sync_die_animation_start.rpc(die_number)
	
@rpc("authority", "call_local", "reliable")
func sync_die_animation_start(die_number:int):
	GameController.start_die_animation.emit(die_number)
	
@rpc('authority', "call_local", "reliable")	
func broadcast_roll_accepted():
	GameController.roll_accepted.emit()
