class_name GameState extends Resource

signal out_of_moves
signal ready
signal die_ready
signal added_player

@export var grid: BoardState
@export var players: Dictionary[int, Player] = {}
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
		
func add_player(tints:Array[Enum.Tint], name:String="", server_id:int=0):
	var id = players.size()
	if !players.has(id):
		var player = Player.new(id, tints, name, server_id)
		players.set(id, player)
		
		if not self.player:
			self.player = player
		
		if Enum.Tint.RED in tints:
			# Red Pigs
			grid.set_piece(1,0,Enum.Piece.PIG, Enum.Tint.RED)
			grid.set_piece(3,0,Enum.Piece.PIG, Enum.Tint.RED)
			grid.set_piece(5,0,Enum.Piece.PIG, Enum.Tint.RED)
			grid.set_piece(8,0,Enum.Piece.PIG, Enum.Tint.RED)
			grid.set_piece(10,0,Enum.Piece.PIG, Enum.Tint.RED)
			grid.set_piece(12,0,Enum.Piece.PIG, Enum.Tint.RED)
			
			# Red Haybales
			grid.set_piece(5,1,Enum.Piece.HAY, Enum.Tint.RED)
			grid.set_piece(8,1,Enum.Piece.HAY, Enum.Tint.RED)
			grid.set_piece(5,10,Enum.Piece.HAY, Enum.Tint.RED)
			grid.set_piece(8,10,Enum.Piece.HAY, Enum.Tint.RED)
		
		if Enum.Tint.BLUE in tints:
			# Blue Pigs
			grid.set_piece(0,1,Enum.Piece.PIG, Enum.Tint.BLUE)
			grid.set_piece(0,3,Enum.Piece.PIG, Enum.Tint.BLUE)
			grid.set_piece(0,5,Enum.Piece.PIG, Enum.Tint.BLUE)
			grid.set_piece(0,8,Enum.Piece.PIG, Enum.Tint.BLUE)
			grid.set_piece(0,10,Enum.Piece.PIG, Enum.Tint.BLUE)
			grid.set_piece(0,12,Enum.Piece.PIG, Enum.Tint.BLUE)
			
			# Blue Haybales
			grid.set_piece(1,5,Enum.Piece.HAY, Enum.Tint.BLUE)
			grid.set_piece(1,8,Enum.Piece.HAY, Enum.Tint.BLUE)
			grid.set_piece(10,5,Enum.Piece.HAY, Enum.Tint.BLUE)
			grid.set_piece(10,8,Enum.Piece.HAY, Enum.Tint.BLUE)
			
		if Enum.Tint.GREEN in tints:
			# Green Pigs
			grid.set_piece(1,13,Enum.Piece.PIG, Enum.Tint.GREEN)
			grid.set_piece(3,13,Enum.Piece.PIG, Enum.Tint.GREEN)
			grid.set_piece(5,13,Enum.Piece.PIG, Enum.Tint.GREEN)
			grid.set_piece(8,13,Enum.Piece.PIG, Enum.Tint.GREEN)
			grid.set_piece(10,13,Enum.Piece.PIG, Enum.Tint.GREEN)
			grid.set_piece(12,13,Enum.Piece.PIG, Enum.Tint.GREEN)
			# Green Haybales
			grid.set_piece(5,3,Enum.Piece.HAY, Enum.Tint.GREEN)
			grid.set_piece(8,3,Enum.Piece.HAY, Enum.Tint.GREEN)
			grid.set_piece(5,12,Enum.Piece.HAY, Enum.Tint.GREEN)
			grid.set_piece(8,12,Enum.Piece.HAY, Enum.Tint.GREEN)
		
		if Enum.Tint.YELLOW in tints:
			# Yellow Pigs
			grid.set_piece(13,1,Enum.Piece.PIG, Enum.Tint.YELLOW)
			grid.set_piece(13,3,Enum.Piece.PIG, Enum.Tint.YELLOW)
			grid.set_piece(13,5,Enum.Piece.PIG, Enum.Tint.YELLOW)
			grid.set_piece(13,8,Enum.Piece.PIG, Enum.Tint.YELLOW)
			grid.set_piece(13,10,Enum.Piece.PIG, Enum.Tint.YELLOW)
			grid.set_piece(13,12,Enum.Piece.PIG, Enum.Tint.YELLOW)
			# Yellow Haybales
			grid.set_piece(3,5,Enum.Piece.HAY, Enum.Tint.YELLOW)
			grid.set_piece(3,8,Enum.Piece.HAY, Enum.Tint.YELLOW)
			grid.set_piece(12,5,Enum.Piece.HAY, Enum.Tint.YELLOW)
			grid.set_piece(12,8,Enum.Piece.HAY, Enum.Tint.YELLOW)
			
		added_player.emit(player)
	
func set_seed(seed):
	rnd.seed = hash(str(seed))
	
func start():
	if not started:
		assert(players.size() > 0, "Add at least one player to game state.")
		self.player = self.players.get(rnd.randi() % self.players.size())
		started = true
		shuffle_daisy_cards()
		shuffle_poop_cards()
		ready.emit()
		die_ready.emit()

func randi_range(from, to) -> int:
	return rnd.randi_range(from,to)

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
	die_ready.emit()
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
	
func try_move(from:Vector2, to:Vector2, options:Dictionary={}):
	if player.remaining_moves > 0:
		var move = grid.try_move(from, to, options)
		if move:
			player.remaining_moves -= 1
		if player.remaining_moves <= 0:
			out_of_moves.emit()
