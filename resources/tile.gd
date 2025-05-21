class_name Tile extends Resource

@export var piece: Piece
@export var barriers: Dictionary[Enum.Direction, bool]
@export var terrain: Terrain
@export var hazard: Hazard

func _init() -> void:
	piece = Piece.new(Enum.Piece.NIL)
	terrain = Terrain.new(Enum.Terrain.NIL)
	hazard = Hazard.new(Enum.Hazard.NIL)
	barriers = {0:false, 1:false, 2:false, 3:false}
