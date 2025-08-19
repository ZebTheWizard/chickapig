extends CanvasLayer


func _on_next_turn_pressed() -> void:
	GameController.next_turn.emit()


func _on_orient_board_pressed() -> void:
	GameController.orient_board.emit()
