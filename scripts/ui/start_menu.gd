extends CanvasLayer

#func _ready() -> void:
	#show()

func _on_play() -> void:
	GameController.play.emit()
	hide()
