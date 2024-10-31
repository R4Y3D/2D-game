extends Node2D

@onready var score = 0;
@onready var player_alive = true;

@onready var enemy_scene = preload("res://Scenes/enemies/grey ships/grey ships anim.tscn")  # Preload your player bullet scene
@onready var score_text_scene = preload("res://Scenes/background/ScoreText.tscn")

var score_text: Node2D;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	print(score)
	if player_alive == true:
		if $player.lives == 0:
			if score_text == null:
				score_text = score_text_scene.instantiate()
				get_tree().current_scene.add_child(score_text)
			score_text.visible = true
			score_text.score = score
			score_text.queue_redraw()
			$DeathScreenTint.visible = true
			var hue = RandomNumberGenerator.new().randf_range(0, 1)
			$DeathScreenTint.set_color(Color.from_hsv(hue, 0.5, 0.79, 0.8))
			player_alive = false;
	else:
		if Input.is_key_pressed(KEY_R):
			score = 0
			score_text.visible = false
			$DeathScreenTint.visible = false
			player_alive = true;
			$player.reset()
