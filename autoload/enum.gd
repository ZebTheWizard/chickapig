extends Node

enum Piece {
	NIL,
	PIG,
	HAY,
	COW,
}

const Directions = [
	Vector2i(0, -1), # Top
	Vector2i(1, 0),  # Right
	Vector2i(0, 1),  # Bottom
	Vector2i(-1, 0), # Left
]

enum Direction {
	TOP,
	RIGHT,
	BOTTOM,
	LEFT,
}

func invert_direction(direction:Direction) -> Direction:
	match direction:
		Direction.TOP:
			return Direction.BOTTOM
		Direction.BOTTOM:
			return Direction.TOP
		Direction.RIGHT:
			return Direction.LEFT
		_:
			return Direction.RIGHT

enum Cow {
	PEN,
	PLACE,
	MOVE,
}

enum Tint {
	NIL,
	RED,
	BLUE,
	GREEN,
	YELLOW,
}

enum Terrain {
	NIL,
	YAY,
	PEN,
}

enum Hazard {
	NIL,
	POO,
}
