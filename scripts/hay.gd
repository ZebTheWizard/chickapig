class_name Hay extends TileSprite

func set_tint(tint:Enum.Tint):
	sprite.region_rect.position.y = 128 * tint
	if tint == Enum.Tint.RED:
		rotation = deg_to_rad(180)
	if tint == Enum.Tint.BLUE:
		rotation = deg_to_rad(90)
	if tint == Enum.Tint.GREEN:
		rotation = deg_to_rad(0)
	if tint == Enum.Tint.YELLOW:
		rotation = deg_to_rad(270)

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		GameController.select_tile(tile)
