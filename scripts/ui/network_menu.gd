extends CanvasLayer


func _on_host_pressed() -> void:
	Network.host(%Username.text)


func _on_join_pressed() -> void:
	Network.join(%Username.text)


func _on_start_pressed() -> void:
	Network.start()
