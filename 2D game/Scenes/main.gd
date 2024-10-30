extends Node2D

@onready var enemy_scene = preload("res://Scenes/enemies/grey ships anim.tscn")  # Preload your player bullet scene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Check if there are no enemies left
	if get_tree().get_nodes_in_group("Enemies").size() == 0:
		var enemies = enemy_scene.instantiate()  # Spawn more enemies
		enemies.position = Vector2(899, 131)
		get_tree().current_scene.add_child(enemies)
