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
	assert_false(game.started)
	assert_eq(game.player, null)
	game.set_seed("a")
	game.start()
	assert_true(game.started)
	assert_eq(game.player.tint, Enum.Tint.RED)

func test_roll_die_sets_moves():
	var game = GameState.new()
	game.set_seed("a")
	game.start()
	game.roll_die()
	assert_eq(game.moves, 2)

func test_roll_die_sets_daisy_card():
	var game = GameState.new()
	game.set_seed("a")
	game.start()
	assert_false(game.can_draw_daisy)
	game.roll_die()
	assert_true(game.can_draw_daisy)
	
func test_roll_die_sets_cow_placement():
	var game = GameState.new()
	game.set_seed("b")
	game.start()
	assert_false(game.can_place_cow)
	game.roll_die()
	assert_true(game.can_place_cow)
	
func test_next_turn():
	var game = GameState.new()
	game.set_seed("a")
	game.start()
	assert_eq(game.player.tint, Enum.Tint.RED)
	game.next_turn()
	assert_eq(game.player.tint, Enum.Tint.GREEN)
	game.next_turn()
	assert_eq(game.player.tint, Enum.Tint.RED)
