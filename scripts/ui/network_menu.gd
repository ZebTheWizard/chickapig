extends CanvasLayer

var mode:String

func _ready() -> void:
	GameController.game.ready.connect(_on_game_ready)
	GameController.game.added_player.connect(_on_added_player)
	show()
	%Start.hide()
	%"2-simple".pressed.connect(func(): mode = "2-simple")
	%"2-classic".pressed.connect(func(): mode = "2-classic")
	%"4-classic".pressed.connect(func(): mode = "4-classic")
	%"2-simple".button_pressed = true
	%"2-simple".pressed.emit()

func _on_game_ready():
	hide()
	
func _on_added_player(player:Player):
	for node in get_tree().get_nodes_in_group("phase_1"):
		node.hide()
	var label = Label.new()
	label.text = player.name
	%PlayerList.add_child(label)
	%PlayerListLabel.text = str("Players (", GameController.game.players.size(), "):")

func _on_host_pressed() -> void:
	Network.host(%Username.text, mode)
	%Start.show()


func _on_join_pressed() -> void:
	Network.join(%Username.text)


func _on_start_pressed() -> void:
	Network.start()
