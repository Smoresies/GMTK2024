extends Area2D

@export var theme_change: int = 0
@export var newScene: PackedScene

func _on_body_entered(body):
	if body is Player:
		await body.leave(theme_change)
		get_tree().change_scene_to_packed(newScene)
