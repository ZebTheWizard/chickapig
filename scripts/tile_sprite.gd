class_name TileSprite extends Area2D

@onready var board:Sprite2D = $"../../../Board"
var tile_size:Vector2
var board_size:Vector2
@onready var sprite: Sprite2D = $"Sprite2D"
var tile:Tile

func _ready() -> void:
	update_scale()
	

func update_scale():
	# include board scale if not parented by board
	board_size = board.get_rect().size
	tile_size = board_size / 14
	scale = tile_size / 128

func set_pos(_position:Vector2):
	var top_left = board.position - board_size / 2
	position = top_left + tile_size / 2 + (_position * tile_size)

func set_tile(_tile:Tile):
	tile = _tile
