extends Node

signal play
signal roll_die
signal next_turn
signal orient_board
signal select
signal rolled
signal roll_accepted
signal start_die_animation(die_number: int)

var game: GameState
var selected_tile:Tile
var default_move_options:Dictionary = {}

func _ready() -> void:
	next_turn.connect(_on_next_turn)
	rolled.connect(_on_rolled)
	
	game = GameState.new()
	game.set_seed("a")
	
	game.out_of_moves.connect(_on_out_of_moves)
	
	# Goal posts
	game.grid.set_terrain(6,0,Enum.Terrain.YAY,Enum.Tint.GREEN)
	game.grid.set_terrain(7,0,Enum.Terrain.YAY,Enum.Tint.GREEN)
	game.grid.set_terrain(6,13,Enum.Terrain.YAY,Enum.Tint.RED)
	game.grid.set_terrain(7,13,Enum.Terrain.YAY,Enum.Tint.RED)
	game.grid.set_terrain(0,6,Enum.Terrain.YAY,Enum.Tint.YELLOW)
	game.grid.set_terrain(0,7,Enum.Terrain.YAY,Enum.Tint.YELLOW)
	game.grid.set_terrain(13,6,Enum.Terrain.YAY,Enum.Tint.BLUE)
	game.grid.set_terrain(13,7,Enum.Terrain.YAY,Enum.Tint.BLUE)
	

func _on_next_turn():
	_next_turn()
	
func _on_out_of_moves():
	next_turn.emit()
	orient_board.emit()
	
func _next_turn():
	game.next_turn()
	
func _on_rolled(number:int):
	game.player.remaining_moves = number

func get_pig_tiles() -> Array[Tile]: 
	var rows = game.grid.rows
	var pieces:Array[Tile] = []
	for row in rows:
		for tile:Tile in row.tiles:
			if tile.piece.type == Enum.Piece.PIG:
				pieces.append(tile)
	return pieces
	
func get_hay_tiles() -> Array[Tile]: 
	var rows = game.grid.rows
	var pieces:Array[Tile] = []
	for row in rows:
		for tile:Tile in row.tiles:
			if tile.piece.type == Enum.Piece.HAY:
				pieces.append(tile)
	return pieces
	
func select_tile(tile:Tile):
	if tile.piece.tint in game.player.tints:
		selected_tile = tile
		select.emit(tile)

func player_can_act() -> bool:
	return game.player.server_id == multiplayer.get_unique_id()
	
func get_local_player() -> Player:
	var player:Player
	for p:Player in game.players.values():
		if p.server_id == multiplayer.get_unique_id():
			player = p
	return player
