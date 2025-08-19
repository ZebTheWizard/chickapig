class_name Tile extends Resource

@export var piece: Piece
@export var barriers: Dictionary[Enum.Direction, bool]
@export var terrain: Terrain
@export var hazard: Hazard
@export var position: Vector2

func _init(_x:int=0, _y:int=0) -> void:
	piece = Piece.new(Enum.Piece.NIL)
	terrain = Terrain.new(Enum.Terrain.NIL)
	hazard = Hazard.new(Enum.Hazard.NIL)
	barriers = {0:false, 1:false, 2:false, 3:false}
	position = Vector2(_x, _y)
	
