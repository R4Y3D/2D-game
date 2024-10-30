extends Node2D

@onready var score = 0;

func _draw():
	var default_font : Font = ThemeDB.fallback_font;
	
	var white : Color = Color.WHITE
	var godot_blue : Color = Color("478cbf")
	var grey : Color = Color("414042")
	DisplayServer.window_get_size()

	draw_string(default_font, Vector2(100, 100), "Your Score: " + str(score),
				HORIZONTAL_ALIGNMENT_CENTER, 500, 55)
	
	draw_string(default_font, Vector2(100, 500), "Press Space to Restart", 
				HORIZONTAL_ALIGNMENT_CENTER, 1000, 55)
	

	
