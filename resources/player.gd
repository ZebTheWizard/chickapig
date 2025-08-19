class_name Player extends Resource

@export var cards: Array[Card] = []
@export var played_cards: Array[Card] = []
@export var id:int
@export var tints: Array[Enum.Tint] = []

func _init(id:int, tint:Array[Enum.Tint]):
	self.id = id
	self.tints = tint
	
func draw_card(deck:Deck) -> Card:
	var card = deck.pick_card()
	cards.push_back(card)
	return card
