class_name Row extends Resource

@export var tiles:Array[Tile]

func _init(size:int) -> void:
	tiles = []
	tiles.resize(size)
	for i in range(size):
		tiles[i] = Tile.new()
	
func get_tile(offset:int) -> Tile:
	return tiles[offset]
	
func to_array() -> Array:
	var result = []
	for tile in tiles:
		result.append(tile.to_array())
	return result
