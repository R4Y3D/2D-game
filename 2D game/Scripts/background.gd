extends Sprite2D

func _ready():
	# Create and configure the Timer
	var timer = Timer.new()
	timer.wait_time = 90.0  # Time in seconds before the node disappears
	timer.one_shot = true  # Make it run only once
	add_child(timer)  # Add the timer to the scene tree so it runs

	# Connect the timeout signal to a function using a Callable
	timer.connect("timeout", Callable(self, "_on_timer_timeout"))

	# Start the timer
	timer.start()

# This function is called when the timer completes
func _on_timer_timeout():
	queue_free()  # Make the node disappear
