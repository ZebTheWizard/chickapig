extends Node

signal play
signal roll_die
signal next_turn
signal orient_board
signal select
signal rolled
signal roll_accepted

var game: GameState
var selected_tile:Tile
var default_move_options:Dictionary = {}

func _ready() -> void:
	next_turn.connect(_on_next_turn)
	rolled.connect(_on_rolled)
	
	game = GameState.new()
	game.set_seed("a")
	
	game.out_of_moves.connect(_on_out_of_moves)
	
	# Red Pigs
	game.grid.set_piece(1,0,Enum.Piece.PIG, Enum.Tint.RED)
	game.grid.set_piece(3,0,Enum.Piece.PIG, Enum.Tint.RED)
	game.grid.set_piece(5,0,Enum.Piece.PIG, Enum.Tint.RED)
	game.grid.set_piece(8,0,Enum.Piece.PIG, Enum.Tint.RED)
	game.grid.set_piece(10,0,Enum.Piece.PIG, Enum.Tint.RED)
	game.grid.set_piece(12,0,Enum.Piece.PIG, Enum.Tint.RED)
	
	# Blue Pigs
	game.grid.set_piece(0,1,Enum.Piece.PIG, Enum.Tint.BLUE)
	game.grid.set_piece(0,3,Enum.Piece.PIG, Enum.Tint.BLUE)
	game.grid.set_piece(0,5,Enum.Piece.PIG, Enum.Tint.BLUE)
	game.grid.set_piece(0,8,Enum.Piece.PIG, Enum.Tint.BLUE)
	game.grid.set_piece(0,10,Enum.Piece.PIG, Enum.Tint.BLUE)
	game.grid.set_piece(0,12,Enum.Piece.PIG, Enum.Tint.BLUE)
	
	# Green Pigs
	game.grid.set_piece(1,13,Enum.Piece.PIG, Enum.Tint.GREEN)
	game.grid.set_piece(3,13,Enum.Piece.PIG, Enum.Tint.GREEN)
	game.grid.set_piece(5,13,Enum.Piece.PIG, Enum.Tint.GREEN)
	game.grid.set_piece(8,13,Enum.Piece.PIG, Enum.Tint.GREEN)
	game.grid.set_piece(10,13,Enum.Piece.PIG, Enum.Tint.GREEN)
	game.grid.set_piece(12,13,Enum.Piece.PIG, Enum.Tint.GREEN)
	
	# Yellow Pigs
	game.grid.set_piece(13,1,Enum.Piece.PIG, Enum.Tint.YELLOW)
	game.grid.set_piece(13,3,Enum.Piece.PIG, Enum.Tint.YELLOW)
	game.grid.set_piece(13,5,Enum.Piece.PIG, Enum.Tint.YELLOW)
	game.grid.set_piece(13,8,Enum.Piece.PIG, Enum.Tint.YELLOW)
	game.grid.set_piece(13,10,Enum.Piece.PIG, Enum.Tint.YELLOW)
	game.grid.set_piece(13,12,Enum.Piece.PIG, Enum.Tint.YELLOW)
	
	# Red Haybales
	game.grid.set_piece(5,1,Enum.Piece.HAY, Enum.Tint.RED)
	game.grid.set_piece(8,1,Enum.Piece.HAY, Enum.Tint.RED)
	game.grid.set_piece(5,10,Enum.Piece.HAY, Enum.Tint.RED)
	game.grid.set_piece(8,10,Enum.Piece.HAY, Enum.Tint.RED)
	
	# Blue Haybales
	game.grid.set_piece(1,5,Enum.Piece.HAY, Enum.Tint.BLUE)
	game.grid.set_piece(1,8,Enum.Piece.HAY, Enum.Tint.BLUE)
	game.grid.set_piece(10,5,Enum.Piece.HAY, Enum.Tint.BLUE)
	game.grid.set_piece(10,8,Enum.Piece.HAY, Enum.Tint.BLUE)
	
	# Green Haybales
	game.grid.set_piece(5,3,Enum.Piece.HAY, Enum.Tint.GREEN)
	game.grid.set_piece(8,3,Enum.Piece.HAY, Enum.Tint.GREEN)
	game.grid.set_piece(5,12,Enum.Piece.HAY, Enum.Tint.GREEN)
	game.grid.set_piece(8,12,Enum.Piece.HAY, Enum.Tint.GREEN)
	
	# Yellow Haybales
	game.grid.set_piece(3,5,Enum.Piece.HAY, Enum.Tint.YELLOW)
	game.grid.set_piece(3,8,Enum.Piece.HAY, Enum.Tint.YELLOW)
	game.grid.set_piece(12,5,Enum.Piece.HAY, Enum.Tint.YELLOW)
	game.grid.set_piece(12,8,Enum.Piece.HAY, Enum.Tint.YELLOW)
	
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
