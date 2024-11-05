extends CanvasLayer

# Reference to the label that displays the score
@onready var score_label: Label = $score  # Change $score to the correct path if necessary

func _ready():
	self.hide()  # Hide the Game Over UI initially

func _on_button_pressed() -> void:
	# Call reset function on the player
	var player = get_parent().get_node("player")
	if player:
		player.reset()  # Ensure reset logic does not affect the score
	else:
		print("GAME WIN")
	
	get_tree().paused = false  # Unpause the game
	get_tree().reload_current_scene()  # Reload the current scene
	MainScene.score = 0;

func game_win():
	await get_tree().create_timer(1.0).timeout  # Wait for 1 second
	get_tree().paused = true  # Pause the game
	self.show()  # Show the Game Over screen

	# Display the score before calling reset
	score_label.text = "Score: " + str(MainScene.score) #(score system works but for some reason displays as NULL)

	# Call reset function on the player
	var player = get_parent().get_node("player")
	if player:
		player.reset()  # Call reset after displaying the score
	else:
		print("GAME WIN")
