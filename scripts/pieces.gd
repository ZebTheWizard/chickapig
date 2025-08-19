extends Node2D

var pig_scene = preload("res://scenes/pig.tscn")

func _ready() -> void:
	#print(GameController.get_pig_pieces())
	GameController.game.grid.update.connect(_on_tile_update)
	_draw_pigs()

func _draw_pigs():
	for tile:Tile in GameController.get_pig_tiles():
		var pig:Pig = pig_scene.instantiate()
		add_child(pig)
		pig.set_tile(tile)
		pig.set_tint(tile.piece.tint)
		pig.set_pos(tile.position)
		
func _on_tile_update(tile: Tile):
	for child in get_children():
		child.queue_free()
	_draw_pigs()
