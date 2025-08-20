extends Node2D

var pig_scene = preload("res://scenes/pig.tscn")
var hay_scene = preload("res://scenes/hay.tscn")

func _ready() -> void:
	#print(GameController.get_pig_pieces())
	GameController.game.grid.update.connect(_on_tile_update)
	_draw_pigs()
	_draw_hay()

func _draw_pigs():
	for tile:Tile in GameController.get_pig_tiles():
		var pig:Pig = pig_scene.instantiate()
		add_child(pig)
		pig.set_tile(tile)
		pig.set_tint(tile.piece.tint)
		pig.set_pos(tile.position)
		
func _draw_hay():
	for tile:Tile in GameController.get_hay_tiles():
		var hay:Hay = hay_scene.instantiate()
		add_child(hay)
		hay.set_tile(tile)
		hay.set_tint(tile.piece.tint)
		hay.set_pos(tile.position)
		
func _on_tile_update(tile: Tile):
	for child in get_children():
		child.queue_free()
	_draw_pigs()
	_draw_hay()
