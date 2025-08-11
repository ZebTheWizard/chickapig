class_name PoopDeck extends Deck

func _init():
	super([
		Card.new({
			"description": "Don't bother rolling! Your next turn is 2 moves.",
			"fine_print": "No, you can't use this turn to take a Daisy Card.",
			"effect": {
				"type": "roll_override",
				"handle": _next_turn_2_moves
			}
		}),
		Card.new({
			"description": "Don't bother rolling! Your next turn is 2 moves.",
			"fine_print": "No, you can't use this turn to take a Daisy Card.",
			"effect": {
				"type": "roll_override",
				"handle": _next_turn_2_moves
			}
		}),
		Card.new({
			"description": "Take one chickapig out of your pen and place it on one of your starting positions.",
			"fine_print": "",
			"effect": {
				"type": "immediate",
				"handle": _restore_chickapig
			}
		}),
		Card.new({
			"description": "Take one chickapig out of your pen and place it on one of your starting positions.",
			"fine_print": "",
			"effect": {
				"type": "immediate",
				"handle": _restore_chickapig
			}
		}),
		Card.new({
			"description": "Next player moves one of your pieces one legal move (chickapig or hay bale).",
			"fine_print": "This move happens before that player rolls.",
			"effect": {
				"type": "before_roll",
				"handle": _move_piece
			}
		}),
		Card.new({
			"description": "Next player moves one of your pieces one legal move (chickapig or hay bale).",
			"fine_print": "This move happens before that player rolls.",
			"effect": {
				"type": "before_roll",
				"handle": _move_piece
			}
		}),
		Card.new({
			"description": "If you have a daisy card, shuffle it back into the deck.",
			"fine_print": "",
			"effect": {
				"type": "immediate",
				"handle": _lose_daisy_card
			}
		}),
		Card.new({
			"description": "Lose your next turn.",
			"fine_print": "",
			"effect": {
				"type": "turn_override",
				"handle": _lose_next_turn
			}
		}),
		Card.new({
			"description": "Lose your next turn.",
			"fine_print": "",
			"effect": {
				"type": "turn_override",
				"handle": _lose_next_turn
			}
		}),
	])

func _next_turn_2_moves(game:GameState):
	pass
	
func _restore_chickapig(game:GameState):
	pass
	
func _move_piece(game:GameState):
	pass
	
func _lose_daisy_card(game:GameState):
	pass
	
func _lose_next_turn(game:GameState):
	pass
