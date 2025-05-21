class_name Layer extends Resource

@export var type: int
@export var tint: Enum.Tint = Enum.Tint.NIL

func _init(type:int, tint:Enum.Tint=Enum.Tint.NIL) -> void:
	self.type = type
	self.tint = tint
	
func clone() -> Piece:
	return get_script().new(self.type, self.tint)
	
func to_array() -> Array:
	return [type, tint]
