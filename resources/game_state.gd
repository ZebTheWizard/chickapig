class_name GameState extends Resource

@export var grid: BoardState
@export var players: Array[Player] = []
@export var player: Player
var rnd:RandomNumberGenerator
var started = false
var moves:int
var can_place_cow = false
var can_draw_daisy = false
var daisy_cards = DaisyDeck.new()
var poop_cards = PoopDeck.new()
var card_choices:Array = []

func _init():
	rnd = RandomNumberGenerator.new()
	grid = BoardState.new(14,14)
	
func add_four_players():
	add_player([Enum.Tint.RED])
	add_player([Enum.Tint.BLUE])
	add_player([Enum.Tint.GREEN])
	add_player([Enum.Tint.YELLOW])
		
func add_player(tints:Array[Enum.Tint]):
	self.players.append(Player.new(players.size(), tints))
	
func set_seed(seed):
	rnd.seed = hash(str(seed))
	
func start():
	if not started:
		assert(players.size() > 0, "Add at least one player to game state.")
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
	
func end_turn():
	_card_effect("end_of_turn")
	
func draw_daisy_card():
	return player.draw_card(daisy_cards)
	
func draw_poop_card():
	return player.draw_card(poop_cards)
	
func _card_effect(type:String) -> Array:
	var results = []
	for card in player.played_cards:
		if card.effect.get("type") == type:
			results.append(card.invoke_effect(self))
	return results
			
func _has_card_effect(type:String) -> bool:
	var found = false
	for card in player.played_cards:
		if card.effect.get("type") == type:
			found = true
	return found
			
func select_card(card:Card):
	player.cards = player.cards.filter(func (c:Card): return c.id != card.id)
	player.played_cards.append(card)
	if "choices" in card.effect:
		card_choices = card.effect.choices
	
func shuffle_daisy_cards():
	daisy_cards.shuffle_with(rnd)
	
func shuffle_poop_cards():
	poop_cards.shuffle_with(rnd)
