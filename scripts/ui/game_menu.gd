extends CanvasLayer

@onready var texture_rect:TextureRect = $Panel/TextureRect
@onready var die_viewport:SubViewport = $"Die Viewport"

func _ready() -> void:
	texture_rect.texture = die_viewport.get_texture()
	GameController.rolled.connect(_on_rolled)
	GameController.roll_accepted.connect(_on_roll_accepted)
	GameController.next_turn.connect(_on_next_turn)
	GameController.game.ready.connect(_on_game_ready)
	GameController.game.die_ready.connect(_on_die_ready)
	hide()
	_hide_roll_choices()

func _on_game_ready():
	show()

func _reset_game_options():
	GameController.game.player.move_options = GameController.default_move_options

func _on_roll_die() -> void:
	Network.request_die_roll.rpc()
	#_hide_roll_actions()

func _hide_roll_choices():
	for node in get_tree().get_nodes_in_group("roll_one"):
			node.hide()
	for node in get_tree().get_nodes_in_group("roll_two"):
			node.hide()

func _on_rolled(number:int):
	_hide_roll_choices()
	if GameController.player_can_act():
		if number > 2:
			await get_tree().create_timer(1).timeout
			Network.broadcast_roll_accepted.rpc()
		elif number == 1:
			for node in get_tree().get_nodes_in_group("roll_one"):
				node.show()
		elif number == 2:
			for node in get_tree().get_nodes_in_group("roll_two"):
				node.show()

func _on_roll_accepted():
	hide()
	
func _on_next_turn():
	show()
	_hide_roll_choices()
	for node in get_tree().get_nodes_in_group("roll_action"):
		node.show()

func _show_roll_actions():
	for node in get_tree().get_nodes_in_group("roll_action"):
		node.show()
		
func _hide_roll_actions():
	for node in get_tree().get_nodes_in_group("roll_action"):
		node.hide()

func _on_give_number_pressed(number: int) -> void:
	#_hide_roll_actions()
	Network.request_die_roll.rpc(number)


func _on_choice_selected_for_one(option: String) -> void:
	print(option)
	if option == "cow":
		GameController.game.player.move_options.set("cow", Enum.Cow.PLACE)
	else:
		GameController.default_move_options.set("cow", Enum.Cow.MOVE)
		GameController.game.player.move_options.set("cow", Enum.Cow.MOVE)
	Network.broadcast_roll_accepted.rpc()


func _on_choice_selected_for_two(option: String) -> void:
	print(option)
	if option == "daisy":
		GameController.game.draw_daisy_card()
		GameController.next_turn.emit()
		GameController.orient_board.emit()
	else:
		Network.broadcast_roll_accepted.rpc()

func _on_die_ready():
	if GameController.player_can_act():
		_show_roll_actions()
		%TurnLabel.hide()
	else:
		_hide_roll_actions()
		%TurnLabel.show()
		%TurnLabel.text = str(GameController.game.player.name, "'s turn")
