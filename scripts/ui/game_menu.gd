extends CanvasLayer


func _on_roll_die() -> void:
	GameController.roll_die.emit()
