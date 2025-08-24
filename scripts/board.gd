extends Sprite2D

func _ready() -> void:
	GameController.orient_board.connect(_on_orient_board)
	GameController.game.ready.connect(_on_game_ready)
	hide()

func _on_game_ready():
	show()
	rotate_board()
	

func _on_orient_board():
	rotate_board()
	
func rotate_board():
	var tints = GameController.get_local_player().tints
	if tints == [Enum.Tint.RED]:
		global_rotation = deg_to_rad(180)
	if tints == [Enum.Tint.BLUE]:
		global_rotation = deg_to_rad(270)
	if tints == [Enum.Tint.GREEN]:
		global_rotation = deg_to_rad(0)
	if tints == [Enum.Tint.YELLOW]:
		global_rotation = deg_to_rad(90)
	if tints == [Enum.Tint.RED, Enum.Tint.BLUE]:
		global_rotation = deg_to_rad(180+ 45)
	if tints == [Enum.Tint.GREEN, Enum.Tint.YELLOW]:
		global_rotation = deg_to_rad(45)
