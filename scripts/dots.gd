extends Node2D

var dot_scene = preload("res://scenes/dot.tscn")

func _ready() -> void:
	GameController.select.connect(_on_select)
	GameController.game.grid.update.connect(_on_tile_update)
	GameController.next_turn.connect(_on_next_turn)
	
func _on_select(tile:Tile):
	_draw_available_moves(tile)

func _draw_available_moves(tile:Tile):
	var moves = GameController.game.grid.get_available_moves(tile.position.x, tile.position.y)
	for child in get_children():
		child.queue_free()
	for move in moves:
		var dot:Dot = dot_scene.instantiate()
		add_child(dot)
		#dot.scale /= 8
		dot.set_pos(Vector2(move[0], move[1]))
		var new_tile:Tile = GameController.game.grid.get_tile(move[0], move[1])
		dot.set_tile(new_tile)
		
func _on_tile_update(tile: Tile):
	GameController.select_tile(tile)
	
func _on_next_turn():
	for child in get_children():
		child.queue_free()
