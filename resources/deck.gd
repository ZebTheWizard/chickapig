class_name Deck extends Resource

var cards:Array[Card] = []

func _init(cards:Array[Card]):
	for i in range(cards.size()):
		var card = cards[i]
		card.id = i + 1
	self.cards = cards
	
func shuffle_with(rnd:RandomNumberGenerator):
	Util.shuffle_array(cards, rnd)
