class_name BoardGridOld extends Resource

@export var rows:Array[Row]
var width
var height
var yays:Dictionary[String, Array]
var yay_positions:Dictionary[Enum.Tint, Array]
var poos:Array[Array]
var cow: Array
var cow_state: Enum.Cow = Enum.Cow.PEN

func _init(col_count:int, row_count:int) -> void:
	rows = []
	rows.resize(row_count)
	width = col_count
	height = row_count
	for i in range(row_count):
		rows[i] = Row.new(col_count)
	
func set_tile(column:int, row:int, value:int, tint=Enum.Tint.NONE):
	rows[row].set_tile(column, value, tint)
	
func merge_tile(column:int, row:int, value:int, tint:Enum.Tint=Enum.Tint.NONE):
	var tile = get_tile(column, row)
	set_tile(column, row, tile.type | value, tint)
	
func unmerge_tile(column:int, row:int, value:int, tint:Enum.Tint=Enum.Tint.NONE):
	var tile = get_tile(column, row)
	set_tile(column, row, tile.type & ~value, tint)
	
func flag_contains(flag:int, needle:int):
	return flag & needle != 0
	
func flag_missing(flag:int, needle:int):
	return flag & needle == 0
	
func get_tile(column:int, row:int) -> Tile:
	return rows[row].get_tile(column)
	
func get_piece(column:int, row:int) -> int:
	var tile = get_tile(column, row)
	return tile.type & ~Enum.Tile.YAY & ~Enum.Tile.POO
	
func set_yay(column:int, row:int, directions:Array[Enum.Direction], tint:Enum.Tint=Enum.Tint.NONE):
	yays.set(str(column, ":", row), directions)
	var positions = yay_positions.get(tint, [])
	positions.append(Vector2(column, row))
	yay_positions.set(tint, positions)
	set_tile(column, row, Enum.Tile.YAY)
	
func get_yay(column: int, row:int) -> Array[Enum.Direction]:
	return _get_yay_or_nil(column, row)
	
func _get_yay_or_nil(column: int, row:int):
	return yays.get(str(column, ':', row))

func set_cow(column:int, row:int):
	if cow:
		poos.append(cow)
	cow = [column, row]
	cow_state = Enum.Cow.PLACE
	set_tile(column, row, Enum.Tile.COW)

func try_move(from:Vector2, to:Vector2, options:Dictionary={}) -> bool:
	var moves = get_available_moves(from.x, from.y, options)
	var move = _moves_has(moves, to)
	if not move:
		return false
		
	var tile = get_tile(from.x, from.y)
	var next_tile = get_tile(to.x, to.y)
	var piece = get_piece(from.x, from.y)
	var last_cow_state = cow_state
	
	if flag_contains(tile.type, Enum.Tile.COW) and cow_state == Enum.Cow.PLACE:
		merge_tile(from.x, from.y, Enum.Tile.POO)
		unmerge_tile(from.x, from.y, Enum.Tile.COW)
		cow_state = Enum.Cow.MOVE
	else:
		merge_tile(from.x, from.y, Enum.Tile.NIL)
		unmerge_tile(from.x, from.y, piece)
		
	if flag_contains(tile.type, Enum.Tile.PIG) and flag_contains(next_tile.type, Enum.Tile.YAY) and tile.tint == next_tile.tint:
		pass
	else:
		merge_tile(to.x, to.y, piece, tile.tint)
	
	if not _is_goal_accessible():
		if flag_contains(tile.type, Enum.Tile.COW) and cow_state == Enum.Cow.PLACE:
			unmerge_tile(from.x, from.y, Enum.Tile.POO)
			merge_tile(from.x, from.y, Enum.Tile.COW)
			cow_state = Enum.Cow.MOVE
		else:
			unmerge_tile(from.x, from.y, Enum.Tile.NIL)
			merge_tile(from.x, from.y, piece, tile.tint)
			
		unmerge_tile(to.x, to.y, piece)
		
		return false
		
	return true

func _moves_has(moves:Array, coord:Vector2) -> bool:
	var found = false
	for move in moves:
		if move[0] == coord.x and move[1] == coord.y:
			found = true
			break

	return found

func get_available_moves(column:int, row:int, options:Dictionary={}) -> Array:
	var tile = get_tile(column, row)
	var piece = get_piece(column, row)
	var result = []
	if options.get('tint', Enum.Tint.NONE) == tile.tint:
		match piece:
			Enum.Tile.PIG:
				result = _get_available_pig_moves(column, row, options)
			Enum.Tile.HAY:
				result = _get_available_hay_moves(column, row, options)
			Enum.Tile.COW:
				result = _get_available_cow_moves(column, row, options)
			_:
				result = []
	return result
	
func _get_available_pig_moves(column:int, row:int, options:Dictionary={}) -> Array:
	var moves = {}
	var directions = Enum.Direction.values()
	var current_tile = get_tile(column, row)
	
	for d in directions:
		var jumped = false
		var direction = Enum.Directions[d]
		var nx = column + int(direction.x)
		var ny = row + int(direction.y)
		var poo = []
		
		while _is_in_bounds(nx, ny):
			if _is_entering_yay_illegally(nx, ny, d):
				break
			if flag_contains(current_tile.type, Enum.Tile.YAY):
				if _is_exiting_yay_illegally(nx, ny, d):
					break
			var tile = get_tile(nx,ny)
			var result = [null, null]
			if options.get("verbose"):
				var info = {}
				if 	flag_contains(tile.type, Enum.Tile.POO):
					poo.append([nx,ny])
					info.set("poo", poo)
				result.append(info)
				
			if _is_slide_through(nx, ny):
				result[0] = nx
				result[1] = ny
				moves.set(direction, result)
				nx += int(direction.x)
				ny += int(direction.y)
			elif options.get("can_jump") and not jumped:
				nx += int(direction.x)
				ny += int(direction.y)
				jumped = true
			else:
				break
	
	return moves.values()
	
func _get_available_hay_moves(column:int, row:int, options:Dictionary={}) -> Array:
	var moves = {}
	var directions = Enum.Direction.values()
	
	for d in directions:
		var direction = Enum.Directions[d]
		var nx = column + int(direction.x)
		var ny = row + int(direction.y)
		if _is_in_bounds(nx, ny):
			if _is_slide_through(nx, ny):
				moves.set(direction, [nx, ny])

	
	return moves.values()
	
func _get_available_cow_moves(column:int, row:int, options:Dictionary={}) -> Array:
	var result
	match options.get("cow"):
		Enum.Cow.PEN:
			result = []
		Enum.Cow.PLACE:
			result = _get_available_cow_placement_moves(column, row, options)
		Enum.Cow.MOVE:
			result = _get_available_cow_movement_moves(column, row, options)
		_:
			result = []
	return result

func _get_available_cow_placement_moves(column:int, row:int, options:Dictionary={}) -> Array:
	var moves = []
	for x in range(width):
		for y in range(height):
			if _is_slide_through(x, y):
				if not (x == column and y == row):
					moves.append([x,y])
	return moves

func _get_available_cow_movement_moves(column:int, row:int, options:Dictionary={}) -> Array:
	var moves = {}
	var directions = Enum.Direction.values()
	
	for d in directions:
		var direction = Enum.Directions[d]
		var nx = column + int(direction.x)
		var ny = row + int(direction.y)
		if _is_in_bounds(nx, ny):
			if _is_slide_through(nx, ny):
				moves.set(direction, [nx, ny])

	
	return moves.values()

func _is_goal_accessible() -> bool:
	var pig_positions = []
	
	for x in width:
		for y in height:
			var tile = get_tile(x, y)
			if flag_contains(tile.type, Enum.Tile.PIG):
				pig_positions.append(Vector2(x, y))
	
	for tint in yay_positions.keys():
		var yay_tiles = yay_positions.get(tint, [])
		var reachable := pig_positions.size() <= 0

		for pig_pos in pig_positions:
			for yay_pos in yay_tiles:
				if pig_pos != yay_pos:
					if _bfs_can_reach_target(pig_pos, yay_pos):
						reachable = true
						break
			if reachable:
				break

		if not reachable:
			return false 

	return true

func _bfs_can_reach_target(start: Vector2, end: Vector2) -> bool:
	var visited = {}
	var queue = [start]

	while queue.size() > 0:
		var current = queue.pop_front()
		if visited.has(current):
			continue
		visited[current] = true

		if current == end:
			return true

		for d in Enum.Direction.values():
			var dir = Enum.Directions[d]
			var nx = current.x + dir.x
			var ny = current.y + dir.y
			while _is_in_bounds(nx, ny) and _is_slide_through(nx, ny):
				if _is_entering_yay_illegally(nx, ny, d):
					break
				var next = Vector2(nx, ny)
				if not visited.has(next):
					queue.append(next)
				nx += dir.x
				ny += dir.y

	return false

func _is_in_bounds(column, row):
	return column >= 0 and column < width and row >= 0 and row < height

func _is_slide_through(column, row):
	var tile = get_tile(column,row)
	var blocking = Enum.Tile.PIG | Enum.Tile.HAY | Enum.Tile.COW
	return tile.type & blocking == 0
	
func _is_entering_yay_illegally(column:int, row: int, direction: Enum.Direction) -> bool:
	var tile = get_tile(column, row)
	if flag_missing(tile.type, Enum.Tile.YAY):
		return false
	var allowed_directions:Array[Enum.Direction] = get_yay(column, row)
	return not allowed_directions.has(direction)
	
func _is_exiting_yay_illegally(column:int, row: int, direction: Enum.Direction) -> bool:
	var tile = get_tile(column, row)
	if flag_missing(tile.type, Enum.Tile.YAY):
		return false
	var allowed_directions:Array[Enum.Direction] = get_yay(column, row)
	return not allowed_directions.has(Enum.invert_direction(direction))

func _to_string() -> String:
	return str(rows)\
	.replace("[[", "[\n\t[")\
	.replace(", [", ",\n\t[")\
	.replace("]]", "]\n]")

func to_array() -> Array:
	var result = []
	for row in rows:
		result.append(row.to_array())
	return result
	
