class_name Dot extends TileSprite

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		GameController.game.grid.try_move(GameController.selected_tile.position, tile.position)
		#GameController.select.emit(tile)
