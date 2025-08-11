class_name GameState extends Resource

@export var grid: BoardState
@export var players: Array[Player]
@export var player: Player
var rnd:RandomNumberGenerator
var started = false
var moves:int
var can_place_cow = false
var can_draw_daisy = false
var daisy_cards = DaisyDeck.new()
var poop_cards = PoopDeck.new()

func _init(players:int = 2):
	assert(players == 2 or players == 4)
	for i in range(players):
		self.players.append(Player.new(i, Enum.Tint.values()[i + 1]))
	rnd = RandomNumberGenerator.new()
		
func set_seed(seed):
	rnd.seed = hash(str(seed))
	
func start():
	if not started:
		self.player = self.players.get(rnd.randi() % self.players.size())
		started = true
		shuffle_daisy_cards()
		shuffle_poop_cards()

func roll_die(num:int = 0) -> int:
	var max = 6
	var min = 1
	moves = rnd.randi() % max + min
	if num:
		assert(num >= min and num <= max)
		moves = num
	if moves == 1:
		can_place_cow = true
	if moves == 2:
		can_draw_daisy = true
	return moves
	
func next_turn() -> Player:
	var id = (player.id + 1) % players.size()
	player = players[id]
	return player
	
func draw_daisy_card():
	pass
	
func draw_poop_card():
	pass
	
func _draw_card(deck: Deck):
	var card = deck.cards.pop_front()
	player.cards.append(card)
	if card.effect.get("type") == "immediate":
		play_card(card)
	_card_effect("immediate")
	
func _card_effect(type:String) -> Array:
	var results = []
	for card in player.played_cards:
		if card.effect.get("type") == type:
			results.append(card.use(self))
	return results
			
func _has_card_effect(type:String) -> bool:
	var found = false
	for card in player.played_cards:
		if card.effect.get("type") == type:
			found = true
	return found
			
func play_card(card:Card):
	player.cards = player.cards.filter(func (c:Card): return c.id != card.id)
	player.played_cards.append(card)
	
func shuffle_daisy_cards():
	daisy_cards.shuffle_with(rnd)
	
func shuffle_poop_cards():
	poop_cards.shuffle_with(rnd)
