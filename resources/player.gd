class_name Player extends Resource

@export var cards: Array[Card] = []
@export var played_cards: Array[Card] = []
@export var id:int
@export var tint: Enum.Tint

func _init(id:int, tint:Enum.Tint):
	self.id = id
	self.tint = tint
