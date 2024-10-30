extends RichTextLabel

var default_font : Font = ThemeDB.fallback_font;

func _draw():
	var white : Color = Color.WHITE
	var godot_blue : Color = Color("478cbf")
	var grey : Color = Color("414042")

	draw_circle(Vector2(42.479, 65.4825), 9.3905, white)
	draw_circle(Vector2(85.524, 65.4825), 9.3905, white)
	draw_circle(Vector2(43.423, 65.92), 6.246, grey)
	draw_circle(Vector2(84.626, 66.008), 6.246, grey)
	draw_line(Vector2(64.273, 60.564), Vector2(64.273, 74.349), white, 5.8)

	# Draw GODOT text below the logo with the default font, size 22.
	draw_string(default_font, Vector2(20, 130), "GODOT",
				HORIZONTAL_ALIGNMENT_CENTER, 90, 22)
