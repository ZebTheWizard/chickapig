extends GutTest

#region Board initialization
func test_make_board():
	var grid = BoardState.new(1,1)
	assert_eq(grid.get_tile(0,0).piece.type, Enum.Piece.NIL)
	
func test_set_piece():
	var grid = BoardState.new(1,1)
	grid.set_piece(0,0, Enum.Piece.PIG, Enum.Tint.RED)
	assert_eq(grid.get_tile(0,0).piece.type, Enum.Piece.PIG)
	assert_eq(grid.get_tile(0,0).piece.tint, Enum.Tint.RED)
#endregion
	
#region PIG: Get available moves
func test_gam_pig_on_1_by_1_is_empty():
	var grid = BoardState.new(1,1)
	grid.set_piece(0,0, Enum.Piece.PIG)
	var moves = grid.get_available_moves(0,0)
	assert_eq_deep(moves, [])
	
func test_gam_pig_2_by_1_has_1_move():
	var grid = BoardState.new(2,1)
	grid.set_piece(0,0, Enum.Piece.PIG)
	var moves = grid.get_available_moves(0,0)
	assert_eq_deep(moves, [
		[1,0]
	])
	
func test_gam_pig_is_blocked_by_other_pieces():
	var grid = BoardState.new(3,3)
	grid.set_piece(0,0, Enum.Piece.HAY)
	grid.set_piece(1,0, Enum.Piece.PIG)
	grid.set_piece(2,0, Enum.Piece.COW)
	var moves = grid.get_available_moves(1,0)
	assert_eq_deep(moves, [
		[1,2]
	])
	
func test_gam_pig_is_blocked_by_barriers():
	var grid = BoardState.new(3,3)
	grid.set_barriers(0,0, [Enum.Direction.RIGHT])
	grid.set_piece(1,0, Enum.Piece.PIG)
	grid.set_barriers(2,0, [Enum.Direction.LEFT])
	var moves = grid.get_available_moves(1,0)
	assert_eq_deep(moves, [
		[1,2]
	])

func test_gam_pig_is_blocked_by_barriers_on_exit():
	var grid = BoardState.new(5,5)
	grid.set_barriers(1,0, [Enum.Direction.LEFT])
	grid.set_piece(2,0, Enum.Piece.PIG)
	grid.set_barriers(3,0, [Enum.Direction.RIGHT])
	var moves = grid.get_available_moves(2,0)
	assert_eq_deep(moves, [
		[3,0],
		[2,4],
		[1,0],
	])
	
func test_gam_pig_jump_over_hay():
	var grid = BoardState.new(5,1)
	grid.set_piece(0,0, Enum.Piece.PIG)
	grid.set_piece(2,0, Enum.Piece.HAY)
	var moves = grid.get_available_moves(0,0)
	assert_eq_deep(moves, [
		[1,0]
	])
	moves = grid.get_available_moves(0,0, {"can_jump": true})
	assert_eq_deep(moves, [
		[4,0]
	])
	
func test_gam_pig_cannot_enter_opposing_yay():
	var grid = BoardState.new(5,1)
	grid.set_piece(0,0, Enum.Piece.PIG)
	grid.set_terrain(4,0, Enum.Terrain.YAY)
	var moves = grid.get_available_moves(0,0)
	assert_eq_deep(moves, [
		[4,0]
	])
	grid.set_terrain(4,0, Enum.Terrain.YAY, Enum.Tint.RED)
	moves = grid.get_available_moves(0,0)
	assert_eq_deep(moves, [
		[3,0]
	])

#endregion

#region HAY: Get available moves

func test_gam_hay_3_by_1_has_1_move():
	var grid = BoardState.new(3,1)
	grid.set_piece(0,0, Enum.Piece.HAY)
	var moves = grid.get_available_moves(0,0)
	assert_eq_deep(moves, [
		[1,0]
	])

func test_gam_hay_is_blocked_by_other_pieces():
	var grid = BoardState.new(3,3)
	grid.set_piece(0,0, Enum.Piece.PIG)
	grid.set_piece(1,0, Enum.Piece.HAY)
	grid.set_piece(2,0, Enum.Piece.COW)
	var moves = grid.get_available_moves(1,0)
	assert_eq_deep(moves, [
		[1,1]
	])

func test_gam_hay_is_not_blocked_by_barriers():
	var grid = BoardState.new(3,3)
	grid.set_barriers(0,0, [Enum.Direction.RIGHT])
	grid.set_piece(1,0, Enum.Piece.HAY)
	grid.set_barriers(2,0, [Enum.Direction.LEFT])
	var moves = grid.get_available_moves(1,0)
	assert_eq_deep(moves, [
		[2,0],
		[1,1],
		[0,0],
	])

func test_gam_hay_is_not_blocked_by_barriers_on_exit():
	var grid = BoardState.new(5,5)
	grid.set_barriers(2,0, [Enum.Direction.LEFT])
	grid.set_piece(2,0, Enum.Piece.HAY)
	grid.set_barriers(3,0, [Enum.Direction.RIGHT])
	var moves = grid.get_available_moves(2,0)
	assert_eq_deep(moves, [
		[3,0],
		[2,1],
		[1,0],
	])

func test_gam_hay_is_blocked_by_pen():
	var grid = BoardState.new(3,3)
	grid.set_barriers(0,0, [Enum.Direction.RIGHT])
	grid.set_terrain(0,0, Enum.Terrain.PEN)
	grid.set_piece(1,0, Enum.Piece.HAY)
	grid.set_barriers(2,0, [Enum.Direction.LEFT])
	grid.set_terrain(2,0, Enum.Terrain.PEN)
	var moves = grid.get_available_moves(1,0)
	assert_eq_deep(moves, [
		[1,1],
	])
	
#endregion

#region COW-move: Get available moves
func test_gam_cow_3_by_1_has_1_move():
	var grid = BoardState.new(3,1)
	grid.set_piece(0,0, Enum.Piece.COW)
	var moves = grid.get_available_moves(0,0, {"cow": Enum.Cow.MOVE})
	assert_eq_deep(moves, [
		[1,0]
	])

func test_gam_cow_is_blocked_by_other_pieces():
	var grid = BoardState.new(3,3)
	grid.set_piece(0,0, Enum.Piece.PIG)
	grid.set_piece(1,0, Enum.Piece.COW)
	grid.set_piece(2,0, Enum.Piece.COW)
	var moves = grid.get_available_moves(1,0, {"cow": Enum.Cow.MOVE})
	assert_eq_deep(moves, [
		[1,1]
	])

func test_gam_cow_is_not_blocked_by_barriers():
	var grid = BoardState.new(3,3)
	grid.set_barriers(0,0, [Enum.Direction.RIGHT])
	grid.set_piece(1,0, Enum.Piece.COW)
	grid.set_barriers(2,0, [Enum.Direction.LEFT])
	var moves = grid.get_available_moves(1,0, {"cow": Enum.Cow.MOVE})
	assert_eq_deep(moves, [
		[2,0],
		[1,1],
		[0,0],
	])

func test_gam_cow_is_not_blocked_by_barriers_on_exit():
	var grid = BoardState.new(5,5)
	grid.set_barriers(2,0, [Enum.Direction.LEFT])
	grid.set_piece(2,0, Enum.Piece.COW)
	grid.set_barriers(3,0, [Enum.Direction.RIGHT])
	var moves = grid.get_available_moves(2,0, {"cow": Enum.Cow.MOVE})
	assert_eq_deep(moves, [
		[3,0],
		[2,1],
		[1,0],
	])

func test_gam_cow_is_blocked_by_pen():
	var grid = BoardState.new(3,3)
	grid.set_barriers(0,0, [Enum.Direction.RIGHT])
	grid.set_terrain(0,0, Enum.Terrain.PEN)
	grid.set_piece(1,0, Enum.Piece.COW)
	grid.set_barriers(2,0, [Enum.Direction.LEFT])
	grid.set_terrain(2,0, Enum.Terrain.PEN)
	var moves = grid.get_available_moves(1,0, {"cow": Enum.Cow.MOVE})
	assert_eq_deep(moves, [
		[1,1],
	])

#endregion

#region COW-placement: Get available moves
func test_gam_cow_placement_3_by_1_has_1_move():
	var grid = BoardState.new(3,1)
	grid.set_piece(0,0, Enum.Piece.COW)
	var moves = grid.get_available_moves(0,0, {"cow": Enum.Cow.PLACE})
	assert_eq_deep(moves, [
		[1,0],
		[2,0]
	])
	
func test_gam_cow_placement_is_blocked_by_pen():
	var grid = BoardState.new(3,3)
	grid.set_barriers(0,0, [Enum.Direction.RIGHT])
	grid.set_terrain(0,0, Enum.Terrain.PEN)
	grid.set_piece(1,0, Enum.Piece.COW)
	grid.set_barriers(2,0, [Enum.Direction.LEFT])
	grid.set_terrain(2,0, Enum.Terrain.PEN)
	var moves = grid.get_available_moves(1,0, {"cow": Enum.Cow.PLACE})
	assert_eq_deep(moves, [
		[0,1],
		[0,2],
		[1,1],
		[1,2],
		[2,1],
		[2,2],
	])
#endregion

#region POO: Get available moves
func test_gam_pig_slide_through_poo():
	var grid = BoardState.new(3,1)
	grid.set_piece(0,0, Enum.Piece.PIG)
	grid.set_hazard(1,0, Enum.Hazard.POO)
	var moves = grid.get_available_moves(0,0, {"verbose": true})
	assert_eq_deep(moves,[
		[2,0, {"poo": [[1,0]]}]
	])
	
func test_gam_hay_cover_poo():
	var grid = BoardState.new(3,1)
	grid.set_piece(0,0, Enum.Piece.HAY)
	grid.set_hazard(1,0, Enum.Hazard.POO)
	var moves = grid.get_available_moves(0,0, {"verbose": true})
	assert_eq_deep(moves,[
		[1,0, {"poo": [[1,0]]}]
	])
	
func test_gam_cow_cover_poo():
	var grid = BoardState.new(3,1)
	grid.set_piece(0,0, Enum.Piece.COW)
	grid.set_hazard(1,0, Enum.Hazard.POO)
	var moves = grid.get_available_moves(0,0, {"verbose": true, "cow": Enum.Cow.MOVE})
	assert_eq_deep(moves,[
		[1,0, {}]
	])
#endregion

#region _bfs_can_reach_target	
func test_bfs_true_open_lane():
	var grid = BoardState.new(3,3)
	grid.set_piece(0,0, Enum.Piece.PIG)
	grid.set_terrain(2,2, Enum.Terrain.YAY)
	grid.set_barriers(2,2, [Enum.Direction.TOP])
	assert_true(grid._bfs_can_reach_target(Vector2i(0,0), Vector2i(2,2)))
	
func test_bfs_true_no_path_but_open_goal():
	var grid = BoardState.new(3,3)
	grid.set_piece(0,0, Enum.Piece.PIG)
	grid.set_piece(0,1, Enum.Piece.HAY)
	grid.set_terrain(2,2, Enum.Terrain.YAY)
	grid.set_barriers(2,2, [Enum.Direction.TOP])
	assert_true(grid._bfs_can_reach_target(Vector2i(0,0), Vector2i(2,2)))

func test_bfs_false_blocked_by_hay():
	var grid = BoardState.new(3,3)
	grid.set_piece(0,0, Enum.Piece.PIG)
	grid.set_piece(1,2, Enum.Piece.HAY)
	grid.set_terrain(2,2, Enum.Terrain.YAY)
	grid.set_barriers(2,2, [Enum.Direction.TOP])
	assert_false(grid._bfs_can_reach_target(Vector2i(0,0), Vector2i(2,2)))

#endregion

#region try_move
func test_tm_true_pig_1_by_3():
	var grid = BoardState.new(3,1)
	grid.set_piece(0,0, Enum.Piece.PIG)
	assert_true(grid.try_move(Vector2i(0,0), Vector2i(2,0)) != [])
	
func test_tm_false_pig_1_by_3():
	var grid = BoardState.new(3,1)
	grid.set_piece(0,0, Enum.Piece.PIG)
	assert_false(grid.try_move(Vector2i(0,0), Vector2i(1,0)) != [])

func test_tm_true_hay_not_blocks_yay():
	var grid = BoardState.new(3,3)
	grid.set_piece(0,0, Enum.Piece.PIG)
	grid.set_piece(1,1, Enum.Piece.HAY)
	grid.set_terrain(2,2, Enum.Terrain.YAY)
	grid.set_barriers(2,2, [Enum.Direction.TOP])
	assert_true(grid.try_move(Vector2i(1,1), Vector2i(1,0)) != [])
	
func test_tm_false_hay_blocks_yay():
	var grid = BoardState.new(3,3)
	grid.set_piece(0,0, Enum.Piece.PIG)
	grid.set_piece(1,1, Enum.Piece.HAY)
	grid.set_terrain(2,2, Enum.Terrain.YAY)
	grid.set_barriers(2,2, [Enum.Direction.TOP])
	assert_false(grid.try_move(Vector2i(1,1), Vector2i(1,2)) != [])
	
func test_tm_returns_verbose_info():
	var grid = BoardState.new(3,3)
	grid.set_piece(0,0, Enum.Piece.PIG)
	grid.set_hazard(0,1, Enum.Hazard.POO)
	grid.set_terrain(2,2, Enum.Terrain.YAY)
	grid.set_barriers(2,2, [Enum.Direction.TOP])
	var move = grid.try_move(Vector2i(0,0), Vector2i(0,2), {"verbose":true})
	assert_eq_deep(move, [0,2, {"poo": [[0,1]]}])
	
func test_tm_false_one_yay_square():
	var grid = BoardState.new(3,3)
	grid.set_piece(0,0, Enum.Piece.PIG)
	grid.set_piece(2,1, Enum.Piece.HAY)
	grid.set_terrain(2,2, Enum.Terrain.YAY)
	grid.set_barriers(2,2, [Enum.Direction.TOP])
	assert_false(grid.try_move(Vector2i(2,1), Vector2i(2,2)) != [])

func test_tm_true_two_yay_squares():
	var grid = BoardState.new(3,3)
	grid.set_piece(0,0, Enum.Piece.PIG)
	grid.set_piece(2,0, Enum.Piece.HAY)
	grid.set_terrain(2,1, Enum.Terrain.YAY)
	grid.set_terrain(2,2, Enum.Terrain.YAY)
	grid.set_barriers(2,1, [Enum.Direction.TOP])
	grid.set_barriers(2,2, [Enum.Direction.BOTTOM])
	assert_true(grid.try_move(Vector2i(2,0), Vector2i(2,1)) != [])
	
func test_tm_two_yay_squares_through_poo():
	var grid = BoardState.new(3,3)
	grid.set_piece(0,0, Enum.Piece.PIG)
	grid.set_piece(2,0, Enum.Piece.HAY)
	grid.set_hazard(2,1, Enum.Hazard.POO)
	grid.set_terrain(2,1, Enum.Terrain.YAY)
	grid.set_terrain(2,2, Enum.Terrain.YAY)
	grid.set_barriers(2,1, [Enum.Direction.TOP])
	grid.set_barriers(2,2, [Enum.Direction.BOTTOM])
	var move = grid.try_move(Vector2i(2,0), Vector2i(2,1), {"verbose": true})
	assert_eq_deep(move, [2,1, {"poo": [[2,1]]}])
#endregion
