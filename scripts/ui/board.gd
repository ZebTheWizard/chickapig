extends CanvasLayer

@onready var moves_left = $"VBoxContainer/Moves Left"

func _ready() -> void:
	GameController.game.ready.connect(_on_game_ready)
	hide()
	
func _on_game_ready():
	show()

func _on_next_turn_pressed() -> void:
	GameController.next_turn.emit()


func _on_orient_board_pressed() -> void:
	GameController.orient_board.emit()
	
func _process(delta: float) -> void:
	if GameController.game.started:
		moves_left.text = str("Moves left: ", GameController.game.player.remaining_moves)
