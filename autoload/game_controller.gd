extends Node

signal play
signal roll_die
signal next_turn
signal orient_board
signal select

var game: GameState
var selected_tile:Tile

func _ready() -> void:
	next_turn.connect(_on_next_turn)
	game = GameState.new()
	game.set_seed("a")
	
	game.add_player([Enum.Tint.RED])
	game.add_player([Enum.Tint.BLUE])
	game.add_player([Enum.Tint.GREEN])
	game.add_player([Enum.Tint.YELLOW])
	
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
	
	# Goal posts
	game.grid.set_terrain(6,0,Enum.Terrain.YAY)
	game.grid.set_terrain(7,0,Enum.Terrain.YAY)
	game.grid.set_terrain(6,13,Enum.Terrain.YAY)
	game.grid.set_terrain(7,13,Enum.Terrain.YAY)
	game.grid.set_terrain(0,6,Enum.Terrain.YAY)
	game.grid.set_terrain(0,7,Enum.Terrain.YAY)
	game.grid.set_terrain(13,6,Enum.Terrain.YAY)
	game.grid.set_terrain(13,7,Enum.Terrain.YAY)
	
	game.start()

func _on_next_turn():
	game.next_turn()

func get_pig_tiles() -> Array[Tile]: 
	var rows = game.grid.rows
	var pigs:Array[Tile] = []
	for row in rows:
		for tile:Tile in row.tiles:
			if tile.piece.type == Enum.Piece.PIG:
				pigs.append(tile)
	return pigs
	
func select_tile(tile:Tile):
	selected_tile = tile
	select.emit(tile)
