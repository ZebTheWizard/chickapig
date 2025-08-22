class_name Player extends Resource

@export var cards: Array[Card] = []
@export var played_cards: Array[Card] = []
@export var id:int
@export var tints: Array[Enum.Tint] = []
@export var remaining_moves:int = 6
@export var move_options:Dictionary
var name:String
var server_id:int

func _init(id:int, tint:Array[Enum.Tint], name:String="", server_id:int=0):
	self.id = id
	self.tints = tint
	self.name = name
	self.server_id = server_id
	
func draw_card(deck:Deck) -> Card:
	var card = deck.pick_card()
	cards.push_back(card)
	return card
