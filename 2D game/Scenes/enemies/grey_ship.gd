extends CharacterBody2D

@onready var explosion_anim = $Explosion
@onready var anim = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("Enemies")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func take_damage() -> void:
	anim.visible = false
	explosion_anim.visible = true
	explosion_anim.play("explode")
	#This is the most horrendous line I've code I've written in a while, but it is godot does not have "root.score" :/
	get_parent().get_parent().get_parent().get_parent().score = get_parent().get_parent().get_parent().get_parent().score + 1
	await explosion_anim.animation_finished  # Change yield to await
	queue_free()
	pass
