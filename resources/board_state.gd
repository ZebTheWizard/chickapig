class_name BoardState extends Resource

@export var rows:Array[Row]
var cow_state: Enum.Cow = Enum.Cow.PEN
var width
var height

func _init(width:int, height:int) -> void:
	self.width = width
	self.height = height
	for h in height:
		rows.append(Row.new(width))
	
#region Getters/Setters		
func get_tile(x:int, y:int) -> Tile:
	assert(x < width)
	assert(y < height)
	var row = rows.get(y)
	if not row:
		return null
	return row.get_tile(x)
	
func set_piece(x:int, y:int, type:Enum.Piece, tint:Enum.Tint=Enum.Tint.NIL) -> void:
	var tile:Tile = get_tile(x, y)
	tile.piece.type = type
	tile.piece.tint = tint
	
func set_barriers(x:int, y:int, barriers:Array[Enum.Direction]):
	var tile:Tile = get_tile(x, y)
	for d in barriers:
		tile.barriers.set(d, true)
		
func set_terrain(x:int, y:int, type:Enum.Terrain, tint:Enum.Tint=Enum.Tint.NIL):
	var tile:Tile = get_tile(x, y)
	tile.terrain.type = type
	tile.terrain.tint = tint
	
func set_hazard(x:int, y:int, type:Enum.Hazard, tint:Enum.Tint=Enum.Tint.NIL):
	var tile:Tile = get_tile(x, y)
	tile.hazard.type = type
	tile.hazard.tint = tint

#endregion

#region Get Available Moves
func get_available_moves(x:int, y:int, options:Dictionary={}) -> Array:
	var tile = get_tile(x,y)
	var moves = []
	match tile.piece.type:
		Enum.Piece.PIG:
			moves.append_array(_get_pig_moves(x, y, options))
		Enum.Piece.HAY:
			moves.append_array(_get_hay_moves(x, y, options))
		Enum.Piece.COW:
			moves.append_array(_get_cow_moves(x, y, options))
	return moves

func _get_pig_moves(x:int, y:int, options:Dictionary={}) -> Array:
	var moves = {}
	var current = get_tile(x, y)
	for d in Enum.Direction.values():
		var jumped = false
		var direction = Enum.Directions.get(d)
		var nx = x + direction.x
		var ny = y + direction.y
		var prev_barriers = {}
		var result = [null, null]
		var info = {}
		if options.get("verbose"):
			result.append(info)
		while _in_bounds(nx, ny):
			var tile = get_tile(nx, ny)
			if tile.barriers.get(Enum.invert_direction(d)):
				break
			if prev_barriers.get(d):
				break
			if tile.terrain.type == Enum.Terrain.YAY and tile.terrain.tint != current.piece.tint:
				break
			if tile.hazard.type == Enum.Hazard.POO:
				var poo = info.get("poo", [])
				poo.append([nx,ny])
				info.set("poo", poo)
			if options.get("verbose"):
				result[2] = info
			if tile.piece.type == Enum.Piece.NIL:
				result[0] = nx
				result[1] = ny
				moves.set(d, result)
				nx += direction.x
				ny += direction.y
				prev_barriers = tile.barriers
			elif options.get("can_jump") and not jumped:
				nx += direction.x
				ny += direction.y
				jumped = true
			else:
				break
	return moves.values()

func _get_hay_moves(x:int, y:int, options:Dictionary={}) -> Array:
	var moves = {}
	for d in Enum.Direction.values():
		var direction = Enum.Directions.get(d)
		var nx = x + direction.x
		var ny = y + direction.y
		var result = [null, null]
		var info = {}
		if options.get("verbose"):
			result.append(info)
		if _in_bounds(nx, ny):
			var tile = get_tile(nx, ny)
			if tile.hazard.type == Enum.Hazard.POO:
				var poo = info.get("poo", [])
				poo.append([nx,ny])
				info.set("poo", poo)
			if options.get("verbose"):
				result[2] = info
			if tile.terrain.type == Enum.Terrain.PEN && tile.barriers.get(Enum.invert_direction(d)):
				pass
			elif tile.piece.type == Enum.Piece.NIL:
				result[0] = nx
				result[1] = ny
				moves.set(d, result)
				nx += direction.x
				ny += direction.y
	return moves.values()

func _get_cow_moves(x:int, y:int, options:Dictionary={}) -> Array:
	var moves = []
	match options.get("cow"):
		Enum.Cow.PLACE:
			moves.append_array(_get_cow_placement_moves(x, y, options))
		Enum.Cow.MOVE:
			moves.append_array(_get_cow_movement_moves(x, y, options))
		_:
			moves = []
	return moves
	
func _get_cow_placement_moves(x:int, y:int, options:Dictionary={}) -> Array:
	var moves = []
	for _x in range(width):
		for _y in range(height):
			var tile = get_tile(_x, _y)
			var result = [null, null]
			var info = {}
			if options.get("verbose"):
				result.append(null)
				result[2] = info
			if tile.piece.type == Enum.Piece.NIL and tile.terrain.type != Enum.Terrain.PEN:
				if not (x == _x and y == _y):
					result[0] = _x
					result[1] = _y
					moves.append(result)
	return moves

func _get_cow_movement_moves(x:int, y:int, options:Dictionary={}) -> Array:
	var moves = {}
	for d in Enum.Direction.values():
		var direction = Enum.Directions.get(d)
		var nx = x + direction.x
		var ny = y + direction.y
		var result = [null, null]
		var info = {}
		if options.get("verbose"):
			result.append(info)
		if _in_bounds(nx, ny):
			var tile = get_tile(nx, ny)
			if options.get("verbose"):
				result[2] = info
			if tile.terrain.type == Enum.Terrain.PEN && tile.barriers.get(Enum.invert_direction(d)):
				pass
			elif tile.piece.type == Enum.Piece.NIL:
				result[0] = nx
				result[1] = ny
				moves.set(d, result)
				nx += direction.x
				ny += direction.y
	return moves.values()
	
func _in_bounds(x:int, y:int) -> bool:
	return x >= 0 and x < width and y >= 0 and y < height
#endregion

#region Try Move
func try_move(from:Vector2, to:Vector2, options:Dictionary={}) -> Array:
	var moves = get_available_moves(from.x, from.y, options)
	var move = _moves_has(moves, to)
	if not move:
		return []
		
	var tile = get_tile(from.x, from.y)
	var piece = tile.piece.clone()
	var last_cow_state = cow_state
	var cow = Enum.Piece.COW
	
	if tile.piece.type == Enum.Piece.COW and cow_state == Enum.Cow.PLACE:
		set_hazard(from.x, from.y, Enum.Hazard.POO)
		set_piece(from.x, from.y, Enum.Piece.NIL)
		cow_state = Enum.Cow.MOVE
	else:
		set_piece(from.x, from.y, Enum.Piece.NIL)
		
	set_piece(to.x, to.y, piece.type, piece.tint)
	
	if not _is_goal_accessible():
		if tile.piece.type == Enum.Piece.COW and cow_state == Enum.Cow.PLACE:
			set_hazard(from.x, from.y, Enum.Hazard.NIL)
			set_piece(from.x, from.y, Enum.Piece.COW)
			cow_state = Enum.Cow.MOVE
		else:
			set_piece(from.x, from.y, piece.type, piece.tint)
			
		set_piece(to.x, to.y, Enum.Piece.NIL)
		
		return []
		
	return move

func _moves_has(moves:Array, coord:Vector2):
	var found = false
	for move in moves:
		if move[0] == coord.x and move[1] == coord.y:
			found = move
			break

	return found
	
func _is_goal_accessible() -> bool:
	var pig_positions = []
	var yay_positions = {}
	
	for x in width:
		for y in height:
			var tile = get_tile(x, y)
			if tile.piece.type == Enum.Piece.PIG:
				pig_positions.append(Vector2i(x, y))
			if tile.terrain.type == Enum.Terrain.YAY:
				var list = yay_positions.get(tile.terrain.tint, [])
				list.append(Vector2i(x, y))
				yay_positions.set(tile.terrain.tint, list)
	
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

func _bfs_can_reach_target(start: Vector2i, end: Vector2i) -> bool:
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
			while _in_bounds(nx, ny):
				var tile = get_tile(nx,ny)
				if tile.piece.type != Enum.Piece.NIL:
					break
				if tile.barriers.get(Enum.invert_direction(d)):
					break
				var next = Vector2i(nx, ny)
				if not visited.has(next):
					queue.append(next)
				nx += dir.x
				ny += dir.y

	return false

#endregion

func to_array() -> Array:
	var result = []
	for row in rows:
		result.append(row.to_array())
	return result
	
