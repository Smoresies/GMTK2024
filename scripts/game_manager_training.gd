extends Node

@export var startingCamera: PhantomCamera2D

# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().create_timer(3).timeout
	startingCamera.set_priority(0)
