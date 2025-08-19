extends GutTest

func test_die_rolls_between_1_and_6():
	var game = GameState.new()
	var in_range = true
	for i in range(1000):
		var num = game.roll_die()
		if num < 1 or num > 6:
			in_range = false
	assert_true(in_range)
	
func test_start_sets_values():
	var game = GameState.new()
	game.add_four_players()
	assert_false(game.started)
	assert_eq(game.player, null)
	game.set_seed("a")
	game.start()
	assert_true(game.started)
	assert_eq(game.player.tints, [Enum.Tint.RED])

func test_roll_die_sets_moves():
	var game = GameState.new()
	game.set_seed("c")
	game.add_four_players()
	game.start()
	game.roll_die()
	assert_eq(game.moves, 2)

func test_roll_die_sets_daisy_card():
	var game = GameState.new()
	game.set_seed("c")
	game.add_four_players()
	game.start()
	assert_false(game.can_draw_daisy)
	game.roll_die()
	assert_true(game.can_draw_daisy)
	
func test_roll_die_sets_cow_placement():
	var game = GameState.new()
	game.set_seed("b")
	game.add_four_players()
	game.start()
	assert_false(game.can_place_cow)
	game.roll_die()
	assert_true(game.can_place_cow)
	
func test_next_turn():
	var game = GameState.new()
	game.add_player([Enum.Tint.RED, Enum.Tint.BLUE])
	game.add_player([Enum.Tint.GREEN, Enum.Tint.YELLOW])
	game.start()
	game.set_seed("a")
	assert_eq(game.player.tints, [Enum.Tint.RED,Enum.Tint.BLUE])
	game.next_turn()
	assert_eq(game.player.tints, [Enum.Tint.GREEN, Enum.Tint.YELLOW])
	game.next_turn()
	assert_eq(game.player.tints, [Enum.Tint.RED,Enum.Tint.BLUE])
	
func test_draw_daisy_card():
	var game = GameState.new()
	game.add_four_players()
	game.set_seed("a")
	game.start()
	var card = game.draw_daisy_card()
	assert_eq(card.id, 3)
	assert_eq(game.player.cards[0].id, 3)
	
func test_draw_daisy_card_next_turn():
	var game = GameState.new()
	game.add_four_players()
	game.set_seed("a")
	game.start()
	game.draw_daisy_card()
	assert_eq(game.players[0].cards[0].id, 3)
	game.next_turn()
	game.draw_daisy_card()
	assert_eq(game.players[0].cards[0].id, 3)
	assert_eq(game.players[1].cards[0].id, 8)

func test_play_daisy_card_no_choices():
	var game = GameState.new()
	game.add_four_players()
	game.set_seed("b")
	game.start()
	var card = game.draw_daisy_card()
	assert_eq(game.player.cards[0].id, 5)
	game.select_card(card)
	assert_eq(game.card_choices[0].label, "avoid consequences")
	assert_eq(game.card_choices[1].label, "add 2 moves")
