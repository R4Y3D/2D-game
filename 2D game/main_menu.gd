extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_startgame_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main.tscn")


func _on_gamerules_pressed() -> void:
	print("Game Rules Pressed")


func _on_exit_pressed() -> void:
	get_tree().quit()
