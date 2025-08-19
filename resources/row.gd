class_name Row extends Resource

@export var tiles:Array[Tile]

func _init(size:int, row:int = 0) -> void:
	tiles = []
	tiles.resize(size)
	for col in range(size):
		tiles[col] = Tile.new(col, row)
	
func get_tile(offset:int) -> Tile:
	return tiles[offset]
	
func to_array() -> Array:
	var result = []
	for tile in tiles:
		result.append(tile.to_array())
	return result
