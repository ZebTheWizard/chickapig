extends GutTest

func test_make_board():
	var grid = BoardGrid.new(3, 2)
	assert_eq_deep(grid.to_array(), [
		[[Enum.Tile.NIL, Enum.Tint.NONE], [Enum.Tile.NIL, Enum.Tint.NONE], [Enum.Tile.NIL, Enum.Tint.NONE]],
		[[Enum.Tile.NIL, Enum.Tint.NONE], [Enum.Tile.NIL, Enum.Tint.NONE], [Enum.Tile.NIL, Enum.Tint.NONE]],
	])

func test_set_board():
	var grid = BoardGrid.new(3, 2)
	grid.set_tile(1,0, Enum.Tile.PIG)
	assert_eq_deep(grid.to_array(), [
		[[Enum.Tile.NIL, Enum.Tint.NONE], [Enum.Tile.PIG, Enum.Tint.NONE], [Enum.Tile.NIL, Enum.Tint.NONE]],
		[[Enum.Tile.NIL, Enum.Tint.NONE], [Enum.Tile.NIL, Enum.Tint.NONE], [Enum.Tile.NIL, Enum.Tint.NONE]],
	])
	
func test_get_board_tile():
	var grid = BoardGrid.new(3, 2)
	grid.set_tile(1,0, Enum.Tile.POO)
	assert_eq_deep(grid.get_tile(1,0).type, Enum.Tile.POO)

func test_get_available_moves_pig_1():
	var grid = BoardGrid.new(3, 2)
	grid.set_tile(1,0, Enum.Tile.PIG)
	var moves = grid.get_available_moves(1,0)
	assert_eq_deep(moves, [
		[2,0], # right
		[1,1], # bttom
		[0,0], # left
	])
	
func test_get_available_moves_pig_2():
	var grid = BoardGrid.new(5, 5)
	grid.set_tile(2,2, Enum.Tile.PIG)
	var moves = grid.get_available_moves(2,2)
	assert_eq_deep(moves, [
		[2,0], # top
		[4,2], # right
		[2,4], # bottom
		[0,2], # left
	])
	
func test_get_available_moves_pig_3():
	var grid = BoardGrid.new(5, 5)
	grid.set_tile(3,2, Enum.Tile.PIG)
	grid.set_tile(2,2, Enum.Tile.POO)
	grid.set_tile(1,2, Enum.Tile.HAY)
	var moves = grid.get_available_moves(3,2)
	assert_eq_deep(moves, [
		[3,0], # top
		[4,2], # right
		[3,4], # bottom
		[2,2], # left
	])

func test_get_available_moves_pig_4():
	var grid = BoardGrid.new(5, 5)
	grid.set_tile(2,2, Enum.Tile.PIG)
	grid.set_yay(4,2, [Enum.Direction.RIGHT])
	var moves = grid.get_available_moves(2,2)
	assert_eq_deep(moves, [
		[2,0], # top
		[4,2], # right
		[2,4], # bottom
		[0,2], # left
	])
	
func test_entering_yay_illegally_1():
	var grid = BoardGrid.new(5, 5)
	grid.set_yay(4,2, [Enum.Direction.RIGHT])
	var result = grid._is_entering_yay_illegally(4,2, Enum.Direction.RIGHT)
	assert_false(result)
	
func test_entering_yay_illegally_2():
	var grid = BoardGrid.new(5, 5)
	grid.set_yay(4,2, [Enum.Direction.RIGHT])
	var result = grid._is_entering_yay_illegally(4,2, Enum.Direction.TOP)
	assert_true(result)
	
func test_entering_yay_illegally_3():
	var grid = BoardGrid.new(5, 5)
	grid.set_yay(4,2, [Enum.Direction.RIGHT, Enum.Direction.TOP])
	assert_false(grid._is_entering_yay_illegally(4,2, Enum.Direction.TOP))
	assert_false(grid._is_entering_yay_illegally(4,2, Enum.Direction.RIGHT))

func test_exiting_yay_illegally_1():
	var grid = BoardGrid.new(5, 5)
	grid.set_yay(4,4, [Enum.Direction.RIGHT, Enum.Direction.BOTTOM])
	grid.set_yay(4,3, [Enum.Direction.RIGHT, Enum.Direction.TOP])
	assert_false(grid._is_exiting_yay_illegally(4,4, Enum.Direction.TOP))
	assert_true(grid._is_exiting_yay_illegally(4,3, Enum.Direction.TOP))

func test_get_available_moves_pig_5():
	var grid = BoardGrid.new(5, 5)
	grid.set_tile(4,4, Enum.Tile.PIG)
	grid.set_yay(4,2, [Enum.Direction.RIGHT])
	var moves = grid.get_available_moves(4,4)
	assert_eq_deep(moves, [
		[4,3], # top
		[0,4], # left
	])
	
func test_get_available_moves_pig_6():
	var grid = BoardGrid.new(5, 5)
	grid.set_tile(4,4, Enum.Tile.PIG)
	grid.set_tile(3,4, Enum.Tile.HAY)
	var moves = grid.get_available_moves(4,4, {"can_jump":false})
	assert_eq_deep(moves, [
		[4,0], # top
	])
	
	moves = grid.get_available_moves(4,4, {"can_jump":true})
	assert_eq_deep(moves, [
		[4,0], # top
		[0,4], # left
	])

func test_get_available_moves_pig_7():
	var grid = BoardGrid.new(5, 5)
	grid.set_tile(4,4, Enum.Tile.PIG)
	grid.set_tile(3,4, Enum.Tile.COW)
	grid.set_tile(2,4, Enum.Tile.HAY)
	var moves = grid.get_available_moves(4,4, {"can_jump":true})
	assert_eq_deep(moves, [
		[4,0], # top
	])
	
func test_try_move_pig_1():
	var grid = BoardGrid.new(5, 5)
	grid.set_tile(4,4, Enum.Tile.PIG)
	grid.set_tile(3,4, Enum.Tile.COW)
	assert_false(grid.try_move(Vector2(4,4), Vector2(3,4), {"can_jump":true}))
	assert_true(grid.try_move(Vector2(4,4), Vector2(0,4), {"can_jump":true}))
	assert_true(grid.try_move(Vector2(0,4), Vector2(0,0), {"can_jump":true}))
	assert_true(grid.get_tile(4,4).type == Enum.Tile.NIL)
	assert_true(grid.get_tile(0,4).type == Enum.Tile.NIL)

func test_get_available_moves_hay_1():
	var grid = BoardGrid.new(3, 2)
	grid.set_tile(1,0, Enum.Tile.HAY)
	var moves = grid.get_available_moves(1,0)
	assert_eq_deep(moves, [
		[2,0], # right
		[1,1], # bottom
		[0,0], # left
	])

func test_get_available_moves_hay_2():
	var grid = BoardGrid.new(5, 5)
	grid.set_tile(2,2, Enum.Tile.HAY)
	var moves = grid.get_available_moves(2,2)
	assert_eq_deep(moves, [
		[2,1], # top
		[3,2], # right
		[2,3], # bottom
		[1,2], # left
	])
	
func test_get_available_moves_hay_3():
	var grid = BoardGrid.new(5, 5)
	grid.set_tile(3,2, Enum.Tile.HAY)
	grid.set_tile(2,2, Enum.Tile.POO)
	grid.set_tile(1,2, Enum.Tile.HAY)
	var moves = grid.get_available_moves(3,2)
	assert_eq_deep(moves, [
		[3,1], # top
		[4,2], # right
		[3,3], # bottom
		[2,2], # left
	])
#
func test_get_available_moves_hay_4():
	var grid = BoardGrid.new(5, 5)
	grid.set_tile(3,2, Enum.Tile.HAY)
	grid.set_yay(4,2, [Enum.Direction.RIGHT])
	var moves = grid.get_available_moves(3,2)
	assert_eq_deep(moves, [
		[3,1], # top
		[4,2], # right
		[3,3], # bottom
		[2,2], # left
	])

func test_get_available_moves_pig_8():
	var grid = BoardGrid.new(5, 5)
	grid.set_tile(3,2, Enum.Tile.PIG)
	grid.set_tile(2,2, Enum.Tile.POO)
	grid.set_tile(1,2, Enum.Tile.HAY)
	var moves = grid.get_available_moves(3,2, {"verbose": true})
	assert_eq_deep(moves, [
		[3,0, {}], # top
		[4,2, {}], # right
		[3,4, {}], # bottom
		[2,2, {"poo":[[2,2]]}], # left
	])

func test_try_move_pig_2():
	var grid = BoardGrid.new(5, 5)
	grid.set_tile(4,4, Enum.Tile.PIG)
	grid.set_tile(4,3, Enum.Tile.HAY)
	grid.set_yay(0,4, [Enum.Direction.LEFT])
	# move to yay square
	assert_true(grid.try_move(Vector2(4,4), Vector2(0,4)))
	
func test_try_move_pig_3():
	var grid = BoardGrid.new(5, 5)
	grid.set_tile(4,3, Enum.Tile.PIG, Enum.Tint.NONE)
	grid.set_tile(4,4, Enum.Tile.PIG, Enum.Tint.RED)
	grid.set_yay(0,4, [Enum.Direction.LEFT])
	grid.set_yay(0,3, [Enum.Direction.LEFT])
	# move to yay square
	assert_true(grid.try_move(Vector2(4,4), Vector2(0,4), {"tint": Enum.Tint.RED}))

func test_try_move_pig_4():
	var grid = BoardGrid.new(5, 5)
	#grid.set_tile(4,3, Enum.Tile.PIG, Enum.Tint.NONE)
	grid.set_tile(4,4, Enum.Tile.PIG, Enum.Tint.RED)
	grid.set_yay(0,4, [Enum.Direction.LEFT, Enum.Direction.BOTTOM])
	grid.set_yay(0,3, [Enum.Direction.LEFT, Enum.Direction.TOP])
	# move to yay square
	assert_true(grid.try_move(Vector2(4,4), Vector2(0,4), {"tint": Enum.Tint.RED}))
	var moves = grid.get_available_moves(0,4, {"tint": Enum.Tint.RED})
	assert_eq_deep(moves, [
		[0,3],
		[4,4]
	])

func test_try_move_pig_5():
	var grid = BoardGrid.new(5, 5)
	grid.set_tile(4,3, Enum.Tile.PIG, Enum.Tint.NONE)
	grid.set_tile(4,4, Enum.Tile.PIG, Enum.Tint.RED)
	grid.set_yay(0,4, [Enum.Direction.LEFT])
	# move to yay square
	assert_false(grid.try_move(Vector2(4,4), Vector2(0,4), {"tint": Enum.Tint.RED}))

func test_get_available_moves_cow_1():
	var grid = BoardGrid.new(3, 2)
	grid.set_tile(1,0, Enum.Tile.COW)
	var moves = grid.get_available_moves(1,0, {"cow": Enum.Cow.MOVE})
	assert_eq_deep(moves, [
		[2,0], # right
		[1,1], # bottom
		[0,0], # left
	])

func test_get_available_moves_cow_2():
	var grid = BoardGrid.new(5, 5)
	grid.set_tile(2,2, Enum.Tile.COW)
	var moves = grid.get_available_moves(2,2, {"cow": Enum.Cow.MOVE})
	assert_eq_deep(moves, [
		[2,1], # top
		[3,2], # right
		[2,3], # bottom
		[1,2], # left
	])
	
func test_get_available_moves_cow_3():
	var grid = BoardGrid.new(5, 5)
	grid.set_tile(3,2, Enum.Tile.COW)
	grid.set_tile(2,2, Enum.Tile.POO)
	grid.set_tile(1,2, Enum.Tile.HAY)
	var moves = grid.get_available_moves(3,2, {"cow": Enum.Cow.MOVE})
	assert_eq_deep(moves, [
		[3,1], # top
		[4,2], # right
		[3,3], # bottom
		[2,2], # left
	])
#
func test_get_available_moves_cow_4():
	var grid = BoardGrid.new(5, 5)
	grid.set_tile(3,2, Enum.Tile.COW)
	grid.set_yay(4,2, [Enum.Direction.RIGHT])
	var moves = grid.get_available_moves(3,2, {"cow": Enum.Cow.MOVE})
	assert_eq_deep(moves, [
		[3,1], # top
		[4,2], # right
		[3,3], # bottom
		[2,2], # left
	])

func test_get_available_moves_cow_5():
	var grid = BoardGrid.new(3, 3)
	grid.set_tile(1,1, Enum.Tile.COW)
	var moves = grid.get_available_moves(1,1, {"cow": Enum.Cow.PLACE})
	assert_eq_deep(moves, [
		[0,0], 
		[0,1],
		[0,2], 
		[1,0],
		[1,2],
		[2,0],
		[2,1],
		[2,2],
	])

func test_get_available_moves_cow_6():
	var grid = BoardGrid.new(3, 3)
	grid.set_cow(1,1)
	assert_true(grid.try_move(Vector2(1,1), Vector2(1,2), {"cow": Enum.Cow.MOVE}))
	assert_eq(grid.get_tile(1,1).type, Enum.Tile.POO)

func test_get_available_moves_cow_7():
	var grid = BoardGrid.new(3, 3)
	grid.set_cow(1,1)
	grid.set_yay(0,1, [Enum.Direction.LEFT])
	grid.merge_tile(0,1, Enum.Tile.POO)
	var moves = grid.get_available_moves(1,1, {"cow": Enum.Cow.MOVE})
	assert_eq_deep(moves, [
		[1,0], # top
		[2,1], # right
		[1,2], # bottom
		[0,1], # left
	])
	
func test_merge_tile():
	var grid = BoardGrid.new(3, 3)
	grid.set_tile(1,1, Enum.Tile.YAY)
	grid.merge_tile(1,1, Enum.Tile.POO)
	assert_ne(grid.get_tile(1,1).type, Enum.Tile.YAY)
	assert_ne(grid.get_tile(1,1).type, Enum.Tile.POO)
	assert_eq(grid.get_tile(1,1).type, Enum.Tile.YAY | Enum.Tile.POO)
	grid.unmerge_tile(1,1, Enum.Tile.POO)
	assert_eq(grid.get_tile(1,1).type, Enum.Tile.YAY)

func test_get_available_moves_tint_1():
	var grid = BoardGrid.new(3, 3)
	grid.set_tile(1,1, Enum.Tile.PIG, Enum.Tint.RED)
	var moves = grid.get_available_moves(1,1)
	assert_eq_deep(moves, [])
	
func test_get_available_moves_tint_2():
	var grid = BoardGrid.new(3, 3)
	grid.set_tile(1,1, Enum.Tile.PIG, Enum.Tint.RED)
	var moves = grid.get_available_moves(1,1, {"tint": Enum.Tint.RED})
	assert_eq_deep(moves, [
		[1,0],
		[2,1],
		[1,2],
		[0,1]
	])
	
func test_get_available_moves_hay_5():
	var grid = BoardGrid.new(3,3)
	grid.set_tile(2,1, Enum.Tile.HAY)
	grid.set_tile(0,2, Enum.Tile.HAY)
	grid.set_tile(0,0, Enum.Tile.PIG)
	assert_true(grid.try_move(Vector2(0,2), Vector2(1,2)))
	
func test_get_available_moves_hay_6():
	var grid = BoardGrid.new(3,3)
	grid.set_tile(2,1, Enum.Tile.HAY)
	grid.set_tile(0,2, Enum.Tile.HAY)
	grid.set_tile(0,0, Enum.Tile.PIG)
	grid.set_yay(2,2, [Enum.Direction.RIGHT])
	assert_false(grid.try_move(Vector2(0,2), Vector2(1,2)))

# check for undo
func test_get_available_moves_hay_7():
	var grid = BoardGrid.new(3,3)
	grid.set_tile(2,1, Enum.Tile.HAY)
	grid.set_tile(0,2, Enum.Tile.HAY)
	grid.set_tile(0,0, Enum.Tile.PIG)
	grid.set_yay(2,2, [Enum.Direction.RIGHT])
	grid.try_move(Vector2(0,2), Vector2(1,2))
	assert_eq(grid.get_tile(0,2).type, Enum.Tile.HAY)
	assert_eq(grid.get_tile(1,2).type, Enum.Tile.NIL)
	
# put hay on single yay
func test_get_available_moves_hay_8():
	var grid = BoardGrid.new(3,3)
	grid.set_tile(2,1, Enum.Tile.HAY)
	grid.set_tile(0,2, Enum.Tile.HAY)
	grid.set_tile(0,0, Enum.Tile.PIG)
	grid.set_yay(2,2, [Enum.Direction.RIGHT])
	assert_false(grid.try_move(Vector2(2,1), Vector2(2,2)))
	
# put hay on double yay
func test_get_available_moves_hay_9():
	var grid = BoardGrid.new(5,5)
	grid.set_tile(4,2, Enum.Tile.HAY)
	grid.set_tile(0,0, Enum.Tile.PIG)
	grid.set_yay(4,3, [Enum.Direction.RIGHT])
	grid.set_yay(4,4, [Enum.Direction.RIGHT])
	assert_true(grid.try_move(Vector2(4,2), Vector2(4,3)))
