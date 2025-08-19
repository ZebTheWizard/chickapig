class_name DaisyDeck extends Deck

func _init():
	super([
		Card.new({
			"description": "After you roll and move, relocate a poop to any open square and roll again.",
			"fine_print": "If there are no poops on the board you can still roll again.",
			"effect": {
				"type": "after_roll",
				"handle": _handle_relocate_poop_and_reroll
			}
		}),
		Card.new({
			"description": "After you roll and move, relocate a poop to any open square and roll again.",
			"fine_print": "If there are no poops on the board you can still roll again.",
			"effect": {
				"type": "after_roll",
				"handle": _handle_relocate_poop_and_reroll
			}
		}),
		Card.new({
			"description": "Free flyover: you may fly over one chickapig, hay bale, or cow.",
			"fine_print": "This move may happen at any point during your turn and counts as one of your moves.",
			"effect": {
				"type": "move_override",
				"handle": _handle_flyover
			}
		}),
		Card.new({
			"description": "Free flyover: you may fly over one chickapig, hay bale, or cow.",
			"fine_print": "This move may happen at any point during your turn and counts as one of your moves.",
			"effect": {
				"type": "move_override",
				"handle": _handle_flyover
			}
		}),
		Card.new({
			"description": "Avoid the consequences of a poop -OR- add 2 moves to any roll.",
			"fine_print": "",
			"effect": {
				"type": "end_of_turn",
				"handle": _avoid_poop_or_add_moves,
				"choices": [
					{
						"id":1,
						"label": "avoid consequences"
					},
					{
						"id":2,
						"label": "add 2 moves"
					}
				]
			}
		}),
		Card.new({
			"description": "Avoid the consequences of a poop -OR- add 2 moves to any roll.",
			"fine_print": "",
			"effect": {
				"type": "end_of_turn",
				"handle": _avoid_poop_or_add_moves,
				"choices": [
					{
						"id":1,
						"label": "avoid consequences"
					},
					{
						"id":2,
						"label": "add 2 moves"
					}
				]
			}
		}),
		Card.new({
			"description": "Shuffle this daisy card back into the deck and take a daisy card from any opponent -OR- add 2 moves to any roll.",
			"fine_print": "",
			"effect": {
				"type": "anytime",
				"handle": _shuffle_daisy_or_add_moves
			}
		}),
		Card.new({
			"description": "Double a roll of your choice.",
			"fine_print": "",
			"effect": {
				"type": "anytime",
				"handle": _double_roll
			}
		}),
		Card.new({
			"description": "Move an opponent's piece of your choice one legal move (chickapig or hay bale).",
			"fine_print": "This move may happen at any point during your turn and does not count as one of your moves.",
			"effect": {
				"type": "anytime",
				"handle": _move_opponent_piece
			}
		})
	])

func _handle_flyover(game:GameState):
	pass

func _handle_relocate_poop_and_reroll(game: GameState):
	pass
	
func _avoid_poop_or_add_moves(game:GameState):
	pass

func _shuffle_daisy_or_add_moves(game:GameState):
	pass
	
func _double_roll(game:GameState):
	pass
	
func _move_opponent_piece(game:GameState):
	pass
